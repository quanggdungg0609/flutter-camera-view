import "dart:io";
import "package:dio/dio.dart";
import "package:flutter_camera_view/core/services/signaling.service.dart";
import "package:flutter_camera_view/features/camera_view/data/datasources/websocket.datasource.dart";
import "package:flutter_camera_view/features/camera_view/data/repositories/local_resource_impl.repository.dart";
import "package:flutter_camera_view/features/camera_view/data/repositories/websocket_impl.repository.dart";
import "package:flutter_camera_view/features/camera_view/domain/repositories/local_resource.repository.dart";
import "package:flutter_camera_view/features/camera_view/domain/repositories/websocket.repository.dart";
import "package:flutter_camera_view/features/camera_view/domain/usescases/get_own_uuid.usecase.dart";
import "package:flutter_camera_view/features/camera_view/domain/usescases/send_ws_message.usecase.dart";
import "package:flutter_camera_view/features/camera_view/domain/usescases/websocket_connect.usecase.dart";
import "package:flutter_camera_view/features/camera_view/domain/usescases/websocket_disconnect.usecase.dart";
import "package:flutter_camera_view/features/camera_view/presentation/bloc/camera_select_cubit/camera_select.cubit.dart";
import "package:flutter_camera_view/features/camera_view/presentation/bloc/webrtc_bloc/webrtc.bloc.dart";
import "package:flutter_camera_view/features/camera_view/presentation/bloc/websocket_bloc/websocket.bloc.dart";
import "package:flutter_camera_view/features/gallery/data/datasources/gallerie.datasource.dart";
import "package:flutter_camera_view/features/gallery/data/repositories/gallerie_impl.repository.dart";
import "package:flutter_camera_view/features/gallery/domain/repositories/gallerie.repository.dart";
import "package:flutter_camera_view/features/gallery/domain/usecases/get_cameras.usecase.dart";
import "package:flutter_camera_view/features/gallery/domain/usecases/get_media_infos.usecase.dart";
import "package:flutter_camera_view/features/gallery/domain/usecases/get_media_items.usecase.dart";
import "package:flutter_camera_view/features/gallery/domain/usecases/get_media_page.usecase.dart";
import "package:flutter_camera_view/features/gallery/domain/usecases/get_media_urls.usecase.dart";
import "package:flutter_camera_view/features/gallery/domain/usecases/get_video_thumbnails.usecase.dart";
import "package:flutter_camera_view/features/gallery/presentation/blocs/camera_select_cubit/resource_select.cubit.dart";
import "package:flutter_camera_view/features/gallery/presentation/blocs/gallerie_bloc/gallerie.bloc.dart";
import "package:flutter_camera_view/features/login/data/datasources/auth.datasource.dart";
import "package:flutter_camera_view/features/login/data/datasources/local.datasource.dart";
import "package:flutter_camera_view/features/login/data/models/tokens.model.dart";
import "package:flutter_camera_view/features/login/data/repositories/account_info_impl.repository.dart";
import "package:flutter_camera_view/features/login/data/repositories/auth_impl.reposiory.dart";
import "package:flutter_camera_view/features/login/domain/entities/tokens.entity.dart";
import "package:flutter_camera_view/features/login/domain/repositories/account_info.repository.dart";
import "package:flutter_camera_view/features/login/domain/repositories/auth.repository.dart";
import "package:flutter_camera_view/features/login/domain/usecases/clear_account_info.usecase.dart";
import "package:flutter_camera_view/features/login/domain/usecases/fetch_account_info.usecase.dart";
import "package:flutter_camera_view/features/login/domain/usecases/login.usecase.dart";
import "package:flutter_camera_view/features/login/domain/usecases/save_account_info.usecase.dart";
import "package:flutter_camera_view/features/login/presentation/bloc/account/account_info.bloc.dart";
import "package:flutter_camera_view/features/login/presentation/bloc/auth/auth_bloc.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:path_provider/path_provider.dart" as path_provider;
import "package:get_it/get_it.dart";
import "package:hive/hive.dart";

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Load env file
  await dotenv.load(fileName: ".env");

  sl.registerSingletonAsync<Directory>(() async {
    return await path_provider.getApplicationCacheDirectory();
  });

  // init flutter secure storage
  sl.registerLazySingleton<FlutterSecureStorage>(() {
    AndroidOptions getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    return storage;
  });

  // services
  sl.registerLazySingleton<SignalingService>(
    () => SignalingService(),
  );

  await sl.isReady<Directory>();
  Hive.init(sl<Directory>().path);
  // * Data sources
  await _initialDataSources();

  // * Repositories
  await _initialRepositories();
  // * Use cases
  await _initalUseCases();

  // * Blocs
  await _initalBlocs();
}

// * Datasources initial
Future<void> _initialDataSources() async {
  // create box of hive
  sl.registerSingletonAsync<BoxCollection>(() async {
    var collection = await BoxCollection.open(
        "CameraViewApp",
        {
          "settings",
          "userInfo",
        },
        path: "${sl<Directory>().path}/CameraViewApp");
    return collection;
  });

  await sl.isReady<BoxCollection>();

  sl.registerSingleton<LocalDataSource>(
    LocalDataSourceImpl(
      secureStorage: sl<FlutterSecureStorage>(),
      hiveCollections: sl<BoxCollection>(),
    ),
  );

  sl.registerLazySingleton<Dio>(() {
    Dio dio = Dio();
    dio.options.baseUrl = dotenv.env["API_URL"]!;

    // Add an interceptor to handle automatic token refresh only for requests with Bearer Auth
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Lấy access token từ LocalDataSource và thêm vào header nếu có
          AccessToken? token = await sl<LocalDataSource>().getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer ${token.value}';
          }
          return handler.next(options);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          if (e.response?.statusCode == 401 && e.response?.data["code"] == "token_not_valid" ||
              e.response?.statusCode == 401 &&
                  e.response?.data["detail"] == "Given token not valid for any token type") {
            final authHeader = (e.requestOptions.headers["Authorization"] as String?);

            if (authHeader?.startsWith("Bearer") == true) {
              RefreshToken? token = await sl<LocalDataSource>().getRefreshToken();

              // If refresh token is not available, reject the request with an appropriate error
              if (token == null) {
                return handler.reject(DioException(
                  requestOptions: e.requestOptions,
                  response: Response(
                    requestOptions: e.requestOptions,
                    statusCode: 401,
                    data: {"detail": "Refresh token not available, please login again"},
                  ),
                  type: DioExceptionType.badResponse,
                ));
              }
              try {
                final refreshResponse = await dio.post(
                  "/auth/refresh/",
                  data: {"refresh": token.value},
                );

                if (refreshResponse.statusCode == 200) {
                  final newAccessToken = refreshResponse.data["access"];

                  AccessTokenModel accessToken = AccessTokenModel(value: newAccessToken);
                  await sl<LocalDataSource>().updateAccessToken(accessToken);
                  // Retry the original request with the new access token
                  final retryOptions = e.requestOptions;
                  retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

                  final retryResponse = await dio.fetch(retryOptions);
                  // return the retried response
                  return handler.resolve(retryResponse);
                }
              } catch (refreshError) {
                // handle refresh token failure or network issues
                return handler.reject(
                  DioException(
                    requestOptions: e.requestOptions,
                    response: Response(
                      requestOptions: e.requestOptions,
                      statusCode: 401,
                      data: {"detail": "Failed to refresh token, please login again"},
                    ),
                    type: DioExceptionType.badResponse,
                  ),
                );
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
    return dio;
  });

  sl.registerSingleton<AuthDataSource>(
    AuthDatasSourceImpl(
      dio: sl<Dio>(),
    ),
  );

  // websocket datasource
  sl.registerSingleton<WebSocketDataSource>(
    WebSocketDataSourceImpl(),
  );

  // gallerie datasource
  sl.registerSingleton<GallerieDataSource>(
    GallerieDataSourceImpl(
      dio: sl<Dio>(),
    ),
  );
}

// * Repositories initial
Future<void> _initialRepositories() async {
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      authDataSource: sl<AuthDataSource>(),
      localDataSource: sl<LocalDataSource>(),
    ),
  );

  sl.registerSingleton<AccountInfoRepository>(
    AccountInfoImplRepository(
      localDataSource: sl<LocalDataSource>(),
    ),
  );

  sl.registerSingleton<WebSocketRepository>(
    WebSocketImplRepository(
      localDataSource: sl<LocalDataSource>(),
      wsDataSource: sl<WebSocketDataSource>(),
    ),
  );

  sl.registerSingleton<LocalResourceRepository>(
    LocalResourceImplRepository(
      localDataSource: sl<LocalDataSource>(),
    ),
  );

  sl.registerSingleton<GallerieRepository>(
    GallerieImplRepository(
      gallerieDataSource: sl<GallerieDataSource>(),
    ),
  );
}

// * Usecases Initial
Future<void> _initalUseCases() async {
  // Todo: maybe remove unused uscases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      repository: sl<AuthRepository>(),
    ),
  );

  sl.registerLazySingleton<ClearAccountInfoUseCase>(
    () => ClearAccountInfoUseCase(
      sl<AccountInfoRepository>(),
    ),
  );

  sl.registerLazySingleton<FetchAccountInfoUseCase>(
    () => FetchAccountInfoUseCase(
      sl<AccountInfoRepository>(),
    ),
  );

  sl.registerLazySingleton<SaveAccountInfoUseCase>(
    () => SaveAccountInfoUseCase(
      sl<AccountInfoRepository>(),
    ),
  );

  sl.registerLazySingleton<WebSocketConnectUseCase>(
    () => WebSocketConnectUseCase(
      wsRepository: sl<WebSocketRepository>(),
    ),
  );

  sl.registerLazySingleton<SendWsMessageUseCase>(
    () => SendWsMessageUseCase(
      wsRepository: sl<WebSocketRepository>(),
    ),
  );

  sl.registerLazySingleton<WebsocketDisconnectUseCase>(
    () => WebsocketDisconnectUseCase(
      wsRepository: sl<WebSocketRepository>(),
    ),
  );

  sl.registerLazySingleton<GetOwnUuidUseCase>(
    () => GetOwnUuidUseCase(
      repository: sl<LocalResourceRepository>(),
    ),
  );

  // * Gallerie use cases
  sl.registerLazySingleton<GetCamerasUseCase>(
    () => GetCamerasUseCase(
      repository: sl<GallerieRepository>(),
    ),
  );

  sl.registerLazySingleton<GetMediaPageUseCase>(
    () => GetMediaPageUseCase(
      repository: sl<GallerieRepository>(),
    ),
  );

  sl.registerLazySingleton<GetMediaItemsUseCase>(
    () => GetMediaItemsUseCase(
      gallerieRepository: sl<GallerieRepository>(),
    ),
  );
}

// * BLOCs initial
Future<void> _initalBlocs() async {
  // * login feature section
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
    ),
  );

  sl.registerFactory<AccountInfoBloc>(
    () => AccountInfoBloc(
      fetchAccountInfoUseCase: sl<FetchAccountInfoUseCase>(),
      saveAccountInfoUseCase: sl<SaveAccountInfoUseCase>(),
      clearAccountInfoUseCase: sl<ClearAccountInfoUseCase>(),
    ),
  );

  // * Camera view feature section
  sl.registerFactory<WebSocketBloc>(
    () => WebSocketBloc(
      connectUseCase: sl<WebSocketConnectUseCase>(),
      disconnectUseCase: sl<WebsocketDisconnectUseCase>(),
      sendWsMessageUseCase: sl<SendWsMessageUseCase>(),
      signalingService: sl<SignalingService>(),
    ),
  );

  sl.registerFactory<WebRTCBloc>(
    () => WebRTCBloc(
      signalingService: sl<SignalingService>(),
      getOwnUuidUseCase: sl<GetOwnUuidUseCase>(),
    ),
  );

  sl.registerFactory<CameraSelectCubit>(
    () => CameraSelectCubit(
      getOwnUuidUseCase: sl<GetOwnUuidUseCase>(),
    ),
  );

  // * Gallerie feature section
  sl.registerFactory<ResourceSelectCubit>(
    () => ResourceSelectCubit(
      getCamerasUseCase: sl<GetCamerasUseCase>(),
    ),
  );

  sl.registerFactory<GallerieBloc>(
    () => GallerieBloc(
      getMediaPageUseCase: sl<GetMediaPageUseCase>(),
      getMediaItemsUseCase: sl<GetMediaItemsUseCase>(),
    ),
  );
}

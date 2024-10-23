import "dart:io";
import "dart:math";
import "dart:typed_data";

import "package:dio/dio.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:path_provider/path_provider.dart" as path_provider;
import "package:get_it/get_it.dart";
import "package:hive/hive.dart";

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Load env file
  await dotenv.load(fileName: ".env");

  sl.registerLazySingletonAsync<Directory>(() async {
    final appDocumentDirectory = await path_provider.getApplicationCacheDirectory();
    return appDocumentDirectory;
  });

  // init flutter secure storage
  sl.registerSingleton(() {
    AndroidOptions getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    return storage;
  });

  Hive.init(sl<Directory>().path);

  // create box of hive
  sl.registerSingletonAsync<BoxCollection>(() async {
    Uint8List key = generateRandomKey();
    var collection = await BoxCollection.open(
      "CameraViewApp",
      {
        "settings",
        "users",
      },
    );
    return collection;
  });

  sl<BoxCollection>().openBox("settings");

  Dio dio = Dio();
  dio.options.baseUrl = dotenv.env["API_URL"]!;
}

Uint8List generateRandomKey() {
  final Random random = Random.secure();
  final Uint8List key = Uint8List(16);
  for (int i = 0; i < 16; i++) {
    key[i] = random.nextInt(256); // Tạo số ngẫu nhiên từ 0 đến 255
  }
  return key;
}

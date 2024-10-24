import 'package:equatable/equatable.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutter_camera_view/core/usecase.dart';
import 'package:flutter_camera_view/features/login/domain/entities/account_info.entity.dart';
import 'package:flutter_camera_view/features/login/domain/usecases/clear_account_info.usecase.dart';
import 'package:flutter_camera_view/features/login/domain/usecases/fetch_account_info.usecase.dart';
import 'package:flutter_camera_view/features/login/domain/usecases/login.usecase.dart';
import 'package:flutter_camera_view/features/login/domain/usecases/save_account_info.usecase.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SaveAccountInfoUseCase saveAccountInfoUseCase;
  final ClearAccountInfoUseCase clearAccountInfoUseCase;
  final FetchAccountInfoUseCase fetchAccountInfoUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.saveAccountInfoUseCase,
    required this.clearAccountInfoUseCase,
    required this.fetchAccountInfoUseCase,
  }) : super(AuthInitialState()) {
    on<FetchAccountInfoEvent>(
      (event, emit) async {
        final failureOrAccountInfo = await fetchAccountInfoUseCase.call(NoParams());

        failureOrAccountInfo.fold(
          (failure) {
            // emit to NotConnected state event failure;
            emit(NotConnectedState(null));
          },
          (accountInfo) {
            if (accountInfo == null) {
              emit(NotConnectedState(null));
            } else {
              emit(NotConnectedState(accountInfo));
            }
          },
        );
      },
    );

    on<SaveAccountInfoEvent>(
      (event, emit) async {
        final failureOrSave = await saveAccountInfoUseCase.call(
          SaveAccountInfoParams(event.accountID, event.password),
        );

        failureOrSave.fold((failure) {
          // dont change anything
        }, (unit) {
          // dont change anything
        });
      },
    );

    on<ClearAccountInfoEvent>(
      (event, emit) async {
        final failureOrClear = await clearAccountInfoUseCase.call(NoParams());
        failureOrClear.fold((failure) {}, (unit) {});
      },
    );
  }
}

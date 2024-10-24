import 'package:equatable/equatable.dart';
import "package:flutter_bloc/flutter_bloc.dart";
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
  }) : super(NotConnectedState());
}

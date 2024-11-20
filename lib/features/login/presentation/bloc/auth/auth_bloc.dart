import 'package:equatable/equatable.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:flutter_camera_view/features/login/domain/usecases/login.usecase.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({
    required this.loginUseCase,
  }) : super(NoAuthenticatedState()) {
    on<LoginEvent>(
      (event, emit) async {
        final failureOrAccountInfo = await loginUseCase.call(
          LoginParams(event.accountID, event.password),
        );
        failureOrAccountInfo.fold((failure) {
          // not authenticated
          emit(NoAuthenticatedState());
        }, (unit) {
          // authenticated success
          emit(Authenticated());
        });
      },
    );
  }
}

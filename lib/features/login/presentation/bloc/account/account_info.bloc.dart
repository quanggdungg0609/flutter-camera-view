import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/login/domain/entities/account_info.entity.dart';
import 'package:flutter_camera_view/features/login/domain/usecases/clear_account_info.usecase.dart';
import 'package:flutter_camera_view/features/login/domain/usecases/fetch_account_info.usecase.dart';
import 'package:flutter_camera_view/features/login/domain/usecases/save_account_info.usecase.dart';

part 'account_info.event.dart';
part 'account_info.state.dart';

class AccountInfoBloc extends Bloc<AccountInfoEvent, AccountInfoState> {
  final FetchAccountInfoUseCase fetchAccountInfoUseCase;
  final SaveAccountInfoUseCase saveAccountInfoUseCase;
  final ClearAccountInfoUseCase clearAccountInfoUseCase;

  AccountInfoBloc(
      {required this.fetchAccountInfoUseCase,
      required this.saveAccountInfoUseCase,
      required this.clearAccountInfoUseCase})
      : super(AccountInfoInitialState()) {
    on<FetchAccountInfoEvent>(
      (event, emit) async {},
    );
  }
}

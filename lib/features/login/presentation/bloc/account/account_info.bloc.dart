import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/core/usecase.dart';
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

  AccountInfoBloc({
    required this.fetchAccountInfoUseCase,
    required this.saveAccountInfoUseCase,
    required this.clearAccountInfoUseCase,
  }) : super(AccountInfoInitialState()) {
    // * Fetch account info data from secure storage
    on<FetchAccountInfoEvent>(
      (event, emit) async {
        emit(FetchingAccountInfoState());
        final failureOrFetchData = await fetchAccountInfoUseCase.call(NoParams());

        failureOrFetchData.fold((failure) {
          // nothing happens
          print("Error: $failure");
          emit(AccountInfoFetchedState(null));
        }, (AccountInfo? accountInfo) {
          emit(AccountInfoFetchedState(accountInfo));
        });
      },
    );

    // * Save account info data into secure storage
    on<SaveAccountInfoEvent>(
      (event, emit) async {
        final failureOrSaveData = await saveAccountInfoUseCase.call(
          SaveAccountInfoParams(
            event.accountID,
            event.password,
          ),
        );

        failureOrSaveData.fold(
          (failure) {
            // * do nothing
            print("Error saving account info: $failure");
          },
          (unit) {
            print("Account info saved successfully");
            // * do nothing
          },
        );
      },
    );
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first/core/base_cubit/base_state.dart';
import 'package:offline_first/core/base_cubit/state_status.dart';
import 'package:offline_first/core/error_handler/failure.dart';


abstract class BaseCubit<S extends BaseState<S>> extends Cubit<S> {
  BaseCubit(super.initialState);

  Future<void> safeExecute<R>(
    Future<Either<Failure, R>> Function() operation,
    Function(R data) onSuccess, {
    Function(Failure failure)? onError,
  }) async {
    emit(state.copyWith(status: StateStatus.loading));

    final result = await operation();

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: StateStatus.error,
          errorMessage: failure.message,
        ));
        onError?.call(failure);
      },
      (data) {
        onSuccess(data);
      },
    );
  }

  void emitIfNotClosed(S state) {
    if (!isClosed) {
      emit(state);
    }
  }
}

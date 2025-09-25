import 'package:injectable/injectable.dart';
import 'package:offline_first/core/base_cubit/base_cubit.dart';
import 'package:offline_first/core/base_cubit/state_status.dart';
import 'package:offline_first/features/users/domain/entities/user_entity.dart';
import 'package:offline_first/features/users/domain/usecases/change_user_usecase.dart';
import 'package:offline_first/features/users/domain/usecases/delete_user_usecase.dart';
import 'package:offline_first/features/users/presentation/cubit/user_profile_page/user_profile_page_state.dart';


@lazySingleton
class UserProfileCubit extends BaseCubit<UserProfileState> {
  final ChangeUserUsecase _changeUserUsecase;
  final DeleteUserUsecase _deleteUserUsecase;

  UserProfileCubit(
    this._changeUserUsecase,
    this._deleteUserUsecase,
  ) : super(const UserProfileState());

  Future<void> changeUser(UserEntity user) async {
    await safeExecute(
      () async => await _changeUserUsecase.call(user),
      (_) => emit(state.copyWith(status: StateStatus.success)),
    );
  }

  Future<void> deleteUser(UserEntity user) async {
    await safeExecute(
      () async => await _deleteUserUsecase.call(user),
      (_) => emit(state.copyWith(status: StateStatus.success)),
    );
  }
}

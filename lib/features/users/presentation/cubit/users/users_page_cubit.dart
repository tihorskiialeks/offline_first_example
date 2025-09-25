import 'package:injectable/injectable.dart';
import 'package:offline_first/core/base_cubit/base_cubit.dart';
import 'package:offline_first/core/base_cubit/state_status.dart';
import 'package:offline_first/core/base_use_case/use_case.dart';
import 'package:offline_first/features/users/domain/entities/user_entity.dart';
import 'package:offline_first/features/users/domain/usecases/get_users_usecase.dart';
import 'package:offline_first/features/users/presentation/cubit/users/users_page_state.dart';


@lazySingleton
class UsersPageCubit extends BaseCubit<UsersPageState> {
  final GetUsersUsecase _getUsersUsecase;
  UsersPageCubit(this._getUsersUsecase) : super(const UsersPageState());

  Future<void> getUsers() async {
    await safeExecute<List<UserEntity>>(
      () async => await _getUsersUsecase.call(NoParams()),
      (users) => emit(state.copyWith(
        users: users,
        status: StateStatus.initial,
      )),
    );
  }
}

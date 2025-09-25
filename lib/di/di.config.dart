// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../features/users/data/repositories/firebase_repository.dart' as _i409;
import '../features/users/data/repositories/local_database_repository.dart'
    as _i169;
import '../features/users/data/repositories/users_repository_impl.dart'
    as _i422;
import '../features/users/domain/repositories/user_repository.dart' as _i572;
import '../features/users/domain/usecases/change_user_usecase.dart' as _i375;
import '../features/users/domain/usecases/delete_user_usecase.dart' as _i555;
import '../features/users/domain/usecases/get_users_usecase.dart' as _i85;
import '../features/users/presentation/cubit/user_profile_page/user_profile_page_cubit.dart'
    as _i18;
import '../features/users/presentation/cubit/users/users_page_cubit.dart'
    as _i785;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $configureDependencies(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.lazySingleton<_i409.FirebaseRepository>(() => _i409.FirebaseRepository());
  gh.lazySingleton<_i169.LocalDatabaseRepository>(
      () => _i169.LocalDatabaseRepository());
  gh.lazySingleton<_i572.UserRepository>(() => _i422.UsersRepositoryImpl(
        gh<_i169.LocalDatabaseRepository>(),
        gh<_i409.FirebaseRepository>(),
      ));
  gh.factory<_i375.ChangeUserUsecase>(
      () => _i375.ChangeUserUsecase(gh<_i572.UserRepository>()));
  gh.factory<_i555.DeleteUserUsecase>(
      () => _i555.DeleteUserUsecase(gh<_i572.UserRepository>()));
  gh.factory<_i85.GetUsersUsecase>(
      () => _i85.GetUsersUsecase(gh<_i572.UserRepository>()));
  gh.lazySingleton<_i785.UsersPageCubit>(
      () => _i785.UsersPageCubit(gh<_i85.GetUsersUsecase>()));
  gh.lazySingleton<_i18.UserProfileCubit>(() => _i18.UserProfileCubit(
        gh<_i375.ChangeUserUsecase>(),
        gh<_i555.DeleteUserUsecase>(),
      ));
  return getIt;
}

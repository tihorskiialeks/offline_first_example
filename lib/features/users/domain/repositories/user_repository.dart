import 'package:dartz/dartz.dart';
import 'package:offline_first/core/base_repository/base_repository.dart';
import 'package:offline_first/core/error_handler/failure.dart';
import 'package:offline_first/features/users/domain/entities/user_entity.dart';


abstract class UserRepository extends BaseRepository {
  UserRepository();

  Future<Either<Failure, List<UserEntity>>> getUsersAndSynchronyzeDatabases();

  Future<Either<Failure, void>> deleteUser(UserEntity user);

  Future<Either<Failure, void>> changeUser(UserEntity user);

  Future<void> addMockUsersToFirebase();
}

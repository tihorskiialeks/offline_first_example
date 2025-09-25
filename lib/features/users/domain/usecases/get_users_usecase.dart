import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:offline_first/core/base_use_case/use_case.dart';
import 'package:offline_first/core/error_handler/failure.dart';
import 'package:offline_first/features/users/domain/entities/user_entity.dart';
import 'package:offline_first/features/users/domain/repositories/user_repository.dart';


@injectable
class GetUsersUsecase
    implements UseCase<Either<Failure, List<UserEntity>>, NoParams> {
  final UserRepository _userRepository;

  const GetUsersUsecase(this._userRepository);

  @override
  Future<Either<Failure, List<UserEntity>>> call(NoParams params) async {
    return await _userRepository.getUsersAndSynchronyzeDatabases();
  }
}

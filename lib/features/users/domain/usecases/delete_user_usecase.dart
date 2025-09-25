import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:offline_first/core/base_use_case/use_case.dart';
import 'package:offline_first/core/error_handler/failure.dart';
import 'package:offline_first/features/users/domain/entities/user_entity.dart';
import 'package:offline_first/features/users/domain/repositories/user_repository.dart';


@injectable
class DeleteUserUsecase implements UseCase<Either<Failure, void>, UserEntity> {
  final UserRepository _userRepository;

  DeleteUserUsecase(this._userRepository);

  @override
  Future<Either<Failure, void>> call(UserEntity user) async {
    return await _userRepository.deleteUser(user);
  }
}

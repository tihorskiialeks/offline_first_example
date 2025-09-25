import 'package:dartz/dartz.dart';
import 'package:offline_first/core/error_handler/error_handler.dart';
import 'package:offline_first/core/error_handler/failure.dart';


abstract class BaseRepository {
  Future<Either<Failure, T>> safeExecute<T>(
      Future<T> Function() operation) async {
    try {
      final result = await operation();
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:offline_first/core/error_handler/data_source.dart';
import 'package:offline_first/core/error_handler/failure.dart';
import 'package:offline_first/core/error_handler/response_code.dart';


class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      // dio error so its error from response of the API
      failure = _handleError(error);
    } else if (error is FirebaseException) {
      failure = _handleFireStoreError(error);
      log(error.message ?? '');
    } else {
      // default error
      failure = DataSource.defaultError.getFailure();
    }
  }

  Failure _handleError(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout =>
        DataSource.connectTimeout.getFailure(),
      DioExceptionType.sendTimeout => DataSource.sendTimeout.getFailure(),
      DioExceptionType.receiveTimeout => DataSource.receiveTimeout.getFailure(),
      DioExceptionType.badResponse => _handleBadResponse(error),
      DioExceptionType.cancel => DataSource.cancel.getFailure(),
      DioExceptionType.unknown => DataSource.defaultError.getFailure(),
      DioExceptionType.badCertificate => DataSource.badRequest.getFailure(),
      DioExceptionType.connectionError =>
        DataSource.noInternetConnection.getFailure(),
    };
  }

  Failure _handleFireStoreError(FirebaseException error) {
    return switch (error.code) {
      'permission-denied' => DataSource.forbidden.getFailure(),
      _ => DataSource.defaultError.getFailure(),
    };
  }

  Failure _handleBadResponse(DioException error) {
    return switch (error.response?.statusCode) {
      ResponseCode.badRequest => DataSource.badRequest.getFailure(),
      ResponseCode.forbidden => DataSource.forbidden.getFailure(),
      ResponseCode.unauthorized => DataSource.unauthorized.getFailure(),
      ResponseCode.notFound => DataSource.notFound.getFailure(),
      ResponseCode.internalServerError =>
        DataSource.internalServerError.getFailure(),
      _ => DataSource.defaultError.getFailure(),
    };
  }
}

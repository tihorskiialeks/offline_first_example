

import 'package:offline_first/core/error_handler/failure.dart';
import 'package:offline_first/core/error_handler/response_code.dart';
import 'package:offline_first/core/error_handler/response_message.dart';

enum DataSource {
  success,
  noContent,
  badRequest,
  forbidden,
  unauthorized,
  notFound,
  internalServerError,
  connectTimeout,
  cancel,
  receiveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  defaultError;

  Failure getFailure() {
    return switch (this) {
      DataSource.badRequest =>
        Failure(ResponseCode.badRequest, ResponseMessage.badRequest),
      DataSource.forbidden =>
        Failure(ResponseCode.forbidden, ResponseMessage.forbidden),
      DataSource.unauthorized =>
        Failure(ResponseCode.unauthorized, ResponseMessage.unauthorized),
      DataSource.notFound =>
        Failure(ResponseCode.notFound, ResponseMessage.notFound),
      DataSource.internalServerError => Failure(
          ResponseCode.internalServerError,
          ResponseMessage.internalServerError),
      DataSource.connectTimeout =>
        Failure(ResponseCode.connectTimeout, ResponseMessage.connectTimeout),
      DataSource.cancel => Failure(ResponseCode.cancel, ResponseMessage.cancel),
      DataSource.receiveTimeout =>
        Failure(ResponseCode.receiveTimeout, ResponseMessage.receiveTimeout),
      DataSource.sendTimeout =>
        Failure(ResponseCode.sendTimeout, ResponseMessage.sendTimeout),
      DataSource.cacheError =>
        Failure(ResponseCode.cacheError, ResponseMessage.cacheError),
      DataSource.noInternetConnection => Failure(
          ResponseCode.noInternetConnection,
          ResponseMessage.noInternetConnection),
      DataSource.defaultError =>
        Failure(ResponseCode.defaultError, ResponseMessage.defaultErrorMessage),
      _ =>
        Failure(ResponseCode.defaultError, ResponseMessage.defaultErrorMessage),
    };
  }
}

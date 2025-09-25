
import 'package:offline_first/core/error_handler/response_code.dart';
import 'package:offline_first/core/error_handler/response_message.dart';

class Failure {
  int code;
  String message;

  Failure(this.code, this.message);
}

class DefaultFailure extends Failure {
  DefaultFailure()
      : super(ResponseCode.defaultError, ResponseMessage.defaultErrorMessage);
}

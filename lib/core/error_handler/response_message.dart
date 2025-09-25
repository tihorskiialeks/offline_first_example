abstract class ResponseMessage {
  /// API response codes
  static const String success = 'success';
  static const String noContent = 'no content';
  static const String badRequest = 'bad request error';
  static const String forbidden = 'forbidden error';
  static const String unauthorized = 'unauthorized error';
  static const String notFound = 'not found error';
  static const String internalServerError = 'internal server error';

  /// local responses codes
  static const String defaultErrorMessage = 'default error';
  static const String connectTimeout = 'timeout error';
  static const String cancel = 'default error';
  static const String receiveTimeout = 'timeout error';
  static const String sendTimeout = 'timeout error';
  static const String cacheError = 'cache error';
  static const String noInternetConnection = 'no internet error';
}

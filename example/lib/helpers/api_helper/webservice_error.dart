import 'package:clear_notification_example/utils/import_utils_class_package.dart';

class WebServiceError implements Exception {
  int? statusCode;
  String? description;

  WebServiceError({
    this.statusCode,
    this.description
  });

  @override
  String toString() {
    String errorStr = "";
    String genericErrorStr = "";

    if (statusCode != null) {
      errorStr = "genericError_apiError-$statusCode";
      String tryAgainStr = 'genericError_apiErrorTryAgain';
      genericErrorStr = "$statusCode! $tryAgainStr";
    }
    else {
      errorStr = description.nonNullValue();
      genericErrorStr = "genericError_unknownException";
    }

    return errorStr.isNotEmpty ? errorStr : genericErrorStr;
  }
}

class APIClientException extends WebServiceError {
  APIClientException({required int statusCode, String? description}) : super(statusCode: statusCode, description: description);
}

class BadRequestException extends APIClientException {
  BadRequestException() : super(statusCode: 400);
}

class UnauthorisedException extends APIClientException {
  UnauthorisedException() : super(statusCode: 401);
}

class APIAccessException extends APIClientException {
  APIAccessException() : super(statusCode: 403);
}

class ResourceNotFoundException extends APIClientException {
  ResourceNotFoundException() : super(statusCode: 404);
}

class MethodNotAllowedException extends APIClientException {
  MethodNotAllowedException() : super(statusCode: 405);
}

class APITimeOutException extends APIClientException {
  APITimeOutException() : super(statusCode: 408);
}

class InternalServerException extends APIClientException {
  InternalServerException() : super(statusCode: 500);
}

class ServiceUnavailableException extends APIClientException {
  ServiceUnavailableException() : super(statusCode: 503);
}

class InternetConnectionError extends APIClientException {
  InternetConnectionError() : super(statusCode: 3999);
}

class NoResponseException extends APIClientException {
  NoResponseException() : super(statusCode: 4000);
}

class AuthTokenException extends APIClientException {
  AuthTokenException() : super(statusCode: 4001);
}

class SessionExpiredException extends APIClientException {
  SessionExpiredException() : super(statusCode: 4003);
}

class CatchCustomException extends WebServiceError {
  CatchCustomException([String? description]) : super(description: description);
}

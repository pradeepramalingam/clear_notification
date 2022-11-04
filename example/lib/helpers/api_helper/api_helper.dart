
import 'package:clear_notification_example/utils/import_utils_class_package.dart';
import 'package:http/http.dart' as http;

class APIHelper {
  final int _timeOutInterval = 30;

  Future<Tuple3<bool, dynamic, WebServiceError?>> post(
    Uri url,
    dynamic body, {
    String contentType = "application/json",
    bool isAuthorizationRequired = true,
  }) async {
    Map<String, String> header = <String, String>{};
    header[HttpHeaders.contentTypeHeader] = contentType;

    debugPrint("Request Params: ${json.encode(body)}", wrapWidth: 1024);

    Tuple3<bool, dynamic, WebServiceError?> responseJson;
    try {
      debugPrint('Api Post, url $url');
      debugPrint("Request Headers: ${json.encode(header)}", wrapWidth: 1024);
      debugPrint("Request Params: ${json.encode(body)}", wrapWidth: 1024);

      final response = await http
          .post(url, body: json.encode(body), headers: header)
          .timeout(
        Duration(seconds: _timeOutInterval),
        onTimeout: () {
          return http.Response('Time out exception!!!!!!', 408);
        },
      );
      responseJson = _returnResponse(response);
      return responseJson;
    } on SocketException {
      return Tuple3(false, null, InternetConnectionError());
    } on TimeoutException {
      return Tuple3(false, null, APITimeOutException());
    } catch (error) {
      return Tuple3(false, null, CatchCustomException(error.toString()));
    }
  }
}

Tuple3<bool, dynamic, WebServiceError?> _returnResponse(
    http.Response? response) {
  int statusCode = 4000;
  // int apiResultCode = 4000;
  dynamic responseJson;
  if (response != null) {
    try {
      statusCode = response.statusCode;
      if (response.bodyBytes.isNotEmpty) {
        responseJson =
            json.decode(const Utf8Decoder().convert(response.bodyBytes));
        // if ((responseJson is Map) && responseJson.containsKey('resultCode') && responseJson['resultCode'] is int) {
        //   apiResultCode = responseJson['resultCode'] ?? 0;
        // }
      }
      else {
        responseJson = {};
      }
      JsonEncoder encoder = const JsonEncoder();
      String prettyprint = encoder.convert(responseJson);
      debugPrint("API Response: $prettyprint", wrapWidth: 1024);
    } on Exception catch (_) {
      debugPrint('PARSE ERROR');
      debugPrint('${response.statusCode}');
      debugPrint(response.body);
    }
  } else {
    debugPrint("API Response: No Response Data");
  }

  switch (statusCode) {
    case 200:
      if (responseJson != null) {
        return Tuple3(true, responseJson, null);
        /*
        switch (apiResultCode) {
          case 4000:
            return Tuple3(false, null, NoResponseException());
          case 0:
            return Tuple3(true, responseJson, null);
          default:
            String resultDescription = responseJson['resultDescription'] ?? '';
            resultDescription = resultDescription.isEmpty ? responseJson['description'] ?? '' : resultDescription;
            return Tuple3(false, null, APIClientException(statusCode: apiResultCode, description: resultDescription));
        }
        */
      }
      return Tuple3(
          false, null, NoResponseException());
    case 400:
      return Tuple3(false, null, BadRequestException());
    case 401:
      return Tuple3(false, null, UnauthorisedException());
    case 403:
      return Tuple3(false, null, APIAccessException());
    case 404:
      return Tuple3(false, null, ResourceNotFoundException());
    case 405:
      return Tuple3(false, null, MethodNotAllowedException());
    case 408:
      return Tuple3(false, null, APITimeOutException());
    case 500:
      return Tuple3(false, null, InternalServerException());
    case 503:
      return Tuple3(false, null, ServiceUnavailableException());
    case 3999:
      return Tuple3(false, null, InternetConnectionError());
    case 4000:
      return Tuple3(false, null, NoResponseException());
    case 4001:
      return Tuple3(false, null, AuthTokenException());
    case 4003:
      return Tuple3(false, null, SessionExpiredException());
    default:
      String? errorReason = response?.reasonPhrase.nonNullValue();
      return Tuple3(
          false,
          null,
          APIClientException(statusCode: statusCode, description: errorReason.nonNullValue())
      );
  }
}

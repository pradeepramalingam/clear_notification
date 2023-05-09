
// import 'package:clear_notification_example/utils/import_utils_class_package.dart';

class APIRouter {
  static final APIRouter _sharedInstance = APIRouter._internal();
  APIRouter._internal();
  static APIRouter get instance => _sharedInstance;

  final String _baseURL = '51.105.237.95';
  final String _baseURLAdditionalPath = 'QA_transitnet/api/mobile';

  Uri driverLogin() {
    return Uri.https(_baseURL, '$_baseURLAdditionalPath/auth');
  }
}

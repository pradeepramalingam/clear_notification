import 'package:clear_notification_example/utils/import_utils_class_package.dart';

class WebService {
  final APIHelper _helper = APIHelper();
  final APIRouter _router = APIRouter.instance;

  Future<Tuple3<bool, LoginResponse?, String>> driverLoginAPI(
      Map<String, String> bodyParams) async {
    final response = await _helper.post(_router.driverLogin(), bodyParams,
        isAuthorizationRequired: false);
    if (response.item1) {
      var formattedResponse = LoginResponse.fromJson(response.item2);
      return Tuple3(
          response.item1, formattedResponse, response.item3.toString());
    } else {
      return Tuple3(false, null, response.item3.toString());
    }
  }
}
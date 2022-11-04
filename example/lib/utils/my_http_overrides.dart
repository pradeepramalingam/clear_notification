import 'package:clear_notification_example/utils/import_utils_class_package.dart';

// FIXME: Added to override certificate issue with api server
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
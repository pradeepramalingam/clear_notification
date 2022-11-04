
import 'package:clear_notification_example/utils/import_utils_class_package.dart';

extension RemoteMessageExtn on RemoteMessage {
  String toDescString() {
    try {
      Map<String, dynamic> msgMap = toMap();
      String msgStr = jsonEncode(msgMap);
      return msgStr;
    }
    catch (error) {
      return error.toString();
    }
  }
}


import 'clear_notification_platform_interface.dart';

class ClearNotification {
  Future<bool?> clearAllNotifications() {
    return ClearNotificationPlatform.instance.clearAllNotifications();
  }

  Future<bool?> clearIOSNotificationWithIDs(List<String> notificationIDs) {
    return ClearNotificationPlatform.instance.clearIOSNotificationWithIDs(notificationIDs);
  }

  Future<bool?> clearAndroidNotificationWithIDs(List<int> notificationIDs) {
    return ClearNotificationPlatform.instance.clearAndroidNotificationWithIDs(notificationIDs);
  }

  Future<bool?> clearNotificationWithKeyValues(String key, List<dynamic> values, int dataTypeValue) {
    // dataTypeValue
    //   0 => int
    //   1 => String
    return ClearNotificationPlatform.instance.clearNotificationWithKeyValues(key, values, dataTypeValue);
  }
}

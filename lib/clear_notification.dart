
import 'clear_notification_platform_interface.dart';

class ClearNotification {
  Future<String?> getPlatformVersion() {
    return ClearNotificationPlatform.instance.getPlatformVersion();
  }

  Future<bool?> clearAllNotifications() {
    return ClearNotificationPlatform.instance.clearAllNotifications();
  }

  Future<bool?> clearIOSNotificationWithIDs(List<String> notificationIDs) {
    return ClearNotificationPlatform.instance.clearIOSNotificationWithIDs(notificationIDs);
  }

  Future<bool?> clearAndroidNotificationWithIDs(List<int> notificationIDs) {
    return ClearNotificationPlatform.instance.clearAndroidNotificationWithIDs(notificationIDs);
  }

  Future<dynamic?> clearNotificationWithKeyValues(String key, List<dynamic> values, int dataTypeValue) {
    // dataTypeValue
    //   0 => int
    //   1 => String
    return ClearNotificationPlatform.instance.clearNotificationWithKeyValues(key, values, dataTypeValue);
  }
}

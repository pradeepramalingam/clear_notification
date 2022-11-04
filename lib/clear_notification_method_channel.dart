import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'clear_notification_platform_interface.dart';

/// An implementation of [ClearNotificationPlatform] that uses method channels.
class MethodChannelClearNotification extends ClearNotificationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('clear_notification');

  Future<bool?> clearAllNotifications() async {
    final result = await methodChannel.invokeMethod<bool>('clearAllNotifications');
    return result;
  }

  Future<bool?> clearIOSNotificationWithIDs(List<String> notificationIDs) async {
    final result = await methodChannel.invokeMethod<bool>('clearIOSNotificationWithIDs', {"notificationIDs": notificationIDs});
    return result;
  }

  Future<bool?> clearAndroidNotificationWithIDs(List<int> notificationIDs) async {
    final result = await methodChannel.invokeMethod<bool>('clearAndroidNotificationWithIDs', {"notificationIDs": notificationIDs});
    return result;
  }

  Future<bool?> clearNotificationWithKeyValues(String key, List<dynamic> values, int dataTypeValue) async {
    final result = await methodChannel.invokeMethod<bool>('clearNotificationWithKeyValues', {"keyToFilter": key, "valuesToFilter": values, "valueDataType": dataTypeValue});
    return result;
  }
}

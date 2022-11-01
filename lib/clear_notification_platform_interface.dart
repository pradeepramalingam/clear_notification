import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'clear_notification_method_channel.dart';

abstract class ClearNotificationPlatform extends PlatformInterface {
  /// Constructs a ClearNotificationPlatform.
  ClearNotificationPlatform() : super(token: _token);

  static final Object _token = Object();

  static ClearNotificationPlatform _instance = MethodChannelClearNotification();

  /// The default instance of [ClearNotificationPlatform] to use.
  ///
  /// Defaults to [MethodChannelClearNotification].
  static ClearNotificationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ClearNotificationPlatform] when
  /// they register themselves.
  static set instance(ClearNotificationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> clearAllNotifications() {
    throw UnimplementedError('clearAllNotifications() has not been implemented.');
  }

  Future<bool?> clearIOSNotificationWithIDs(List<String> notificationIDs) {
    throw UnimplementedError('clearNotificationWithIDs() has not been implemented.');
  }

  Future<bool?> clearAndroidNotificationWithIDs(List<int> notificationIDs) {
    throw UnimplementedError('clearAndroidNotificationWithIDs() has not been implemented.');
  }

  Future<bool?> clearNotificationWithKeyValues(String key, List<dynamic> values, int dataTypeValue) {
    throw UnimplementedError('clearNotificationWithKeyValues() has not been implemented.');
  }
}

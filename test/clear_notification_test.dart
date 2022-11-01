import 'package:flutter_test/flutter_test.dart';
import 'package:clear_notification/clear_notification.dart';
import 'package:clear_notification/clear_notification_platform_interface.dart';
import 'package:clear_notification/clear_notification_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockClearNotificationPlatform
    with MockPlatformInterfaceMixin
    implements ClearNotificationPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool?> clearAllNotifications() => Future.value(true);

  @override
  Future<bool?> clearIOSNotificationWithIDs(List<String> notificationIDs) => Future.value(true);

  @override
  Future<bool?> clearAndroidNotificationWithIDs(List<int> notificationIDs) => Future.value(true);

  @override
  Future<bool?> clearNotificationWithKeyValues(String key, List values, int dataTypeValue) => Future.value(true);
}

void main() {
  final ClearNotificationPlatform initialPlatform = ClearNotificationPlatform.instance;

  test('$MethodChannelClearNotification is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelClearNotification>());
  });

  test('getPlatformVersion', () async {
    ClearNotification clearNotificationPlugin = ClearNotification();
    MockClearNotificationPlatform fakePlatform = MockClearNotificationPlatform();
    ClearNotificationPlatform.instance = fakePlatform;

    expect(await clearNotificationPlugin.getPlatformVersion(), '42');
  });
}

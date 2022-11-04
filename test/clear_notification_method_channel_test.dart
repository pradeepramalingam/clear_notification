import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clear_notification/clear_notification_method_channel.dart';

void main() {
  MethodChannelClearNotification platform = MethodChannelClearNotification();
  const MethodChannel channel = MethodChannel('clear_notification');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}

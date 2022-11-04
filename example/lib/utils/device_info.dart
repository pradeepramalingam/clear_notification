import 'dart:ui' as ui;
import 'package:clear_notification_example/utils/import_utils_class_package.dart';

enum DeviceType {
  tablet,
  phone,
  unknown
}

class DeviceInfo {
  static final DeviceInfo _sharedInstance = DeviceInfo._internal();
  DeviceInfo._internal();
  static DeviceInfo get instance => _sharedInstance;

  DeviceType _deviceType = DeviceType.unknown;

  get deviceType {
    if (_deviceType == DeviceType.unknown) {
      _getDeviceType();
    }

    return _deviceType;
  }

  _getDeviceType() {
    final double devicePixelRatio = ui.window.devicePixelRatio;
    final ui.Size size = ui.window.physicalSize;
    final double width = size.width;
    final double height = size.height;


    if(devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      _deviceType = DeviceType.tablet;
    }
    else if(devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      _deviceType = DeviceType.tablet;
    }
    else {
      _deviceType = DeviceType.phone;
    }
  }

  BuildContext? _currentContext() {
    return NavigationService.navigatorKey.currentContext;
  }

  double getScreenWidth() {
    var context = _currentContext();
    if (context == null) {
      return 0;
    }
    return MediaQuery.of(context).size.width;
  }

  double getScreenHeight() {
    var context = _currentContext();
    if (context == null) {
      return 0;
    }
    return MediaQuery.of(context).size.height;
  }

  double getScreenHeightExcludeSafeArea() {
    var context = _currentContext();
    if (context == null) {
      return 0;
    }
    final double height =  MediaQuery.of(context).size.height;
    final EdgeInsets padding = MediaQuery.of(context).padding;
    return height - padding.top - padding.bottom;
  }

  String getPlatform() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'ANDROID';
      case TargetPlatform.iOS:
        return 'IOS';
      case TargetPlatform.fuchsia:
        return 'FUCHSIA';
      case TargetPlatform.macOS:
        return 'MACOS';
      case TargetPlatform.linux:
        return 'LINUX';
      case TargetPlatform.windows:
        return 'WINDOWS';
      default:
        return 'OTHER';
    }
  }
}
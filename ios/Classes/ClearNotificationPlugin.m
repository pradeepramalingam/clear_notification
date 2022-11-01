#import "ClearNotificationPlugin.h"
#if __has_include(<clear_notification/clear_notification-Swift.h>)
#import <clear_notification/clear_notification-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "clear_notification-Swift.h"
#endif

@implementation ClearNotificationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftClearNotificationPlugin registerWithRegistrar:registrar];
}
@end

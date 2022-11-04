import 'package:clear_notification_example/utils/import_utils_class_package.dart';

/// There 3 steps to work with push notification :
/// - Create the notification
/// - Hanldle notification click
/// - App status (foreground/background and killed(Terminated))
///
/// Creating the notification:
///
/// - When the app is killed or in background state, creating the notification is handled through the back-end services.
///   When the app is in the foreground, we have full control of the notification. so in this case we build the notification from scratch.
///
/// Handle notification click:
///
/// - When the app is killed, there is a function called getInitialMessage which
///   returns the remoteMessage in case we receive a notification otherwise returns null.
///   It can be called at any point of the application (Preferred to be after defining GetMaterialApp so that we can go to any screen without getting any errors)
/// - When the app is in the background, there is a function called onMessageOpenedApp which is called when user clicks on the notification.
///   It returns the remoteMessage.
/// - When the app is in the foreground, there is a function flutterLocalNotificationsPlugin, is passes a future function called onSelectNotification which
///   is called when user clicks on the notification.
///

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() async {
    _requestPermission();
    _setToken();
    _enableIOSNotifications();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      ),
    );
    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? messageDetails) async {
      //android => this is executed when app is in foreground and tapped on notification
      RemoteMessage? msg = messageDetails?.toRemoteMessage();
      if (msg != null) {
        handleNotificationTaps(message: msg);
      }
    });

    _notificationTapListener();
    _firebaseForegroundListener();
    _firebaseBGOnTapListener();
    _listenToFCMTokenRefresh();
  }

  static void _requestPermission() {
    FirebaseMessaging.instance.requestPermission().then((value) {
      debugPrint('notification status: ${value.authorizationStatus.name}');
    });
  }

  static void _setToken() async {
    String apnsToken = await FirebaseMessaging.instance.getAPNSToken() ?? '';
    debugPrint('APNs Token: $apnsToken');
    SharedPrefs.instance.setAPNsToken(apnsToken);

    try {
      String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      debugPrint('FCM Token: $fcmToken');
      SharedPrefs.instance.setFCMToken(fcmToken);
    } catch (firebaseOfflineTokenException) {
      debugPrint(
          'FCM Token Error: ${firebaseOfflineTokenException.toString()}');
    }
  }

  static _enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  static void _notificationTapListener() {
    //iOS,Android => when the app is in terminated state and user taps on notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        handleNotificationTaps(
          message: message,
          fromBG: true,
        );
      }
    });
  }

  static void _firebaseForegroundListener() async {
    FirebaseMessaging.onMessage.listen((message) {
      //android => this is executed when app is in foreground and a notification is received

      if (message.notification != null) {
        switch (DeviceInfo.instance.getPlatform()) {
          case 'ANDROID':
            LocalNotificationService.display(message);
            break;
          default:
            break;
        }
      }
    });
  }

  static void _firebaseBGOnTapListener() async {
    //iOS => when the app is in background/foreground state and user taps on notification
    //Android => when the app is in background state and user taps on notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        handleNotificationTaps(message: message);
      }
    });
  }

  static Future _listenToFCMTokenRefresh() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((newFCMToken) async {
      debugPrint('FCM New Token: $newFCMToken');
      SharedPrefs.instance.setFCMToken(newFCMToken);

      if (!(await SharedPrefs.instance.getIsUserLoggedIn())) {
        return;
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            'TNetMobileAppNotification',
            'TNetMobileAppNotification_channel',
            channelDescription:
                'This is channel used for notification communication',
            importance: Importance.max,
            priority: Priority.high,
            styleInformation: BigTextStyleInformation(''),
          ),
          iOS: IOSNotificationDetails());

      await _notificationsPlugin.show(id, message.notification?.title,
          message.notification?.body, notificationDetails,
          payload: message.toDescString());
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  static void handleNotificationTaps({
    required RemoteMessage message,
    bool fromBG = false,
  }) async {
    debugPrint(message.toString());
  }
}


Future<void> pushNotificationBGHandler(RemoteMessage message) async {
  //Android => this is executed when app is in bg and a notification is received
}

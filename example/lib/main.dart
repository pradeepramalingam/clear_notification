import 'package:clear_notification/clear_notification.dart';
import 'package:clear_notification_example/utils/import_utils_class_package.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initialize firebase
  await Firebase.initializeApp();
  //to capture bg notification activities
  FirebaseMessaging.onBackgroundMessage(pushNotificationBGHandler);
  //Initialize Notification Settings
  LocalNotificationService.initialize();

  // HttpOverrides.global = new MyHttpOverrides();
  HttpOverrides.global = MyHttpOverrides();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  _configLoading();

  runApp(const MyApp());
}

void _configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.blue.shade200
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.blue.shade400.withOpacity(0.5)
    ..toastPosition = EasyLoadingToastPosition.bottom
    ..userInteractions = false;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _clearNotificationPlugin = ClearNotification();
  var _isLoggedIn = false;

  @override
  void initState() {
    verifyLoggedIn();
    super.initState();
  }

  Future verifyLoggedIn () async {
    bool isLoggedIn = await SharedPrefs.instance.getIsUserLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  Future<bool>logIn() async {
    String fcmToken = await SharedPrefs.instance.getFCMToken();
    var bodyParams = {
      "instanceId" : fcmToken,
      "email" : 'pradeep.ramalingam@swordgroup.in',
      "language" : 'en'
    };
    EasyLoading.show();
    Tuple3<bool, LoginResponse?, String> response = await WebService().driverLoginAPI(bodyParams);
    EasyLoading.dismiss();
    if (response.item1) {
      var loginResponseCode = response.item2?.resultCode;
      if (loginResponseCode != null) {
        var loginResponse = response.item2?.resultDescription ?? 'driverLogin_loginFailed';
        switch (loginResponseCode) {
          case 0:
            if (loginResponse.toLowerCase() == 'Success'.toLowerCase()) {
              EasyLoading.showInfo('driverLogin_codeSent');
              await SharedPrefs.instance.setIsUserLoggedIn(true);
              setState(() {
                _isLoggedIn = true;
              });
              return true;
            }
            else {
              EasyLoading.showError(loginResponse);
            }
            break;
          case -4:
            EasyLoading.showInfo('driverLogin_registerNew');
            break;
          default:
            EasyLoading.showError(loginResponse);
            break;
        }
      }
    }
    else {
      EasyLoading.showError(response.item3);
    }
    return false;
  }

  Future<void> clearNotification() async {
    try {
      // bool? result1 = await _clearNotificationPlugin.clearAllNotifications();
      // print(result1);

      // bool? result2 = await _clearNotificationPlugin.clearIOSNotificationWithIDs(['asd', 'qwe']);
      // print(result2);

      // bool? result3 = await _clearNotificationPlugin.clearAndroidNotificationWithIDs([123, 456]);
      // print(result3);

      bool? result4 = await _clearNotificationPlugin.clearNotificationWithKeyValues('testKey', ['321', '564'], 1);
      print(result4);
    }
    catch (exception) {
      print(exception.toString());
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: !_isLoggedIn ?
          ElevatedButton(
            child: Text('Log In'),
            onPressed: () => logIn(),
          ) :
          ElevatedButton(
            child: Text('Clear Notification'),
            onPressed: () => clearNotification(),
          ),
        ),
      ),
    );
  }
}

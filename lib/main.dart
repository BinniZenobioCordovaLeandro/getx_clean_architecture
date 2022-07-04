import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pickpointer/src/core/providers/firebase_notification_provider.dart';
import 'package:pickpointer/src/core/providers/notification_provider.dart';
import 'package:pickpointer/src/core/themes/dark_theme.dart';
import 'package:pickpointer/src/core/themes/light_theme.dart';
import 'package:pickpointer/src/features/route_feature/views/routes_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final NotificationProvider? notificationProvider =
    NotificationProvider.getInstance();

final FirebaseNotificationProvider? firebaseNotificationProvider =
    FirebaseNotificationProvider.getInstance();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  notificationProvider?.initialize();
  firebaseNotificationProvider?.initialize();
  firebaseNotificationProvider?.getToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: LightTheme().get(),
      darkTheme: DarkTheme().get(),
      home: const RoutesPage(),
      defaultTransition: Transition.cupertino,
    );
  }
}

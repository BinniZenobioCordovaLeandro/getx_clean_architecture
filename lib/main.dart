import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/route_manager.dart';
import 'package:pickpointer/src/app.dart';
import 'package:pickpointer/src/core/themes/dark_theme.dart';
import 'package:pickpointer/src/core/themes/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pickpointer/src/features/offer_feature/views/offer_page.dart';
import 'package:pickpointer/src/features/order_feature/views/order_page.dart';
import 'package:pickpointer/src/features/route_feature/views/route_page.dart';
import 'package:pickpointer/src/features/user_feature/views/user_page.dart';
import 'package:pickpointer/web_layout.dart';
import 'firebase_options.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pages = [
      GetPage(
        name: '/',
        page: () => const App(),
      ),
      GetPage(
        name: '/route/:abstractRouteEntityId',
        page: () => const RoutePage(),
      ),
      GetPage(
        name: '/order/:abstractOrderEntityId',
        page: () => const OrderPage(),
        preventDuplicates: false,
        transition: Transition.upToDown,
      ),
      GetPage(
        name: '/offer/:abstractOfferEntityId',
        page: () => const OfferPage(),
        preventDuplicates: false,
        transition: Transition.upToDown,
      ),
      GetPage(
        name: '/user',
        page: () => const UserPage(),
      ),
    ];
    if (kIsWeb) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: LightTheme().get(),
        darkTheme: DarkTheme().get(),
        defaultTransition: Transition.cupertino,
        initialRoute: '/',
        getPages: pages,
        home: Row(
          children: const [
            Expanded(
              flex: 1,
              child: WebLayout(),
            ),
          ],
        ),
      );
    }
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: LightTheme().get(),
      darkTheme: DarkTheme().get(),
      defaultTransition: Transition.cupertino,
      initialRoute: '/',
      getPages: pages,
      home: const App(),
    );
  }
}

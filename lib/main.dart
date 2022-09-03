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
import 'package:pickpointer/web_layout.dart';
import 'firebase_options.dart';

Future<void> main() async {
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
    if (kIsWeb) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: LightTheme().get(),
        darkTheme: DarkTheme().get(),
        defaultTransition: Transition.cupertino,
        initialRoute: '/',
        getPages: [
          GetPage(
            name: '/',
            page: () => const App(),
          ),
          GetPage(
            name: '/order/:abstractOrderEntityId',
            page: () => const OrderPage(),
          ),
          GetPage(
            name: '/offer/:abstractOfferEntityId',
            page: () => const OfferPage(),
          ),
        ],
        home: Row(
          children: [
            const Expanded(
              flex: 1,
              child: WebLayout(),
            ),
            Container(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: const App(),
            )
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
      getPages: [
        GetPage(
          name: '/',
          page: () => const App(),
        ),
        GetPage(
          name: '/order/:abstractOrderEntityId',
          page: () => const OrderPage(),
        ),
        GetPage(
          name: '/offer/:abstractOfferEntityId',
          page: () => const OfferPage(),
        ),
      ],
      home: const App(),
    );
  }
}

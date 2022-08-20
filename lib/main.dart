import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pickpointer/src/app.dart';
import 'package:pickpointer/src/core/themes/dark_theme.dart';
import 'package:pickpointer/src/core/themes/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pickpointer/src/features/offer_feature/views/offer_page.dart';
import 'package:pickpointer/src/features/order_feature/views/order_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: const App(),
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
    );
  }
}

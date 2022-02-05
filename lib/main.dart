import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pickpointer/src/core/themes/dark_theme.dart';
import 'package:pickpointer/src/core/themes/light_theme.dart';
import 'package:pickpointer/src/features/route_feature/views/routes_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: LightTheme().get(),
      darkTheme: DarkTheme().get(),
      home: const RoutesPage(),
      defaultTransition: Transition.cupertino,
    );
  }
}

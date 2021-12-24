import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pickpointer/src/features/user_feature/views/user_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: UserPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pickpointer/src/features/user_feature/views/sign_in_user_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: SignInUserPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/progress_state_button_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';
import 'package:pickpointer/src/features/user_feature/logic/sign_in_controller.dart';
import 'package:progress_state_button/progress_button.dart';

class SignInUserPage extends StatefulWidget {
  const SignInUserPage({Key? key}) : super(key: key);

  @override
  State<SignInUserPage> createState() => _SignInUserPageState();
}

class _SignInUserPageState extends State<SignInUserPage> {
  final SignInController signInController = SignInController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Social Login',
        showGoback: true,
      ),
      body: Obx(() {
        return Center(
          child: FractionallySizedBoxWidget(
            child: WrapWidget(
              children: [
                ProgressStateButtonWidget(
                  state: signInController.googleIsLoading.value
                      ? ButtonState.loading
                      : ButtonState.success,
                  color: Colors.white,
                  background: const Color(0xFFDD4B39),
                  success: 'CONTINUAR CON GOOGLE',
                  onPressed: () {
                    signInController.signInWithGoogle().then((boolean) {
                      if (boolean) Navigator.of(context).pop(true);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

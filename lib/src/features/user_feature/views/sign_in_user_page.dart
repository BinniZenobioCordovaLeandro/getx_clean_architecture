import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/progress_state_button_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class SignInUserPage extends StatelessWidget {
  const SignInUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'PickPointer',
        showGoback: true,
      ),
      body: Center(
        child: FractionallySizedBoxWidget(
          child: WrapWidget(
            children: [
              ProgressStateButtonWidget(
                color: Colors.white,
                background: const Color(0xFFDD4B39),
                success: 'CONTINUAR CON GOOGLE',
                onPressed: () {
                  print('ger');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

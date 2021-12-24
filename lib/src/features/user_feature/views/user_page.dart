import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/scaffold_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/features/user_feature/logic/user_controller.dart';

class UserPage extends StatelessWidget {
  const UserPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: const AppBarWidget(
        title: 'User Page',
      ),
      body: GetBuilder<UserController>(
        init: UserController(),
        builder: (UserController userController) {
          return  const SizedBox(
            child: TextWidget('hi'),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pickpointer/packages/user_package/data/models/user_model.dart';
import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/future_builder_shimmer_widget.dart';
import 'package:pickpointer/src/core/widgets/scaffold_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/features/user_feature/logic/user_controller.dart';

class UserPage extends StatelessWidget {
  final UserController userController = UserController.instance;

  UserPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: const AppBarWidget(
        title: 'User Page',
      ),
      body: Obx(() {
        Future<List<AbstractUserEntity>> futureListAbstractUserEntity =
            userController.futureListAbstractUserEntity.value;
        return FutureBuilderShimmerWidget(
            key: key,
            future: futureListAbstractUserEntity,
            initialData: List<AbstractUserEntity>.from([
              const UserModel(
                id: '...',
                name: '...',
              ),
            ]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List<AbstractUserEntity> listAbstractUserEntity = snapshot.data;
              return ListView.builder(
                itemCount: listAbstractUserEntity.length,
                itemBuilder: (BuildContext context, int index) {
                  AbstractUserEntity abstractUserEntity =
                      listAbstractUserEntity[index];
                  return ListTile(
                    title: TextWidget(
                      '${abstractUserEntity.name}',
                    ),
                  );
                },
              );
            });
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pickpointer/src/core/widgets/form_widget.dart';
import 'package:pickpointer/src/core/widgets/progress_state_button_widget.dart';
import 'package:pickpointer/src/core/widgets/rank_widget.dart';
import 'package:pickpointer/src/core/widgets/scaffold_scroll_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/features/user_feature/logic/user_controller.dart';
import 'package:pickpointer/src/features/user_feature/views/widgets/pick_image_card.dart';
import 'package:progress_state_button/progress_button.dart';

class UserPage extends StatefulWidget {
  const UserPage({
    Key? key,
  }) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UserController userController = UserController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return FormWidget(
        key: userController.formKey,
        child: ScaffoldScrollWidget(
          isLoading: userController.isLoadingData.value,
          title: 'Perfil',
          children: [
            RankWidget(
              value: userController.rank.value,
            ),
            TextFieldWidget(
              labelText: 'Nombre Completo',
              initialValue: userController.name.value,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                return null;
              },
              onChanged: (value) => userController.name.value = value,
            ),
            TextFieldWidget(
              labelText: 'Email',
              initialValue: userController.email.value,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                RegExp emailPath = RegExp(
                  r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                );
                if (!emailPath.hasMatch(value)) {
                  return 'El email no es válido';
                }
                return null;
              },
              onChanged: (value) => userController.email.value = value,
            ),
            TextFieldWidget(
              labelText: 'Documento de Identidad',
              initialValue: userController.document.value,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                return null;
              },
              onChanged: (value) => userController.document.value = value,
            ),
            TextFieldWidget(
              labelText: 'Numero de Telefono',
              initialValue: userController.phoneNumber.value,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo es requerido';
                }
                return null;
              },
              onChanged: (value) => userController.phoneNumber.value = value,
            ),
            const SizedBox(
              width: double.infinity,
              child: TextWidget('Avatar'),
            ),
            PickImageCard(
              urlSvgOrImage: userController.avatar.value,
              onChanged: (String? string) {
                userController.avatar.value = string!;
              },
            ),
            SwitchListTile(
              title: const Text('Activar modo conductor'),
              value: userController.isDriver.value,
              onChanged: userController.isDriver.value
                  ? null
                  : (value) => userController.isDriver.value = value,
            ),
            if (userController.isDriver.value)
              TextFieldWidget(
                labelText: 'Placa',
                initialValue: userController.carPlate.value,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
                onChanged: (value) => userController.carPlate.value = value,
              ),
            if (userController.isDriver.value)
              const SizedBox(
                width: double.infinity,
                child: TextWidget('Foto de Carro'),
              ),
            if (userController.isDriver.value)
              PickImageCard(
                urlSvgOrImage: userController.carPhoto.value,
                onChanged: (String? string) {
                  userController.carPhoto.value = string!;
                },
              ),
            if (userController.isDriver.value)
              TextFieldWidget(
                labelText: 'Modelo de Carro',
                initialValue: userController.carModel.value,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
                onChanged: (value) => userController.carModel.value = value,
              ),
            if (userController.isDriver.value)
              TextFieldWidget(
                labelText: 'Color de Carro',
                initialValue: userController.carColor.value,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
                onChanged: (value) => userController.carColor.value = value,
              ),
            ProgressStateButtonWidget(
              state: userController.isLoadingSave.value
                  ? ButtonState.loading
                  : ButtonState.success,
              success: 'GUARDAR',
              onPressed: () => userController.updateUserData(),
            ),
          ],
        ),
      );
    });
  }
}

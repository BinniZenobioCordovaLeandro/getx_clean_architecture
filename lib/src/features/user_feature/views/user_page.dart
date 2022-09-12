import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickpointer/src/core/helpers/modal_bottom_sheet_helper.dart';
import 'package:pickpointer/src/core/widgets/form_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/progress_state_button_widget.dart';
import 'package:pickpointer/src/core/widgets/rank_widget.dart';
import 'package:pickpointer/src/core/widgets/scaffold_scroll_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';
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
                RegExp regExp = RegExp(r'^\+\d{11,15}$');
                if (!regExp.hasMatch(value)) {
                  return 'Corrige el formato, Ej. +51987123654';
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
              onPressed: () {
                bool isValidForm =
                    userController.formKey.currentState!.validate();
                if (isValidForm) {
                  userController
                      .sendVerificationCode(
                    phoneNumber: userController.phoneNumber.value,
                  )
                      .then((bool? boolean) {
                    if (boolean == true) {
                      ModalBottomSheetHelper(
                        context: context,
                        title: 'PickPointer!',
                        child: FormWidget(
                          key: userController.formCodeKey,
                          child: SizedBox(
                            width: double.infinity,
                            child: FractionallySizedBoxWidget(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: WrapWidget(
                                  children: [
                                    SizedBox(
                                      child: TextFieldWidget(
                                        labelText: 'Codigo de verificación',
                                        initialValue:
                                            userController.phoneCode.value,
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Este campo es requerido';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) => userController
                                            .phoneCode.value = value,
                                      ),
                                    ),
                                    SizedBox(
                                      child: ProgressStateButtonWidget(
                                        state:
                                            userController.isLoadingSave.value
                                                ? ButtonState.loading
                                                : ButtonState.success,
                                        success: 'VALIDAR NUMERO',
                                        onPressed: () {
                                          bool isValidForm = userController
                                              .formCodeKey.currentState!
                                              .validate();
                                          if (isValidForm) {
                                            userController.verifyCode(
                                              smsCode: userController
                                                  .phoneCode.value,
                                            );
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  });
                }
              },
            ),
          ],
        ),
      );
    });
  }
}

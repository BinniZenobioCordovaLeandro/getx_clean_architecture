import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/dropdown_button_form_field_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/switch_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class NewCreditCardWidget extends StatelessWidget {
  const NewCreditCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          BlurWidget(
            child: CardWidget(
              color: Colors.transparent,
              child: FractionallySizedBoxWidget(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: WrapWidget(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextFieldWidget(
                          labelText: 'Nombre del titular',
                          onChanged: (value) {
                            print(value);
                          },
                        ),
                      ),
                      SizedBox(
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              child: DropdownButtonFormFieldWidget(
                                labelText: 'Tipo de documento',
                                listValue: const ['DNI', 'Pasaporte', 'CE'],
                                value: 'DNI',
                                onChanged: (value) {
                                  print(value);
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFieldWidget(
                                labelText: 'Documento',
                                onChanged: (value) {
                                  print(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextFieldWidget(
                          labelText: 'Numero de tarjeta',
                          onChanged: (value) {
                            print(value);
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Flex(direction: Axis.horizontal, children: [
                          Expanded(
                            child: TextFieldWidget(
                              labelText: 'Mes',
                              onChanged: (value) {
                                print(value);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFieldWidget(
                              labelText: 'Año',
                              onChanged: (value) {
                                print(value);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFieldWidget(
                              labelText: 'CVV',
                              onChanged: (value) {
                                print(value);
                              },
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: SwitchWidget(
                          title: 'Guardar tarjeta',
                          value: false,
                          onChanged: (boolean) {
                            print('onChanged');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CardWidget(
            color: Colors.transparent,
            child: FractionallySizedBoxWidget(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: WrapWidget(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: TextFieldWidget(
                        labelText: 'Nombre del titular',
                        onChanged: (value) {
                          print(value);
                        },
                      ),
                    ),
                    SizedBox(
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            child: DropdownButtonFormFieldWidget(
                              labelText: 'Tipo de documento',
                              listValue: const ['DNI', 'Pasaporte', 'CE'],
                              value: 'DNI',
                              onChanged: (value) {
                                print(value);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFieldWidget(
                              labelText: 'Documento',
                              onChanged: (value) {
                                print(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextFieldWidget(
                        labelText: 'Numero de tarjeta',
                        onChanged: (value) {
                          print(value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Flex(direction: Axis.horizontal, children: [
                        Expanded(
                          child: TextFieldWidget(
                            labelText: 'Mes',
                            onChanged: (value) {
                              print(value);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFieldWidget(
                            labelText: 'Año',
                            onChanged: (value) {
                              print(value);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFieldWidget(
                            labelText: 'CVV',
                            onChanged: (value) {
                              print(value);
                            },
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: SwitchWidget(
                        title: 'Guardar tarjeta',
                        value: false,
                        onChanged: (boolean) {
                          print('onChanged');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

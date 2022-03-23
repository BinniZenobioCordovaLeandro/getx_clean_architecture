import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/elevated_button_widget.dart';
import 'package:pickpointer/src/core/widgets/form_widget.dart';
import 'package:pickpointer/src/core/widgets/scaffold_scroll_widget.dart';
import 'package:pickpointer/src/core/widgets/search_location_card_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';

class NewRoute extends StatelessWidget {
  const NewRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return FormWidget(
      key: formKey,
      child: ScaffoldScrollWidget(
        title: 'Solicitar nueva ruta',
        footer: ElevatedButtonWidget(
          title: 'Enviar',
          onPressed: () {
            print('enviar solicitud');
          },
        ),
        children: [
          const SearchLocationCardWidget(
            title: 'Punto de partida',
            labelText: '',
          ),
          const Divider(),
          const SearchLocationCardWidget(
            title: 'Punto de llegada',
            labelText: '',
          ),
          const Divider(),
          TextFieldWidget(
            labelText: 'Precio',
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Especifique el precio por asiento';
              }
              if (!(double.tryParse(value) != null)) {
                return 'El precio debe ser un número';
              }
              return null;
            },
            onChanged: (string) {
              print('object');
            },
          ),
          TextFieldWidget(
            labelText: 'Asientos',
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: false,
              signed: false,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Especifique el número de asientos';
              }
              if (!(int.tryParse(value) != null)) {
                return 'El número de asientos debe ser un número entero';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

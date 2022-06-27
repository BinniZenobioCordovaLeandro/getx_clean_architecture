import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pickpointer/src/core/widgets/form_widget.dart';
import 'package:pickpointer/src/core/widgets/progress_state_button_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/scaffold_scroll_widget.dart';
import 'package:pickpointer/src/core/widgets/search_location_card_widget.dart';
import 'package:pickpointer/src/features/route_feature/logic/new_route_controller.dart';
import 'package:progress_state_button/progress_button.dart';

class NewRoutePage extends StatefulWidget {
  const NewRoutePage({Key? key}) : super(key: key);

  @override
  State<NewRoutePage> createState() => _NewRoutePageState();
}

class _NewRoutePageState extends State<NewRoutePage> {
  final NewRouteController newRouteController = NewRouteController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return FormWidget(
        key: newRouteController.formKey,
        child: ScaffoldScrollWidget(
          title: 'Solicitar nueva ruta',
          children: [
            TextFieldWidget(
              maxLines: 2,
              labelText: 'Describe Punto de Origen',
              helperText: 'Ej. Frente a plaza de Armas de Lima',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Especifique el INICIO de la ruta';
                }
                return null;
              },
              onChanged: (String string) {
                newRouteController.from.value = string;
              },
            ),
            SearchLocationCardWidget(
              disabled: true,
              title: 'Punto de origen en Mapa',
              labelText: 'Buscar en GoogleMaps',
              leading: const Icon(
                Icons.taxi_alert_outlined,
                color: Colors.blue,
              ),
              iconMarker: const Icon(
                Icons.location_pin,
                color: Colors.blue,
              ),
              initialLatLng: newRouteController.startPosition.value,
              onChanged: (LatLng latLng) {
                newRouteController.startPosition.value = latLng;
              },
            ),
            const Divider(),
            TextFieldWidget(
              maxLines: 2,
              labelText: 'Describe Punto de Destino',
              helperText: 'Ej. Frente al Colegio Monterrico de Arequipa',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Especifique el FINAL de la ruta';
                }
                return null;
              },
              onChanged: (String string) {
                newRouteController.to.value = string;
              },
            ),
            SearchLocationCardWidget(
              disabled: true,
              title: 'Punto de destino en Mapa',
              labelText: 'Buscar en Maps',
              leading: const Icon(
                Icons.location_pin,
                color: Colors.red,
              ),
              iconMarker: const Icon(
                Icons.location_pin,
                color: Colors.red,
              ),
              initialLatLng: newRouteController.endPosition.value,
              onChanged: (LatLng latLng) {
                newRouteController.endPosition.value = latLng;
              },
            ),
            const Divider(),
            TextFieldWidget(
              labelText: 'Precio sugerido por asiento',
              helperText: 'Ej. 4.00',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: false,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Especifique el precio por asiento. Ej. 4.00';
                }
                if (!(double.tryParse(value) != null)) {
                  return 'El precio debe ser un número';
                }
                if (double.parse(value) < 5) {
                  return 'El precio debe ser mayor a 5.00';
                }
                return null;
              },
              onChanged: (string) {
                String price = double.parse(string).toStringAsFixed(3);
                newRouteController.price.value = double.parse(price);
              },
            ),
            TextFieldWidget(
              labelText: 'Titulo simple',
              helperText: 'Ej. De Lima a Arequipa',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Especifique el titulo de la ruta';
                }
                return null;
              },
              onChanged: (String string) {
                newRouteController.title.value = string;
              },
            ),
            const Divider(),
            ProgressStateButtonWidget(
              state: newRouteController.isLoading.value
                  ? ButtonState.loading
                  : ButtonState.success,
              success: 'Enviar solicitud',
              onPressed: () {
                newRouteController.onSubmit();
              },
            )
          ],
        ),
      );
    });
  }
}

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

class NewRoute extends StatefulWidget {
  const NewRoute({Key? key}) : super(key: key);

  @override
  State<NewRoute> createState() => _NewRouteState();
}

class _NewRouteState extends State<NewRoute> {
  final NewRouteController newRouteController = NewRouteController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return FormWidget(
        key: newRouteController.formKey,
        child: ScaffoldScrollWidget(
          title: 'Solicitar nueva ruta',
          footer: ProgressStateButtonWidget(
            state: newRouteController.isLoading.value
                ? ButtonState.loading
                : ButtonState.success,
            success: 'Enviar solicitud',
            onPressed: () {
              newRouteController.onSubmit();
            },
          ),
          children: [
            SearchLocationCardWidget(
              disabled: true,
              title: 'Punto de partida',
              labelText: 'Buscar ubicación',
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
            SearchLocationCardWidget(
              disabled: true,
              title: 'Punto de llegada',
              labelText: 'Buscar ubicación',
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
              labelText: 'Precio',
              helperText: 'Ej. 4.00',
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
                newRouteController.price.value = string;
              },
            ),
            TextFieldWidget(
              labelText: 'Titulo',
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
            TextFieldWidget(
              labelText: 'Descripción',
              helperText: 'Ej. Desde Plaza de Armas de Lima hasta Colegio Monterrico de Arequipa',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Especifique la descripción de la ruta';
                }
                return null;
              },
              onChanged: (String string) {
                newRouteController.description.value = string;
              },
            ),
          ],
        ),
      );
    });
  }
}

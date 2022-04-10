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
          children: [
            TextFieldWidget(
              labelText: 'Punto de Origen',
              helperText: 'Ej. Plaza de Armas de Lima',
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
              labelText: 'Buscar en Maps',
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
              labelText: 'Punto de Destino',
              helperText: 'Ej. Colegio Monterrico de Arequipa',
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
                return null;
              },
              onChanged: (string) {
                newRouteController.price.value = string;
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

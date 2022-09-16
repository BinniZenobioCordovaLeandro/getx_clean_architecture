import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pickpointer/src/core/widgets/form_widget.dart';
import 'package:pickpointer/src/core/widgets/progress_state_button_widget.dart';
import 'package:pickpointer/src/core/widgets/switch_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/scaffold_scroll_widget.dart';
import 'package:pickpointer/src/core/widgets/search_location_card_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
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
          title: (newRouteController.origin.value.isNotEmpty &&
                  newRouteController.destain.value.isNotEmpty)
              ? 'De ${newRouteController.origin.value} hasta ${newRouteController.destain.value}'
              : 'Solicitar nueva ruta',
          children: [
            const SizedBox(
              width: double.infinity,
              child: TextWidget(
                'TIP: Las rutas son rieles virtuales que los vehiculos pueden realizar.',
              ),
            ),
            TextFieldWidget(
              labelText: 'Ciudad de Origen',
              helperText: 'Ej. Lima',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ej. Lima';
                }
                return null;
              },
              onChanged: (String string) {
                newRouteController.origin.value = string;
              },
            ),
            TextFieldWidget(
              maxLines: 2,
              labelText: 'Describe Punto exacto de Origen',
              helperText: 'Ej. Frente a plaza de Armas de Lima',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ej. Frente a plaza de Armas de Lima';
                }
                return null;
              },
              onChanged: (String string) {
                newRouteController.from.value = string;
              },
            ),
            SearchLocationCardWidget(
              disabled: true,
              title: 'Marca el origen en el Mapa',
              labelText: 'Latitude y longitud',
              leading: const Icon(
                Icons.taxi_alert_outlined,
                color: Colors.blue,
              ),
              iconMarker: const Icon(
                Icons.location_pin,
                color: Colors.blue,
                size: 50.0,
              ),
              initialLatLng: newRouteController.startPosition.value,
              onChanged: (LatLng latLng) {
                newRouteController.startPosition.value = latLng;
              },
            ),
            const Divider(),
            TextFieldWidget(
              labelText: 'Ciudad de Destino',
              helperText: 'Ej. Huancayo',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ej. Huancayo';
                }
                return null;
              },
              onChanged: (String string) {
                newRouteController.destain.value = string;
              },
            ),
            TextFieldWidget(
              maxLines: 2,
              labelText: 'Describe Punto exacto de Destino',
              helperText: 'Ej. Frente al Colegio Monterrico de Arequipa',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ej. Frente al Colegio Monterrico de Arequipa';
                }
                return null;
              },
              onChanged: (String string) {
                newRouteController.to.value = string;
              },
            ),
            SearchLocationCardWidget(
              disabled: true,
              title: 'Marca el destino en Mapa',
              labelText: 'Latitude y longitud',
              leading: const Icon(
                Icons.location_pin,
                color: Colors.red,
              ),
              iconMarker: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 50.0,
              ),
              initialLatLng: newRouteController.endPosition.value,
              onChanged: (LatLng latLng) {
                newRouteController.endPosition.value = latLng;
              },
            ),
            const Divider(),
            const SizedBox(
              width: double.infinity,
              child: TextWidget(
                'TIP: El precio BASE debe considerar recojo a domicilio.\nLos clientes conocen que el recojo a domicilio esta permitido solo si se encuentra dentro de la ruta.',
              ),
            ),
            TextFieldWidget(
              labelText: 'Precio sugerido por ASIENTO',
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
            const Divider(),
            const SizedBox(
              width: double.infinity,
              child: SwitchWidget(
                title: '¿Realizas esta ruta al menos 3 dias a la semana?',
                value: true,
              ),
            ),
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

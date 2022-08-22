import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pickpointer/src/core/widgets/progress_state_button_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/form_widget.dart';
import 'package:pickpointer/src/core/widgets/scaffold_scroll_widget.dart';
import 'package:pickpointer/src/core/widgets/search_location_card_widget.dart';
import 'package:pickpointer/src/features/payment_feature/logic/payment_controller.dart';
import 'package:pickpointer/src/features/payment_feature/views/enums/method_pay_type.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/src/features/payment_feature/views/widgets/cash_method_pay_radio_widget.dart';
import 'package:progress_state_button/progress_button.dart';

class PaymentPage extends StatefulWidget {
  final String? abstractOfferEntityId;
  final AbstractOfferEntity? abstractOfferEntity;

  const PaymentPage({
    Key? key,
    this.abstractOfferEntity,
    this.abstractOfferEntityId,
  })  : assert(
          abstractOfferEntity != null || abstractOfferEntityId != null,
        ),
        super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final PaymentController paymentController = PaymentController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return FormWidget(
        key: paymentController.formKey,
        child: ScaffoldScrollWidget(
          title: 'Contratar viaje',
          children: [
            SizedBox(
              width: double.infinity,
              child: TextWidget(
                'Configuración de viaje',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(
              child: SearchLocationCardWidget(
                title: 'Salgo del origen de la ruta',
                labelText: 'Recogeme en',
                leading: const Icon(
                  Icons.taxi_alert_outlined,
                  color: Colors.blue,
                ),
                helperText:
                    'El punto de recojo, debe estar entre la ruta seleccionada.\nEj: Av. Siempreviva',
                // initialLatLng: LatLng(
                //   double.parse('${widget.abstractOfferEntity!.startLat}'),
                //   double.parse('${widget.abstractOfferEntity!.startLng}'),
                // ),
                validator: (value) {
                  if (value == null) {
                    return 'Debe seleccionar un punto de recojo';
                  }
                  return null;
                },
                onChanged: (LatLng latLng) {
                  print(latLng);
                  paymentController.originLatLng.value = latLng;
                },
              ),
            ),
            SizedBox(
              child: SearchLocationCardWidget(
                title: 'Voy al destino de la ruta',
                labelText: 'Dejame en',
                leading: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                ),
                initialValue: true,
                helperText:
                    'El punto de bajada, debe estar entre la ruta seleccionada.\nEj: Av. Siempreviva',
                initialLatLng: LatLng(
                  double.parse('${widget.abstractOfferEntity!.endLat}'),
                  double.parse('${widget.abstractOfferEntity!.endLng}'),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Debe seleccionar un punto de bajada';
                  }
                  return null;
                },
                onChanged: (LatLng latLng) {
                  paymentController.destinationLatLng.value = latLng;
                },
              ),
            ),
            const Divider(),
            SizedBox(
              width: double.infinity,
              child: TextWidget(
                'Asientos',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(
              child: TextFieldWidget(
                labelText: 'Cantidad de asientos',
                helperText:
                    'Maximo de ${widget.abstractOfferEntity!.maxCount! - widget.abstractOfferEntity!.count!} asientos disponibles',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                  signed: false,
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Debe ingresar la cantidad de asientos';
                  }
                  if (!(int.tryParse(value) != null)) {
                    return 'Debe ingresar un número entero';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Debe ingresar la cantidad de asientos';
                  }
                  if (int.parse(value) >
                      (widget.abstractOfferEntity!.maxCount! -
                          widget.abstractOfferEntity!.count!)) {
                    int max = widget.abstractOfferEntity!.maxCount! -
                        widget.abstractOfferEntity!.count!;
                    return 'Maximo de $max asientos disponibles';
                  }
                  return null;
                },
                onChanged: (value) {
                  paymentController.seats.value = int.parse(value);
                },
              ),
            ),
            const Divider(),
            SizedBox(
              width: double.infinity,
              child: TextWidget(
                'Metodos de pago',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            CashMethodPayRadioWidget(
              title: 'Efectivo',
              groupValue: MethodPayType.cash,
              value: MethodPayType.cash,
              onChanged: (value) {
                paymentController.payMethod.value = 1;
              },
            ),
            ProgressStateButtonWidget(
              state: paymentController.isLoading.value
                  ? ButtonState.loading
                  : ButtonState.success,
              success: 'Contratar',
              onPressed: () {
                if (paymentController.payMethod.value != 0) {
                  paymentController.onSubmit(
                    abstractOfferEntity: widget.abstractOfferEntity!,
                  );
                }
              },
            ),
          ],
        ),
      );
    });
  }
}

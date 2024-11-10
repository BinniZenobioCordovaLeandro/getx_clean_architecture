import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pickpointer/src/core/helpers/modal_bottom_sheet_helper.dart';
import 'package:pickpointer/src/core/widgets/card_alert_widget.dart';
import 'package:pickpointer/src/core/widgets/flutter_map_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/list_tile_radio_card_widget.dart';
import 'package:pickpointer/src/core/widgets/list_tile_radio_widget.dart';
import 'package:pickpointer/src/core/widgets/location_map_widget.dart';
import 'package:pickpointer/src/core/widgets/progress_state_button_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/form_widget.dart';
import 'package:pickpointer/src/core/widgets/scaffold_scroll_widget.dart';
import 'package:pickpointer/src/core/widgets/search_location_card_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';
import 'package:pickpointer/src/features/offer_feature/logic/offer_controller.dart';
import 'package:pickpointer/src/features/payment_feature/logic/payment_controller.dart';
import 'package:pickpointer/src/features/payment_feature/views/enums/method_pay_type.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/src/features/payment_feature/views/widgets/cash_method_pay_radio_widget.dart';
import 'package:pickpointer/src/features/payment_feature/views/widgets/payment_resume_widget.dart';
import 'package:progress_state_button/progress_button.dart';

class PaymentPage extends StatefulWidget {
  final String? abstractOfferEntityId;
  final AbstractOfferEntity? abstractOfferEntity;

  const PaymentPage({
    Key? key,
    this.abstractOfferEntity,
    this.abstractOfferEntityId,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final PaymentController paymentController = PaymentController.instance;
  final OfferController offerController = OfferController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      DateTime currentDateTime = DateTime.now();
      bool? isOnDate =
          paymentController.offerDateTime?.isBefore(currentDateTime);
      String? dateString = (paymentController.offerDateTime != null)
          ? DateFormat('dd/MM/yyyy kk:mm a')
              .format(paymentController.offerDateTime!)
          : null;
      return FormWidget(
        key: paymentController.formKey,
        child: ScaffoldScrollWidget(
          title: 'Contratar viaje',
          children: [
            if (isOnDate == false)
              CardAlertWidget(
                color: Theme.of(context).primaryColor,
                title: 'El vehiculo saldra en fecha y hora $dateString',
                message:
                    'Luego de comprar tu asiento, te notificaremos cuando la fecha y hora lleguen, y cuando el vehiculo este cerca a tu posición.',
              ),
            SizedBox(
              width: double.infinity,
              child: TextWidget(
                'Detalles de tu viaje',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Text("¿De donde sales?",
                style: Theme.of(context).textTheme.titleLarge),
            ListTileRadioWidget(
              title: const Text("Voy al paradero mas cercano"),
              groupValue: paymentController.userOriginFromHome.value,
              value: false,
              onChanged: (value) {
                paymentController.userOriginFromHome.value = value;
                paymentController.userOriginLatLng.value =
                    paymentController.offerStartLatLng.value;
              },
            ),
            ListTileRadioWidget(
              title: const Text("Recogeme en mi casa"),
              groupValue: paymentController.userOriginFromHome.value,
              value: true,
              onChanged: (value) {
                paymentController.userOriginFromHome.value = value;
              },
            ),
            if (paymentController.userOriginFromHome.value)
              LocationMapWidget(
                initialLatLng: paymentController.userOriginLatLng.value,
                onChanged: (LatLng latLng) {
                  paymentController.userOriginLatLng.value = latLng;
                },
                iconMarker: const Icon(
                  Icons.person_pin,
                  color: Colors.blue,
                  size: 50,
                ),
              ),
            Text("¿A donde vas?",
                style: Theme.of(context).textTheme.titleLarge),
            ListTileRadioWidget(
              title: const Text("Voy al paradero final de la ruta"),
              groupValue: paymentController.userDestinationToHome.value,
              value: false,
              onChanged: (value) {
                paymentController.userDestinationToHome.value = value;
                paymentController.userDestinationLatLng.value =
                    paymentController.offerEndLatLng.value;
              },
            ),
            ListTileRadioWidget(
              title: const Text("Dejame en mi casa"),
              groupValue: paymentController.userDestinationToHome.value,
              value: true,
              onChanged: (value) {
                paymentController.userDestinationToHome.value = value;
              },
            ),
            if (paymentController.userDestinationToHome.value)
              LocationMapWidget(
                initialLatLng: paymentController.userDestinationLatLng.value,
                onChanged: (LatLng latLng) {
                  paymentController.userDestinationLatLng.value = latLng;
                },
                iconMarker: const Icon(
                  Icons.person_pin_outlined,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            const Divider(),
            SizedBox(
              width: double.infinity,
              child: TextWidget(
                'Asientos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              child: TextFieldWidget(
                labelText: 'Cantidad de asientos',
                helperText:
                    'Maximo de ${paymentController.offerAvailableSeats.value} asientos disponibles',
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
                      paymentController.offerAvailableSeats.value) {
                    return 'Maximo de ${paymentController.offerAvailableSeats.value} asientos disponibles';
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
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            CashMethodPayRadioWidget(
              title: 'Efectivo',
              groupValue: paymentController.payMethod.value,
              value: MethodPayType.cash.label,
              onChanged: (value) => paymentController.payMethod.value = value,
            ),
            CashMethodPayRadioWidget(
              title: 'Yape',
              groupValue: paymentController.payMethod.value,
              value: MethodPayType.yape.label,
              onChanged: (value) => paymentController.payMethod.value = value,
            ),
            CashMethodPayRadioWidget(
              title: 'Plin',
              groupValue: paymentController.payMethod.value,
              value: MethodPayType.plin.label,
              onChanged: (value) => paymentController.payMethod.value = value,
            ),
            const Divider(),
            if (paymentController.errorMessage.value.isNotEmpty)
              CardAlertWidget(
                title: 'HEY!',
                message: paymentController.errorMessage.value,
              ),
            ProgressStateButtonWidget(
              state: paymentController.isLoading.value
                  ? ButtonState.loading
                  : ButtonState.success,
              success: 'CONTINUAR',
              onPressed: () {
                bool isValidForm =
                    paymentController.formKey.currentState!.validate();
                if (isValidForm) {
                  paymentController
                      .calculateAditionalPrice()!
                      .then((bool value) {
                    if (value) {
                      ModalBottomSheetHelper(
                        context: context,
                        title: '',
                        child: Obx(() {
                          return SizedBox(
                            width: double.infinity,
                            child: FractionallySizedBoxWidget(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: WrapWidget(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextWidget(
                                        'Resumen de pago',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ),
                                    PaymentResumeWidget(
                                      quantity: paymentController.seats.value,
                                      subtotal:
                                          paymentController.subtotal.value,
                                      aditional:
                                          paymentController.aditionalCost.value,
                                      total: paymentController.total.value,
                                    ),
                                    AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: FlutterMapWidget(
                                        mapController:
                                            paymentController.mapController,
                                        children: [
                                          MarkerLayer(
                                            markers: [
                                              Marker(
                                                width: 50,
                                                height: 50,
                                                anchorPos: AnchorPos.align(
                                                  AnchorAlign.center,
                                                ),
                                                point: paymentController
                                                    .offerStartLatLng.value,
                                                builder:
                                                    (BuildContext context) =>
                                                        const Icon(
                                                  Icons.taxi_alert_outlined,
                                                  color: Colors.blue,
                                                  size: 50,
                                                ),
                                              ),
                                              Marker(
                                                width: 50,
                                                height: 50,
                                                anchorPos: AnchorPos.align(
                                                  AnchorAlign.top,
                                                ),
                                                point: paymentController
                                                    .offerEndLatLng.value,
                                                builder:
                                                    (BuildContext context) =>
                                                        const Icon(
                                                  Icons.location_pin,
                                                  color: Colors.red,
                                                  size: 50,
                                                ),
                                              ),
                                              Marker(
                                                width: 50,
                                                height: 50,
                                                anchorPos: AnchorPos.align(
                                                    AnchorAlign.top),
                                                point: paymentController
                                                    .userOriginLatLng.value,
                                                builder:
                                                    (BuildContext context) =>
                                                        Icon(
                                                  Icons.person_pin,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 50,
                                                ),
                                              ),
                                              Marker(
                                                width: 50,
                                                height: 50,
                                                anchorPos: AnchorPos.align(
                                                    AnchorAlign.top),
                                                point: paymentController
                                                    .userDestinationLatLng
                                                    .value,
                                                builder:
                                                    (BuildContext context) =>
                                                        const Icon(
                                                  Icons.person_pin,
                                                  color: Colors.red,
                                                  size: 50,
                                                ),
                                              ),
                                              for (var wayPoint
                                                  in paymentController
                                                      .offerWayPoints.value)
                                                Marker(
                                                  width: 10,
                                                  height: 10,
                                                  anchorPos: AnchorPos.align(
                                                      AnchorAlign.center),
                                                  point: wayPoint,
                                                  builder:
                                                      (BuildContext context) =>
                                                          Icon(
                                                    Icons.circle,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 10,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          PolylineLayer(
                                            polylines: [
                                              Polyline(
                                                points: <LatLng>[
                                                  ...paymentController
                                                      .basePolylineListLatLng
                                                      .value,
                                                ],
                                                strokeWidth: 5,
                                                color: Colors.black,
                                                isDotted: true,
                                                gradientColors: <Color>[
                                                  Colors.grey,
                                                ],
                                              ),
                                              Polyline(
                                                points: <LatLng>[
                                                  ...paymentController
                                                      .userPolylineListLatLng
                                                      .value,
                                                ],
                                                strokeWidth: 5,
                                                color: Colors.black,
                                                isDotted: true,
                                                gradientColors: <Color>[
                                                  Colors.blue,
                                                  Colors.red,
                                                  Colors.red,
                                                  Colors.red,
                                                  Colors.red,
                                                  Colors.red,
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextWidget(
                                      'Ruta sugerida para realizar el recorrido.\nEsta ruta puede cambiar, segun el trafico, accidentes vehiculares, o contrato de los asientos restantes.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    ),
                                    TextWidget(
                                      'Luego de contratar, te enviaremos NOTIFICACIONES indicando cuando el vehiculo inicia la ruta y cuando esta cerca a tu PUNTO DE ORIGEN.\nTen un viaje SEGURO, COMODO, ACCESIBLE Y RAPIDO!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    ),
                                    ProgressStateButtonWidget(
                                      state: paymentController.isLoading.value
                                          ? ButtonState.loading
                                          : ButtonState.success,
                                      success: 'CONTRATAR',
                                      loading: 'CONTRATANDO',
                                      onPressed: () {
                                        if (paymentController.payMethod.value !=
                                            0) {
                                          paymentController.onSubmit(
                                            abstractOfferEntity:
                                                widget.abstractOfferEntity!,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
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

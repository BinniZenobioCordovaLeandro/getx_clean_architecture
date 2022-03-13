import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/src/core/widgets/elevated_button_widget.dart';
import 'package:pickpointer/src/core/widgets/scaffold_scroll_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/features/order_feature/views/order_page.dart';
import 'package:pickpointer/src/features/payment_feature/logic/payment_controller.dart';
import 'package:pickpointer/src/features/payment_feature/views/enums/method_pay_type.dart';
import 'package:pickpointer/src/features/payment_feature/views/widgets/cash_method_pay_radio_widget.dart';
import 'package:pickpointer/src/features/payment_feature/views/widgets/search_location_card_widget.dart';

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

  MethodPayType methodPayType = MethodPayType.wallet;

  @override
  Widget build(BuildContext context) {
    return ScaffoldScrollWidget(
      title: 'Contratar viaje',
      footer: ElevatedButtonWidget(
        title: 'Contratar S/. 9.00',
        onPressed: () {
          paymentController
              .createOrder()
              .then((AbstractOrderEntity abstractOrderEntity) => {
                    Get.to(
                      () => OrderPage(
                        abstractOrderEntity: abstractOrderEntity,
                      ),
                      arguments: {
                        'abstractOrderEntity': abstractOrderEntity,
                      },
                    )
                  });
        },
      ),
      children: [
        SizedBox(
          width: double.infinity,
          child: TextWidget(
            'Configuración de Ruta',
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
            initialLatLng: LatLng(
              double.parse('${widget.abstractOfferEntity!.startLat}'),
              double.parse('${widget.abstractOfferEntity!.startLng}'),
            ),
            onChanged: (LatLng latLng) {
              print(latLng);
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
            disabled: true,
            helperText:
                'El punto de bajada, debe estar entre la ruta seleccionada.\nEj: Av. Siempreviva',
            initialLatLng: LatLng(
              double.parse('${widget.abstractOfferEntity!.endLat}'),
              double.parse('${widget.abstractOfferEntity!.endLng}'),
            ),
            onChanged: (LatLng latLng) {
              print(latLng);
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
        // WalletMethodPayRadioWidget(
        //   title: 'Monedero (Saldo S/ 6.00)',
        //   groupValue: methodPayType,
        //   value: MethodPayType.wallet,
        //   toRecharge: true,
        //   onPressed: () {
        //     Get.to(
        //       () => const RechargeWalletPage(
        //         amount: 15.00,
        //       ),
        //       arguments: {
        //         'amount': 15.00,
        //       },
        //     );
        //   },
        //   onChanged: (value) {
        //     setState(() {
        //       methodPayType = value;
        //     });
        //   },
        // ),
        CashMethodPayRadioWidget(
          title: 'Cash',
          groupValue: methodPayType,
          value: MethodPayType.cash,
          onChanged: (value) {
            setState(() {
              methodPayType = value;
            });
          },
        ),
      ],
    );
  }
}

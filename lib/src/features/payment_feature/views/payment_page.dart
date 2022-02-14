import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/elevated_button_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/safe_area_widget.dart';
import 'package:pickpointer/src/core/widgets/single_child_scroll_view_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';
import 'package:pickpointer/src/features/payment_feature/views/widgets/search_location_card_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/enums/credit_card_type.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/list_tile_credit_card_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/list_tile_new_credit_card_widget.dart';

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
  CreditCardType creditCardType = CreditCardType.creditCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Pagar viaje',
        showGoback: true,
      ),
      body: SafeAreaWidget(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollViewWidget(
                child: Center(
                  child: FractionallySizedBoxWidget(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: WrapWidget(
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
                              helperText:
                                  'El punto de recojo, debe estar entre la ruta seleccionada.\nEj: Av. Siempreviva',
                              initialLatLng: LatLng(
                                double.parse(
                                    '${widget.abstractOfferEntity!.startLat}'),
                                double.parse(
                                    '${widget.abstractOfferEntity!.startLng}'),
                              ),
                              onChanged: (LatLng latLng) {
                                print(latLng);
                              },
                            ),
                          ),
                          SizedBox(
                            child: SearchLocationCardWidget(
                              title: 'Voy al destino de la ruta',
                              initialValue: true,
                              disabled: true,
                              labelText: 'Dejame en',
                              helperText:
                                  'El punto de bajada, debe estar entre la ruta seleccionada.\nEj: Av. Siempreviva',
                              initialLatLng: LatLng(
                                double.parse(
                                    '${widget.abstractOfferEntity!.endLat}'),
                                double.parse(
                                    '${widget.abstractOfferEntity!.endLng}'),
                              ),
                              onChanged: (LatLng latLng) {
                                print(latLng);
                              },
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: TextWidget(
                              'Metodos de pago',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          ListTileCreditCardWidget(
                            groupValue: creditCardType,
                            value: CreditCardType.creditCard,
                            onChanged: (value) {
                              setState(() {
                                creditCardType = value as CreditCardType;
                              });
                            },
                          ),
                          ListTileNewCreditCardWidget(
                            groupValue: creditCardType,
                            value: CreditCardType.newCreditCard,
                            onChanged: (value) {
                              setState(() {
                                creditCardType = value as CreditCardType;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: FractionallySizedBoxWidget(
                child: ElevatedButtonWidget(
                  title: 'Pagar S/. 9.00',
                  onPressed: () {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

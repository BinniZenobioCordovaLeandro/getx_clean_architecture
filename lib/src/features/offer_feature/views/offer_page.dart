import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/src/core/widgets/form_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/progress_state_button_widget.dart';
import 'package:pickpointer/src/core/widgets/safe_area_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class OfferPage extends StatefulWidget {
  final AbstractRouteEntity abstractRouteEntity;

  const OfferPage({
    Key? key,
    required this.abstractRouteEntity,
  }) : super(key: key);

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  @override
  Widget build(BuildContext context) {
    final MapController mapController = MapController();
    final formKey = GlobalKey<FormState>();

    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return SafeAreaWidget(
          child: FormWidget(
            key: formKey,
            child: FractionallySizedBoxWidget(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.00,
                ),
                child: WrapWidget(
                  children: [
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
                        int positions = int.parse(value);
                        if (positions > 4) {
                          return 'El número de asientos no puede ser mayor a 4';
                        }
                        return null;
                      },
                    ),
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
                        double price = double.parse(value);
                        double minPrice = double.tryParse(
                                '${widget.abstractRouteEntity.price}') ??
                            5.00;
                        double maxPrice = minPrice + (minPrice * 0.30);
                        if (price < minPrice) {
                          return 'El precio no puede ser menor a ${minPrice.toStringAsFixed(2)}';
                        }
                        if (price > maxPrice) {
                          return 'El precio no puede ser mayor a ${maxPrice.toStringAsFixed(2)}';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ProgressStateButtonWidget(
                        success: 'Publicar',
                        onPressed: () {
                          bool isformValid = formKey.currentState!.validate();
                          if (isformValid) {
                            Get.back();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

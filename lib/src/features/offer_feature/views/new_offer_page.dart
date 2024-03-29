import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/src/core/widgets/form_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/list_tile_switch_widget.dart';
import 'package:pickpointer/src/core/widgets/progress_state_button_widget.dart';
import 'package:pickpointer/src/core/widgets/safe_area_widget.dart';
import 'package:pickpointer/src/core/widgets/single_child_scroll_view_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';
import 'package:pickpointer/src/features/offer_feature/logic/new_offer_controller.dart';
import 'package:progress_state_button/progress_button.dart';

class NewOfferPage extends StatefulWidget {
  final AbstractRouteEntity abstractRouteEntity;

  const NewOfferPage({
    Key? key,
    required this.abstractRouteEntity,
  }) : super(key: key);

  @override
  State<NewOfferPage> createState() => _NewOfferPageState();
}

class _NewOfferPageState extends State<NewOfferPage> {
  final NewOfferController offerController = NewOfferController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SafeAreaWidget(
        child: FormWidget(
          key: offerController.formKey,
          child: SingleChildScrollViewWidget(
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
                      onChanged: (String string) {
                        offerController.maxCount.value = int.parse(string);
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
                        double maxPrice = minPrice * 3;
                        if (price < minPrice) {
                          return 'El precio no puede ser menor a ${minPrice.toStringAsFixed(2)}';
                        }
                        if (price > maxPrice) {
                          return 'El precio no puede ser mayor a ${maxPrice.toStringAsFixed(2)}';
                        }
                        return null;
                      },
                      onChanged: (String string) {
                        String price = double.parse(string).toStringAsFixed(3);
                        offerController.price.value = double.parse(price);
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ListTileSwitchWidget(
                        isSwitch: true,
                        title: const TextWidget('Realizare la ruta ahora'),
                        value: offerController.showImmediately.value,
                        onChanged: (response) {
                          offerController.showImmediately.value = response!;
                        },
                      ),
                    ),
                    if (!offerController.showImmediately.value)
                      TextFieldWidget(
                        key: Key(
                            'value_datetime_${offerController.dateTimeString.value}'),
                        initialValue: offerController.dateTimeString.value,
                        labelText: 'Fecha',
                        helperText: 'Dia/Mes/Año',
                        autofocus: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Especifique la fecha de viaje';
                          }
                          return null;
                        },
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 7)),
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                          ).then(
                            (DateTime? dateTime) {
                              print(dateTime!.toIso8601String());
                              offerController.dateTime = dateTime;
                              offerController.dateTimeString.value =
                                  DateFormat('dd/MM/yyyy').format(dateTime);
                            },
                          );
                        },
                      ),
                    if (!offerController.showImmediately.value)
                      TextFieldWidget(
                        key: Key(
                            'value_timeofday_${offerController.timeOfDayString.value}'),
                        initialValue: offerController.timeOfDayString.value,
                        labelText: 'Hora',
                        helperText: 'Hora:Minuto',
                        autofocus: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Especifique la hora de viaje';
                          }
                          return null;
                        },
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            initialEntryMode: TimePickerEntryMode.dial,
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              );
                            },
                          ).then((TimeOfDay? timeOfDay) {
                            offerController.timeOfDay = timeOfDay!;
                            offerController.timeOfDayString.value =
                                '${timeOfDay.hour}:${timeOfDay.minute}';
                          });
                        },
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ProgressStateButtonWidget(
                        state: offerController.isLoading.value
                            ? ButtonState.loading
                            : ButtonState.success,
                        success: 'Publicar',
                        onPressed: () {
                          offerController.onSumbit(
                            abstractRouteEntity: widget.abstractRouteEntity,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

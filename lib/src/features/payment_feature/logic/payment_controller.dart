import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/order_package/data/datasources/firebase_order_datasource.dart';
import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/packages/order_package/domain/usecases/get_order_usecase.dart';
import 'package:pickpointer/src/core/providers/notification_provider.dart';
import 'package:pickpointer/src/features/order_feature/views/order_page.dart';

class PaymentController extends GetxController {
  static PaymentController get instance => Get.put(PaymentController());

  final formKey = GlobalKey<FormState>();

  final NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();

  final GetOrderUsecase getOrderUsecase = GetOrderUsecase(
    abstractOrderRepository: FirebaseOrderDatasource(),
  );

  final isLoading = false.obs;
  final originLatLng = LatLng(0, 0).obs;
  final destinationLatLng = LatLng(0, 0).obs;
  final payMethod = 0.obs;

  Future<bool>? sendNotification() {
    Future<bool>? futureBool = notificationProvider
        ?.sendNotification(
          title: 'ORDEN CREADA CON EXITO',
          body: 'Su orden ha sido creada con exito',
        )
        .then((value) => value);
    return futureBool;
  }

  Future<AbstractOrderEntity> createOrder() {
    sendNotification();
    return getOrderUsecase.call(orderId: '1')!;
  }

  @override
  void onReady() {
    AbstractOfferEntity abstractOfferEntity =
        Get.arguments['abstractOfferEntity'];
  }

  onSubmit({
    required AbstractOfferEntity abstractOfferEntity,
  }) {
    if (formKey.currentState!.validate() && payMethod.value != 0) {
      createOrder().then((AbstractOrderEntity abstractOrderEntity) => {
            Get.to(
              () => OrderPage(
                abstractOrderEntity: abstractOrderEntity,
              ),
              arguments: {
                'abstractOrderEntity': abstractOrderEntity,
              },
            )
          });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/order_package/data/datasources/firebase_order_datasource.dart';
import 'package:pickpointer/packages/order_package/data/models/order_model.dart';
import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/packages/order_package/domain/usecases/add_order_usecase.dart';
import 'package:pickpointer/src/core/providers/notification_provider.dart';
import 'package:pickpointer/src/features/order_feature/views/order_page.dart';

class PaymentController extends GetxController {
  static PaymentController get instance => Get.put(PaymentController());

  final formKey = GlobalKey<FormState>();

  final NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();

  final AddOrderUsecase addOrderUsecase = AddOrderUsecase(
    abstractOrderRepository: FirebaseOrderDatasource(),
  );

  AbstractOfferEntity? abstractOfferEntity;

  final isLoading = false.obs;
  final originLatLng = LatLng(0, 0).obs;
  final destinationLatLng = LatLng(0, 0).obs;
  final payMethod = 0.obs;

  Future<bool>? sendNotification({
    required AbstractOrderEntity abstractOrderEntity,
  }) {
    Future<bool>? futureBool = notificationProvider
        ?.sendNotification(
          title: 'ORDEN CREADA CON EXITO',
          body: 'Su orden ha sido creada con exito',
        )
        .then((value) => value);
    return futureBool;
  }

  @override
  void onReady() {
    abstractOfferEntity = Get.arguments['abstractOfferEntity'];
  }

  onSubmit({
    required AbstractOfferEntity abstractOfferEntity,
  }) {
    if (formKey.currentState!.validate() && payMethod.value != 0) {
      addOrderUsecase
          .call(
        order: const OrderModel(
          id: '1',
          orderId: '123456789',
          price: '100',
          total: '90',
          status: 'Pending',
          statusId: '1',
          userId: '1',
          userName: 'John Doe',
          userPhone: '+1 123 456 7890',
          userPickPointLat: '-12.118871',
          userPickPointLng: '-76.870707',
          offerId: '1',
          routeId: '1',
          routeDescription: 'Manchay a Ovalo Santa Anita',
          routeTo: 'Ovalo Santa Anita',
          routeFrom: 'Manchay',
          routePrice: '100',
          routeQuantity: '1',
          routeTotal: '90',
          routeStartLat: '-12.123276353363956',
          routeStartLng: '-76.87233782753958',
          routeEndLat: '-12.0552257792263',
          routeEndLng: '-76.96429734159008',
          routeWayPoints:
              '["-12.076121251499771, -76.90765870404498", "-12.071811365487575, -76.95666951452563"]',
          driverId: '2',
          driverName: 'edith Thomas Cord',
          driverPhone: '+1 123 456 7890',
          createdAt: '2020-01-01',
          updatedAt: '2020-01-05',
        ),
      )
          .then((AbstractOrderEntity abstractOrderEntity) {
        sendNotification(abstractOrderEntity: abstractOrderEntity);
        Get.to(
          () => OrderPage(
            abstractOrderEntity: abstractOrderEntity,
          ),
          arguments: {
            'abstractOrderEntity': abstractOrderEntity,
          },
        );
      });
    }
  }
}

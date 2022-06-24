import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/order_package/data/datasources/http_order_datasource.dart';
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
    abstractOrderRepository: HttpOrderDatasource(),
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
        order: OrderModel(
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
          userOutPointLat: '-12.1',
          userOutPointLng: '-76.2',
          offerId: abstractOfferEntity.id,
          routeId: abstractOfferEntity.routeId,
          routeDescription: 'Manchay a Ovalo Santa Anita',
          routeTo: 'Ovalo Santa Anita',
          routeFrom: 'Manchay',
          routePrice: abstractOfferEntity.price,
          routeQuantity: '1',
          routeTotal:
              (double.parse(abstractOfferEntity.price!) * 1).toStringAsFixed(2),
          routeStartLat: '-12.123276353363956',
          routeStartLng: '-76.87233782753958',
          routeEndLat: '-12.0552257792263',
          routeEndLng: '-76.96429734159008',
          routeWayPoints: abstractOfferEntity.wayPoints,
          driverId: abstractOfferEntity.userId,
          driverName: abstractOfferEntity.userName,
          driverPhone: abstractOfferEntity.userPhoneNumber,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
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

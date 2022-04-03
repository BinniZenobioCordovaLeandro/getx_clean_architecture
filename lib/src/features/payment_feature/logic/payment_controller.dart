import 'package:get/get.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/order_package/data/datasources/firebase_order_datasource.dart';
import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/packages/order_package/domain/usecases/get_order_usecase.dart';
import 'package:pickpointer/src/core/providers/notification_provider.dart';

class PaymentController extends GetxController {
  static PaymentController get instance => Get.put(PaymentController());

  final NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();

  GetOrderUsecase getOrderUsecase = GetOrderUsecase(
    abstractOrderRepository: FirebaseOrderDatasource(),
  );

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
}

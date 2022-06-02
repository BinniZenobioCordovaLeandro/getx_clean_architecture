import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';

abstract class AbstractOrderRepository {
  Future<List<AbstractOrderEntity>>? getOrders();

  Future<AbstractOrderEntity>? getOrder({
    required String orderId,
  });

  Future<AbstractOrderEntity> addOrder({
    required AbstractOrderEntity order,
  });

  Future<AbstractOrderEntity> updateOrder({
    required AbstractOrderEntity order,
  });
}

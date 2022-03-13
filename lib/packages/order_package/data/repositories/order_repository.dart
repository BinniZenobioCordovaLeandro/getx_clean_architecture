import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/packages/order_package/domain/repositories/abstract_order_repository.dart';

class OrderRepository implements AbstractOrderRepository {
  final AbstractOrderRepository? _abstractOrderRepository;

  OrderRepository({
    required AbstractOrderRepository? abstractOrderRepository,
  })  : assert(abstractOrderRepository != null),
        _abstractOrderRepository = abstractOrderRepository;

  @override
  Future<List<AbstractOrderEntity>>? getOrders() {
    return _abstractOrderRepository!.getOrders();
  }

  @override
  Future<AbstractOrderEntity>? getOrder({
    required String orderId,
  }) {
    return _abstractOrderRepository!.getOrder(orderId: orderId);
  }

  @override
  Future<void> addOrder({
    required AbstractOrderEntity order,
  }) {
    return _abstractOrderRepository!.addOrder(order: order);
  }

  @override
  Future<AbstractOrderEntity> updateOrder({
    required AbstractOrderEntity order,
  }) {
    return _abstractOrderRepository!.updateOrder(order: order);
  }
}

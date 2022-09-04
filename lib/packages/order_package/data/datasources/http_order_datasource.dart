import 'package:pickpointer/packages/order_package/data/models/order_model.dart';
import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/packages/order_package/domain/repositories/abstract_order_repository.dart';
import 'package:http/http.dart' as http;

class HttpOrderDatasource implements AbstractOrderRepository {
  @override
  Future<List<AbstractOrderEntity>>? getOrders() {
    return Future.value();
  }

  @override
  Future<AbstractOrderEntity>? getOrder({
    required String orderId,
  }) {
    return Future.value();
  }

  @override
  Future<AbstractOrderEntity> addOrder({
    required AbstractOrderEntity order,
  }) {
    Future<AbstractOrderEntity> futureAbstractOrderEntity = http
        .put(
      Uri.parse(
          'https://us-central1-pickpointer.cloudfunctions.net/createOrder'),
      headers: {'Content-Type': 'application/json'},
      body: (order as OrderModel).toJson(),
    )
        .then((http.Response value) {
      return OrderModel.fromJson(value.body);
    });
    return futureAbstractOrderEntity;
  }

  @override
  Future<AbstractOrderEntity> updateOrder({
    required AbstractOrderEntity order,
  }) {
    return Future.value(order);
  }
}

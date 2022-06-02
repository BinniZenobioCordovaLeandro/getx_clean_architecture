import 'dart:convert';
import 'dart:io';
import 'package:pickpointer/packages/order_package/data/models/order_model.dart';
import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/packages/order_package/domain/repositories/abstract_order_repository.dart';

class HttpOrderDatasource implements AbstractOrderRepository {
  final HttpClient _httpClient;

  HttpOrderDatasource({required HttpClient httpClient})
      : _httpClient = httpClient;

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
    Future<AbstractOrderEntity> futureAbstractOrderEntity = _httpClient
        .getUrl(Uri.parse('http://localhost:3000/createOrder'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) {
      return response.transform(utf8.decoder).join();
    }).then((String string) {
      final data = json.decode(string);
      return OrderModel.fromMap(data);
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

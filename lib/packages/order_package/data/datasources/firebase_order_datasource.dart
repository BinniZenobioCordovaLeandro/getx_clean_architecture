import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickpointer/packages/order_package/data/models/order_model.dart';
import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/packages/order_package/domain/repositories/abstract_order_repository.dart';

class FirebaseOrderDatasource implements AbstractOrderRepository {
  CollectionReference? orders;

  FirebaseOrderDatasource() {
    orders = FirebaseFirestore.instance.collection('c_orders');
  }

  @override
  Future<List<AbstractOrderEntity>>? getOrders() {
    return orders?.get().then((snapshot) {
      List<AbstractOrderEntity> orders = [];
      for (DocumentSnapshot order in snapshot.docs) {
        orders.add(OrderModel.fromMap(order.data() as Map<String, dynamic>));
      }
      return orders;
    });
  }

  @override
  Future<AbstractOrderEntity>? getOrder({
    required String orderId,
  }) {
    return orders?.doc(orderId).get().then((snapshot) {
      return OrderModel.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }

  @override
  Future<AbstractOrderEntity> addOrder({
    required AbstractOrderEntity order,
  }) {
    OrderModel orderModel = order as OrderModel;
    orders?.doc(orderModel.id).set(orderModel.toMap());
    return Future.value(orderModel);
  }

  @override
  Future<AbstractOrderEntity> updateOrder({
    required AbstractOrderEntity order,
  }) {
    OrderModel orderModel = order as OrderModel;
    Map<String, dynamic> mapStringDynamic = orderModel.toMap();
    Map<String, dynamic> newMapStringDynamic = {};
    mapStringDynamic.forEach((key, value) {
      if (value != null) {
        newMapStringDynamic.putIfAbsent(key, () => value);
      }
    });
    orders?.doc(orderModel.id).update(newMapStringDynamic);
    return Future.value(orderModel);
  }
}

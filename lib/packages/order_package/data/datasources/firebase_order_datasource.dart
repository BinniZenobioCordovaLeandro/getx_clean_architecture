import 'package:pickpointer/packages/order_package/data/models/order_model.dart';
import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/packages/order_package/domain/repositories/abstract_order_repository.dart';

class FirebaseOrderDatasource implements AbstractOrderRepository {
  FirebaseOrderDatasource();

  @override
  Future<List<AbstractOrderEntity>>? getOrders() {
    return Future.value(<AbstractOrderEntity>[
      const OrderModel(
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
        routeWayPoints: '["-12.076121251499771, -76.90765870404498", "-12.071811365487575, -76.95666951452563"]',
        driverId: '2',
        driverName: 'edith Thomas Cord',
        driverPhone: '+1 123 456 7890',
        createdAt: '2020-01-01',
        updatedAt: '2020-01-05',
      ),
      const OrderModel(
        id: '2',
        orderId: '123456789',
        price: '100',
        total: '90',
        status: 'Pending',
        statusId: '1',
        userId: '1',
        userName: 'John Doe',
        userPhone: '+1 123 456 7890',
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
        routeWayPoints: '["-12.076121251499771, -76.90765870404498", "-12.071811365487575, -76.95666951452563"]',
        driverId: '2',
        driverName: 'edith Thomas Cord',
        driverPhone: '+1 123 456 7890',
        createdAt: '2020-01-01',
        updatedAt: '2020-01-05',
      ),
    ]);
  }

  @override
  Future<AbstractOrderEntity>? getOrder({
    required String orderId,
  }) {
    return Future.value(
      const OrderModel(
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
        routeWayPoints: '["-12.076121251499771, -76.90765870404498", "-12.071811365487575, -76.95666951452563"]',
        driverId: '2',
        driverName: 'edith Thomas Cord',
        driverPhone: '+1 123 456 7890',
        createdAt: '2020-01-01',
        updatedAt: '2020-01-05',
      ),
    );
  }

  @override
  Future<AbstractOrderEntity> addOrder({
    required AbstractOrderEntity order,
  }) {
    return Future.value(order);
  }

  @override
  Future<AbstractOrderEntity> updateOrder({
    required AbstractOrderEntity order,
  }) {
    return Future.value(order);
  }
}

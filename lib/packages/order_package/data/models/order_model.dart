import 'dart:convert';

import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';

class OrderModel implements AbstractOrderEntity {
  @override
  final String? id;
  @override
  final String? orderId;
  @override
  final String? price;
  @override
  final String? total;
  @override
  final String? status;
  @override
  final String? statusId;
  @override
  final String? userId;
  @override
  final String? userName;
  @override
  final String? userEmail;
  @override
  final String? userPhone;
  @override
  final String? userPickPointLat;
  @override
  final String? userPickPointLng;
  @override
  final String? userOutPointLat;
  @override
  final String? userOutPointLng;
  @override
  final String? offerId;
  @override
  final String? routeId;
  @override
  final String? routeDescription;
  @override
  final String? routeTo;
  @override
  final String? routeFrom;
  @override
  final String? routePrice;
  @override
  final String? routeQuantity;
  @override
  final String? routeTotal;
  @override
  final String? routeStartLat;
  @override
  final String? routeStartLng;
  @override
  final String? routeEndLat;
  @override
  final String? routeEndLng;
  @override
  final String? routeWayPoints;
  @override
  final String? driverId;
  @override
  final String? driverName;
  @override
  final String? driverEmail;
  @override
  final String? driverPhone;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  const OrderModel({
    this.id,
    this.orderId,
    this.price,
    this.total,
    this.status,
    this.statusId,
    this.userId,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.userPickPointLat,
    this.userPickPointLng,
    this.userOutPointLat,
    this.userOutPointLng,
    this.offerId,
    this.routeId,
    this.routeDescription,
    this.routeTo,
    this.routeFrom,
    this.routePrice,
    this.routeQuantity,
    this.routeTotal,
    this.routeStartLat,
    this.routeStartLng,
    this.routeEndLat,
    this.routeEndLng,
    this.routeWayPoints,
    this.driverId,
    this.driverName,
    this.driverEmail,
    this.driverPhone,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data) => OrderModel(
        id: data['id'] as String?,
        orderId: data['order_id'] as String?,
        price: data['price'] as String?,
        total: data['total'] as String?,
        status: data['status'] as String?,
        userId: data['user_id'] as String?,
        userName: data['user_name'] as String?,
        userEmail: data['user_email'] as String?,
        userPhone: data['user_phone'] as String?,
        userPickPointLat: data['user_pick_point_lat'] as String?,
        userPickPointLng: data['user_pick_point_lng'] as String?,
        userOutPointLat: data['user_out_point_lat'] as String?,
        userOutPointLng: data['user_out_point_lng'] as String?,
        offerId: data['offer_id'] as String?,
        routeId: data['route_id'] as String?,
        routeDescription: data['route_description'] as String?,
        routeTo: data['route_to'] as String?,
        routeFrom: data['route_from'] as String?,
        routePrice: data['route_price'] as String?,
        routeQuantity: data['route_quantity'] as String?,
        routeTotal: data['route_total'] as String?,
        routeStartLat: data['route_start_lat'] as String?,
        routeStartLng: data['route_start_lng'] as String?,
        routeEndLat: data['route_end_lat'] as String?,
        routeEndLng: data['route_end_lng'] as String?,
        routeWayPoints: data['route_way_points'] as String?,
        driverId: data['driver_id'] as String?,
        driverName: data['driver_name'] as String?,
        driverEmail: data['driver_email'] as String?,
        driverPhone: data['driver_phone'] as String?,
        createdAt: data['created_at'] as String?,
        updatedAt: data['updated_at'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'order_id': orderId,
        'price': price,
        'total': total,
        'status': status,
        'user_id': userId,
        'user_name': userName,
        'user_email': userEmail,
        'user_phone': userPhone,
        'user_pick_point_lat': userPickPointLat,
        'user_pick_point_lng': userPickPointLng,
        'user_out_point_lat': userOutPointLat,
        'user_out_point_lng': userOutPointLng,
        'offer_id': offerId,
        'route_id': routeId,
        'route_description': routeDescription,
        'route_to': routeTo,
        'route_from': routeFrom,
        'route_price': routePrice,
        'route_quantity': routeQuantity,
        'route_total': routeTotal,
        'route_start_lat': routeStartLat,
        'route_start_lng': routeStartLng,
        'route_end_lat': routeEndLat,
        'route_end_lng': routeEndLng,
        'route_way_points': routeWayPoints,
        'driver_id': driverId,
        'driver_name': driverName,
        'driver_email': driverEmail,
        'driver_phone': driverPhone,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrderModel].
  factory OrderModel.fromJson(String data) {
    return OrderModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OrderModel] to a JSON string.
  String toJson() => json.encode(toMap());

  OrderModel copyWith({
    String? id,
    String? orderId,
    String? price,
    String? total,
    String? status,
    String? userId,
    String? userName,
    String? userEmail,
    String? userPhone,
    String? userPickPointLat,
    String? userPickPointLng,
    String? userOutPointLat,
    String? userOutPointLng,
    String? offerId,
    String? routeId,
    String? routeDescription,
    String? routeTo,
    String? routeFrom,
    String? routePrice,
    String? routeQuantity,
    String? routeTotal,
    String? routeStartLat,
    String? routeStartLng,
    String? routeEndLat,
    String? routeEndLng,
    String? routeWayPoints,
    String? driverId,
    String? driverName,
    String? driverEmail,
    String? driverPhone,
    String? createdAt,
    String? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      price: price ?? this.price,
      total: total ?? this.total,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      userPickPointLat: userPickPointLat ?? this.userPickPointLat,
      userPickPointLng: userPickPointLng ?? this.userPickPointLng,
      userOutPointLat: userOutPointLat ?? this.userOutPointLat,
      userOutPointLng: userOutPointLng ?? this.userOutPointLng,
      offerId: offerId ?? this.offerId,
      routeId: routeId ?? this.routeId,
      routeDescription: routeDescription ?? this.routeDescription,
      routeTo: routeTo ?? this.routeTo,
      routeFrom: routeFrom ?? this.routeFrom,
      routePrice: routePrice ?? this.routePrice,
      routeQuantity: routeQuantity ?? this.routeQuantity,
      routeTotal: routeTotal ?? this.routeTotal,
      routeStartLat: routeStartLat ?? this.routeStartLat,
      routeStartLng: routeStartLng ?? this.routeStartLng,
      routeEndLat: routeEndLat ?? this.routeEndLat,
      routeEndLng: routeEndLng ?? this.routeEndLng,
      routeWayPoints: routeWayPoints ?? this.routeWayPoints,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverEmail: driverEmail ?? this.driverEmail,
      driverPhone: driverPhone ?? this.driverPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      orderId,
      price,
      total,
      status,
      userId,
      userName,
      userEmail,
      userPhone,
      userPickPointLat,
      userPickPointLng,
      userOutPointLat,
      userOutPointLng,
      offerId,
      routeId,
      routeDescription,
      routeTo,
      routeFrom,
      routePrice,
      routeQuantity,
      routeTotal,
      routeStartLat,
      routeStartLng,
      routeEndLat,
      routeEndLng,
      routeWayPoints,
      driverId,
      driverName,
      driverEmail,
      driverPhone,
      createdAt,
      updatedAt,
    ];
  }
}

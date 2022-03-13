import 'package:equatable/equatable.dart';

abstract class AbstractOrderEntity extends Equatable {
  final String? id;
  final String? orderId;
  final String? price;
  final String? total;
  final String? status;
  final String? statusId;
  final String? userId;
  final String? userName;
  final String? userEmail;
  final String? userPhone;
  final String? userPickPointLat;
  final String? userPickPointLng;
  final String? routeId;
  final String? routeDescription;
  final String? routeTo;
  final String? routeFrom;
  final String? routePrice;
  final String? routeQuantity;
  final String? routeTotal;
  final String? routeStartLat;
  final String? routeStartLng;
  final String? routeEndLat;
  final String? routeEndLng;
  final String? routeWayPoints;
  final String? driverId;
  final String? driverName;
  final String? driverEmail;
  final String? driverPhone;
  final String? createdAt;
  final String? updatedAt;

  const AbstractOrderEntity({
    this.id,
    this.orderId,
    this.userId,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.userPickPointLat,
    this.userPickPointLng,
    this.price,
    this.total,
    this.status,
    this.statusId,
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
}

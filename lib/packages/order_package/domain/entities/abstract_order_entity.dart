import 'package:equatable/equatable.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/offer_order_entity.dart';

abstract class AbstractOrderEntity extends Equatable {
  final String? id;
  final String? orderId;
  final double? price;
  final int? count;
  final double? subtotal;
  final double? total;
  final String?
      stateId; // Esperando -1, enCarretera 2 , enListo 3, Completado 1, Cancelado 0
  final String? stateDescription;
  final String? userId;
  final String? userName;
  final String? userEmail;
  final String? userAvatar;
  final String? userPhone;
  final String? userPickPointLat;
  final String? userPickPointLng;
  final String? userDropPointLat;
  final String? userDropPointLng;
  final String? userTokenMessaging;
  final String? offerId;
  final int? offerCount;
  final int? offerMaxCount;
  final double? offerPrice;
  final DateTime? offerDateTime;
  final String? offerStartLat;
  final String? offerStartLng;
  final String? offerEndLat;
  final String? offerEndLng;
  final String? offerWayPoints;
  final List<OfferOrderEntity>? offerOrders;
  final String? routeId;
  final String? routeTitle;
  final String? routeDescription;
  final double? routePrice;
  final String? routeFrom;
  final String? routeTo;
  final String? routeStartLat;
  final String? routeStartLng;
  final String? routeEndLat;
  final String? routeEndLng;
  final String? driverId;
  final String? driverName;
  final String? driverEmail;
  final String? driverAvatar;
  final String? driverCarPlate;
  final String? driverCarPhoto;
  final String? driverCarModel;
  final String? driverCarColor;
  final String? driverPhoneNumber;
  final String? driverRank;
  final String? driverTokenMessaging;
  final int? createdAt;
  final int? updatedAt;

  const AbstractOrderEntity({
    this.id,
    this.orderId,
    this.price,
    this.count,
    this.subtotal,
    this.total,
    this.stateId,
    this.stateDescription,
    this.userId,
    this.userName,
    this.userEmail,
    this.userAvatar,
    this.userPhone,
    this.userPickPointLat,
    this.userPickPointLng,
    this.userDropPointLat,
    this.userDropPointLng,
    this.userTokenMessaging,
    this.offerId,
    this.offerCount,
    this.offerMaxCount,
    this.offerPrice,
    this.offerDateTime,
    this.offerStartLat,
    this.offerStartLng,
    this.offerEndLat,
    this.offerEndLng,
    this.offerWayPoints,
    this.offerOrders,
    this.routeId,
    this.routeTitle,
    this.routeDescription,
    this.routePrice,
    this.routeFrom,
    this.routeTo,
    this.routeStartLat,
    this.routeStartLng,
    this.routeEndLat,
    this.routeEndLng,
    this.driverId,
    this.driverName,
    this.driverEmail,
    this.driverAvatar,
    this.driverCarPlate,
    this.driverCarPhoto,
    this.driverCarModel,
    this.driverCarColor,
    this.driverPhoneNumber,
    this.driverRank,
    this.driverTokenMessaging,
    this.createdAt,
    this.updatedAt,
  });
}

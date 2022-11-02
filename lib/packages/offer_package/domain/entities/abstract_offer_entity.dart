import 'package:equatable/equatable.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/offer_order_entity.dart';

abstract class AbstractOfferEntity extends Equatable {
  final String? id;
  final int? count;
  final int? maxCount;
  final double? price;
  final double? total;
  final DateTime? dateTime;
  final String? startLat;
  final String? startLng;
  final String? endLat;
  final String? endLng;
  final String? wayPoints;
  final List<OfferOrderEntity>? orders;
  final String? stateId;
  final String? stateDescription;
  final String? userId;
  final String? userName;
  final String? userEmail;
  final String? userAvatar;
  final String? userCarPlate;
  final String? userCarPhoto;
  final String? userCarModel;
  final String? userCarColor;
  final String? userPhoneNumber;
  final String? userRank;
  final String? userTokenMessaging;
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
  final int? updatedAt;
  final int? createdAt;

  const AbstractOfferEntity({
    this.id,
    this.count,
    this.maxCount,
    this.price,
    this.total,
    this.dateTime,
    this.startLat,
    this.startLng,
    this.endLat,
    this.endLng,
    this.wayPoints,
    this.orders,
    this.stateId,
    this.stateDescription,
    this.userId,
    this.userName,
    this.userEmail,
    this.userAvatar,
    this.userCarPlate,
    this.userCarPhoto,
    this.userCarModel,
    this.userCarColor,
    this.userPhoneNumber,
    this.userRank,
    this.userTokenMessaging,
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
    this.updatedAt,
    this.createdAt,
  });
}

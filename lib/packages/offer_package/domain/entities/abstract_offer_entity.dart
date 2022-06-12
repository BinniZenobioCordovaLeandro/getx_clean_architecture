import 'package:equatable/equatable.dart';

abstract class AbstractOfferEntity extends Equatable {
  final String? id;
  final String? routeId;
  final String? count;
  final String? maxCount;
  final String? price;
  final String? startLat;
  final String? startLng;
  final String? endLat;
  final String? endLng;
  final String? wayPoints;
  final String? orders;
  final String? userId;
  final String? userName;
  final String? userAvatar;
  final String? userCarPlate;
  final String? userCarPhoto;
  final String? userCarModel;
  final String? userCarColor;
  final String? userPhoneNumber;
  final String? userRank;
  final String? updatedAt;
  final String? createdAt;

  const AbstractOfferEntity({
    this.id,
    this.routeId,
    this.count,
    this.maxCount,
    this.price,
    this.startLat,
    this.startLng,
    this.endLat,
    this.endLng,
    this.wayPoints,
    this.orders,
    this.userId,
    this.userName,
    this.userAvatar,
    this.userCarPlate,
    this.userCarPhoto,
    this.userCarModel,
    this.userCarColor,
    this.userPhoneNumber,
    this.userRank,
    this.updatedAt,
    this.createdAt,
  });
}

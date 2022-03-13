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
  final String? userId;
  final String? userName;
  final String? userAvatar;
  final String? userCarPlate;
  final String? userCarPhoto;
  final String? userPhoneNumber;
  final String? userRank;

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
    this.userId,
    this.userName,
    this.userAvatar,
    this.userCarPlate,
    this.userCarPhoto,
    this.userPhoneNumber,
    this.userRank,
  });
}

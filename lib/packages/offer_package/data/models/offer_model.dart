import 'dart:convert';

import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';

class OfferModel implements AbstractOfferEntity {
  @override
  final String? id;
  @override
  final String? routeId;
  @override
  final String? count;
  @override
  final String? maxCount;
  @override
  final String? price;
  @override
  final String? startLat;
  @override
  final String? startLng;
  @override
  final String? endLat;
  @override
  final String? endLng;
  @override
  final String? wayPoints;
  @override
  final String? userId;
  @override
  final String? userName;
  @override
  final String? userAvatar;
  @override
  final String? userCarPlate;
  @override
  final String? userCarPhoto;
  @override
  final String? userCarModel;
  @override
  final String? userCarColor;
  @override
  final String? userPhoneNumber;
  @override
  final String? userRank;
  @override
  final String? updatedAt;
  @override
  final String? createdAt;

  const OfferModel({
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
    this.userCarModel,
    this.userCarColor,
    this.userPhoneNumber,
    this.userRank,
    this.updatedAt,
    this.createdAt,
  });

  factory OfferModel.fromMap(Map<String, dynamic> data) => OfferModel(
        id: data['id'] as String?,
        routeId: data['route_id'] as String?,
        count: data['count'] as String?,
        maxCount: data['max_count'] as String?,
        price: data['price'] as String?,
        startLat: data['start_lat'] as String?,
        startLng: data['start_lng'] as String?,
        endLat: data['end_lat'] as String?,
        endLng: data['end_lng'] as String?,
        wayPoints: data['way_points'] as String?,
        userId: data['user_id'] as String?,
        userName: data['user_name'] as String?,
        userAvatar: data['user_avatar'] as String?,
        userCarPlate: data['user_car_plate'] as String?,
        userCarPhoto: data['user_car_photo'] as String?,
        userCarModel: data['user_car_model'] as String?,
        userCarColor: data['user_car_color'] as String?,
        userPhoneNumber: data['user_phone_number'] as String?,
        userRank: data['user_rank'] as String?,
        updatedAt: data['updated_at'] as String?,
        createdAt: data['created_at'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'route_id': routeId,
        'count': count,
        'max_count': maxCount,
        'price': price,
        'start_lat': startLat,
        'start_lng': startLng,
        'end_lat': endLat,
        'end_lng': endLng,
        'way_points': wayPoints,
        'user_id': userId,
        'user_name': userName,
        'user_avatar': userAvatar,
        'user_car_plate': userCarPlate,
        'user_car_photo': userCarPhoto,
        'user_car_model': userCarModel,
        'user_car_color': userCarColor,
        'user_phone_number': userPhoneNumber,
        'user_rank': userRank,
        'updated_at': updatedAt,
        'created_at': createdAt,
      };

  factory OfferModel.fromJson(String data) {
    return OfferModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  OfferModel copyWith({
    String? id,
    String? routeId,
    String? count,
    String? maxCount,
    String? price,
    String? startLat,
    String? startLng,
    String? endLat,
    String? endLng,
    String? wayPoints,
    String? userId,
    String? userName,
    String? userAvatar,
    String? userCarPlate,
    String? userCarPhoto,
    String? userCarModel,
    String? userCarColor,
    String? userPhoneNumber,
    String? userRank,
    String? updatedAt,
    String? createdAt,
  }) {
    return OfferModel(
      id: id ?? this.id,
      routeId: routeId ?? this.routeId,
      count: count ?? this.count,
      maxCount: maxCount ?? this.maxCount,
      price: price ?? this.price,
      startLat: startLat ?? this.startLat,
      startLng: startLng ?? this.startLng,
      endLat: endLat ?? this.endLat,
      endLng: endLng ?? this.endLng,
      wayPoints: wayPoints ?? this.wayPoints,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      userCarPlate: userCarPlate ?? this.userCarPlate,
      userCarPhoto: userCarPhoto ?? this.userCarPhoto,
      userCarModel: userCarModel ?? this.userCarModel,
      userCarColor: userCarColor ?? this.userCarColor,
      userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
      userRank: userRank ?? this.userRank,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      routeId,
      count,
      maxCount,
      price,
      startLat,
      startLng,
      endLat,
      endLng,
      wayPoints,
      userId,
      userName,
      userAvatar,
      userCarPlate,
      userCarPhoto,
      userCarModel,
      userCarColor,
      userPhoneNumber,
      userRank,
      updatedAt,
      createdAt,
    ];
  }
}

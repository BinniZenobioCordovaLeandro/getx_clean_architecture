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
  final String? userPhoneNumber;
  @override
  final String? userRank;

  const OfferModel({
    this.id,
    this.routeId,
    this.count,
    this.maxCount,
    this.price,
    this.userId,
    this.userName,
    this.userAvatar,
    this.userCarPlate,
    this.userCarPhoto,
    this.userPhoneNumber,
    this.userRank,
  });

  factory OfferModel.fromMap(Map<String, dynamic> data) => OfferModel(
        id: data['id'] as String?,
        routeId: data['route_id'] as String?,
        count: data['count'] as String?,
        maxCount: data['max_count'] as String?,
        price: data['price'] as String?,
        userId: data['user_id'] as String?,
        userName: data['user_name'] as String?,
        userAvatar: data['user_avatar'] as String?,
        userCarPlate: data['user_car_plate'] as String?,
        userCarPhoto: data['user_car_photo'] as String?,
        userPhoneNumber: data['user_phone_number'] as String?,
        userRank: data['user_rank'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'route_id': routeId,
        'count': count,
        'max_count': maxCount,
        'price': price,
        'user_id': userId,
        'user_name': userName,
        'user_avatar': userAvatar,
        'user_car_plate': userCarPlate,
        'user_car_photo': userCarPhoto,
        'user_phone_number': userPhoneNumber,
        'user_rank': userRank,
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
    String? userId,
    String? userName,
    String? userAvatar,
    String? userCarPlate,
    String? userCarPhoto,
    String? userPhoneNumber,
    String? userRank,
  }) {
    return OfferModel(
      id: id ?? this.id,
      routeId: routeId ?? this.routeId,
      count: count ?? this.count,
      maxCount: maxCount ?? this.maxCount,
      price: price ?? this.price,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      userCarPlate: userCarPlate ?? this.userCarPlate,
      userCarPhoto: userCarPhoto ?? this.userCarPhoto,
      userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
      userRank: userRank ?? this.userRank,
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
      userId,
      userName,
      userAvatar,
      userCarPlate,
      userCarPhoto,
      userPhoneNumber,
      userRank,
    ];
  }
}

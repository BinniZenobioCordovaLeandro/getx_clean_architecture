import 'dart:convert';
import 'package:pickpointer/packages/offer_package/data/models/offer_order_model.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/offer_order_entity.dart';

class OfferModel implements AbstractOfferEntity {
  @override
  final String? id;
  @override
  final int? count;
  @override
  final int? maxCount;
  @override
  final double? price;
  @override
  final double? total;
  @override
  final DateTime? dateTime;
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
  final List<OfferOrderEntity>? orders;
  @override
  final String?
      stateId; // Esperando -1, enCarretera 2 , Completado 1, Cancelado 0
  @override
  final String? stateDescription;
  @override
  final String? userId;
  @override
  final String? userName;
  @override
  final String? userEmail;
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
  final String? userTokenMessaging;
  @override
  final String? routeId;
  @override
  final String? routeTitle;
  @override
  final String? routeDescription;
  @override
  final double? routePrice;
  @override
  final String? routeFrom;
  @override
  final String? routeTo;
  @override
  final String? routeStartLat;
  @override
  final String? routeStartLng;
  @override
  final String? routeEndLat;
  @override
  final String? routeEndLng;
  @override
  final int? updatedAt;
  @override
  final int? createdAt;

  const OfferModel({
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

  factory OfferModel.fromMap(Map<String, dynamic> data) => OfferModel(
        id: data['id'] as String?,
        count: data['count'] as int?,
        maxCount: data['max_count'] as int?,
        price: double.tryParse('${data['price']}'),
        total: double.tryParse('${data['total']}'),
        dateTime: data['date_time'] != null
            ? DateTime.parse(data['date_time'])
            : null,
        startLat: data['start_lat'] as String?,
        startLng: data['start_lng'] as String?,
        endLat: data['end_lat'] as String?,
        endLng: data['end_lng'] as String?,
        wayPoints: data['way_points'] as String?,
        orders: List<OfferOrderEntity>.from(
            data['orders'] != null && data['orders'].length > 10
                ? (jsonDecode(data['orders'])).map(
                    (order) => OfferOrderModel.fromMap(order),
                  )
                : []),
        stateId: data['state_id'] as String?,
        stateDescription: data['state_description'] as String?,
        userId: data['user_id'] as String?,
        userName: data['user_name'] as String?,
        userEmail: data['user_email'] as String?,
        userAvatar: data['user_avatar'] as String?,
        userCarPlate: data['user_car_plate'] as String?,
        userCarPhoto: data['user_car_photo'] as String?,
        userCarModel: data['user_car_model'] as String?,
        userCarColor: data['user_car_color'] as String?,
        userPhoneNumber: data['user_phone_number'] as String?,
        userRank: data['user_rank'] as String?,
        userTokenMessaging: data['user_token_messaging'] as String?,
        routeId: data['route_id'] as String?,
        routeTitle: data['route_title'] as String?,
        routeDescription: data['route_description'] as String?,
        routePrice: double.tryParse('${data['route_price']}'),
        routeFrom: data['route_from'] as String?,
        routeTo: data['route_to'] as String?,
        routeStartLat: data['route_start_lat'] as String?,
        routeStartLng: data['route_start_lng'] as String?,
        routeEndLat: data['route_end_lat'] as String?,
        routeEndLng: data['route_end_lng'] as String?,
        updatedAt: data['updated_at'] as int?,
        createdAt: data['created_at'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'count': count,
        'max_count': maxCount,
        'price': price,
        'total': total,
        'date_time': dateTime?.toIso8601String(),
        'start_lat': startLat,
        'start_lng': startLng,
        'end_lat': endLat,
        'end_lng': endLng,
        'way_points': wayPoints,
        'orders': (orders != null && orders!.isNotEmpty)
            ? jsonEncode(
                orders
                    ?.map((OfferOrderEntity order) =>
                        (order as OfferOrderModel).toMap())
                    .toList(),
              )
            : '[]',
        'state_id': stateId,
        'state_description': stateDescription,
        'user_id': userId,
        'user_name': userName,
        'user_email': userEmail,
        'user_avatar': userAvatar,
        'user_car_plate': userCarPlate,
        'user_car_photo': userCarPhoto,
        'user_car_model': userCarModel,
        'user_car_color': userCarColor,
        'user_phone_number': userPhoneNumber,
        'user_rank': userRank,
        'user_token_messaging': userTokenMessaging,
        'route_id': routeId,
        'route_title': routeTitle,
        'route_description': routeDescription,
        'route_price': routePrice,
        'route_from': routeFrom,
        'route_to': routeTo,
        'route_start_lat': routeStartLat,
        'route_start_lng': routeStartLng,
        'route_end_lat': routeEndLat,
        'route_end_lng': routeEndLng,
        'updated_at': updatedAt,
        'created_at': createdAt,
      };

  factory OfferModel.fromJson(String data) {
    return OfferModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  OfferModel copyWith({
    String? id,
    int? count,
    int? maxCount,
    double? price,
    double? total,
    DateTime? dateTime,
    String? startLat,
    String? startLng,
    String? endLat,
    String? endLng,
    String? wayPoints,
    List<OfferOrderEntity>? orders,
    String? stateId,
    String? stateDescription,
    String? userId,
    String? userName,
    String? userEmail,
    String? userAvatar,
    String? userCarPlate,
    String? userCarPhoto,
    String? userCarModel,
    String? userCarColor,
    String? userPhoneNumber,
    String? userRank,
    String? userTokenMessaging,
    String? routeId,
    String? routeTitle,
    String? routeDescription,
    double? routePrice,
    String? routeFrom,
    String? routeTo,
    String? routeStartLat,
    String? routeStartLng,
    String? routeEndLat,
    String? routeEndLng,
    int? updatedAt,
    int? createdAt,
  }) {
    return OfferModel(
      id: id ?? this.id,
      count: count ?? this.count,
      maxCount: maxCount ?? this.maxCount,
      price: price ?? this.price,
      total: total ?? this.total,
      dateTime: dateTime ?? this.dateTime,
      startLat: startLat ?? this.startLat,
      startLng: startLng ?? this.startLng,
      endLat: endLat ?? this.endLat,
      endLng: endLng ?? this.endLng,
      wayPoints: wayPoints ?? this.wayPoints,
      orders: orders ?? this.orders,
      stateId: stateId ?? this.stateId,
      stateDescription: stateDescription ?? this.stateDescription,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userAvatar: userAvatar ?? this.userAvatar,
      userCarPlate: userCarPlate ?? this.userCarPlate,
      userCarPhoto: userCarPhoto ?? this.userCarPhoto,
      userCarModel: userCarModel ?? this.userCarModel,
      userCarColor: userCarColor ?? this.userCarColor,
      userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
      userRank: userRank ?? this.userRank,
      userTokenMessaging: userTokenMessaging ?? this.userTokenMessaging,
      routeId: routeId ?? this.routeId,
      routeTitle: routeTitle ?? this.routeTitle,
      routeDescription: routeDescription ?? this.routeDescription,
      routePrice: routePrice ?? this.routePrice,
      routeFrom: routeFrom ?? this.routeFrom,
      routeTo: routeTo ?? this.routeTo,
      routeStartLat: routeStartLat ?? this.routeStartLat,
      routeStartLng: routeStartLng ?? this.routeStartLng,
      routeEndLat: routeEndLat ?? this.routeEndLat,
      routeEndLng: routeEndLng ?? this.routeEndLng,
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
      count,
      maxCount,
      price,
      total,
      dateTime,
      startLat,
      startLng,
      endLat,
      endLng,
      wayPoints,
      orders,
      stateId,
      stateDescription,
      userId,
      userName,
      userEmail,
      userAvatar,
      userCarPlate,
      userCarPhoto,
      userCarModel,
      userCarColor,
      userPhoneNumber,
      userRank,
      userTokenMessaging,
      routeId,
      routeTitle,
      routeDescription,
      routePrice,
      routeFrom,
      routeTo,
      routeStartLat,
      routeStartLng,
      routeEndLat,
      routeEndLng,
      updatedAt,
      createdAt,
    ];
  }
}

import 'dart:convert';

import 'package:pickpointer/packages/offer_package/data/models/offer_order_model.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/offer_order_entity.dart';
import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';

class OrderModel implements AbstractOrderEntity {
  @override
  final String? id;
  @override
  final String? orderId;
  @override
  final double? price;
  @override
  final int? count;
  @override
  final double? subtotal;
  @override
  final double? total;
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
  final String? userPhone;
  @override
  final String? userPickPointLat;
  @override
  final String? userPickPointLng;
  @override
  final String? userDropPointLat;
  @override
  final String? userDropPointLng;
  @override
  final String? userTokenMessaging;
  @override
  final String? offerId;
  @override
  final int? offerCount;
  @override
  final int? offerMaxCount;
  @override
  final double? offerPrice;
  @override
  final String? offerStartLat;
  @override
  final String? offerStartLng;
  @override
  final String? offerEndLat;
  @override
  final String? offerEndLng;
  @override
  final String? offerWayPoints;
  @override
  final List<OfferOrderEntity>? offerOrders;
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
  final String? driverId;
  @override
  final String? driverName;
  @override
  final String? driverEmail;
  @override
  final String? driverAvatar;
  @override
  final String? driverCarPlate;
  @override
  final String? driverCarPhoto;
  @override
  final String? driverCarModel;
  @override
  final String? driverCarColor;
  @override
  final String? driverPhoneNumber;
  @override
  final String? driverRank;
  @override
  final String? driverTokenMessaging;
  @override
  final int? createdAt;
  @override
  final int? updatedAt;

  const OrderModel({
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

  factory OrderModel.fromMap(Map<String, dynamic> data) => OrderModel(
        id: data['id'] as String?,
        orderId: data['order_id'] as String?,
        price: double.parse('${data['price']}'),
        count: data['count'] as int?,
        subtotal: double.parse('${data['subtotal']}'),
        total: double.parse('${data['total']}'),
        stateId: data['state_id'] as String?,
        stateDescription: data['state_description'] as String?,
        userId: data['user_id'] as String?,
        userName: data['user_name'] as String?,
        userEmail: data['user_email'] as String?,
        userAvatar: data['user_avatar'] as String?,
        userPhone: data['user_phone'] as String?,
        userPickPointLat: data['user_pick_point_lat'] as String?,
        userPickPointLng: data['user_pick_point_lng'] as String?,
        userDropPointLat: data['user_drop_point_lat'] as String?,
        userDropPointLng: data['user_drop_point_lng'] as String?,
        userTokenMessaging: data['user_token_messaging'] as String?,
        offerId: data['offer_id'] as String?,
        offerCount: data['offer_count'] as int?,
        offerMaxCount: data['offer_max_count'] as int?,
        offerPrice: double.parse('${data['offer_price']}'),
        offerStartLat: data['offer_start_lat'] as String?,
        offerStartLng: data['offer_start_lng'] as String?,
        offerEndLat: data['offer_end_lat'] as String?,
        offerEndLng: data['offer_end_lng'] as String?,
        offerWayPoints: data['offer_way_points'] as String?,
        offerOrders: List<OfferOrderEntity>.from(
          data['offer_orders'] != null && data['offer_orders'].length > 10
              ? (jsonDecode(data['offer_orders']) ?? []).map(
                  (order) => OfferOrderModel.fromMap(order),
                )
              : [],
        ),
        routeId: data['route_id'] as String?,
        routeTitle: data['route_title'] as String?,
        routeDescription: data['route_description'] as String?,
        routePrice: double.parse('${data['route_price']}'),
        routeFrom: data['route_from'] as String?,
        routeTo: data['route_to'] as String?,
        routeStartLat: data['route_start_lat'] as String?,
        routeStartLng: data['route_start_lng'] as String?,
        routeEndLat: data['route_end_lat'] as String?,
        routeEndLng: data['route_end_lng'] as String?,
        driverId: data['driver_id'] as String?,
        driverName: data['driver_name'] as String?,
        driverEmail: data['driver_email'] as String?,
        driverAvatar: data['driver_avatar'] as String?,
        driverCarPlate: data['driver_car_plate'] as String?,
        driverCarPhoto: data['driver_car_photo'] as String?,
        driverCarModel: data['driver_car_model'] as String?,
        driverCarColor: data['driver_car_color'] as String?,
        driverPhoneNumber: data['driver_phone_number'] as String?,
        driverRank: data['driver_rank'] as String?,
        driverTokenMessaging: data['driver_token_messaging'] as String?,
        createdAt: data['created_at'] as int?,
        updatedAt: data['updated_at'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'order_id': orderId,
        'price': price,
        'count': count,
        'subtotal': subtotal,
        'total': total,
        'state_id': stateId,
        'state_description': stateDescription,
        'user_id': userId,
        'user_name': userName,
        'user_email': userEmail,
        'user_avatar': userAvatar,
        'user_phone': userPhone,
        'user_pick_point_lat': userPickPointLat,
        'user_pick_point_lng': userPickPointLng,
        'user_drop_point_lat': userDropPointLat,
        'user_drop_point_lng': userDropPointLng,
        'user_token_messaging': userTokenMessaging,
        'offer_id': offerId,
        'offer_count': offerCount,
        'offer_max_count': offerMaxCount,
        'offer_price': offerPrice,
        'offer_start_lat': offerStartLat,
        'offer_start_lng': offerStartLng,
        'offer_end_lat': offerEndLat,
        'offer_end_lng': offerEndLng,
        'offer_way_points': offerWayPoints,
        'offer_orders': (offerOrders != null && offerOrders!.isNotEmpty)
            ? jsonEncode(
                offerOrders
                    ?.map((OfferOrderEntity order) =>
                        (order as OfferOrderModel).toMap())
                    .toList(),
              )
            : '[]',
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
        'driver_id': driverId,
        'driver_name': driverName,
        'driver_email': driverEmail,
        'driver_avatar': driverAvatar,
        'driver_car_plate': driverCarPlate,
        'driver_car_photo': driverCarPhoto,
        'driver_car_model': driverCarModel,
        'driver_car_color': driverCarColor,
        'driver_phone_number': driverPhoneNumber,
        'driver_rank': driverRank,
        'driver_token_messaging': driverTokenMessaging,
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
    double? price,
    int? count,
    double? subtotal,
    double? total,
    String? stateId,
    String? stateDescription,
    String? userId,
    String? userName,
    String? userEmail,
    String? userAvatar,
    String? userPhone,
    String? userPickPointLat,
    String? userPickPointLng,
    String? userDropPointLat,
    String? userDropPointLng,
    String? userTokenMessaging,
    String? offerId,
    int? offerCount,
    int? offerMaxCount,
    double? offerPrice,
    String? offerStartLat,
    String? offerStartLng,
    String? offerEndLat,
    String? offerEndLng,
    String? offerWayPoints,
    List<OfferOrderEntity>? offerOrders,
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
    String? driverId,
    String? driverName,
    String? driverEmail,
    String? driverAvatar,
    String? driverCarPlate,
    String? driverCarPhoto,
    String? driverCarModel,
    String? driverCarColor,
    String? driverPhoneNumber,
    String? driverRank,
    String? driverTokenMessaging,
    int? createdAt,
    int? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      price: price ?? this.price,
      count: count ?? this.count,
      subtotal: subtotal ?? this.subtotal,
      total: total ?? this.total,
      stateId: stateId ?? this.stateId,
      stateDescription: stateDescription ?? this.stateDescription,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userAvatar: userAvatar ?? this.userAvatar,
      userPhone: userPhone ?? this.userPhone,
      userPickPointLat: userPickPointLat ?? this.userPickPointLat,
      userPickPointLng: userPickPointLng ?? this.userPickPointLng,
      userDropPointLat: userDropPointLat ?? this.userDropPointLat,
      userDropPointLng: userDropPointLng ?? this.userDropPointLng,
      userTokenMessaging: userTokenMessaging ?? this.userTokenMessaging,
      offerId: offerId ?? this.offerId,
      offerCount: offerCount ?? this.offerCount,
      offerMaxCount: offerMaxCount ?? this.offerMaxCount,
      offerPrice: offerPrice ?? this.offerPrice,
      offerStartLat: offerStartLat ?? this.offerStartLat,
      offerStartLng: offerStartLng ?? this.offerStartLng,
      offerEndLat: offerEndLat ?? this.offerEndLat,
      offerEndLng: offerEndLng ?? this.offerEndLng,
      offerWayPoints: offerWayPoints ?? this.offerWayPoints,
      offerOrders: offerOrders ?? this.offerOrders,
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
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverEmail: driverEmail ?? this.driverEmail,
      driverAvatar: driverAvatar ?? this.driverAvatar,
      driverCarPlate: driverCarPlate ?? this.driverCarPlate,
      driverCarPhoto: driverCarPhoto ?? this.driverCarPhoto,
      driverCarModel: driverCarModel ?? this.driverCarModel,
      driverCarColor: driverCarColor ?? this.driverCarColor,
      driverPhoneNumber: driverPhoneNumber ?? this.driverPhoneNumber,
      driverRank: driverRank ?? this.driverRank,
      driverTokenMessaging: driverTokenMessaging ?? this.driverTokenMessaging,
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
      count,
      subtotal,
      total,
      stateId,
      stateDescription,
      userId,
      userName,
      userEmail,
      userAvatar,
      userPhone,
      userPickPointLat,
      userPickPointLng,
      userDropPointLat,
      userDropPointLng,
      userTokenMessaging,
      offerId,
      offerCount,
      offerMaxCount,
      offerPrice,
      offerStartLat,
      offerStartLng,
      offerEndLat,
      offerEndLng,
      offerWayPoints,
      offerOrders,
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
      driverId,
      driverName,
      driverEmail,
      driverAvatar,
      driverCarPlate,
      driverCarPhoto,
      driverCarModel,
      driverCarColor,
      driverPhoneNumber,
      driverRank,
      driverTokenMessaging,
      createdAt,
      updatedAt,
    ];
  }
}

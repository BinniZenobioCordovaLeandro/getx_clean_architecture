import 'dart:convert';

import 'package:pickpointer/packages/offer_package/domain/entities/offer_order_entity.dart';

class OfferOrderModel implements OfferOrderEntity {
  @override
  final String? userId;
  @override
  final String? orderId;
  @override
  final String? fullName;
  @override
  final String? phoneNumber;
  @override
  final String? avatar;
  @override
  final int? count;
  @override
  final double? subtotal;
  @override
  final double? total;
  @override
  final String? pickPointLat;
  @override
  final String? pickPointLng;
  @override
  final String? dropPointLat;
  @override
  final String? dropPointLng;
  @override
  final String? tokenMessaging;

  const OfferOrderModel({
    this.userId,
    this.orderId,
    this.fullName,
    this.phoneNumber,
    this.avatar,
    this.count,
    this.subtotal,
    this.total,
    this.pickPointLat,
    this.pickPointLng,
    this.dropPointLat,
    this.dropPointLng,
    this.tokenMessaging,
  });

  @override
  String toString() {
    return 'OfferOrderModel(userId: $userId, orderId: $orderId, fullName: $fullName, phoneNumber: $phoneNumber, avatar: $avatar, count: $count, subtotal: $subtotal, total: $total, pickPointLat: $pickPointLat, pickPointLng: $pickPointLng, dropPointLat: $dropPointLat, dropPointLng: $dropPointLng, tokenMessaging: $tokenMessaging)';
  }

  factory OfferOrderModel.fromMap(Map<String, dynamic> data) {
    return OfferOrderModel(
      userId: data['user_id'] as String?,
      orderId: data['order_id'] as String?,
      fullName: data['full_name'] as String?,
      phoneNumber: data['phone_number'] as String?,
      avatar: data['avatar'] as String?,
      count: data['count'] as int?,
      subtotal: double.tryParse('${data['subtotal']}'),
      total: double.tryParse('${data['total']}'),
      pickPointLat: data['pick_point_lat'] as String?,
      pickPointLng: data['pick_point_lng'] as String?,
      dropPointLat: data['drop_point_lat'] as String?,
      dropPointLng: data['drop_point_lng'] as String?,
      tokenMessaging: data['token_messaging'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'user_id': userId,
        'order_id': orderId,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'avatar': avatar,
        'count': count,
        'subtotal': subtotal,
        'total': total,
        'pick_point_lat': pickPointLat,
        'pick_point_lng': pickPointLng,
        'drop_point_lat': dropPointLat,
        'drop_point_lng': dropPointLng,
        'token_messaging': tokenMessaging,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OfferOrderModel].
  factory OfferOrderModel.fromJson(String data) {
    return OfferOrderModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OfferOrderModel] to a JSON string.
  String toJson() => json.encode(toMap());

  OfferOrderModel copyWith({
    String? userId,
    String? orderId,
    String? fullName,
    String? phoneNumber,
    String? avatar,
    int? count,
    double? subtotal,
    double? total,
    String? pickPointLat,
    String? pickPointLng,
    String? dropPointLat,
    String? dropPointLng,
    String? tokenMessaging,
  }) {
    return OfferOrderModel(
      userId: userId ?? this.userId,
      orderId: orderId ?? this.orderId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      count: count ?? this.count,
      subtotal: subtotal ?? this.subtotal,
      total: total ?? this.total,
      pickPointLat: pickPointLat ?? this.pickPointLat,
      pickPointLng: pickPointLng ?? this.pickPointLng,
      dropPointLat: dropPointLat ?? this.dropPointLat,
      dropPointLng: dropPointLng ?? this.dropPointLng,
      tokenMessaging: tokenMessaging ?? this.tokenMessaging,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      userId,
      orderId,
      fullName,
      phoneNumber,
      avatar,
      count,
      subtotal,
      total,
      pickPointLat,
      pickPointLng,
      dropPointLat,
      dropPointLng,
      tokenMessaging,
    ];
  }
}

import 'package:equatable/equatable.dart';

abstract class OfferOrderEntity extends Equatable {
  final String? userId;
  final String? orderId;
  final String? fullName;
  final String? phoneNumber;
  final String? avatar;
  final int? count;
  final double? subtotal;
  final double? total;
  final String? pickPointLat;
  final String? pickPointLng;
  final String? dropPointLat;
  final String? dropPointLng;
  final String? tokenMessaging;

  const OfferOrderEntity({
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
}

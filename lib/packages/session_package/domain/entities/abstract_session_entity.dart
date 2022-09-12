import 'package:equatable/equatable.dart';

abstract class AbstractSessionEntity extends Equatable {
  final bool? isSigned;
  final bool? isDriver;
  final bool? isPhoneVerified;
  final String? idSessions;
  final String? idUsers;
  final bool? onRoad;
  final String? currentOfferId;
  final String? currentOrderId;
  final String? tokenMessaging;

  const AbstractSessionEntity({
    this.isSigned,
    this.isDriver,
    this.isPhoneVerified,
    this.idSessions,
    this.idUsers,
    this.onRoad,
    this.currentOfferId,
    this.currentOrderId,
    this.tokenMessaging,
  });
}

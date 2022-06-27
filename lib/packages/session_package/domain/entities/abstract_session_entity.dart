import 'package:equatable/equatable.dart';

abstract class AbstractSessionEntity extends Equatable {
  final bool? isSigned;
  final bool? isDriver;
  final String? idSessions;
  final String? idUsers;
  final bool? onRoad;
  final String? currentOfferId;
  final String? currentOrderId;

  const AbstractSessionEntity({
    this.isSigned,
    this.isDriver,
    this.idSessions,
    this.idUsers,
    this.onRoad,
    this.currentOfferId,
    this.currentOrderId,
  });
}

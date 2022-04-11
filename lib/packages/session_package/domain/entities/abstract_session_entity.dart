import 'package:equatable/equatable.dart';

abstract class AbstractSessionEntity extends Equatable {
  final bool? isSigned;
  final bool? isDriver;
  final String? idSessions;
  final String? idUsers;
  final String? name;
  final String? email;
  final String? avatar;
  final String? carPlate;
  final String? carPhoto;
  final String? carModel;
  final String? carColor;
  final String? phoneNumber;
  final String? rank;

  const AbstractSessionEntity({
    this.isSigned,
    this.isDriver,
    this.idSessions,
    this.idUsers,
    this.name,
    this.email,
    this.avatar,
    this.carPlate,
    this.carPhoto,
    this.carModel,
    this.carColor,
    this.phoneNumber,
    this.rank,
  });
}

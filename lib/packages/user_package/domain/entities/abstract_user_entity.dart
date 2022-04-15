import 'package:equatable/equatable.dart';

abstract class AbstractUserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? avatar;
  final String? document;
  final String? carPlate;
  final String? carPhoto;
  final String? carModel;
  final String? carColor;
  final String? phoneNumber;
  final String? rank;
  final String? isDriver;

  const AbstractUserEntity({
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.document,
    this.carPlate,
    this.carPhoto,
    this.carModel,
    this.carColor,
    this.phoneNumber,
    this.rank,
    this.isDriver,
  });
}

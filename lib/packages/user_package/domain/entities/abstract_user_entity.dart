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
  final String? carDescription;
  final String? phoneNumber;
  final String? licensePhoto;
  final String? license;
  final String? rank;
  final String? observation;
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
    this.carDescription,
    this.phoneNumber,
    this.licensePhoto,
    this.license,
    this.observation,
    this.rank,
    this.isDriver,
  });
}

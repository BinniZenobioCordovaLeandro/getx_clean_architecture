import 'package:equatable/equatable.dart';

abstract class AbstractUserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? avatar;
  final String? carPlate;
  final String? carPhoto;
  final String? phoneNumber;
  final String? rank;
  final String? role;

  const AbstractUserEntity({
    this.id,
    this.name,
    this.avatar,
    this.carPlate,
    this.carPhoto,
    this.phoneNumber,
    this.rank,
    this.role,
  });
}

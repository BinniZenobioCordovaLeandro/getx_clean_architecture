import 'package:equatable/equatable.dart';

abstract class AbstractVehicleEntity extends Equatable {
  final String? id;
  final String? latitude;
  final String? longitude;
  final String? offerId;
  final String? stateId;

  const AbstractVehicleEntity({
    this.id,
    this.latitude,
    this.longitude,
    this.offerId,
    this.stateId,
  });
}

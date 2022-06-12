import 'package:equatable/equatable.dart';

abstract class AbstractVehicleEntity extends Equatable {
  final String? id;
  final String? lat;
  final String? lng;
  final String? offerId;

  const AbstractVehicleEntity({
    this.id,
    this.lat,
    this.lng,
    this.offerId,
  });
}

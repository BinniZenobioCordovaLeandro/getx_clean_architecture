import 'package:equatable/equatable.dart';

abstract class AbstractRouteEntity extends Equatable {
  final String? id;
  final String? description;
  final String? startLat;
  final String? startLng;
  final String? endLat;
  final String? endLng;

  const AbstractRouteEntity({
    this.id,
    this.description,
    this.startLat,
    this.startLng,
    this.endLat,
    this.endLng,
  });
}

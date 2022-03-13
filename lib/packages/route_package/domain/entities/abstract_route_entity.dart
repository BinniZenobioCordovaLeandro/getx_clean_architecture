import 'package:equatable/equatable.dart';

abstract class AbstractRouteEntity extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final String? price;
  final String? from;
  final String? to;
  final String? startLat;
  final String? startLng;
  final String? endLat;
  final String? endLng;

  const AbstractRouteEntity({
    this.id,
    this.title,
    this.description,
    this.price,
    this.from,
    this.to,
    this.startLat,
    this.startLng,
    this.endLat,
    this.endLng,
  });
}

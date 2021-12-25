import 'dart:convert';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';

class RouteModel implements AbstractRouteEntity {
  @override
  final String? id;
  @override
  final String? description;
  @override
  final String? startLat;
  @override
  final String? startLng;
  @override
  final String? endLat;
  @override
  final String? endLng;

  const RouteModel({
    this.id,
    this.description,
    this.startLat,
    this.startLng,
    this.endLat,
    this.endLng,
  });

  factory RouteModel.fromMap(Map<String, dynamic> data) => RouteModel(
        id: data['id'] as String?,
        description: data['description'] as String?,
        startLat: data['start_lat'] as String?,
        startLng: data['start_lng'] as String?,
        endLat: data['end_lat'] as String?,
        endLng: data['end_lng'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'description': description,
        'start_lat': startLat,
        'start_lng': startLng,
        'end_lat': endLat,
        'end_lng': endLng,
      };

  factory RouteModel.fromJson(String data) {
    return RouteModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  RouteModel copyWith({
    String? id,
    String? description,
    String? startLat,
    String? startLng,
    String? endLat,
    String? endLng,
  }) {
    return RouteModel(
      id: id ?? this.id,
      description: description ?? this.description,
      startLat: startLat ?? this.startLat,
      startLng: startLng ?? this.startLng,
      endLat: endLat ?? this.endLat,
      endLng: endLng ?? this.endLng,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      description,
      startLat,
      startLng,
      endLat,
      endLng,
    ];
  }
}

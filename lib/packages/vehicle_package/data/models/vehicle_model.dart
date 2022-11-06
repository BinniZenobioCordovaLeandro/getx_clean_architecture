import 'dart:convert';

import 'package:pickpointer/packages/vehicle_package/domain/entities/abstract_vehicle_entity.dart';

class VehicleModel extends AbstractVehicleEntity {
  @override
  final String? id;
  @override
  final String? latitude;
  @override
  final String? longitude;
  @override
  final String? offerId;
  @override
  final String?
      stateId; // Esperando -1, enCarretera 2 , enListo 3, Completado 1, Cancelado 0

  const VehicleModel({
    this.id,
    this.latitude,
    this.longitude,
    this.offerId,
    this.stateId,
  });

  factory VehicleModel.fromMap(Map<String, dynamic> data) => VehicleModel(
        id: data['id'] as String?,
        latitude: data['latitude'] as String?,
        longitude: data['longitude'] as String?,
        offerId: data['offer_id'] as String?,
        stateId: data['state_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'offer_id': offerId,
        'state_id': stateId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [VehicleModel].
  factory VehicleModel.fromJson(String data) {
    return VehicleModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [VehicleModel] to a JSON string.
  String toJson() => json.encode(toMap());

  VehicleModel copyWith({
    String? id,
    String? latitude,
    String? longitude,
    String? offerId,
    String? stateId,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      offerId: offerId ?? this.offerId,
      stateId: stateId ?? this.stateId,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        id,
        latitude,
        longitude,
        offerId,
        stateId,
      ];
}

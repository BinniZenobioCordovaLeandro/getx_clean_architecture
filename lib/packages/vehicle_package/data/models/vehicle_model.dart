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

  const VehicleModel({
    this.id,
    this.latitude,
    this.longitude,
    this.offerId,
  });

  factory VehicleModel.fromMap(Map<String, dynamic> data) => VehicleModel(
        id: data['id'] as String?,
        latitude: data['lat'] as String?,
        longitude: data['lng'] as String?,
        offerId: data['offer_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'lat': latitude,
        'lng': longitude,
        'offer_id': offerId,
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
    String? lat,
    String? lng,
    String? offerId,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      latitude: lat ?? this.latitude,
      longitude: lng ?? this.longitude,
      offerId: offerId ?? this.offerId,
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
      ];
}

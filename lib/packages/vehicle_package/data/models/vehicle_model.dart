import 'dart:convert';

import 'package:pickpointer/packages/vehicle_package/domain/entities/abstract_vehicle_entity.dart';

class VehicleModel extends AbstractVehicleEntity {
  @override
  final String? id;
  @override
  final String? lat;
  @override
  final String? lng;
  @override
  final String? offerId;

  const VehicleModel({
    this.id,
    this.lat,
    this.lng,
    this.offerId,
  });

  factory VehicleModel.fromMap(Map<String, dynamic> data) => VehicleModel(
        id: data['id'] as String?,
        lat: data['lat'] as String?,
        lng: data['lng'] as String?,
        offerId: data['offer_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'lat': lat,
        'lng': lng,
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
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      offerId: offerId ?? this.offerId,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        id,
        lat,
        lng,
        offerId,
      ];
}

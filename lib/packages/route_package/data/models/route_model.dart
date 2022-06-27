import 'dart:convert';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';

class RouteModel implements AbstractRouteEntity {
  @override
  final String? id;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final double? price;
  @override
  final String? from;
  @override
  final String? to;
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

  factory RouteModel.fromMap(Map<String, dynamic> data) => RouteModel(
        id: data['id'] as String?,
        title: data['title'] as String?,
        description: data['description'] as String?,
        price: double.parse('${data['price']}'),
        from: data['from'] as String?,
        to: data['to'] as String?,
        startLat: data['start_lat'] as String?,
        startLng: data['start_lng'] as String?,
        endLat: data['end_lat'] as String?,
        endLng: data['end_lng'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'from': from,
        'to': to,
        'start_lat': startLat,
        'start_lng': startLng,
        'end_lat': endLat,
        'end_lng': endLng,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RouteModel].
  factory RouteModel.fromJson(String data) {
    return RouteModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RouteModel] to a JSON string.
  String toJson() => json.encode(toMap());

  RouteModel copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? from,
    String? to,
    String? startLat,
    String? startLng,
    String? endLat,
    String? endLng,
  }) {
    return RouteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      from: from ?? this.from,
      to: to ?? this.to,
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
      title,
      description,
      price,
      from,
      to,
      startLat,
      startLng,
      endLat,
      endLng,
    ];
  }
}

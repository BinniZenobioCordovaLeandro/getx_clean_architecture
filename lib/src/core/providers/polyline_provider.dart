import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:pickpointer/src/core/env/config_env.dart';

class PolylineProvider {
  static PolylineProvider? _instance;
  PolylinePoints polylinePoints = PolylinePoints();

  static PolylineProvider? getInstance() {
    _instance ??= PolylineProvider();
    return _instance;
  }

  Future<List<LatLng>> getPolylineBetweenCoordinates({
    required LatLng origin,
    required LatLng destination,
    List<LatLng>? wayPoints,
  }) {
    Future<List<LatLng>> futureListLatLng = polylinePoints
        .getRouteBetweenCoordinates(
      ConfigEnv.apiKeyDirections,
      PointLatLng(
        origin.latitude,
        origin.longitude,
      ),
      PointLatLng(
        destination.latitude,
        destination.longitude,
      ),
      wayPoints: (wayPoints != null && wayPoints.isNotEmpty) ? wayPoints.map((wayPoint) {
        return PolylineWayPoint(location: '${wayPoint.latitude},${wayPoint.longitude}');
      }).toList() : [],
    )
        .then((PolylineResult polylineResult) {
      if (polylineResult.errorMessage?.isNotEmpty == true) {
        return throw Exception(polylineResult.errorMessage);
      }
      return polylineResult.points
          .map((PointLatLng point) => LatLng(
                point.latitude,
                point.longitude,
              ))
          .toList();
    }, onError: (dynamic error) {
      return throw Exception(error.toString());
    });

    return futureListLatLng;
  }

  List<LatLng> decodePolyline(String encodedString) {
    List<PointLatLng> listPointLatLng =
        polylinePoints.decodePolyline(encodedString);
    return listPointLatLng
        .map((PointLatLng point) => LatLng(point.latitude, point.longitude))
        .toList();
  }
}

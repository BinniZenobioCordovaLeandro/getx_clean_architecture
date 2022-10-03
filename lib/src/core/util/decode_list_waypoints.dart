import 'dart:convert';
import 'package:latlong2/latlong.dart';

List<LatLng> decodeListWaypoints(String wayPoints) {
  List<LatLng> listLatLng = [];
  if (wayPoints.length > 10) {
    List list = jsonDecode(wayPoints);
    listLatLng = list.map((string) {
      var split = string.split(',');
      LatLng latLng = LatLng(
        double.parse(split[0].trim()),
        double.parse(split[1].trim()),
      );
      return latLng;
    }).toList();
  }
  return listLatLng;
}

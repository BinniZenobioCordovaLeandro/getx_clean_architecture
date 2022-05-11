import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class GeolocatorProvider {
  static GeolocatorProvider? _instance;

  bool isLocationServiceEnabled = false;
  GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  static GeolocatorProvider? getInstance() {
    _instance ??= GeolocatorProvider();
    return _instance;
  }

  Future<bool> checkPermission() async {
    bool? serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!(serviceEnabled == true)) {
      throw Exception('Location service is not enabled');
    }

    LocationPermission? permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission is denied forever');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw Exception('Location permission is denied');
      }
    }

    isLocationServiceEnabled = true;
    return isLocationServiceEnabled;
  }

  Future<Position?>? getCurrentPosition() {
    if (!isLocationServiceEnabled) {
      throw Exception('Location service is not enabled');
    }
    return Geolocator.getCurrentPosition(
      timeLimit: const Duration(
        seconds: 60,
      ),
    ).then((Position? position) {
      return position;
    }, onError: (dynamic error) {
      throw Exception(error.toString());
    });
  }

  Stream<Position> streamPosition() {
    if (!isLocationServiceEnabled) {
      throw Exception('Location service is not enabled');
    }
    _geolocatorPlatform.getServiceStatusStream().listen((event) {
      if (event == ServiceStatus.disabled) {
        isLocationServiceEnabled = false;
      }
    });
    Stream<Position> streamPosition = _geolocatorPlatform.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    );
    return streamPosition;
  }

  double distanceBetween(
      startLatitude, startLongitude, endLatitude, endLongitude) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }

  double getDistanceBetweenPoints({
    required LatLng origin,
    required LatLng destination,
  }) {
    double distanceInMeters = Geolocator.distanceBetween(
      origin.latitude,
      origin.longitude,
      destination.latitude,
      destination.longitude,
    );
    return distanceInMeters;
  }
}

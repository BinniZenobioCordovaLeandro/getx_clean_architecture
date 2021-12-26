import 'package:geolocator/geolocator.dart';

class GeolocatorProvider {
  static GeolocatorProvider? _instance;

  bool isLocationServiceEnabled = false;

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
}
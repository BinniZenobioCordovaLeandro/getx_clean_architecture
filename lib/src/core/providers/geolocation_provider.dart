import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

final _streamOnPositionChanged = StreamController<Position>.broadcast();

class GeolocatorProvider {
  static GeolocatorProvider? _instance;

  bool isLocationServiceEnabled = false;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Stream<Position> get onPositionChanged => _streamOnPositionChanged.stream;

  static GeolocatorProvider? getInstance() {
    _instance ??= GeolocatorProvider();
    return _instance;
  }

  initialize() {
    checkPermission().then((bool isReady) {
      if (isReady) configure();
    });
  }

  Future<bool> configure() {
    _geolocatorPlatform.getServiceStatusStream().listen((ServiceStatus event) {
      if (event == ServiceStatus.disabled) {
        isLocationServiceEnabled = false;
        initialize();
      }
    });
    _geolocatorPlatform
        .getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        timeLimit: Duration(seconds: 10),
      ),
    )
        .listen(handlerOnPositionChanged, onError: (err) {
      print('ERROR STREAM POSITION!');
    });
    return Future.value(true);
  }

  Future<bool> checkPermission() async {
    bool? serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!(serviceEnabled == true)) {}
    // throw Exception('Location service is not enabled');
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

  Future<Position?>? getCurrentPosition() async {
    if (!isLocationServiceEnabled) {
      await checkPermission();
      // throw Exception('Location service is not enabled');
    }
    return Geolocator.getCurrentPosition(
      timeLimit: const Duration(
        seconds: 60,
      ),
    ).then((Position? position) {
      return position;
    }, onError: (dynamic error) {
      print('getCurrentPosition');
      print(error);
      throw Exception(error.toString());
    });
  }

  handlerOnPositionChanged(Position streamPosition) {
    if (isLocationServiceEnabled) {
      _streamOnPositionChanged.sink.add(streamPosition);
    }
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

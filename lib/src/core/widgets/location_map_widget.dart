import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:pickpointer/src/core/providers/geolocation_provider.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/flutter_map_widget.dart';

class LocationMapWidget extends StatefulWidget {
  final LatLng? initialLatLng;
  final Function(LatLng)? onChanged;
  final Icon iconMarker;

  const LocationMapWidget({
    Key? key,
    this.initialLatLng,
    this.onChanged,
    this.iconMarker = const Icon(
      Icons.location_history,
      size: 50.0,
      color: Colors.red,
    ),
  }) : super(key: key);

  @override
  State<LocationMapWidget> createState() => _LocationMapWidgetState();
}

class _LocationMapWidgetState extends State<LocationMapWidget> {
  final MapController? mapController = MapController();

  final GeolocatorProvider? geolocatorProvider =
      GeolocatorProvider.getInstance();

  LatLng latLng = LatLng(0, 0);
  LatLng myLatLng = LatLng(0, 0);

  String? errorPlaces;
  List<Prediction> listPrediction = [];

  moveToMyLocation() {
    getMyLocation()?.then((LatLng? latLng) {
      if (latLng != null) {
        move(latLng);
      }
    });
  }

  Future<LatLng?>? getMyLocation() {
    Future<LatLng?>? futureLatLng =
        geolocatorProvider?.getCurrentPosition()?.then((Position? position) {
      if (position != null) {
        LatLng latLng = LatLng(
          position.latitude,
          position.longitude,
        );
        myLatLng = latLng;
        return latLng;
      }
      return null;
    });
    return futureLatLng;
  }

  move(LatLng latLng) {
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      mapController!.move(latLng, 15.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      color: Theme.of(context).colorScheme.background,
      shape: const RoundedRectangleBorder(),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            FlutterMapWidget(
              mapController: mapController,
              onMapReady: () {
                if (widget.initialLatLng != null &&
                    widget.initialLatLng?.latitude != 0 &&
                    widget.initialLatLng?.longitude != 0) {
                  latLng = widget.initialLatLng!;
                  move(widget.initialLatLng!);
                } else {
                  moveToMyLocation();
                }
              },
              onPositionChanged: (mapPosition, boolean) => {
                setState(() {
                  latLng = mapPosition.center!;
                  if (widget.onChanged != null) {
                    print(latLng);
                    widget.onChanged!(latLng);
                  }
                })
              },
              children: [
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 20.0,
                      height: 20.0,
                      point: myLatLng,
                      anchorPos: AnchorPos.align(AnchorAlign.top),
                      builder: (BuildContext context) => IconButton(
                        tooltip: 'Mi ubicacion actual',
                        icon: Center(
                          child: Icon(
                            Icons.person_pin_circle_sharp,
                            color: Theme.of(context).primaryColor,
                            size: 20.0,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Marker(
                      width: 0,
                      height: 0,
                      point: latLng,
                      anchorPos: AnchorPos.align(AnchorAlign.center),
                      builder: (BuildContext context) => const Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.black,
                      ),
                    ),
                    Marker(
                      width: 45.0,
                      height: 45.0,
                      point: latLng,
                      anchorPos: AnchorPos.align(AnchorAlign.top),
                      builder: (BuildContext context) => Center(
                        child: widget.iconMarker,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: IconButton(
                onPressed: () => moveToMyLocation(),
                tooltip: 'Ir a mi ubicación',
                icon: const Icon(
                  Icons.my_location,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

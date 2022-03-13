import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';

class FlutterMapWidget extends StatelessWidget {
  final MapController? mapController;
  final LatLng? center;
  final LatLngBounds? bounds;
  final List<Widget> children;
  final int? interactiveFlags;
  final void Function(MapPosition, bool)? onPositionChanged;

  const FlutterMapWidget({
    Key? key,
    this.mapController,
    this.center,
    this.bounds,
    this.children = const [],
    this.interactiveFlags = InteractiveFlag.pinchZoom | InteractiveFlag.drag,
    this.onPositionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        maxZoom: 18.3,
        zoom: 13.0,
        center: center,
        interactiveFlags: interactiveFlags ?? InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        bounds: bounds,
        boundsOptions: const FitBoundsOptions(
          padding: EdgeInsets.all(
            32.0,
          ),
        ),
        onPositionChanged: onPositionChanged,
      ),
      children: [
        TileLayerWidget(
          options: TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
        ),
        ...children,
      ],
    );
  }
}

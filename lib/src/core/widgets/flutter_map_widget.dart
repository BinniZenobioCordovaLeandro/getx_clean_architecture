import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';

class FlutterMapWidget extends StatelessWidget {
  final MapController? mapController;
  final List<LayerOptions>? layers;
  final List<Widget> children;
  final LatLng? center;

  const FlutterMapWidget({
    Key? key,
    this.mapController,
    this.layers,
    this.center,
    this.children = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        maxZoom: 17.0,
        zoom: 13.0,
        center: center,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        ...?layers,
      ],
      children: children,
    );
  }
}

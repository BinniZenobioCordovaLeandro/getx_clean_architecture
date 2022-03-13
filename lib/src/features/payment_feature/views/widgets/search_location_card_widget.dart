import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:pickpointer/src/core/providers/geolocation_provider.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/flutter_map_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/list_tile_switch_card_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class SearchLocationCardWidget extends StatefulWidget {
  final String title;
  final String labelText;
  final Widget? leading;
  final String? helperText;
  final bool? initialValue;
  final LatLng? initialLatLng;
  final bool disabled;
  final Function(LatLng)? onChanged;

  const SearchLocationCardWidget({
    Key? key,
    required this.title,
    required this.labelText,
    this.leading,
    this.helperText,
    this.initialValue = false,
    this.initialLatLng,
    this.disabled = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<SearchLocationCardWidget> createState() =>
      _SearchLocationCardWidgetState();
}

class _SearchLocationCardWidgetState extends State<SearchLocationCardWidget> {
  final MapController mapController = MapController();

  final GeolocatorProvider? geolocatorProvider =
      GeolocatorProvider.getInstance();
  bool boolean = false;
  LatLng latLng = LatLng(0, 0);
  LatLng myLatLng = LatLng(0, 0);

  moveToMyLocation() {
    getMyLocation()?.then((LatLng? latLng) {
      if (latLng != null) {
        mapController.move(latLng, 15.0);
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

  @override
  void initState() {
    if (widget.initialValue != null) {
      boolean = widget.initialValue!;
    }
    getMyLocation();
    if (widget.initialLatLng != null) {
      WidgetsBinding.instance!.addPostFrameCallback((Duration duration) {
        mapController.move(widget.initialLatLng!, 15.0);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      color: Theme.of(context).backgroundColor,
      shape: (!boolean)
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            )
          : const RoundedRectangleBorder(),
      child: WrapWidget(
        children: [
          Center(
            child: ListTileSwitchCardWidget(
              showBorder: false,
              leading: widget.leading,
              title: TextWidget(
                widget.title,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              value: boolean,
              onChanged: widget.disabled
                  ? null
                  : (value) {
                      print(value);
                      WidgetsBinding.instance!
                          .addPostFrameCallback((Duration duration) {
                        setState(() {
                          boolean = value!;
                          if (value == true) {
                            if (widget.onChanged != null) {
                              widget.onChanged!(widget.initialLatLng!);
                            }
                            mapController.move(widget.initialLatLng!, 15.0);
                          }
                        });
                      });
                    },
            ),
          ),
          if (!boolean)
            Center(
              child: FractionallySizedBoxWidget(
                child: SizedBox(
                  width: double.infinity,
                  child: TextFieldWidget(
                    labelText: widget.labelText,
                    helperText: widget.helperText,
                  ),
                ),
              ),
            ),
          AspectRatio(
            aspectRatio: 3 / 1,
            child: Stack(
              children: [
                FlutterMapWidget(
                  mapController: mapController,
                  interactiveFlags: boolean ? InteractiveFlag.none : null,
                  onPositionChanged: (mapPosition, boolean) => {
                    WidgetsBinding.instance!
                        .addPostFrameCallback((Duration duration) {
                      setState(() {
                        LatLng _latLng = mapPosition.center!;
                        latLng = _latLng;
                        if (widget.onChanged != null) {
                          widget.onChanged!(_latLng);
                        }
                      });
                    })
                  },
                  children: [
                    MarkerLayerWidget(
                      options: MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 30.0,
                            height: 30.0,
                            point: myLatLng,
                            anchorPos: AnchorPos.align(
                              AnchorAlign.top,
                            ),
                            builder: (BuildContext context) => IconButton(
                              tooltip: 'Mi ubicacion actual',
                              icon: const Icon(
                                Icons.person_pin_circle_sharp,
                                color: Colors.blueAccent,
                                size: 30.0,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Marker(
                            width: 50.0,
                            height: 50.0,
                            point: latLng,
                            anchorPos: AnchorPos.align(
                              AnchorAlign.top,
                            ),
                            builder: (BuildContext context) => IconButton(
                              icon: Icon(
                                Icons.location_history,
                                color: Theme.of(context).primaryColor,
                                size: 50.0,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!boolean)
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
        ],
      ),
    );
  }
}

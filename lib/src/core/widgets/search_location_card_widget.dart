import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:pickpointer/src/core/providers/geolocation_provider.dart';
import 'package:pickpointer/src/core/providers/places_provider.dart';
import 'package:pickpointer/src/core/util/debounder_util.dart';
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
  final FormFieldValidator<String>? validator;
  final Function(LatLng)? onChanged;
  final Icon iconMarker;

  const SearchLocationCardWidget({
    Key? key,
    required this.title,
    required this.labelText,
    this.leading,
    this.helperText,
    this.initialValue = false,
    this.initialLatLng,
    this.disabled = false,
    this.validator,
    this.onChanged,
    this.iconMarker = const Icon(
      Icons.location_history,
      size: 50.0,
    ),
  }) : super(key: key);

  @override
  State<SearchLocationCardWidget> createState() =>
      _SearchLocationCardWidgetState();
}

class _SearchLocationCardWidgetState extends State<SearchLocationCardWidget> {
  final MapController mapController = MapController();

  final GeolocatorProvider? geolocatorProvider =
      GeolocatorProvider.getInstance();
  final PlacesProvider? placesProvider = PlacesProvider.getInstance();
  final Debouncer debouncer = Debouncer();
  final TextEditingController textEditingController = TextEditingController();

  bool boolean = false;
  LatLng latLng = LatLng(0, 0);
  LatLng myLatLng = LatLng(0, 0);

  String? errorPlaces;
  List<Prediction> listPrediction = [];

  getPredictions(String string) {
    placesProvider?.getPredictions(string).then(
      (List<Prediction> responseListPrediction) {
        errorPlaces = '';
        if (responseListPrediction.length > 3) {
          setState(() {
            listPrediction = responseListPrediction.sublist(0, 3);
          });
        } else {
          setState(() {
            listPrediction = responseListPrediction.sublist(0, 3);
          });
        }
      },
      onError: (dynamic error) {
        setState(() {
          errorPlaces = error.toString();
        });
      },
    );
  }

  Future<LatLng>? getPlaceDetail(String placeId) {
    Future<LatLng>? futureLatLng =
        placesProvider?.getPlaceDetails(placeId).then(
      (PlacesDetailsResponse placeDetailsResponse) {
        errorPlaces = '';
        LatLng latLng = LatLng(
          placeDetailsResponse.result.geometry!.location.lat,
          placeDetailsResponse.result.geometry!.location.lng,
        );
        return latLng;
      },
      onError: (dynamic error) {
        setState(() {
          errorPlaces = error.toString();
        });
      },
    );
    return futureLatLng;
  }

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
    WidgetsBinding.instance!.addPostFrameCallback((Duration duration) {
      if (widget.initialLatLng?.latitude != 0 &&
          widget.initialLatLng?.longitude != 0) {
        mapController.move(widget.initialLatLng!, 15.0);
      } else {
        moveToMyLocation();
      }
    });
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
                    controller: textEditingController,
                    labelText: widget.labelText,
                    helperText: widget.helperText,
                    onTap: () {
                      textEditingController.text = '';
                    },
                    validator: widget.validator,
                    onChanged: (String? value) {
                      if (value != null && value.length >= 3) {
                        debouncer.run(() {
                          getPredictions(value);
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          if (listPrediction.isNotEmpty == true)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < listPrediction.length; i++)
                  ListTile(
                    leading: widget.leading,
                    title: TextWidget(
                      '${listPrediction[i].description}',
                    ),
                    dense: true,
                    onTap: () {
                      getPlaceDetail('${listPrediction[i].placeId}')?.then(
                        (LatLng? latLng) {
                          if (latLng != null) {
                            WidgetsBinding.instance!
                                .addPostFrameCallback((Duration duration) {
                              mapController.move(latLng, 15.0);
                              setState(() {
                                listPrediction = [];
                                if (widget.onChanged != null) {
                                  widget.onChanged!(latLng);
                                }
                                textEditingController.text =
                                    '${listPrediction[i].description}';
                              });
                            });
                          }
                        },
                      );
                    },
                  ),
              ],
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
                        textEditingController.text =
                            '${latLng.latitude.toStringAsFixed(6)}, ${latLng.longitude.toStringAsFixed(6)}';
                      });
                    })
                  },
                  children: [
                    MarkerLayerWidget(
                      options: MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 20.0,
                            height: 20.0,
                            point: myLatLng,
                            anchorPos: AnchorPos.align(
                              AnchorAlign.top,
                            ),
                            builder: (BuildContext context) => IconButton(
                              tooltip: 'Mi ubicacion actual',
                              icon: Icon(
                                Icons.person_pin_circle_sharp,
                                color: Theme.of(context).primaryColor,
                                size: 20.0,
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
                              iconSize: 50.0,
                              icon: widget.iconMarker,
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

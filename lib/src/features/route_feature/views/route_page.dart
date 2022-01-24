import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:pickpointer/packages/offer_package/data/models/offer_model.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/src/core/helpers/modal_bottom_sheet_helper.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/elevated_button_widget.dart';
import 'package:pickpointer/src/core/widgets/flutter_map_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/future_builder_shimmer_widget.dart';
import 'package:pickpointer/src/core/widgets/safe_area_widget.dart';
import 'package:pickpointer/src/core/widgets/single_child_scroll_view_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';
import 'package:pickpointer/src/features/route_feature/logic/route_controller.dart';
import 'package:pickpointer/src/features/route_feature/views/enums/credit_card_type.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/list_tile_credit_card_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/list_tile_new_credit_card_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/offer_card_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/popup_card_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/route_card_widget.dart';

class RoutePage extends StatefulWidget {
  final String? abstractRouteEntityId;
  final AbstractRouteEntity? abstractRouteEntity;

  const RoutePage(
      {Key? key, this.abstractRouteEntity, this.abstractRouteEntityId})
      : assert(
          abstractRouteEntity != null || abstractRouteEntityId != null,
        ),
        super(key: key);

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  final RouteController routeController = RouteController.instance;
  final MapController mapController = MapController();

  Future<List<LatLng>>? futureListLatLng;
  Future<List<AbstractOfferEntity>>? futureListAbstractOfferEntity;

  CreditCardType creditCardType = CreditCardType.creditCard;

  @override
  void initState() {
    super.initState();
    futureListLatLng = routeController.getPolylineBetweenCoordinates(
      origin: LatLng(
        double.tryParse('${widget.abstractRouteEntity?.startLat}') ?? 0,
        double.tryParse('${widget.abstractRouteEntity?.startLng}') ?? 0,
      ),
      destination: LatLng(
        double.tryParse('${widget.abstractRouteEntity?.endLat}') ?? 0,
        double.tryParse('${widget.abstractRouteEntity?.endLng}') ?? 0,
      ),
    );
    futureListAbstractOfferEntity = routeController.getOffersByRoute(
        routeId: '${widget.abstractRouteEntity?.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(
        title: 'PickPointer + S/. ${widget.abstractRouteEntity?.price}',
        showGoback: true,
      ),
      body: Stack(
        children: [
          FlutterMapWidget(
            bounds: LatLngBounds(
              LatLng(
                double.tryParse('${widget.abstractRouteEntity?.startLat}') ?? 0,
                double.tryParse('${widget.abstractRouteEntity?.startLng}') ?? 0,
              ),
              LatLng(
                double.tryParse('${widget.abstractRouteEntity?.endLat}') ?? 0,
                double.tryParse('${widget.abstractRouteEntity?.endLng}') ?? 0,
              ),
            ),
            children: [
              PopupMarkerLayerWidget(
                options: PopupMarkerLayerOptions(
                  markers: [
                    Marker(
                      key: Key('${widget.abstractRouteEntity?.id}_end'),
                      width: 50,
                      height: 50,
                      anchorPos: AnchorPos.align(
                        AnchorAlign.top,
                      ),
                      point: LatLng(
                        double.tryParse(
                                '${widget.abstractRouteEntity?.endLat}') ??
                            0,
                        double.tryParse(
                                '${widget.abstractRouteEntity?.endLng}') ??
                            0,
                      ),
                      builder: (BuildContext context) => const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                  ],
                  popupBuilder: (BuildContext context, Marker marker) {
                    return PopupCardWidget(
                      message: "Hasta:\n${widget.abstractRouteEntity?.to}",
                      onTap: () {},
                    );
                  },
                ),
              ),
              PopupMarkerLayerWidget(
                options: PopupMarkerLayerOptions(
                  markers: [
                    Marker(
                      key: Key('${widget.abstractRouteEntity?.id}_start'),
                      width: 50,
                      height: 50,
                      anchorPos: AnchorPos.align(
                        AnchorAlign.center,
                      ),
                      point: LatLng(
                        double.tryParse(
                                '${widget.abstractRouteEntity?.startLat}') ??
                            0,
                        double.tryParse(
                                '${widget.abstractRouteEntity?.startLng}') ??
                            0,
                      ),
                      builder: (BuildContext context) => const Icon(
                        Icons.taxi_alert_outlined,
                        color: Colors.blue,
                        size: 50,
                      ),
                    ),
                  ],
                  popupBuilder: (BuildContext context, Marker marker) {
                    return PopupCardWidget(
                      message: "Desde:\n${widget.abstractRouteEntity?.from}",
                      onTap: () {},
                    );
                  },
                ),
              ),
              FutureBuilderShimmerWidget(
                key: const Key('futureListLatLng'),
                future: futureListLatLng,
                initialData: List<LatLng>.from([
                  LatLng(
                    double.tryParse(
                            '${widget.abstractRouteEntity?.startLat}') ??
                        0,
                    double.tryParse(
                            '${widget.abstractRouteEntity?.startLng}') ??
                        0,
                  ),
                  LatLng(
                    double.tryParse('${widget.abstractRouteEntity?.endLat}') ??
                        0,
                    double.tryParse('${widget.abstractRouteEntity?.endLng}') ??
                        0,
                  ),
                ]),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return PolylineLayerWidget(
                    options: PolylineLayerOptions(
                      // ignore: invalid_use_of_protected_member
                      polylines: [
                        Polyline(
                          points: <LatLng>[
                            ...snapshot.data,
                          ],
                          strokeWidth: 5,
                          color: Colors.black,
                          isDotted: true,
                          gradientColors: <Color>[
                            Colors.blue,
                            Colors.red,
                            Colors.red,
                            Colors.red,
                            Colors.red,
                            Colors.red,
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: SafeAreaWidget(
              child: FractionallySizedBoxWidget(
                child: RouteCardWidget(
                  abstractRouteEntity: widget.abstractRouteEntity,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: SafeAreaWidget(
              child: SizedBox(
                height: 300,
                child: FractionallySizedBoxWidget(
                  child: SingleChildScrollViewWidget(
                    child: FutureBuilderShimmerWidget(
                      key: const Key('futureListAbstractOfferEntity'),
                      future: futureListAbstractOfferEntity,
                      initialData: List<AbstractOfferEntity>.from([
                        const OfferModel(
                          id: '...',
                          routeId: '...',
                          count: '...',
                          maxCount: '...',
                          price: '...',
                          userId: '...',
                          userName: '...',
                          userAvatar: '...',
                          userCarPlate: '...',
                          userCarPhoto: '...',
                          userPhoneNumber: '...',
                          userRank: '...',
                        ),
                      ]),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return WrapWidget(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            if (snapshot.hasData && snapshot.data.isNotEmpty)
                              for (final AbstractOfferEntity abstractOfferEntity
                                  in snapshot.data)
                                OfferCardWidget(
                                  abstractOfferEntity: abstractOfferEntity,
                                  onPressed: (abstractOfferEntity) {
                                    ModalBottomSheetHelper(
                                      context: context,
                                      title: 'Pagar viaje',
                                      child: StatefulBuilder(
                                        builder:
                                            (BuildContext context, setState) {
                                          return SingleChildScrollViewWidget(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: WrapWidget(
                                                children: [
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child:
                                                        FractionallySizedBoxWidget(
                                                      child:
                                                          ListTileCreditCardWidget(
                                                        groupValue:
                                                            creditCardType,
                                                        value: CreditCardType
                                                            .creditCard,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            creditCardType = value
                                                                as CreditCardType;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child:
                                                        FractionallySizedBoxWidget(
                                                      child:
                                                          ListTileNewCreditCardWidget(
                                                        groupValue:
                                                            creditCardType,
                                                        value: CreditCardType
                                                            .newCreditCard,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            creditCardType = value
                                                                as CreditCardType;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      childFooter: FractionallySizedBoxWidget(
                                        child: ElevatedButtonWidget(
                                          title: 'Pagar S/. 9.00',
                                          onPressed: () {},
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

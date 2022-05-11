import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/drawer_widget.dart';
import 'package:pickpointer/src/core/widgets/flutter_map_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/linear_progress_indicator_widget.dart';
import 'package:pickpointer/src/core/widgets/safe_area_widget.dart';
import 'package:pickpointer/src/features/order_feature/logic/order_controller.dart';
import 'package:pickpointer/src/features/order_feature/views/widgets/call_card_widget.dart';
import 'package:pickpointer/src/features/order_feature/views/widgets/messages_box_widget.dart';
import 'package:pickpointer/src/features/order_feature/views/widgets/order_card_widget.dart';
import 'package:pickpointer/src/features/order_feature/views/widgets/popup_marker_taxi_widget.dart';

class OrderPage extends StatefulWidget {
  final String? abstractOrderEntityId;
  final AbstractOrderEntity? abstractOrderEntity;

  const OrderPage({
    Key? key,
    this.abstractOrderEntity,
    this.abstractOrderEntityId,
  }) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final OrderController orderController = OrderController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      endDrawer: const DrawerWidget(
        title: 'Mensajes',
        child: MessagesBoxWidget(),
      ),
      endDrawerEnableOpenDragGesture: true,
      appBar: AppBarWidget(
        title: 'Order ${widget.abstractOrderEntity?.id}',
        actions: [
          IconButton(
            tooltip: 'Compartir',
            icon: const Icon(
              Icons.ios_share_rounded,
            ),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'Mensajes',
            icon: const Icon(
              Icons.message_rounded,
            ),
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ],
      ),
      body: Obx(() {
        return Stack(
          children: [
            SizedBox(
              child: FlutterMapWidget(
                mapController: orderController.mapController,
                bounds: orderController.latLngBounds != null
                    ? LatLngBounds(
                        orderController.latLngBounds[0],
                        orderController.latLngBounds[1],
                      )
                    : null,
                children: [
                  PolylineLayerWidget(
                    options: PolylineLayerOptions(
                      // ignore: invalid_use_of_protected_member
                      polylines: [
                        Polyline(
                          points: <LatLng>[
                            ...orderController.polylineTaxiListLatLng.value,
                          ],
                          strokeWidth: 5,
                          color: Colors.blue,
                          isDotted: true,
                        ),
                      ],
                    ),
                  ),
                  PolylineLayerWidget(
                    options: PolylineLayerOptions(
                      // ignore: invalid_use_of_protected_member
                      polylines: [
                        Polyline(
                          points: <LatLng>[
                            ...orderController.polylineListLatLng.value,
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
                  ),
                  MarkerLayerWidget(
                    options: MarkerLayerOptions(
                      markers: [
                        for (var wayPoint
                            in orderController.listWayPoints.value)
                          Marker(
                            width: 20,
                            height: 20,
                            anchorPos: AnchorPos.align(
                              AnchorAlign.top,
                            ),
                            point: wayPoint,
                            builder: (BuildContext context) => Icon(
                              Icons.person_pin,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
                  PopupMarkerLayerWidget(
                    options: PopupMarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 50,
                          height: 50,
                          anchorPos: AnchorPos.align(
                            AnchorAlign.center,
                          ),
                          point: orderController.positionTaxi.value,
                          builder: (BuildContext context) => Icon(
                            Icons.local_taxi_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 50,
                          ),
                        ),
                        Marker(
                          width: 50,
                          height: 50,
                          anchorPos: AnchorPos.align(
                            AnchorAlign.top,
                          ),
                          point: orderController.pickPoint.value,
                          builder: (BuildContext context) => const Icon(
                            Icons.person_pin_circle_sharp,
                            color: Colors.blue,
                            size: 50,
                          ),
                        ),
                      ],
                      popupBuilder: (BuildContext context, Marker marker) {
                        return PopupMarkerTaxiWidget(
                          meters: orderController.distanceTaxi.value,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (orderController.isLoading.value)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicatorWidget(),
              ),
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: SafeAreaWidget(
                child: FractionallySizedBoxWidget(
                  child: OrderCardWidget(
                    abstractOrderEntity: widget.abstractOrderEntity,
                  ),
                ),
              ),
            ),
            const Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: SafeAreaWidget(
                child: FractionallySizedBoxWidget(
                  child: CallCardWidget(),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

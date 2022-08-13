import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/src/app.dart';
import 'package:pickpointer/src/core/helpers/launcher_link_helper.dart';
import 'package:pickpointer/src/core/helpers/modal_bottom_sheet_helper.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/drawer_widget.dart';
import 'package:pickpointer/src/core/widgets/elevated_button_widget.dart';
import 'package:pickpointer/src/core/widgets/flutter_map_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/linear_progress_indicator_widget.dart';
import 'package:pickpointer/src/core/widgets/safe_area_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';
import 'package:pickpointer/src/features/order_feature/logic/order_controller.dart';
import 'package:pickpointer/src/features/order_feature/views/widgets/call_card_widget.dart';
import 'package:pickpointer/src/features/order_feature/views/widgets/messages_box_widget.dart';
import 'package:pickpointer/src/features/order_feature/views/widgets/order_card_widget.dart';
import 'package:pickpointer/src/features/order_feature/views/widgets/popup_marker_taxi_widget.dart';
import 'package:pickpointer/src/features/route_feature/logic/routes_controller.dart';
import 'package:pickpointer/src/features/route_feature/views/routes_page.dart';

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
  final OrderController orderController = OrderController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          key: orderController.scaffoldKey,
          resizeToAvoidBottomInset: true,
          endDrawer: const DrawerWidget(
            title: 'Mensajes',
            child: MessagesBoxWidget(),
          ),
          endDrawerEnableOpenDragGesture: true,
          appBar: AppBarWidget(
            title: 'Orden ${orderController.orderId.value}',
            actions: [
              IconButton(
                tooltip: 'Refrescar',
                icon: const Icon(
                  Icons.refresh_rounded,
                ),
                onPressed: () => orderController.refreshOrder(),
              ),
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
                  orderController.scaffoldKey.currentState!.openEndDrawer();
                },
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Salir a VER RUTAS"),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    ModalBottomSheetHelper(
                      context: context,
                      title: 'Salir a VER RUTAS',
                      child: SizedBox(
                        width: double.infinity,
                        child: FractionallySizedBoxWidget(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: WrapWidget(
                              children: [
                                TextWidget(
                                  '¿Estás seguro de que deseas salir del viaje actual?',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                TextWidget(
                                  'Si sales el viaje continuará en curso hasta que el conductor llegue al destino.\n Ademas no podras volver a esta vista.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                ElevatedButtonWidget(
                                  title: 'Confirmar',
                                  onPressed: () {
                                    orderController
                                        .finishTrip()
                                        .then((bool value) {
                                      if (value) {
                                        Get.offAll(
                                          () => const RoutesPage(),
                                        );
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              SizedBox(
                child: FlutterMapWidget(
                  mapController: orderController.mapController,
                  bounds: (orderController.taxiPosition.value != null &&
                          orderController.userPickPoint.value != null)
                      ? LatLngBounds(
                          orderController.taxiPosition.value,
                          orderController.userPickPoint.value,
                        )
                      : null,
                  children: [
                    PolylineLayerWidget(
                      options: PolylineLayerOptions(
                        polylines: [
                          Polyline(
                            points: <LatLng>[
                              orderController.taxiPosition.value,
                              orderController.userPosition.value,
                            ],
                            strokeWidth: 5,
                            color: Colors.purple,
                            isDotted: true,
                          ),
                        ],
                      ),
                    ),
                    PolylineLayerWidget(
                      options: PolylineLayerOptions(
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
                              width: 10,
                              height: 10,
                              anchorPos: AnchorPos.align(AnchorAlign.center),
                              point: wayPoint,
                              builder: (BuildContext context) => Icon(
                                Icons.circle,
                                color: Theme.of(context).primaryColor,
                                size: 10,
                              ),
                            ),
                        ],
                      ),
                    ),
                    PopupMarkerLayerWidget(
                      options: PopupMarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 30,
                            height: 30,
                            anchorPos: AnchorPos.align(AnchorAlign.center),
                            point: orderController.userPosition.value,
                            builder: (BuildContext context) => const Icon(
                              Icons.adjust_rounded,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ),
                          Marker(
                            width: 50,
                            height: 50,
                            anchorPos: AnchorPos.align(
                              AnchorAlign.center,
                            ),
                            point: orderController.taxiPosition.value,
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
                            point: orderController.userPickPoint.value,
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
                      routeTo: orderController.routeTo.value,
                      routeFrom: orderController.routeFrom.value,
                      userPickPointLat: orderController.userPickPointLat.value,
                      userPickPointLng: orderController.userPickPointLng.value,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: SafeAreaWidget(
                  child: FractionallySizedBoxWidget(
                    child: CallCardWidget(
                        avatarUrl: orderController.driverAvatar.value,
                        name: orderController.driverName.value,
                        carPhoto: orderController.driverCarPhoto.value,
                        carModel: orderController.driverCarModel.value,
                        carPlate: orderController.driverCarPlate.value,
                        onPressed: () {
                          LauncherLinkHelper launcherLinkHelper =
                              LauncherLinkHelper(
                            url: orderController.driverPhoneNumber.value,
                            isPhone: true,
                          );
                          launcherLinkHelper.makePhoneCall();
                        }),
                  ),
                ),
              ),
            ],
          ));
    });
  }
}

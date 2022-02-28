import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pickpointer/packages/order_package/domain/entities/abstract_order_entity.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/flutter_map_widget.dart';
import 'package:pickpointer/src/core/widgets/linear_progress_indicator_widget.dart';
import 'package:pickpointer/src/features/order_feature/logic/order_controller.dart';

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
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const AppBarWidget(
        title: 'Order 12383722',
      ),
      body: Obx(() {
        return Stack(
          children: [
            SizedBox(
              child: FlutterMapWidget(
                mapController: mapController,
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
                            ...orderController.polylineListLatLng.value,
                          ],
                          strokeWidth: 5,
                          color: Colors.blue,
                          isDotted: true,
                        ),
                      ],
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
          ],
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pickpointer/packages/route_package/data/models/route_model.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/future_builder_shimmer_widget.dart';
import 'package:pickpointer/src/core/widgets/scaffold_widget.dart';
import 'package:pickpointer/src/features/route_feature/logic/route_controller.dart';

class RoutesPage extends StatelessWidget {
  final RouteController routeController = RouteController.instance;

  RoutesPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: const AppBarWidget(
        title: 'Routes',
      ),
      body: Obx(() {
        Future<List<AbstractRouteEntity>> futureListAbstractRouteEntity =
            routeController.futureListAbstractRouteEntity.value;
        return FutureBuilderShimmerWidget(
            key: key,
            future: futureListAbstractRouteEntity,
            initialData: List<AbstractRouteEntity>.from([
              const RouteModel(
                id: '...',
                description: '...',
              ),
            ]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List<AbstractRouteEntity> listAbstractRouteEntity = snapshot.data;
              return ListView.builder(
                itemCount: listAbstractRouteEntity.length,
                itemBuilder: (BuildContext context, int index) {
                  AbstractRouteEntity abstractRouteEntity =
                      listAbstractRouteEntity[index];
                  return ListTile(
                    title: Text('${abstractRouteEntity.description}'),
                  );
                },
              );
            });
      }),
    );
  }
}

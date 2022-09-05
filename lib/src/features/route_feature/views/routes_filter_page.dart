import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/scaffold_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';
import 'package:pickpointer/src/features/route_feature/logic/routes_filter_controller.dart';
import 'package:pickpointer/src/features/route_feature/views/route_page.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/route_item_card_widget.dart';

class RoutesFilterPage extends StatelessWidget {
  const RoutesFilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RoutesFilterController routesFilterController =
        RoutesFilterController.instance;
    return Obx(() {
      return ScaffoldWidget(
        appBar: const AppBarWidget(
          title: 'Filtrar rutas',
          showGoback: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: WrapWidget(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    for (var abstractRouteEntity
                        in routesFilterController.filteredRoutes.value)
                      SizedBox(
                        width: double.infinity,
                        child: FractionallySizedBoxWidget(
                          child: RouteItemCardWidget(
                            onTap: () {
                              Get.to(
                                () => RoutePage(
                                  abstractRouteEntity: abstractRouteEntity,
                                ),
                                arguments: {
                                  'abstractRouteEntity': abstractRouteEntity,
                                },
                              );
                            },
                            abstractRouteEntity: abstractRouteEntity,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  child: FractionallySizedBoxWidget(
                    child: WrapWidget(
                      children: [
                        TextFieldWidget(
                          labelText: 'Destino',
                          onChanged: (String string) {
                            routesFilterController.filterToRoutes(string);
                          },
                        ),
                        TextFieldWidget(
                          labelText: 'Origen',
                          onChanged: (String string) {
                            routesFilterController.filterFromRoutes(string);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

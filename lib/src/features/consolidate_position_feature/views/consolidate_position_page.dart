import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickpointer/packages/offer_package/data/models/offer_model.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/src/core/helpers/launcher_link_helper.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/getx_snackbar_widget.dart';
import 'package:pickpointer/src/core/widgets/outline_button_widget.dart';
import 'package:pickpointer/src/core/widgets/safe_area_widget.dart';
import 'package:pickpointer/src/core/widgets/scaffold_widget.dart';
import 'package:pickpointer/src/core/widgets/single_child_scroll_view_widget.dart';
import 'package:pickpointer/src/core/widgets/text_button_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';
import 'package:pickpointer/src/features/consolidate_position_feature/logic/consolidate_position_controller.dart';
import 'package:pickpointer/src/features/consolidate_position_feature/views/widgets/stack_offer_card_widget.dart';
import 'package:pickpointer/src/features/payment_feature/views/payment_page.dart';
import 'package:pickpointer/src/features/route_feature/views/new_route_page.dart';
import 'package:pickpointer/src/features/route_feature/views/route_page.dart';
import 'package:pickpointer/src/features/route_feature/views/widgets/route_item_card_widget.dart';
import 'package:pickpointer/src/features/user_feature/views/sign_in_user_page.dart';
import 'package:pickpointer/src/features/user_feature/views/user_page.dart';
// TODO: Show Offer by card ordered by lastOne, and under set a section with a list of all routes.
// Prepare a card for offers and routes.

class ConsolidatePositionPage extends StatefulWidget {
  const ConsolidatePositionPage({Key? key}) : super(key: key);

  @override
  State<ConsolidatePositionPage> createState() =>
      _ConsolidatePositionPageState();
}

class _ConsolidatePositionPageState extends State<ConsolidatePositionPage> {
  final ConsolidatePositionController consolidatePositionController =
      ConsolidatePositionController.instance;

  Future<void> onTapOffer(AbstractOfferEntity abstractOfferEntity) async {
    await consolidatePositionController.verifySession();
    if (consolidatePositionController.isSigned.value) {
      if (consolidatePositionController.isPhoneVerified.value == false) {
        GetxSnackbarWidget(
          title: 'VERIFICA TU NUMERO DE CELULAR',
          subtitle: 'Por favor agrega y verifica tu número de dispositivo.',
        );
        Get.to(
          () => const UserPage(),
          arguments: {},
        );
      } else {
        Get.to(
          () => PaymentPage(
            abstractOfferEntity: abstractOfferEntity,
          ),
          arguments: {
            'abstractOfferEntity': abstractOfferEntity,
          },
        );
      }
    } else {
      Get.to(
        () => const SignInUserPage(),
      );
    }
  }

  void onTapOfferRoute(String? routeId) {
    Get.to(
      () => RoutePage(
        abstractRouteEntityId: routeId,
      ),
      arguments: {
        'abstractRouteEntityId': routeId,
      },
    );
  }

  void onTapRoute(AbstractRouteEntity abstractRouteEntity) {
    Get.to(
      () => RoutePage(
        abstractRouteEntity: abstractRouteEntity,
      ),
      arguments: {
        'abstractRouteEntity': abstractRouteEntity,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SafeAreaWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollViewWidget(
                child: FractionallySizedBoxWidget(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: WrapWidget(
                      children: [
                        if (consolidatePositionController
                            .mapStringListAbstractOfferEntity.value.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  'Ofertas disponibles',
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.left,
                                ),
                                TextWidget(
                                  'Estos vehiculos estan disponibles para viajar',
                                  style: Theme.of(context).textTheme.caption,
                                  textAlign: TextAlign.left,
                                )
                              ],
                            ),
                          ),
                        if (consolidatePositionController.isFiltered.value)
                          for (var listAbstractOfferEntity
                              in consolidatePositionController
                                  .filteredOffers.value.values)
                            StackOfferCardWidget(
                              listAbstractOfferEntity: listAbstractOfferEntity,
                              onTap: onTapOffer,
                              onTapRoute: onTapOfferRoute,
                            )
                        else if (consolidatePositionController
                            .mapStringListAbstractOfferEntity.value.isNotEmpty)
                          for (var listAbstractOfferEntity
                              in consolidatePositionController
                                  .mapStringListAbstractOfferEntity
                                  .value
                                  .values)
                            StackOfferCardWidget(
                              listAbstractOfferEntity: listAbstractOfferEntity,
                              onTap: onTapOffer,
                              onTapRoute: onTapOfferRoute,
                            ),
                        if (consolidatePositionController
                            .listAbstractRouteEntity.value.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  'Rutas disponibles',
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.left,
                                ),
                                TextWidget(
                                  'Estas son paraderos fisicos a los cuales puedes acudir y encontrar autos para la ruta',
                                  style: Theme.of(context).textTheme.caption,
                                  textAlign: TextAlign.left,
                                )
                              ],
                            ),
                          ),
                        if (consolidatePositionController.isFiltered.value)
                          for (var abstractRouteEntity
                              in consolidatePositionController
                                  .filteredRoutes.value)
                            RouteItemCardWidget(
                              abstractRouteEntity: abstractRouteEntity,
                              onTap: onTapRoute,
                            )
                        else
                          for (var abstractRouteEntity
                              in consolidatePositionController
                                  .listAbstractRouteEntity.value)
                            RouteItemCardWidget(
                              abstractRouteEntity: abstractRouteEntity,
                              onTap: onTapRoute,
                            ),
                        // if (routesController.isDriver.value == true)
                        SizedBox(
                          width: double.infinity,
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                child: TextWidget(
                                  '¿No encuentras tu ruta?',
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                child: OutlinedButtonWidget(
                                  title: 'Solicitar ruta',
                                  onPressed: () {
                                    Get.to(
                                      () => const NewRoutePage(),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextButtonWidget(
                            title: 'Hecho con ❤️＆🧠 por PickPointer.com',
                            onPressed: () {
                              LauncherLinkHelper launcherLinkHelper =
                                  LauncherLinkHelper(
                                url: 'https://pickpointer.com/',
                              );
                              launcherLinkHelper.launchInBrowser();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FractionallySizedBoxWidget(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: TextFieldWidget(
                    labelText: 'Buscar destino',
                    onChanged: (String destain) {
                      consolidatePositionController.onFilterDestain(destain);
                    },
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

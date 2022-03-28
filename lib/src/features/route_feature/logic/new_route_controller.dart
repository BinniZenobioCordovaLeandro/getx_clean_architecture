import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:pickpointer/packages/route_package/data/datasources/route_datasources/firebase_route_datasource.dart';
import 'package:pickpointer/packages/route_package/data/models/route_model.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/route_package/domain/usecases/add_request_usecase.dart';
import 'package:pickpointer/src/core/providers/notification_provider.dart';

class NewRouteController extends GetxController {
  static NewRouteController get instance => Get.put(NewRouteController());

  final NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  var startPosition = LatLng(0, 0).obs;
  var endPosition = LatLng(0, 0).obs;
  var price = ''.obs;
  var title = ''.obs;
  var description = ''.obs;

  AddRequestRouteUsecase addRequestRouteUsecase = AddRequestRouteUsecase(
    abstractRouteRepository: FirebaseRouteDatasource(),
  );

  Future<bool>? addRequestRoute(AbstractRouteEntity abstractRouteEntity) {
    isLoading.value = true;
    Future<bool>? futureBool = addRequestRouteUsecase
        .call(
      abstractRouteEntity: abstractRouteEntity,
    )
        ?.then((abstractRouteEntity) {
      isLoading.value = false;
      return true;
    });
    return futureBool;
  }

  Future<bool>? sendNotification() {
    Future<bool>? futureBool = notificationProvider
        ?.sendNotification(
          title: 'Solicitud enviada con exito',
          body: 'Su solicitud de ruta ha sido enviada con exito',
        )
        .then((value) => value);
    return futureBool;
  }

  void onSubmit() {
    bool isValidForm = formKey.currentState!.validate();
    if (isValidForm) {
      AbstractRouteEntity abstractRouteEntity = RouteModel(
        startLat: startPosition.value.latitude.toString(),
        startLng: startPosition.value.longitude.toString(),
        endLat: endPosition.value.latitude.toString(),
        endLng: endPosition.value.longitude.toString(),
        price: price.value,
        title: title.value,
        description: description.value,
      );
      addRequestRoute(abstractRouteEntity)?.then((bool boolean) {
        if (boolean) {
          sendNotification();
          Get.back();
        }
      });
    }
  }
}

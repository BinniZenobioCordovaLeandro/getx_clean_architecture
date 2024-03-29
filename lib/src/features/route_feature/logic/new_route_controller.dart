import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:pickpointer/packages/route_package/data/datasources/route_datasources/firebase_route_datasource.dart';
import 'package:pickpointer/packages/route_package/data/models/route_model.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/route_package/domain/usecases/add_request_usecase.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_firebase_session_datasource.dart';
import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/verify_session_usecase.dart';
import 'package:pickpointer/src/core/providers/notification_provider.dart';
import 'package:pickpointer/src/core/widgets/getx_snackbar_widget.dart';
import 'package:uuid/uuid.dart';

class NewRouteController extends GetxController {
  static NewRouteController get instance => Get.put(NewRouteController());

  final Uuid _uuid = const Uuid();
  final NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  var startPosition = LatLng(0, 0).obs;
  var endPosition = LatLng(0, 0).obs;
  var price = 0.0.obs;
  var from = ''.obs;
  var to = ''.obs;

  var origin = ''.obs;
  var destain = ''.obs;

  final VerifySessionUsecase _verifySessionUsecase = VerifySessionUsecase(
    abstractSessionRepository: SharedPreferencesFirebaseSessionDatasources(),
  );

  final AddRequestRouteUsecase _addRequestRouteUsecase = AddRequestRouteUsecase(
    abstractRouteRepository: FirebaseRouteDatasource(),
  );

  Future<bool>? addRequestRoute(
      AbstractRouteEntity abstractRouteEntity, String userId) {
    isLoading.value = true;
    Future<bool>? futureBool = _addRequestRouteUsecase
        .call(
      abstractRouteEntity: abstractRouteEntity,
      userId: userId,
    )
        ?.then((abstractRouteEntity) {
      isLoading.value = false;
      return true;
    });
    return futureBool;
  }

  Future<bool>? sendNotification() {
    Future<bool>? futureBool = notificationProvider
        ?.sendLocalNotification(
          title: 'Solicitud enviada con exito',
          body:
              'Estamos revisando la informacion proporcionada, y te notificaremos al aprobarla.',
        )
        .then((value) => value);
    return futureBool;
  }

  void onSubmit() {
    bool isValidForm = formKey.currentState!.validate();
    if (isValidForm) {
      AbstractRouteEntity abstractRouteEntity = RouteModel(
        id: _uuid.v1(),
        from: from.value,
        startLat: startPosition.value.latitude.toString(),
        startLng: startPosition.value.longitude.toString(),
        to: to.value,
        endLat: endPosition.value.latitude.toString(),
        endLng: endPosition.value.longitude.toString(),
        price: price.value,
        title: 'De ${origin.value} hasta ${destain.value}',
        description: 'Desde ${from.value}, hasta ${to.value}',
      );
      _verifySessionUsecase
          .call()
          .then((AbstractSessionEntity abstractSessionEntity) {
        if (abstractSessionEntity.isSigned!) {
          addRequestRoute(abstractRouteEntity, abstractSessionEntity.idUsers!)
              ?.then((bool boolean) {
            if (boolean) {
              sendNotification();
              formKey.currentState!.reset();
              Get.back();
              GetxSnackbarWidget(
                title: 'SOLICITUD ENVIADA!',
                subtitle:
                    'Estamos revisando tu solicitud, la aprobaremos lo antes posible.',
              );
            }
          });
        }
      });
    }
  }
}

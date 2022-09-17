import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickpointer/packages/offer_package/data/datasources/offer_datasources/firebase_offer_datasource.dart';
import 'package:pickpointer/packages/offer_package/data/models/offer_model.dart';
import 'package:pickpointer/packages/offer_package/domain/entities/abstract_offer_entity.dart';
import 'package:pickpointer/packages/offer_package/domain/usecases/add_offer_usecase.dart';
import 'package:pickpointer/packages/route_package/domain/entities/abstract_route_entity.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_firebase_session_datasource.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_session_datasource.dart';
import 'package:pickpointer/packages/session_package/data/models/session_model.dart';
import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/update_session_usecase.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/verify_session_usecase.dart';
import 'package:pickpointer/packages/user_package/data/datasources/user_datasource.dart/firebase_user_datasource.dart';
import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';
import 'package:pickpointer/packages/user_package/domain/usecases/get_user_usecase.dart';
import 'package:pickpointer/src/core/providers/firebase_notification_provider.dart';
import 'package:pickpointer/src/core/providers/notification_provider.dart';
import 'package:pickpointer/src/core/widgets/getx_snackbar_widget.dart';
import 'package:pickpointer/src/features/offer_feature/views/offer_page.dart';
import 'package:uuid/uuid.dart';

class NewOfferController extends GetxController {
  static NewOfferController get instance => Get.put(NewOfferController());

  final Uuid _uuid = const Uuid();

  final NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();

  final FirebaseNotificationProvider? firebaseNotificationProvider =
      FirebaseNotificationProvider.getInstance();

  final VerifySessionUsecase _verifySessionUsecase = VerifySessionUsecase(
    abstractSessionRepository: SharedPreferencesSessionDatasources(),
  );

  final UpdateSessionUsecase _updateSessionUsecase = UpdateSessionUsecase(
    abstractSessionRepository: SharedPreferencesFirebaseSessionDatasources(),
  );

  final AddOfferUsecase _addOfferUsecase = AddOfferUsecase(
    abstractOfferRepository: FirebaseOfferDatasource(),
  );

  final GetUserUsecase _getUserUsecase = GetUserUsecase(
    abstractUserRepository: FirebaseUserDatasource(),
  );

  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  var maxCount = 0.obs;
  var price = 0.0.obs;
  var showImmediately = false.obs;

  Future<bool>? sendLocalNotification({
    required AbstractRouteEntity abstractRouteEntity,
  }) {
    Future<bool>? futureBool = notificationProvider
        ?.sendLocalNotification(
          title: 'Oferta registrada, destino "${abstractRouteEntity.to}"',
          body:
              'Ahora eres visible para los usuarios en esta ruta:\nDestino: ${abstractRouteEntity.to}\nOrigen: ${abstractRouteEntity.from}',
        )
        .then((value) => value);
    return futureBool;
  }

  Future<bool>? sendNotificationToRouteTopic({
    required AbstractOfferEntity abstractOfferEntity,
  }) {
    Future<bool>? futureBool = firebaseNotificationProvider!.sendMessageToTopic(
      topic: 'route_${abstractOfferEntity.routeId}',
      title:
          'S/. ${abstractOfferEntity.price?.toStringAsFixed(2)} => ${abstractOfferEntity.routeTitle}',
      body:
          'Viaja a ${abstractOfferEntity.routeTo} por solo S/.${abstractOfferEntity.price?.toStringAsFixed(2)}!',
      link: '/route/${abstractOfferEntity.routeId}',
    )..then((value) => value);
    return futureBool;
  }

  void onSumbit({
    required AbstractRouteEntity abstractRouteEntity,
  }) {
    bool isValidForm = formKey.currentState!.validate();
    if (isValidForm) {
      isLoading.value = true;
      _verifySessionUsecase
          .call()
          .then((AbstractSessionEntity abstractSessionEntity) {
        if (abstractSessionEntity.isSigned!) {
          _getUserUsecase
              .call(userId: abstractSessionEntity.idUsers!)!
              .then((AbstractUserEntity abstractUserEntity) {
            if (abstractUserEntity.isDriver == '1') {
              AbstractOfferEntity abstractOfferEntity = OfferModel(
                id: _uuid.v1(),
                count: 0,
                maxCount: maxCount.value,
                price: price.value,
                startLat: abstractRouteEntity.startLat,
                startLng: abstractRouteEntity.startLng,
                endLat: abstractRouteEntity.endLat,
                endLng: abstractRouteEntity.endLng,
                wayPoints: '[]',
                orders: '[]',
                stateId: '-1',
                stateDescription:
                    'Esperando', // STATUS // Esperando -1, enCarretera 2 , Completado 1, Cancelado 0
                userId: abstractSessionEntity.idUsers,
                userName: abstractUserEntity.name,
                userEmail: abstractUserEntity.email,
                userAvatar: abstractUserEntity.avatar,
                userCarPlate: abstractUserEntity.carPlate,
                userCarPhoto: abstractUserEntity.carPhoto,
                userCarModel: abstractUserEntity.carModel,
                userCarColor: abstractUserEntity.carColor,
                userPhoneNumber: abstractUserEntity.phoneNumber,
                userRank: abstractUserEntity.rank,
                userTokenMessaging: abstractSessionEntity.tokenMessaging,
                routeId: abstractRouteEntity.id,
                routeTitle: abstractRouteEntity.title,
                routeDescription: abstractRouteEntity.description,
                routePrice: abstractRouteEntity.price,
                routeFrom: abstractRouteEntity.from,
                routeTo: abstractRouteEntity.to,
                routeStartLat: abstractRouteEntity.startLat,
                routeStartLng: abstractRouteEntity.startLng,
                routeEndLat: abstractRouteEntity.endLat,
                routeEndLng: abstractRouteEntity.endLng,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
                createdAt: DateTime.now().millisecondsSinceEpoch,
              );
              _addOfferUsecase
                  .call(abstractOfferEntity: abstractOfferEntity)!
                  .then((AbstractOfferEntity abstractOfferEntity) {
                isLoading.value = false;
                formKey.currentState!.reset();
                sendLocalNotification(
                  abstractRouteEntity: abstractRouteEntity,
                );
                _updateSessionUsecase
                    .call(
                  abstractSessionEntity:
                      (abstractSessionEntity as SessionModel).copyWith(
                    onRoad: true,
                    currentOfferId: abstractOfferEntity.id,
                  ),
                )
                    .then((AbstractSessionEntity savedAbstractSessionEntity) {
                  if (savedAbstractSessionEntity.onRoad == true) {
                    GetxSnackbarWidget(
                      title: 'TU OFERTA ES AHORA VISIBLE!',
                      subtitle:
                          'Espera a completar los ${abstractOfferEntity.maxCount} pasajeros, o inicia manualmente con los que tengas.',
                      duration: const Duration(seconds: 15),
                    );
                    sendNotificationToRouteTopic(
                        abstractOfferEntity: abstractOfferEntity);
                    Get.offAll(
                      () => OfferPage(
                        abstractOfferEntity: abstractOfferEntity,
                      ),
                      arguments: {
                        'abstractOfferEntity': abstractOfferEntity,
                      },
                    );
                  } else {
                    isLoading.value = false;
                  }
                });
              });
            }
          });
        } else {
          isLoading.value = false;
        }
      }).catchError((error) {
        isLoading.value = false;
      });
    }
  }
}

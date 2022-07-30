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
import 'package:pickpointer/src/core/providers/notification_provider.dart';
import 'package:pickpointer/src/features/offer_feature/views/offer_page.dart';
import 'package:uuid/uuid.dart';

class NewOfferController extends GetxController {
  static NewOfferController get instance => Get.put(NewOfferController());

  final Uuid _uuid = const Uuid();
  final NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  var maxCount = 0.obs;
  var price = 0.0.obs;

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

  Future<bool>? sendNotification({
    required AbstractRouteEntity abstractRouteEntity,
  }) {
    Future<bool>? futureBool = notificationProvider
        ?.sendNotification(
          title: 'Oferta registrada, destino "${abstractRouteEntity.to}"',
          body:
              'Ahora eres visible para los usuarios en esta ruta:\nDestino: ${abstractRouteEntity.to}\nOrigen: ${abstractRouteEntity.from}',
        )
        .then((value) => value);
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
                wayPoints:
                    '["-12.114398419240583, -76.87099057482455", "-12.100091477862088, -76.86953248267001", "-12.084886779107038, -76.8750718551892"]',
                orders:
                    '[{"userId":"3cacsAS21312321","orderId":"ascasASCSVAS23312","userToken":"ASCASVAS1wewq122","fullName":"Abel Rocksnamas","avatar":"https://upload.wikimedia.org/wikipedia/commons/f/f4/User_Avatar_2.png","lat":"-12.114398419240583","lng":"-76.87099057482455"},{"userId":"3cacsAS21312321","orderId":"ascasASCSVAS23312","userToken":"ASCASVAS1wewq122","fullName":"Borrir Docs Gamers","avatar":"https://upload.wikimedia.org/wikipedia/commons/f/f4/User_Avatar_2.png","lat":"-12.100091477862088","lng":"-76.86953248267001"},{"userId":"3cacsAS21312321","orderId":"ascasASCSVAS23312","userToken":"ASCASVAS1wewq122","fullName":"Donkey Kong","avatar":"https://upload.wikimedia.org/wikipedia/commons/f/f4/User_Avatar_2.png","lat":"-12.084886779107038","lng":"-76.8750718551892"}]',
                stateId: '-1',
                stateDescription:
                    'Esperando', // Esperando -1, enCarretera 0 , Completado 1, Cancelado 2
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
                sendNotification(
                  abstractRouteEntity: abstractRouteEntity,
                );
                _updateSessionUsecase.call(
                  abstractSessionEntity:
                      (abstractSessionEntity as SessionModel).copyWith(
                    onRoad: true,
                    currentOfferId: abstractOfferEntity.id,
                  ),
                );
                Get.to(
                  () => OfferPage(
                    abstractOfferEntity: abstractOfferEntity,
                  ),
                  arguments: {
                    'abstractOfferEntity': abstractOfferEntity,
                  },
                );
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

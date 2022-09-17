import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_firebase_session_datasource.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_session_datasource.dart';
import 'package:pickpointer/packages/session_package/data/models/session_model.dart';
import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/update_session_usecase.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/verify_session_usecase.dart';
import 'package:pickpointer/packages/user_package/data/datasources/user_datasource.dart/firebase_user_datasource.dart';
import 'package:pickpointer/packages/user_package/data/models/user_model.dart';
import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';
import 'package:pickpointer/packages/user_package/domain/usecases/get_user_usecase.dart';
import 'package:pickpointer/packages/user_package/domain/usecases/update_user_usecase.dart';
import 'package:pickpointer/src/core/providers/firebase_authentication_provider.dart';
import 'package:pickpointer/src/core/providers/firebase_notification_provider.dart';
import 'package:pickpointer/src/core/providers/storage_provider.dart';
import 'package:pickpointer/src/core/widgets/getx_snackbar_widget.dart';
import 'package:pickpointer/src/features/route_feature/views/routes_page.dart';

class UserController extends GetxController {
  static UserController get instance => Get.put(UserController());

  final StorageProvider? storageProvider = StorageProvider.getInstance();

  final FirebaseNotificationProvider? firebaseNotificationProvider =
      FirebaseNotificationProvider.getInstance();

  final FirebaseAuthenticationProvider? firebaseAuthenticationProvider =
      FirebaseAuthenticationProvider.getInstance();

  final formKey = GlobalKey<FormState>();
  final formCodeKey = GlobalKey<FormState>();

  var isLoadingData = false.obs;
  var errorMessage = ''.obs;
  var isLoadingSave = false.obs;

  var userId = ''.obs;
  var name = ''.obs;
  var email = ''.obs;
  var avatar = ''.obs;
  var document = ''.obs;
  var carPlate = ''.obs;
  var carPhoto = ''.obs;
  var carModel = ''.obs;
  var carColor = ''.obs;
  var phoneNumber = ''.obs;
  var phoneCode = ''.obs;
  var rank = 5.0.obs;
  var isDriver = false.obs;
  var isDriverVerified = false.obs;
  var policies = false.obs;

  final VerifySessionUsecase _verifySessionUsecase = VerifySessionUsecase(
    abstractSessionRepository: SharedPreferencesFirebaseSessionDatasources(),
  );

  final UpdateSessionUsecase _updateSessionUsecase = UpdateSessionUsecase(
    abstractSessionRepository: SharedPreferencesFirebaseSessionDatasources(),
  );

  final UpdateUserUsecase _updateUserUsecase = UpdateUserUsecase(
    abstractUserRepository: FirebaseUserDatasource(),
  );

  final GetUserUsecase _getUserUsecase = GetUserUsecase(
    abstractUserRepository: FirebaseUserDatasource(),
  );

  getUserData() {
    isLoadingData.value = true;
    _verifySessionUsecase.call().then((abstractSessionEntity) {
      if (abstractSessionEntity.isSigned!) {
        _getUserUsecase
            .call(userId: abstractSessionEntity.idUsers!)!
            .then((AbstractUserEntity abstractUserEntity) => {
                  userId.value = abstractSessionEntity.idUsers!,
                  name.value = abstractUserEntity.name ?? '',
                  email.value = abstractUserEntity.email ?? '',
                  avatar.value = abstractUserEntity.avatar ?? '',
                  document.value = abstractUserEntity.document ?? '',
                  carPlate.value = abstractUserEntity.carPlate ?? '',
                  carPhoto.value = abstractUserEntity.carPhoto ?? '',
                  carModel.value = abstractUserEntity.carModel ?? '',
                  carColor.value = abstractUserEntity.carColor ?? '',
                  phoneNumber.value = abstractUserEntity.phoneNumber ?? '',
                  rank.value = double.parse(abstractUserEntity.rank ?? '5.0'),
                  isDriver.value = abstractUserEntity.isDriver == '1' ||
                      abstractUserEntity.isDriver == '2',
                  isDriverVerified.value = abstractUserEntity.isDriver == '1',
                  formKey.currentState?.validate(),
                  isLoadingData.value = false,
                });
      } else {
        isLoadingData.value = false;
      }
    });
  }

  Future<String> filePathNormalizer(
    String? path, {
    String? name,
  }) async {
    RegExp regExpHttp = RegExp('^http');
    if (path != null && !regExpHttp.hasMatch(path)) {
      String? urlPath = await storageProvider?.putFileFromPath(
        path,
        directory: userId.value,
        name: name,
      );
      return urlPath as String;
    }
    return path as String;
  }

  verifyCode({
    required String smsCode,
  }) {
    isLoadingSave.value = true;
    errorMessage.value = '';
    firebaseAuthenticationProvider!
        .verifyPhoneAuth(smsCode: smsCode)
        .then((String? user) {
      if (user != null) {
        updateUserData();
      } else {
        isLoadingSave.value = false;
      }
    }).catchError((error) {
      errorMessage.value =
          'El CODIGO no es valido, verifica tu número ${phoneNumber.value}, o intenta más tarde.';
      isLoadingSave.value = false;
    });
  }

  Future<bool?> sendVerificationCode({
    required String phoneNumber,
  }) {
    isLoadingSave.value = true;
    Future<bool> futureBool = firebaseAuthenticationProvider!
        .sendPhoneAuth(
            phoneNumber: phoneNumber,
            onError: (String? identifier) {
              switch (identifier) {
                case 'invalid-phone-number':
                  errorMessage.value =
                      'Ingresaste un número de telefono no valido.';
                  break;
                case 'missing-client-identifier':
                  errorMessage.value =
                      'Tienes que superar el CAPTCHA, vuelve atras y reintenta.';
                  break;
                case 'too-many-requests':
                  errorMessage.value =
                      'Intenta más tarde, Realizaste demasiados intentos fallidos.';
                  break;
                default:
                  errorMessage.value =
                      'Intenta más tarde, presentamos un inconveniente al tratar de valid.';
              }
              isLoadingSave.value = false;
            })
        .then((bool boolean) {
      isLoadingSave.value = false;
      return boolean;
    }).catchError((error) {
      errorMessage.value = 'Debes de verificar que no eres un robot.';
      isLoadingSave.value = false;
    });
    return futureBool;
  }

  Future<bool> updateSession({
    required bool isPhoneVerified,
  }) {
    Future<bool> futureBool = _verifySessionUsecase
        .call()
        .then((AbstractSessionEntity abstractSessionEntity) {
      SessionModel sessionModel = abstractSessionEntity as SessionModel;
      _updateSessionUsecase.call(
        abstractSessionEntity: sessionModel.copyWith(
          isPhoneVerified: true,
        ),
      );
      firebaseNotificationProvider!
          .subscribeToTopic(topic: 'pickpointer_app_phone_verified');
      return isPhoneVerified;
    });
    return futureBool;
  }

  updateUserData() async {
    bool isValidForm = formKey.currentState!.validate();
    try {
      if (isValidForm) {
        isLoadingSave.value = true;
        String avatarNormalized =
            await filePathNormalizer(avatar.value, name: 'avatar');
        String carPhotoNormalized =
            await filePathNormalizer(carPhoto.value, name: 'carPhoto');
        final UserModel _userModel = UserModel(
          id: userId.value,
          name: name.value,
          email: email.value,
          avatar: avatarNormalized,
          document: document.value,
          carPlate: carPlate.value,
          carPhoto: carPhotoNormalized,
          carModel: carModel.value,
          carColor: carColor.value,
          phoneNumber: phoneNumber.value,
          rank: rank.value.toString(),
          isDriver: isDriverVerified.value
              ? '1'
              : isDriver.value
                  ? '2'
                  : '0', // TODO: only can set 1 (isDriver) from DataBase
        );
        _updateUserUsecase
            .call(abstractUserEntity: _userModel)!
            .then((AbstractUserEntity abstractUserEntity) {
          updateSession(isPhoneVerified: true);
          GetxSnackbarWidget(
            title: 'Actualizado!',
            subtitle: 'Estamos revizando la informacion.',
          );
          isLoadingSave.value = false;
          Get.offAll(
            () => const RoutesPage(),
          );
        });
      }
    } catch (e) {
      isLoadingSave.value = false;
    }
  }

  @override
  void onReady() {
    getUserData();
  }
}

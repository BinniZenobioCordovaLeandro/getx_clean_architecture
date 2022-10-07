import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_firebase_session_datasource.dart';
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

  Timer? countDownTimer;

  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: 'formKey_userPage');
  final GlobalKey<FormState> formCodeKey =
      GlobalKey<FormState>(debugLabel: 'formCodeKey_userPage');

  var isLoadingData = false.obs;
  var message = ''.obs;
  var errorMessage = ''.obs;
  var isLoadingSave = false.obs;

  var timerResetValue = 60;
  var timerTracker = 60.obs;

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

  stopTimer() {
    countDownTimer?.cancel();
    timerTracker.value = timerResetValue;
  }

  startTimer() {
    const second = Duration(seconds: 1);
    countDownTimer = Timer.periodic(second, (timer) {
      if (timerTracker.value == 0) {
        timer.cancel();
        timerTracker.value = timerResetValue;
      } else {
        timerTracker.value--;
      }
    });
  }

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
      message.value = 'Cargando, Imagen de $name ..';
      String? urlPath = await storageProvider?.putFileFromPath(
        path,
        directory: userId.value,
        name: name,
      );
      return urlPath as String;
    }
    return path as String;
  }

  resendCode() {
    startTimer();
    sendVerificationCode(
      phoneNumber: phoneNumber.value,
    );
  }

  verifyCode({
    required String smsCode,
  }) {
    isLoadingSave.value = true;
    errorMessage.value = '';
    firebaseAuthenticationProvider!
        .verifyPhoneAuth(smsCode: smsCode)
        .then((String? user) {
      if (user != null && user.isNotEmpty) {
        isLoadingSave.value = true;
        message.value =
            'Perfecto!, ahora estamos procesando tu información, espera...';
        updateUserData();
      } else {
        errorMessage.value =
            'El CODIGO no es valido y expiro,\nTe enviaremos uno NUEVO, espera... ${timerTracker.value} segundos';
        isLoadingSave.value = false;
      }
    }).catchError((error) {
      if (error.code == 'invalid-verification-code') {
        errorMessage.value =
            'El CODIGO usado es INVALIDO. Por favor reenvia el codigo SMS y asegurate de usar el ULTIMO recibido.';
      } else if (error.code == 'invalid-verification-id') {
        errorMessage.value = 'Estas usando un codigo que no es el ULTIMO.';
      } else {
        errorMessage.value =
            'ERROR, No te logramos enviar el mensaje.\nVerifica tu número, tu conexion a internet e intenta más tarde.';
      }
      isLoadingSave.value = false;
    });
  }

  Future<bool?> sendVerificationCode({
    required String phoneNumber,
  }) {
    isLoadingSave.value = true;
    errorMessage.value = '';
    message.value = '';
    Future<bool> futureBool = firebaseAuthenticationProvider!
        .sendPhoneAuth(
      phoneNumber: phoneNumber,
      onError: (String? identifier) {
        switch (identifier) {
          case 'invalid-phone-number':
            errorMessage.value = 'Ingresaste un número de telefono no valido.';
            break;
          case 'missing-client-identifier':
            errorMessage.value =
                'Tienes que superar el CAPTCHA, vuelve atras y reintenta.';
            break;
          case 'too-many-requests':
            errorMessage.value =
                'Intenta más tarde, realizaste demasiados intentos fallidos. Vuelve en 1 hora o intenta con otro número.';
            break;
          default:
            errorMessage.value =
                'Verifica tu conexion a internet, e intenta más tarde.';
        }
        stopTimer();
        isLoadingSave.value = false;
      },
      onSent: () {
        isLoadingSave.value = false;
        errorMessage.value = '';
        message.value =
            'Te hemos enviado el código de verificación al número $phoneNumber';
        startTimer();
      },
      onAutoRetrieval: () {
        errorMessage.value = '';
        message.value =
            'Te enviamos un nuevo codigo, a tu número $phoneNumber . Verifica bien y usa el ultimo.';
        startTimer();
      },
      onVerified: (PhoneAuthCredential credential) {
        errorMessage.value = '';
        message.value =
            'Número $phoneNumber verificado!,\nEspera un instante a que terminemos de cargar los datos...';
      },
    )
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

        message.value = 'Actualizando, datos de perfil, espera...';
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_session_datasource.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/verify_session_usecase.dart';
import 'package:pickpointer/packages/user_package/data/datasources/user_datasource.dart/firebase_user_datasource.dart';
import 'package:pickpointer/packages/user_package/data/models/user_model.dart';
import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';
import 'package:pickpointer/packages/user_package/domain/usecases/get_user_usecase.dart';
import 'package:pickpointer/packages/user_package/domain/usecases/update_user_usecase.dart';

class UserController extends GetxController {
  static UserController get instance => Get.put(UserController());

  final formKey = GlobalKey<FormState>();

  var isLoadingData = false.obs;
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
  var rank = 5.0.obs;
  var isDriver = false.obs;

  final UpdateUserUsecase _updateUserUsecase = UpdateUserUsecase(
    abstractUserRepository: FirebaseUserDatasource(),
  );

  final GetUserUsecase _getUserUsecase = GetUserUsecase(
    abstractUserRepository: FirebaseUserDatasource(),
  );

  final VerifySessionUsecase _verifySessionUsecase = VerifySessionUsecase(
    abstractSessionRepository: SharedPreferencesSessionDatasources(),
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
                  isDriver.value = abstractUserEntity.isDriver == '1',
                  formKey.currentState?.validate(),
                  isLoadingData.value = false,
                });
      } else {
        isLoadingData.value = false;
      }
    });
  }

  updateUserData() {
    bool isValidForm = formKey.currentState!.validate();
    if (isValidForm) {
      isLoadingSave.value = true;
      final UserModel _userModel = UserModel(
        id: userId.value,
        name: name.value,
        email: email.value,
        avatar: avatar.value,
        document: document.value,
        carPlate: carPlate.value,
        carPhoto: carPhoto.value,
        carModel: carModel.value,
        carColor: carColor.value,
        phoneNumber: phoneNumber.value,
        rank: rank.value.toString(),
        isDriver: isDriver.value
            ? '2'
            : '0', // TODO: only can set 1 (isDriver) from DataBase
      );
      _updateUserUsecase
          .call(abstractUserEntity: _userModel)!
          .then((AbstractUserEntity abstractUserEntity) {
        isLoadingSave.value = false;
      });
    }
  }

  @override
  void onReady() {
    getUserData();
  }
}

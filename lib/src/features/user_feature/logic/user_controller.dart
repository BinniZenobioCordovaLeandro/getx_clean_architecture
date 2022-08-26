import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_session_datasource.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/verify_session_usecase.dart';
import 'package:pickpointer/packages/user_package/data/datasources/user_datasource.dart/firebase_user_datasource.dart';
import 'package:pickpointer/packages/user_package/data/models/user_model.dart';
import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';
import 'package:pickpointer/packages/user_package/domain/usecases/get_user_usecase.dart';
import 'package:pickpointer/packages/user_package/domain/usecases/update_user_usecase.dart';
import 'package:pickpointer/src/core/providers/storage_provider.dart';

class UserController extends GetxController {
  static UserController get instance => Get.put(UserController());

  final StorageProvider? storageProvider = StorageProvider.getInstance();

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
  var isDriverVerified = false.obs;

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
        print('_userModel');
        _updateUserUsecase
            .call(abstractUserEntity: _userModel)!
            .then((AbstractUserEntity abstractUserEntity) {
          Get.snackbar('Actualizado!',
              'Estamos revizando la informacion.'); // TODO: Create a component for the SNACK
          isLoadingSave.value = false;
        });
      }
    } catch (e) {
      print('error');
      print(e);
      isLoadingSave.value = false;
    }
  }

  @override
  void onReady() {
    getUserData();
  }
}

import 'package:get/get.dart';
import 'package:pickpointer/packages/user_package/data/datasources/user_datasource.dart/firebase_user_datasource.dart';
import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';
import 'package:pickpointer/packages/user_package/domain/usecases/get_users_usecase.dart';

class UserController extends GetxController {
  static UserController get instance => Get.put(UserController());

  var futureListAbstractUserEntity = Future.value(<AbstractUserEntity>[]).obs;

  final GetUsersUsecase _getUsersUsecase = GetUsersUsecase(
    abstractUserRepository: FirebaseUserDatasource(),
  );

  @override
  void onReady() {
    futureListAbstractUserEntity.value = _getUsersUsecase
        .call()!
        .then((List<AbstractUserEntity> listAbstractUserEntity) {
      return listAbstractUserEntity;
    });
  }
}

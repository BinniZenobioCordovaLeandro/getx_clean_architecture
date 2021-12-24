import 'dart:io';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pickpointer/packages/user_package/data/datasources/user_datasource.dart/http_user_datasource.dart';
import 'package:pickpointer/packages/user_package/domain/usecases/get_user_usecase.dart';

class UserController extends GetxController {
  final GetUserUsecase _getUserUsecase = GetUserUsecase(
    abstractUserRepository: HttpUserDatasource(
      httpClient: HttpClient(),
    ),
  );

  @override
  void onReady() {
    // _getUserUsecase.call(userId: 1)?.then((AbstractUserEntity abstractUserEntity) {

    // });
  }
}

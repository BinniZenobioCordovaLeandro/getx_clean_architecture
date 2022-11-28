import 'package:get/get.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_firebase_session_datasource.dart';
import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/update_session_usecase.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/verify_session_usecase.dart';
import 'package:pickpointer/src/core/providers/package_info_provider.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.put(HomeController());

  final VerifySessionUsecase _verifySessionUsecase = VerifySessionUsecase(
    abstractSessionRepository: SharedPreferencesFirebaseSessionDatasources(),
  );

  final UpdateSessionUsecase _updateSessionUsecase = UpdateSessionUsecase(
    abstractSessionRepository: SharedPreferencesFirebaseSessionDatasources(),
  );

  var version = 'x.x.x'.obs;
  var isSigned = false.obs;
  var isDriver = false.obs;
  var isLoading = false.obs;

  getVersion() {
    PackageInfoProvider.getInstance()
        .then((PackageInfoProvider? packageInfoProvider) {
      if (packageInfoProvider != null) {
        version.value = packageInfoProvider.getFullVersion();
      }
    });
  }

  Future<bool> verifySession() {
    Future<bool> futureBool = _verifySessionUsecase
        .call()
        .then((AbstractSessionEntity abstractSessionEntity) {
      isSigned.value = abstractSessionEntity.isSigned!;
      isDriver.value = abstractSessionEntity.isDriver ?? false;
      _updateSessionUsecase.call(abstractSessionEntity: abstractSessionEntity);
      return isSigned.value;
    });
    return futureBool;
  }

  @override
  void onReady() {
    getVersion();
    verifySession();
    super.onReady();
  }
}

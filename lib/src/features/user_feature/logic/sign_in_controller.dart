import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_session_datasource.dart';
import 'package:pickpointer/packages/session_package/data/models/session_model.dart';
import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/update_session_usecase.dart';
import 'package:pickpointer/src/core/providers/google_sign_in_provider.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.put(SignInController());

  final GoogleSignInProvider? _googleSignInProvider =
      GoogleSignInProvider.getInstance();

  var isSigned = false.obs;
  var googleIsLoading = false.obs;

  final UpdateSessionUsecase _updateSessionUsecase = UpdateSessionUsecase(
    abstractSessionRepository: SharedPreferencesSessionDatasources(),
  );

  Future<bool> signIn(number) async {
    if (number == 0) {
      googleIsLoading.value = true;
      GoogleSignInAccount? googleSignInAccount =
          await _googleSignInProvider?.handleSignIn();
      if (googleSignInAccount != null) {
        AbstractSessionEntity abstractSessionEntity = SessionModel(
          isSigned: true,
          idUsers: googleSignInAccount.id,
          name: googleSignInAccount.displayName,
          email: googleSignInAccount.email,
          avatar: googleSignInAccount.photoUrl,
        );
        _updateSessionUsecase.call(
            abstractSessionEntity: abstractSessionEntity);
        googleIsLoading.value = false;
        isSigned.value = true;
        return true;
      } else {
        googleIsLoading.value = false;
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> signInWithGoogle() {
    return signIn(0);
  }
}

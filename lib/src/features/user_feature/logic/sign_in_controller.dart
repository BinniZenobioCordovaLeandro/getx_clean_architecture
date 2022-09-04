import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pickpointer/packages/session_package/data/datasources/session_datasources/shared_preferences_firebase_session_datasource.dart';
import 'package:pickpointer/packages/session_package/data/models/session_model.dart';
import 'package:pickpointer/packages/session_package/domain/entities/abstract_session_entity.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/update_session_usecase.dart';
import 'package:pickpointer/packages/session_package/domain/usecases/verify_session_usecase.dart';
import 'package:pickpointer/packages/user_package/data/datasources/user_datasource.dart/firebase_user_datasource.dart';
import 'package:pickpointer/packages/user_package/data/models/user_model.dart';
import 'package:pickpointer/packages/user_package/domain/entities/abstract_user_entity.dart';
import 'package:pickpointer/packages/user_package/domain/usecases/get_user_usecase.dart';
import 'package:pickpointer/packages/user_package/domain/usecases/set_user_usecase.dart';
import 'package:pickpointer/packages/user_package/domain/usecases/user_exists_usecase.dart';
import 'package:pickpointer/src/core/providers/firebase_notification_provider.dart';
import 'package:pickpointer/src/core/providers/google_sign_in_provider.dart';
import 'package:pickpointer/src/core/providers/notification_provider.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.put(SignInController());

  final GoogleSignInProvider? _googleSignInProvider =
      GoogleSignInProvider.getInstance();

  final NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();

  final FirebaseNotificationProvider? firebaseNotificationProvider =
      FirebaseNotificationProvider.getInstance();

  var isSigned = false.obs;
  var googleIsLoading = false.obs;

  final VerifySessionUsecase _verifySessionUsecase = VerifySessionUsecase(
    abstractSessionRepository: SharedPreferencesFirebaseSessionDatasources(),
  );

  final UpdateSessionUsecase _updateSessionUsecase = UpdateSessionUsecase(
    abstractSessionRepository: SharedPreferencesFirebaseSessionDatasources(),
  );

  final UserExistsUsecase _userExistsUsecase = UserExistsUsecase(
    abstractUserRepository: FirebaseUserDatasource(),
  );

  final GetUserUsecase _getUserUsecase = GetUserUsecase(
    abstractUserRepository: FirebaseUserDatasource(),
  );

  final SetUserUsecase _setUserUsecase = SetUserUsecase(
    abstractUserRepository: FirebaseUserDatasource(),
  );

  Future<bool>? sendNotification() {
    Future<bool>? futureBool = notificationProvider
        ?.sendNotification(
          title: 'BIENVENIDO A PICKPOINTER (MODO TEST)',
          body:
              'Esta app permite viajar rapido y barato.\nDisfrute el modo TEST. Pronto saldremos a PRODUCCIÓN!.',
        )
        .then((value) => value);
    return futureBool;
  }

  Future<bool> signIn(number) async {
    if (number == 0) {
      googleIsLoading.value = true;
      GoogleSignInAccount? googleSignInAccount =
          await _googleSignInProvider?.handleSignIn();
      if (googleSignInAccount != null) {
        _verifySessionUsecase
            .call()
            .then((AbstractSessionEntity abstractSessionEntity) async {
          final SessionModel sessionModel =
              abstractSessionEntity as SessionModel;
          final tokenMessaging = await firebaseNotificationProvider?.getToken();
          final SessionModel newSessionModel = sessionModel.copyWith(
            isSigned: true,
            idUsers: googleSignInAccount.id,
            tokenMessaging: tokenMessaging,
          );
          _getUserUsecase
              .call(userId: googleSignInAccount.id)
              ?.then((AbstractUserEntity abstractUserEntity) {
            final UserModel userModel = abstractUserEntity as UserModel;
            _updateSessionUsecase.call(
                abstractSessionEntity: newSessionModel.copyWith(
              isDriver: userModel.isDriver == '1',
            ));
          }).catchError((error) {
            _userExistsUsecase
                .call(userId: googleSignInAccount.id)
                ?.then((boolean) {
              if (boolean == false) {
                final UserModel userModel = UserModel(
                  id: googleSignInAccount.id,
                  name: googleSignInAccount.displayName,
                  email: googleSignInAccount.email,
                  avatar: googleSignInAccount.photoUrl,
                );
                _setUserUsecase.call(abstractUserEntity: userModel);
              }
              _updateSessionUsecase.call(
                  abstractSessionEntity: newSessionModel);
            });
          });
          googleIsLoading.value = false;
          isSigned.value = true;
        });
        sendNotification();
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

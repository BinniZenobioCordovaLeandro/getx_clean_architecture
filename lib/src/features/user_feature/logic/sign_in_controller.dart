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
import 'package:pickpointer/src/core/providers/facebook_sign_in_provider.dart';
import 'package:pickpointer/src/core/providers/firebase_notification_provider.dart';
import 'package:pickpointer/src/core/providers/google_sign_in_provider.dart';
import 'package:pickpointer/src/core/providers/notification_provider.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.put(SignInController());

  final GoogleSignInProvider? _googleSignInProvider =
      GoogleSignInProvider.getInstance();

  final FacebookSignInProvider _facebookSignInProvider =
      FacebookSignInProvider();

  final NotificationProvider? notificationProvider =
      NotificationProvider.getInstance();

  final FirebaseNotificationProvider? firebaseNotificationProvider =
      FirebaseNotificationProvider.getInstance();

  var isSigned = false.obs;
  var googleIsLoading = false.obs;
  var facebookIsLoading = false.obs;

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
        ?.sendLocalNotification(
          title: 'BIENVENIDO A PICKPOINTER (MODO TEST)',
          body:
              'Esta app permite viajar rapido y barato.\nDisfrute el modo TEST. Pronto saldremos a PRODUCCIÓN!.',
        )
        .then((value) => value);
    return futureBool;
  }

  Future<bool> registerUser({
    required String signId,
    required String? signDisplayName,
    required String? signEmail,
    required String? signPhotoUrl,
  }) async {
    AbstractSessionEntity abstractSessionEntity =
        await _verifySessionUsecase.call();

    final SessionModel sessionModel = abstractSessionEntity as SessionModel;
    final tokenMessaging = await firebaseNotificationProvider?.getToken();

    final SessionModel newSessionModel = sessionModel.copyWith(
      isSigned: true,
      idUsers: signId,
      tokenMessaging: tokenMessaging,
    );

    try {
      AbstractUserEntity? abstractUserEntity =
          await _getUserUsecase.call(userId: signId);
      final UserModel userModel = abstractUserEntity as UserModel;
      _updateSessionUsecase.call(
          abstractSessionEntity: newSessionModel.copyWith(
        isDriver: userModel.isDriver == '1',
      ));
      return Future.value(true);
    } catch (e) {
      await _userExistsUsecase.call(userId: signId)?.then((boolean) {
        if (boolean == false) {
          final UserModel userModel = UserModel(
            id: signId,
            name: signDisplayName,
            email: signEmail,
            avatar: signPhotoUrl,
          );
          _setUserUsecase.call(abstractUserEntity: userModel);
        }
        _updateSessionUsecase.call(abstractSessionEntity: newSessionModel);
      });
      return Future.value(true);
    }
  }

  Future<bool> signIn(number) async {
    switch (number) {
      case 0:
        GoogleSignInAccount? googleSignInAccount =
            await _googleSignInProvider?.handleSignIn();
        if (googleSignInAccount != null) {
          bool registedUser = await registerUser(
            signId: googleSignInAccount.id,
            signDisplayName: googleSignInAccount.displayName,
            signEmail: googleSignInAccount.email,
            signPhotoUrl: googleSignInAccount.photoUrl,
          );
          if (registedUser) return Future.value(true);
          return Future.value(false);
        } else {
          return Future.value(false);
        }
      case 1:
        FacebookUserModel? facebookUserModel =
            await _facebookSignInProvider.handleSignIn();
        if (facebookUserModel != null) {
          bool registedUser = await registerUser(
            signId: facebookUserModel.id!,
            signDisplayName:
                '${facebookUserModel.firstName} ${facebookUserModel.lastName}',
            signEmail: facebookUserModel.email,
            signPhotoUrl: facebookUserModel.picture?.data?.url,
          );
          if (registedUser) return Future.value(true);
          return Future.value(true);
        } else {
          return Future.value(false);
        }
      default:
        return Future.value(false);
    }
  }

  Future<bool> signInWithGoogle() {
    googleIsLoading.value = true;
    return signIn(0).then((bool boolean) {
      googleIsLoading.value = false;
      if (boolean) {
        isSigned.value = true;
        sendNotification();
      }
      return boolean;
    });
  }

  Future<bool> signInWithFacebook() {
    facebookIsLoading.value = true;
    return signIn(1).then((bool boolean) {
      facebookIsLoading.value = false;
      if (boolean) {
        isSigned.value = true;
        sendNotification();
      }
      return boolean;
    });
  }
}

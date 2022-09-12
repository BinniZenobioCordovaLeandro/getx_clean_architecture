import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationProvider {
  static FirebaseAuthenticationProvider? _instance;
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static String? lastVerificationId;

  static FirebaseAuthenticationProvider? getInstance() {
    _instance ??= FirebaseAuthenticationProvider();
    return _instance;
  }

  Future<bool> sendPhoneAuth({
    required String phoneNumber,
  }) async {
    try {
      print('sendPhoneAuth phoneNumber $phoneNumber');
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('credential ${credential.smsCode}, ${credential.signInMethod}');
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
          if (e.code == 'missing-client-identifier') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          print('codeSent.verificationId $verificationId');
          lastVerificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
          print('codeAutoRetrievalTimeout.verificationId $verificationId');
          lastVerificationId = verificationId;
        },
      );
      return Future.value(true);
    } catch (error) {
      print('error ${error.toString()}');
      return Future.error(error);
    }
  }

  Future<String?> verifyPhoneAuth({
    required String smsCode,
  }) {
    if (lastVerificationId != null) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: lastVerificationId!,
        smsCode: smsCode,
      );
      return signInAuthenticator(credential: credential);
    }
    return Future.error('no value for lastVerificationId');
  }

  Future<String?> signInAuthenticator({
    required AuthCredential credential,
  }) {
    // Sign the user in (or link) with the credential
    Future<String?> futureString = firebaseAuth
        .signInWithCredential(credential)
        .then((UserCredential userCredential) {
      print('userCredential ${userCredential.toString()}');
      return '${userCredential.user}';
    });
    return futureString;
  }
}

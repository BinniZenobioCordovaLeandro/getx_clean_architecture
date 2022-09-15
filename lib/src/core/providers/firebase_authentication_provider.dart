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
    Function? onSent,
    Function? onVerified,
    final Function(String? identifier)? onError,
  }) async {
    try {
      print('sendPhoneAuth phoneNumber $phoneNumber');
      firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('credential ${credential.smsCode}, ${credential.signInMethod}');
        },
        verificationFailed: (FirebaseAuthException e) {
          // e.code == 'invalid-phone-number' // 'The provided phone number is not valid.';
          // e.code == 'missing-client-identifier' // 'The user is missinf identified';
          // e.code == "too-many-requests" // 'Too many requests received';
          if (onError != null) {
            onError(e.code);
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
      return Future.delayed(
        const Duration(seconds: 1),
        () => true,
      );
    } catch (error) {
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
    return Future.error('No value for lastVerificationId');
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

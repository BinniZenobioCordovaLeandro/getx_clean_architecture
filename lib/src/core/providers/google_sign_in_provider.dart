import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider {
  static GoogleSignInProvider? _instance;

  GoogleSignIn? googleSignIn;

  static GoogleSignInProvider? getInstance() {
    _instance ??= GoogleSignInProvider();
    return _instance;
  }

  GoogleSignInProvider() {
    googleSignIn = GoogleSignIn(
      scopes: ['email'],
      signInOption: SignInOption.standard,
    );
  }

  Future<GoogleSignInAccount?> handleSignIn() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn?.signIn();
      if (googleSignInAccount?.email != null) {
        return googleSignInAccount;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> handleSignOut() async {
    googleSignIn?.disconnect();
  }
}

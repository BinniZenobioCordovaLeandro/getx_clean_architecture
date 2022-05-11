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
      clientId: '123054099128-91nov2744gl9rihf4qoc0aa22q1j029j.apps.googleusercontent.com',
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

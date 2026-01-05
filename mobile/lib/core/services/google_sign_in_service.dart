import 'package:google_sign_in/google_sign_in.dart';

/// Service for handling Google Sign-In authentication.
class GoogleSignInService {
  static const String _clientId =
      '694993836560-maf4lvbbmrr5crt5ckd6ucg3f8ljkuh5.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: _clientId,
    scopes: ['email', 'profile'],
  );

  /// Initiates Google Sign-In flow and returns the ID token.
  /// Returns null if sign-in was cancelled or failed.
  Future<String?> signIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        // User cancelled sign-in
        return null;
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      return auth.idToken;
    } catch (e) {
      print('Google Sign-In error: $e');
      return null;
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  /// Checks if user is currently signed in with Google.
  Future<bool> isSignedIn() async {
    return _googleSignIn.isSignedIn();
  }
}

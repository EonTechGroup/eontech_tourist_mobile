import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _webClientId =
      '70293007713-44btpqvd920t7squqfppku69ck14cqhb.apps.googleusercontent.com';

  static const String _androidClientId =
      '70293007713-g1egibh2t9uaqcqrsf1772uaklm35nto.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: _androidClientId,
    serverClientId: _webClientId,
    scopes: ['email'],
  );

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<AuthResult> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.setSettings(appVerificationDisabledForTesting: true);
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return AuthResult.success(credential.user!);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_friendlyError(e));
    } catch (e) {
      return AuthResult.error('Login failed: ${e.toString()}');
    }
  }

  Future<AuthResult> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _auth.setSettings(appVerificationDisabledForTesting: true);
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user!.updateDisplayName(name.trim());
      await credential.user!.reload();
      return AuthResult.success(_auth.currentUser!);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_friendlyError(e));
    } catch (e) {
      return AuthResult.error('Registration failed: ${e.toString()}');
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut().catchError((_) {});

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return AuthResult.error('Google sign-in was cancelled.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        return AuthResult.error(
          'idToken is null. Check SHA-1 in Firebase Console.',
        );
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return AuthResult.success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_friendlyError(e));
    } catch (e) {
      return AuthResult.error('Google sign-in failed: ${e.toString()}');
    }
  }

  Future<AuthResult> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return AuthResult.success(null);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(_friendlyError(e));
    } catch (e) {
      return AuthResult.error('Could not send reset email. Try again.');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut().catchError((_) {});
  }

  String _friendlyError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again.';
      case 'network-request-failed':
        return 'No internet connection. Check your network.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled in Firebase.';
      case 'account-exists-with-different-credential':
        return 'Account exists with a different sign-in method.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}

class AuthResult {
  final User? user;
  final String? error;
  final bool isSuccess;

  const AuthResult._({this.user, this.error, required this.isSuccess});

  factory AuthResult.success(User? user) =>
      AuthResult._(user: user, isSuccess: true);

  factory AuthResult.error(String message) =>
      AuthResult._(error: message, isSuccess: false);
}
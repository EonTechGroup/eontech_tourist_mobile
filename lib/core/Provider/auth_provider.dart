import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthNotifier extends ChangeNotifier {
  static final AuthNotifier _instance = AuthNotifier._internal();
  factory AuthNotifier() => _instance;
  AuthNotifier._internal();

  AuthStatus _status = AuthStatus.unknown;
  String? _userId;
  String? _userName;
  String? _userEmail;
  String? _error;
  bool _isLoading = false;

  AuthStatus get status => _status;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // ── Check existing token on app start ──────────────────────────────────

  Future<void> checkAuthStatus() async {
    _setLoading(true);
    try {
      final hasToken = await ApiService().hasValidToken();
      if (hasToken) {
        final result = await ApiService().getMe();
        if (result.isSuccess) {
          final user = result.data!;
          _setAuthenticated(
            userId: user['id']?.toString() ?? '',
            userName: user['name']?.toString() ?? '',
            userEmail: user['email']?.toString() ?? '',
          );
        } else {
          await ApiService().clearTokens();
          _setUnauthenticated();
        }
      } else {
        _setUnauthenticated();
      }
    } catch (e) {
      _setUnauthenticated();
    } finally {
      _setLoading(false);
    }
  }

  // ── Register ────────────────────────────────────────────────────────────

  Future<String?> register({
    required String name,
    required String email,
    required String password,
    required String nationality,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      // Firebase register
      final firebaseResult = await AuthService().registerWithEmail(
        name: name,
        email: email,
        password: password,
      );

      if (firebaseResult.isError) {
        _error = firebaseResult.error;
        notifyListeners();
        return _error;
      }

      // Backend register
      final backendResult = await ApiService().register(
        name: name,
        email: email,
        password: password,
        nationality: nationality,
      );

      if (backendResult.isSuccess) {
        final data = backendResult.data!;
        if (data['access_token'] != null) {
          await ApiService().saveTokens(
            access: data['access_token'] as String,
            refresh: data['refresh_token'] as String? ?? '',
          );
        }
        _setAuthenticated(
          userId: data['user']?['id']?.toString() ?? '',
          userName: name,
          userEmail: email,
        );
        return null;
      } else {
        // Backend failed but Firebase succeeded — still authenticate
        _setAuthenticated(
          userId: firebaseResult.user!.uid,
          userName: name,
          userEmail: email,
        );
        return null;
      }
    } catch (e) {
      _error = 'Registration failed: $e';
      notifyListeners();
      return _error;
    } finally {
      _setLoading(false);
    }
  }

  // ── Login ───────────────────────────────────────────────────────────────

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      // Firebase login
      final firebaseResult = await AuthService().loginWithEmail(
        email: email,
        password: password,
      );

      if (firebaseResult.isError) {
        _error = firebaseResult.error;
        notifyListeners();
        return _error;
      }

      // Backend login
      final backendResult = await ApiService().login(
        email: email,
        password: password,
      );

      if (backendResult.isSuccess) {
        final data = backendResult.data!;
        if (data['access_token'] != null) {
          await ApiService().saveTokens(
            access: data['access_token'] as String,
            refresh: data['refresh_token'] as String? ?? '',
          );
        }
        _setAuthenticated(
          userId: data['user']?['id']?.toString() ??
              firebaseResult.user!.uid,
          userName: data['user']?['name']?.toString() ??
              email.split('@').first,
          userEmail: email,
        );
      } else {
        // Backend failed — use Firebase data
        _setAuthenticated(
          userId: firebaseResult.user!.uid,
          userName: firebaseResult.user!.displayName ??
              email.split('@').first,
          userEmail: email,
        );
      }
      return null;
    } catch (e) {
      _error = 'Login failed: $e';
      notifyListeners();
      return _error;
    } finally {
      _setLoading(false);
    }
  }

  // ── Google Sign-In ──────────────────────────────────────────────────────

  Future<String?> loginWithGoogle() async {
    _setLoading(true);
    _error = null;

    try {
      final result = await AuthService().signInWithGoogle();

      if (result.isError) {
        _error = result.error;
        notifyListeners();
        return _error;
      }

      final user = result.user!;
      _setAuthenticated(
        userId: user.uid,
        userName: user.displayName ?? user.email!.split('@').first,
        userEmail: user.email ?? '',
      );
      return null;
    } catch (e) {
      _error = 'Google sign-in failed: $e';
      notifyListeners();
      return _error;
    } finally {
      _setLoading(false);
    }
  }

  // ── Logout ──────────────────────────────────────────────────────────────

  Future<void> logout() async {
    await AuthService().signOut();
    await ApiService().clearTokens();
    _setUnauthenticated();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  void _setAuthenticated({
    required String userId,
    required String userName,
    required String userEmail,
  }) {
    _status = AuthStatus.authenticated;
    _userId = userId;
    _userName = userName;
    _userEmail = userEmail;
    notifyListeners();
  }

  void _setUnauthenticated() {
    _status = AuthStatus.unauthenticated;
    _userId = null;
    _userName = null;
    _userEmail = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
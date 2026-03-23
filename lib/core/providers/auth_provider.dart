import 'package:flutter/foundation.dart';
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

  Future<void> checkAuthStatus() async {
    _setLoading(true);
    try {
      final hasToken = await ApiService().hasValidToken();
      if (!hasToken) {
        _setUnauthenticated();
        return;
      }

      final result = await ApiService().getMe();
      if (result.isSuccess && result.data != null) {
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
    } catch (_) {
      await ApiService().clearTokens();
      _setUnauthenticated();
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
    required String nationality,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      final firebase = await AuthService().registerWithEmail(
          name: name, email: email, password: password);
      if (firebase.isError) return firebase.error;

      final backend = await ApiService().register(
          name: name, email: email, password: password, nationality: nationality);

      if (backend.isSuccess && backend.data != null) {
        await ApiService().saveTokens(
          access: backend.data?['access_token']?.toString() ?? '',
          refresh: backend.data?['refresh_token']?.toString() ?? '',
        );
      }

      _setAuthenticated(userId: firebase.user?.uid ?? '', userName: name, userEmail: email);
      return null;
    } catch (e) {
      return 'Registration failed: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      final firebase = await AuthService().loginWithEmail(email: email, password: password);
      if (firebase.isError) return firebase.error;

      final backend = await ApiService().login(email: email, password: password);

      if (backend.isSuccess && backend.data != null) {
        final userData = backend.data?['user'];
        await ApiService().saveTokens(
          access: backend.data?['access_token']?.toString() ?? '',
          refresh: backend.data?['refresh_token']?.toString() ?? '',
        );

        _setAuthenticated(
          userId: userData?['id']?.toString() ?? '',
          userName: userData?['name']?.toString() ?? '',
          userEmail: email,
        );
      } else {
        _setAuthenticated(
          userId: firebase.user?.uid ?? '',
          userName: firebase.user?.displayName ?? email.split('@').first,
          userEmail: email,
        );
      }

      return null;
    } catch (e) {
      return 'Login failed: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> loginWithGoogle() async {
    _setLoading(true);
    _error = null;
    try {
      final result = await AuthService().signInWithGoogle();
      if (result.isError) return result.error;

      final user = result.user;
      final idToken = await user?.getIdToken();

      if (idToken != null) {
        final backend = await ApiService().googleAuth(idToken);
        if (backend.isSuccess && backend.data != null) {
          await ApiService().saveTokens(
            access: backend.data?['access_token']?.toString() ?? '',
            refresh: backend.data?['refresh_token']?.toString() ?? '',
          );
        }
      }

      _setAuthenticated(
        userId: user?.uid ?? '',
        userName: user?.displayName ?? user?.email?.split('@').first ?? '',
        userEmail: user?.email ?? '',
      );

      return null;
    } catch (e) {
      return 'Google login failed: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await AuthService().signOut();
    await ApiService().clearTokens();
    _setUnauthenticated();
  }

  void _setAuthenticated({required String userId, required String userName, required String userEmail}) {
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
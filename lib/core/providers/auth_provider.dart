// lib/core/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import '../models/user.dart'; // ✅ UserRole lives here — single source of truth
import '../services/api_service.dart';
import '../services/auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

// ⚠️  DO NOT redefine UserRole here — it is imported from core/models/user.dart
// Having two definitions causes: "The argument type 'UserRole' can't be
// assigned to the parameter type 'UserRole'" errors at compile time.

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
  UserRole? _userRole;

  // ── Getters ──────────────────────────────
  AuthStatus get status => _status;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  UserRole? get userRole => _userRole;

  // ── Auth status check ─────────────────────
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
          role: _roleFromString(user['role']?.toString()),
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

  // ── Register ─────────────────────────────
  // ✅ `role` param added — receives the user's selection from RegisterScreen
  Future<String?> register({
    required String name,
    required String email,
    required String password,
    required String nationality,
    UserRole role = UserRole.tourist,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      final firebase = await AuthService().registerWithEmail(
        name: name,
        email: email,
        password: password,
      );
      if (firebase.isError) return firebase.error;

      final backend = await ApiService().register(
        name: name,
        email: email,
        password: password,
        nationality: nationality,
        role: _roleToString(role), // ✅ send to backend
      );

      if (backend.isSuccess && backend.data != null) {
        await ApiService().saveTokens(
          access: backend.data?['access_token']?.toString() ?? '',
          refresh: backend.data?['refresh_token']?.toString() ?? '',
        );
      }

      // ✅ Store chosen role — not hardcoded tourist
      _setAuthenticated(
        userId: firebase.user?.uid ?? '',
        userName: name,
        userEmail: email,
        role: role,
      );
      return null;
    } catch (e) {
      return 'Registration failed: $e';
    } finally {
      _setLoading(false);
    }
  }

  // ── Email/Password Login ─────────────────
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      final firebase = await AuthService().loginWithEmail(
        email: email,
        password: password,
      );
      if (firebase.isError) return firebase.error;

      final backend =
          await ApiService().login(email: email, password: password);

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
          role: _roleFromString(userData?['role']?.toString()),
        );
      } else {
        // Fallback: Firebase only
        _setAuthenticated(
          userId: firebase.user?.uid ?? '',
          userName:
              firebase.user?.displayName ?? email.split('@').first,
          userEmail: email,
          role: UserRole.tourist,
        );
      }
      return null;
    } catch (e) {
      return 'Login failed: $e';
    } finally {
      _setLoading(false);
    }
  }

  // ── Google Login ─────────────────────────
  Future<String?> loginWithGoogle() async {
    _setLoading(true);
    _error = null;
    try {
      final result = await AuthService().signInWithGoogle();
      if (result.isError) return result.error;

      final user = result.user;
      final idToken = await user?.getIdToken();

      UserRole role = UserRole.tourist;
      if (idToken != null) {
        final backend = await ApiService().googleAuth(idToken);
        if (backend.isSuccess && backend.data != null) {
          await ApiService().saveTokens(
            access: backend.data?['access_token']?.toString() ?? '',
            refresh: backend.data?['refresh_token']?.toString() ?? '',
          );
          role = _roleFromString(
              backend.data?['user']?['role']?.toString());
        }
      }

      _setAuthenticated(
        userId: user?.uid ?? '',
        userName:
            user?.displayName ?? user?.email?.split('@').first ?? '',
        userEmail: user?.email ?? '',
        role: role,
      );
      return null;
    } catch (e) {
      return 'Google login failed: $e';
    } finally {
      _setLoading(false);
    }
  }

  // ── Password Reset ───────────────────────
  Future<String?> sendPasswordReset(String email) async {
    try {
      final result = await AuthService().sendPasswordReset(email);
      if (result.isError) return result.error;
      return null;
    } catch (e) {
      return 'Failed to send reset email: $e';
    }
  }

  // ── Logout ──────────────────────────────
  Future<void> logout() async {
    await AuthService().signOut();
    await ApiService().clearTokens();
    _setUnauthenticated();
  }

  // ── Role conversion helpers ───────────────
  UserRole _roleFromString(String? value) {
    if (value == 'business_owner') return UserRole.businessOwner;
    return UserRole.tourist;
  }

  String _roleToString(UserRole role) {
    return role == UserRole.businessOwner ? 'business_owner' : 'tourist';
  }

  // ── Internal helpers ─────────────────────
  void _setAuthenticated({
    required String userId,
    required String userName,
    required String userEmail,
    UserRole? role,
  }) {
    _status = AuthStatus.authenticated;
    _userId = userId;
    _userName = userName;
    _userEmail = userEmail;
    _userRole = role ?? UserRole.tourist;
    notifyListeners();
  }

  void _setUnauthenticated() {
    _status = AuthStatus.unauthenticated;
    _userId = null;
    _userName = null;
    _userEmail = null;
    _userRole = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
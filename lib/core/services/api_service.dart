import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String _baseUrl = 'https://api.southsrilanka.lk/v1';
  static const String _tokenKey = 'jwt_access_token';
  static const String _refreshKey = 'jwt_refresh_token';

  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    // ── Request interceptor: attach Bearer token ──────────────────────────
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: _tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // 401 → attempt silent token refresh
          if (e.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry original request with new token
              final token = await _storage.read(key: _tokenKey);
              e.requestOptions.headers['Authorization'] = 'Bearer $token';
              final cloned = await _dio.fetch(e.requestOptions);
              return handler.resolve(cloned);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  // ── Token Management ────────────────────────────────────────────────────

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await Future.wait([
      _storage.write(key: _tokenKey, value: access),
      _storage.write(key: _refreshKey, value: refresh),
    ]);
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _tokenKey),
      _storage.delete(key: _refreshKey),
    ]);
  }

  Future<bool> hasValidToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<bool> _refreshToken() async {
    try {
      final refresh = await _storage.read(key: _refreshKey);
      if (refresh == null) return false;
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refresh},
      );
      final newAccess = response.data['access_token'] as String?;
      final newRefresh = response.data['refresh_token'] as String?;
      if (newAccess != null && newRefresh != null) {
        await saveTokens(access: newAccess, refresh: newRefresh);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // ── Auth Endpoints ──────────────────────────────────────────────────────

  Future<ApiResult<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    return _safeCall(() => _dio.post('/auth/login', data: {
          'email': email,
          'password': password,
        }));
  }

  Future<ApiResult<Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
    required String nationality,
  }) async {
    return _safeCall(() => _dio.post('/auth/register', data: {
          'name': name,
          'email': email,
          'password': password,
          'nationality': nationality,
        }));
  }

  Future<ApiResult<Map<String, dynamic>>> googleAuth(String idToken) async {
    return _safeCall(() => _dio.post('/auth/google', data: {'id_token': idToken}));
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (_) {}
    await clearTokens();
  }

  // ── Places Endpoints ────────────────────────────────────────────────────

  Future<ApiResult<Map<String, dynamic>>> fetchPlaces({
    String? category,
    String? district,
    String? query,
    double? lat,
    double? lng,
    double? radiusKm,
    int page = 1,
    int limit = 20,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (category != null) 'category': category,
      if (district != null) 'district': district,
      if (query != null && query.isNotEmpty) 'q': query,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (radiusKm != null) 'radius_km': radiusKm,
    };
    return _safeCall(() => _dio.get('/places', queryParameters: params));
  }

  Future<ApiResult<Map<String, dynamic>>> fetchPlaceDetail(String id) async {
    return _safeCall(() => _dio.get('/places/$id'));
  }

  Future<ApiResult<Map<String, dynamic>>> toggleSavePlace(String placeId) async {
    return _safeCall(() => _dio.post('/places/$placeId/save'));
  }

  Future<ApiResult<Map<String, dynamic>>> markVisited(String placeId) async {
    return _safeCall(() => _dio.post('/places/$placeId/visited'));
  }

  // ── Flash Offers ────────────────────────────────────────────────────────

  Future<ApiResult<Map<String, dynamic>>> fetchNearbyOffers({
    required double lat,
    required double lng,
    double radiusKm = 5,
  }) async {
    return _safeCall(() => _dio.get('/offers/nearby', queryParameters: {
          'lat': lat,
          'lng': lng,
          'radius_km': radiusKm,
        }));
  }

  Future<ApiResult<Map<String, dynamic>>> createOffer({
    required String businessId,
    required String title,
    required int discountPercent,
    required int durationHours,
    required double radiusKm,
  }) async {
    return _safeCall(() => _dio.post('/offers', data: {
          'business_id': businessId,
          'title': title,
          'discount_percent': discountPercent,
          'duration_hours': durationHours,
          'radius_km': radiusKm,
        }));
  }

  Future<ApiResult<Map<String, dynamic>>> deleteOffer(String offerId) async {
    return _safeCall(() => _dio.delete('/offers/$offerId'));
  }

  // ── Business (Owner) ────────────────────────────────────────────────────

  Future<ApiResult<Map<String, dynamic>>> fetchMyBusinesses() async {
    return _safeCall(() => _dio.get('/owner/businesses'));
  }

  Future<ApiResult<Map<String, dynamic>>> createBusiness(
      Map<String, dynamic> data) async {
    return _safeCall(() => _dio.post('/owner/businesses', data: data));
  }

  Future<ApiResult<Map<String, dynamic>>> fetchOwnerStats(
      String businessId) async {
    return _safeCall(() => _dio.get('/owner/businesses/$businessId/stats'));
  }

  Future<ApiResult<Map<String, dynamic>>> fetchOwnerReviews(
      String businessId) async {
    return _safeCall(() => _dio.get('/owner/businesses/$businessId/reviews'));
  }

  Future<ApiResult<Map<String, dynamic>>> replyToReview({
    required String reviewId,
    required String reply,
  }) async {
    return _safeCall(() => _dio.post('/reviews/$reviewId/reply', data: {
          'reply': reply,
        }));
  }

  // ── Itinerary ───────────────────────────────────────────────────────────

  Future<ApiResult<Map<String, dynamic>>> fetchItinerary() async {
    return _safeCall(() => _dio.get('/itinerary'));
  }

  Future<ApiResult<Map<String, dynamic>>> saveItinerary(
      Map<String, dynamic> data) async {
    return _safeCall(() => _dio.put('/itinerary', data: data));
  }

  // ── Safe call wrapper ───────────────────────────────────────────────────

  Future<ApiResult<Map<String, dynamic>>> _safeCall(
    Future<Response> Function() call,
  ) async {
    try {
      final response = await call();
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return ApiResult.success(data);
      }
      return ApiResult.success({'data': data});
    } on DioException catch (e) {
      return ApiResult.error(_dioErrorMessage(e));
    } catch (e) {
      return ApiResult.error('Unexpected error: $e');
    }
  }

  String _dioErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Check your internet.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        final msg = e.response?.data?['message'];
        if (msg is String) return msg;
        return 'Server error (${e.response?.statusCode})';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

// ── Result wrapper ──────────────────────────────────────────────────────────

class ApiResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const ApiResult._({this.data, this.error, required this.isSuccess});

  factory ApiResult.success(T data) =>
      ApiResult._(data: data, isSuccess: true);

  factory ApiResult.error(String message) =>
      ApiResult._(error: message, isSuccess: false);

  bool get isError => !isSuccess;
}
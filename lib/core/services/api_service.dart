import 'package:shared_preferences/shared_preferences.dart';
import '../models/business.dart';
import '../models/offer.dart';
import '../models/place.dart';
import '../utils/mock_data.dart';

class ApiResult<T> {
  final bool isSuccess;
  final T? data;
  final String? error;

  ApiResult.success(this.data)
      : isSuccess = true,
        error = null;
  ApiResult.failure(this.error)
      : isSuccess = false,
        data = null;
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // ── Token Storage ──────────────────────────────────────────────────────────

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, access);
      await prefs.setString(_refreshTokenKey, refresh);
    } catch (_) {}
  }

  Future<void> clearTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
    } catch (_) {}
  }

  Future<bool> hasValidToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_accessTokenKey);
      return token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_accessTokenKey);
    } catch (_) {
      return null;
    }
  }

  // ── Auth APIs ──────────────────────────────────────────────────────────────

  Future<ApiResult<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return ApiResult.success({
        'user': {'id': 'u1', 'name': 'Demo User'},
        'access_token': 'mock_access_token',
        'refresh_token': 'mock_refresh_token',
      });
    } catch (e) {
      return ApiResult.failure('Login failed: $e');
    }
  }

  Future<ApiResult<Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
    required String nationality, required String role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return ApiResult.success({
        'user': {'id': 'u1', 'name': name},
        'access_token': 'mock_access_token',
        'refresh_token': 'mock_refresh_token',
      });
    } catch (e) {
      return ApiResult.failure('Registration failed: $e');
    }
  }

  Future<ApiResult<Map<String, dynamic>>> googleAuth(String idToken) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return ApiResult.success({
        'user': {'id': 'u1', 'name': 'Google User'},
        'access_token': 'mock_access_token',
        'refresh_token': 'mock_refresh_token',
      });
    } catch (e) {
      return ApiResult.failure('Google auth failed: $e');
    }
  }

  Future<ApiResult<Map<String, dynamic>>> getMe() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return ApiResult.success({
        'id': 'u1',
        'name': 'Demo User',
        'email': 'demo@test.com',
      });
    } catch (e) {
      return ApiResult.failure('Failed to fetch user: $e');
    }
  }

  // ── Businesses ─────────────────────────────────────────────────────────────

  Future<ApiResult<Map<String, dynamic>>> fetchMyBusinesses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return ApiResult.success({
        'data': MockData.businesses.map((b) => _toMap(b)).toList(),
      });
    } catch (e) {
      return ApiResult.failure('Failed to fetch businesses: $e');
    }
  }

  Future<ApiResult<Map<String, dynamic>>> createBusiness(
      Map<String, dynamic> body) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      MockData.businesses.add(Business(
        id: 'b${MockData.businesses.length + 1}',
        name: body['name'] ?? 'New Business',
        description: body['description'] ?? '',
        imageUrl: '',
        latitude: (body['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (body['longitude'] as num?)?.toDouble() ?? 0.0,
        address: body['address'] ?? '',
        phone: body['phone'] ?? '',
        website: body['website'] ?? '',
        vibes: [],
        hours: {},
        rating: 0,
      ));
      return ApiResult.success({
        'data': MockData.businesses.map((b) => _toMap(b)).toList(),
      });
    } catch (e) {
      return ApiResult.failure('Failed to create business: $e');
    }
  }

  // ── Places ─────────────────────────────────────────────────────────────────

  Future<ApiResult<Map<String, dynamic>>> getNearbyPlaces({
    required double lat,
    required double lng,
    double radiusKm = 50,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return ApiResult.success({
        'data': MockData.places.map((p) => _toMapPlace(p)).toList(),
      });
    } catch (e) {
      return ApiResult.failure('Failed to fetch places: $e');
    }
  }

  Future<ApiResult<Map<String, dynamic>>> searchPlaces(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final filtered = MockData.places
          .where((p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return ApiResult.success({
        'data': filtered.map((p) => _toMapPlace(p)).toList(),
      });
    } catch (e) {
      return ApiResult.failure('Search failed: $e');
    }
  }

  Future<ApiResult<Map<String, dynamic>>> fetchPlaceDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final place = MockData.places.firstWhere(
        (p) => p.id == id,
        orElse: () => MockData.places.first,
      );
      return ApiResult.success(_toMapPlace(place));
    } catch (e) {
      return ApiResult.failure('Failed to fetch place: $e');
    }
  }

  // ── Offers ─────────────────────────────────────────────────────────────────

  Future<ApiResult<Map<String, dynamic>>> fetchNearbyOffers({
    required double lat,
    required double lng,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return ApiResult.success({
        'data': MockData.offers.map((o) => _toMapOffer(o)).toList(),
      });
    } catch (e) {
      return ApiResult.failure('Failed to fetch offers: $e');
    }
  }

  // ── Map Helpers ────────────────────────────────────────────────────────────

  Map<String, dynamic> _toMap(Business b) => {
        'id': b.id,
        'name': b.name,
        'description': b.description,
        'image_url': b.imageUrl,
        'latitude': b.latitude,
        'longitude': b.longitude,
        'address': b.address,
        'phone': b.phone,
        'website': b.website,
        'vibes': b.vibes,
        'hours': b.hours,
        'rating': b.rating,
      };

  Map<String, dynamic> _toMapPlace(Place p) => {
        'id': p.id,
        'name': p.name,
        'description': p.description,
        'category': p.category,
        'district': p.district,
        'latitude': p.latitude,
        'longitude': p.longitude,
        'rating': p.rating,
        'reviewCount': p.reviewCount,
        'imagePaths': p.imagePaths,
        'entryFee': p.entryFee,
        'bestTime': p.bestTime,
        'tags': p.tags,
        'hours': p.hours,
        'isFeatured': p.isFeatured,
        'contactNumber': p.contactNumber ?? '',
        'website': p.website ?? '',
      };

  Map<String, dynamic> _toMapOffer(Offer o) => {
        'id': o.id,
        'business_id': o.businessId,
        'business_name': o.businessName,
        'title': o.title,
        'description': o.description,
        'discount_percent': o.discountPercent,
        'expiresAt': o.expiresAt.toIso8601String(),
        'radius_km': o.radiusKm,
      };
}
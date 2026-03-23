import 'package:flutter/foundation.dart';
import '../models/business.dart';
import '../services/api_service.dart';
import '../utils/mock_data.dart';

class BusinessesProvider extends ChangeNotifier {
  static final BusinessesProvider _instance =
      BusinessesProvider._internal();
  factory BusinessesProvider() => _instance;
  BusinessesProvider._internal();

  List<Business> _businesses = [];
  bool _isLoading = false;
  bool _isRefreshing = false;
  String? _error;

  List<Business> get businesses => _businesses;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get error => _error;

  Future<void> fetchMyBusinesses({bool refresh = false}) async {
    if (_isLoading || _isRefreshing) return;

    refresh ? _isRefreshing = true : _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await ApiService().fetchMyBusinesses();

      if (result.isSuccess) {
        final list = result.data?['data'] as List<dynamic>? ?? [];
        _businesses =
            list.map((e) => _parseBusiness(e)).toList();
      } else {
        _error = result.error;
        _businesses = List.from(MockData.businesses);
      }
    } catch (e) {
      _error = e.toString();
      _businesses = List.from(MockData.businesses);
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<String?> createBusiness({
    required String name,
    required String category,
    required String description,
    required String phone,
    required double lat,
    required double lng,
  }) async {
    try {
      final result = await ApiService().createBusiness({
        'name': name,
        'category': category,
        'description': description,
        'phone': phone,
        'latitude': lat,
        'longitude': lng,
      });

      if (result.isSuccess) {
        await fetchMyBusinesses(refresh: true);
        return null;
      }

      return result.error;
    } catch (e) {
      return 'Failed to create business: $e';
    }
  }

  Business _parseBusiness(dynamic item) {
    return Business(
      id: item['id']?.toString() ?? '',
      name: item['name']?.toString() ?? '',
      description: item['description']?.toString() ?? '',
      imageUrl: item['image_url']?.toString() ??
          item['imageUrl']?.toString() ??
          '',
      latitude: (item['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (item['longitude'] as num?)?.toDouble() ?? 0,
      address: item['address']?.toString() ?? '',
      phone: item['phone']?.toString() ?? '',
      website: item['website']?.toString() ?? '',
      vibes: item['vibes'] != null
          ? List<String>.from(item['vibes'])
          : [],
      hours: item['hours'] != null
          ? Map<String, String>.from(item['hours'])
          : {},
      rating: (item['rating'] as num?)?.toDouble() ?? 0,
    );
  }
}
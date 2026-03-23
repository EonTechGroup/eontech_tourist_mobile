import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';
import '../models/place.dart';
import '../utils/mock_data.dart';

class PlacesProvider extends ChangeNotifier {
  List<Place> _places = [];
  List<Place> _filteredPlaces = [];
  bool _isLoading = false;
  bool _isRefreshing = false;
  String? _error;
  String _selectedCategory = 'all';
  String _selectedDistrict = 'All';
  String _searchQuery = '';
  LatLng? _userLocation;

  List<Place> get places => _filteredPlaces;
  List<Place> get allPlaces => _places;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get selectedDistrict => _selectedDistrict;
  LatLng? get userLocation => _userLocation;

  Future<void> fetchNearby({bool refresh = false}) async {
    if (_isLoading || _isRefreshing) return;
    refresh ? _isRefreshing = true : _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final locationResult = await LocationService().getCurrentLocation();
      double lat = 6.0535;
      double lng = 80.2210;

      if (locationResult.isSuccess && locationResult.position != null) {
        lat = locationResult.position!.latitude;
        lng = locationResult.position!.longitude;
        _userLocation = LatLng(lat, lng);
      }

      final result = await ApiService().getNearbyPlaces(lat: lat, lng: lng, radiusKm: 50);
      if (result.isSuccess && result.data != null) {
        final list = result.data?['data'] as List<dynamic>? ?? [];
        _places = list.map((item) => _parsePlace(item)).toList();
        if (_places.isEmpty) _places = List<Place>.from(MockData.places);
      } else {
        _places = List<Place>.from(MockData.places);
      }

      _applyFilters();
    } catch (e) {
      _places = List<Place>.from(MockData.places);
      _applyFilters();
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void setDistrict(String district) {
    _selectedDistrict = district;
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredPlaces = _places.where((place) {
      final matchCategory = _selectedCategory == 'all' || place.category == _selectedCategory;
      final matchDistrict = _selectedDistrict == 'All' || place.district == _selectedDistrict;
      final matchSearch = _searchQuery.isEmpty ||
          place.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          place.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCategory && matchDistrict && matchSearch;
    }).toList();
  }

  Place _parsePlace(dynamic item) {
    return Place(
      id: item['id']?.toString() ?? '',
      name: item['name']?.toString() ?? '',
      description: item['description']?.toString() ?? '',
      category: item['category']?.toString() ?? 'beach',
      district: item['district']?.toString() ?? '',
      latitude: double.tryParse(item['latitude']?.toString() ?? '0') ?? 0,
      longitude: double.tryParse(item['longitude']?.toString() ?? '0') ?? 0,
      rating: double.tryParse(item['rating']?.toString() ?? '0') ?? 0,
      reviewCount: int.tryParse(item['reviewCount']?.toString() ?? '0') ?? 0,
      imagePaths: item['imagePaths'] != null ? List<String>.from(item['imagePaths']) : ['assets/images/1.jpg'],
      entryFee: item['entryFee']?.toString() ?? 'Free',
      bestTime: item['bestTime']?.toString() ?? '',
      tags: item['tags'] != null ? List<String>.from(item['tags']) : [],
      isFeatured: item['isFeatured'] as bool? ?? false,
      hours: {},
    );
  }
}
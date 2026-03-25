import 'package:flutter/material.dart';
import '../../core/models/user.dart';
import '../../core/models/place.dart';
import '../../core/utils/mock_data.dart';

class AppProvider extends ChangeNotifier {
  // ── Auth State ─────────────────────────────────────────
  AppUser? _currentUser;
  bool _isLoggedIn = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  // ✅ Added optional `role` param — defaults to tourist so nothing else breaks
  void login(String email, String name, {UserRole role = UserRole.tourist}) {
    _currentUser = AppUser(
      id: 'user-001',
      name: name,
      email: email,
      role: role,
    );
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _savedPlaceIds.clear();
    notifyListeners();
  }

  // ── Places State ───────────────────────────────────────
  final List<Place> _allPlaces = MockData.places;
  String _selectedCategory = 'all';
  String _selectedDistrict = 'All';
  String _searchQuery = '';

  List<Place> get allPlaces => _allPlaces;
  String get selectedCategory => _selectedCategory;
  String get selectedDistrict => _selectedDistrict;
  String get searchQuery => _searchQuery;

  List<Place> get filteredPlaces {
    return _allPlaces.where((place) {
      final matchCategory =
          _selectedCategory == 'all' || place.category == _selectedCategory;
      final matchDistrict =
          _selectedDistrict == 'All' || place.district == _selectedDistrict;
      final matchSearch =
          _searchQuery.isEmpty ||
          place.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          place.tags.any(
            (t) => t.toLowerCase().contains(_searchQuery.toLowerCase()),
          );
      return matchCategory && matchDistrict && matchSearch;
    }).toList();
  }

  List<Place> get featuredPlaces =>
      _allPlaces.where((p) => p.isFeatured).toList();

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setDistrict(String district) {
    _selectedDistrict = district;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = 'all';
    _selectedDistrict = 'All';
    _searchQuery = '';
    notifyListeners();
  }

  // ── Saved Places ───────────────────────────────────────
  final Set<String> _savedPlaceIds = {};

  bool isSaved(String placeId) => _savedPlaceIds.contains(placeId);

  void toggleSave(String placeId) {
    if (_savedPlaceIds.contains(placeId)) {
      _savedPlaceIds.remove(placeId);
    } else {
      _savedPlaceIds.add(placeId);
    }
    notifyListeners();
  }

  List<Place> get savedPlaces =>
      _allPlaces.where((p) => _savedPlaceIds.contains(p.id)).toList();

  // ── Visited Places ─────────────────────────────────────
  final Set<String> _visitedPlaceIds = {};

  bool isVisited(String placeId) => _visitedPlaceIds.contains(placeId);

  void toggleVisited(String placeId) {
    if (_visitedPlaceIds.contains(placeId)) {
      _visitedPlaceIds.remove(placeId);
    } else {
      _visitedPlaceIds.add(placeId);
    }
    notifyListeners();
  }

  List<Place> get visitedPlaces =>
      _allPlaces.where((p) => _visitedPlaceIds.contains(p.id)).toList();

  int get visitedCount => _visitedPlaceIds.length;

  // ── Bottom Navigation / Tabs ──────────────────────────
  int _currentTab = 0;

  int get currentTab => _currentTab;

  void setTab(int index) {
    _currentTab = index;
    notifyListeners();
  }

  // ── Theme ──────────────────────────────────────────────
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // ── Onboarding ─────────────────────────────────────────
  bool _hasSeenOnboarding = false;
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  void completeOnboarding() {
    _hasSeenOnboarding = true;
    notifyListeners();
  }

  Future<void> fetchNearbyPlaces({required bool refresh}) async {}

  void listenToOffers() {}

  Future<void> fetchNearbyOffers({
    required double lat,
    required double lng,
    required bool refresh,
  }) async {}

  void stopListeningOffers() {}
}
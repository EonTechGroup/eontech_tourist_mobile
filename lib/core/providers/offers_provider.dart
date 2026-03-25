import 'package:flutter/foundation.dart';
import '../models/offer.dart';
import '../services/api_service.dart';
import '../services/socket_service.dart';
import '../utils/mock_data.dart';

class OffersProvider extends ChangeNotifier {
  List<Offer> _offers = [];
  bool _isLoading = false;
  bool _isRefreshing = false;

  List<Offer> get offers => _offers;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;

  // Fetch offers near the user
  Future<void> fetchNearbyOffers({required double lat, required double lng, bool refresh = false}) async {
    if (_isLoading || _isRefreshing) return;
    refresh ? _isRefreshing = true : _isLoading = true;
    notifyListeners();

    try {
      final result = await ApiService().fetchNearbyOffers(lat: lat, lng: lng);
      if (result.isSuccess && result.data != null) {
        final list = result.data?['data'] as List<dynamic>? ?? [];
        _offers = list.map((o) => _parseOffer(o)).toList();
      } else {
        _offers = List<Offer>.from(MockData.offers);
      }
    } catch (e) {
      _offers = List<Offer>.from(MockData.offers);
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  // Listen to socket updates
  void listenToSocketEvents() {
    SocketService().onOfferUpdate((data) {
      _offers = (data as List<dynamic>).map((o) => _parseOffer(o)).toList();
      notifyListeners();
        });
  }

  void stopListening() {
    SocketService().disconnect();
  }

  Offer _parseOffer(dynamic item) {
    return Offer(
      id: item['id']?.toString() ?? '',
      businessId: item['business_id']?.toString() ?? '',
      businessName: item['business_name']?.toString() ?? '',
      title: item['title']?.toString() ?? '',
      description: item['description']?.toString() ?? '',
      discountPercent: double.tryParse(item['discount_percent']?.toString() ?? '0') ?? 0,
      expiresAt: DateTime.tryParse(item['expiresAt']?.toString() ?? '') ?? DateTime.now(),
      radiusKm: double.tryParse(item['radius_km']?.toString() ?? '0') ?? 0,
    );
  }
}
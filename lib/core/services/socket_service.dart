import 'dart:async';
import '../utils/mock_data.dart';

typedef SocketCallback = void Function(List<dynamic> data);

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  bool _connected = false;

  SocketCallback? _flashOfferCallback;
  SocketCallback? _offerUpdateCallback;
  SocketCallback? _offerExpiredCallback;

  Timer? _timer;

  // Connect to "socket"
  Future<void> connect() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _connected = true;

    // Simulate offer updates every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (_offerUpdateCallback != null && MockData.offers.isNotEmpty) {
        // Send all offers as update for demo
        _offerUpdateCallback!(MockData.offers.map((o) {
          return {
            'id': o.id,
            'business_id': o.businessId,
            'business_name': o.businessName,
            'title': o.title,
            'description': o.description,
            'discount_percent': o.discountPercent,
            'expiresAt': o.expiresAt.toIso8601String(),
            'radius_km': o.radiusKm,
          };
        }).toList());
      }
    });
  }

  // Mock subscribe to nearby offers
  void subscribeOffers({required double lat, required double lng}) {
    // no-op in mock
  }

  // Listen for flash offer events
  void onFlashOffer(SocketCallback cb) {
    _flashOfferCallback = cb;
  }

  // Listen for offer updates
  void onOfferUpdate(SocketCallback cb) {
    _offerUpdateCallback = cb;
  }

  // Listen for offer expiration
  void onOfferExpired(SocketCallback cb) {
    _offerExpiredCallback = cb;
  }

  // Stop flash offer listener
  void offFlashOffer() {
    _flashOfferCallback = null;
  }

  // Disconnect
  void disconnect() {
    _timer?.cancel();
    _connected = false;
    _flashOfferCallback = null;
    _offerUpdateCallback = null;
    _offerExpiredCallback = null;
  }
}
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _lastPosition;
  Position? get lastPosition => _lastPosition;

  // ── Permission + fetch ──────────────────────────────────────────────────

  Future<LocationResult> getCurrentLocation() async {
    // 1. Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationResult.error(
          'Location services are disabled. Enable GPS to use this feature.');
    }

    // 2. Check / request permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationResult.error('Location permission denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return LocationResult.error(
          'Location permission permanently denied. Enable it in Settings.');
    }

    // 3. Get position
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      _lastPosition = position;
      return LocationResult.success(position);
    } catch (e) {
      return LocationResult.error('Could not get location: $e');
    }
  }

  /// Stream of position updates (for live tracking)
  Stream<Position> get positionStream => Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 20,
        ),
      );

  // ── Distance calculations ───────────────────────────────────────────────

  /// Haversine distance in kilometres between two lat/lng points
  static double distanceKm({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    const earthR = 6371.0;
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthR * c;
  }

  /// Human-readable distance label  →  "320 m" / "4.2 km"
  static String distanceLabel({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    final km = distanceKm(lat1: lat1, lng1: lng1, lat2: lat2, lng2: lng2);
    if (km < 1) {
      return '${(km * 1000).toStringAsFixed(0)} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }

  /// Filter a list of items by radius, returns sorted by distance (nearest first)
  static List<T> filterByRadius<T>({
    required List<T> items,
    required double Function(T) getLat,
    required double Function(T) getLng,
    required double centerLat,
    required double centerLng,
    required double radiusKm,
  }) {
    final filtered = items.where((item) {
      final d = distanceKm(
        lat1: centerLat,
        lng1: centerLng,
        lat2: getLat(item),
        lng2: getLng(item),
      );
      return d <= radiusKm;
    }).toList();

    filtered.sort((a, b) {
      final da = distanceKm(
          lat1: centerLat,
          lng1: centerLng,
          lat2: getLat(a),
          lng2: getLng(a));
      final db = distanceKm(
          lat1: centerLat,
          lng1: centerLng,
          lat2: getLat(b),
          lng2: getLng(b));
      return da.compareTo(db);
    });

    return filtered;
  }

  static double _toRad(double deg) => deg * math.pi / 180;
}

// ── Result wrapper ──────────────────────────────────────────────────────────

class LocationResult {
  final Position? position;
  final String? error;
  final bool isSuccess;

  const LocationResult._({this.position, this.error, required this.isSuccess});

  factory LocationResult.success(Position pos) =>
      LocationResult._(position: pos, isSuccess: true);

  factory LocationResult.error(String msg) =>
      LocationResult._(error: msg, isSuccess: false);
}
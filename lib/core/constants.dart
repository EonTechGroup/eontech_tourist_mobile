class AppConstants {
  // ── Map defaults — centered on South Sri Lanka ─────────
  static const double defaultLat  = 6.0535;
  static const double defaultLng  = 80.2210;
  static const double defaultZoom = 9.0;

  // ── South Sri Lanka bounding box ───────────────────────
  static const double southLat = 5.85;
  static const double northLat = 6.80;
  static const double westLng  = 79.95;
  static const double eastLng  = 81.90;

  // ── Animation durations ────────────────────────────────
  static const Duration fast   = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow   = Duration(milliseconds: 600);

  // ── Spacing ────────────────────────────────────────────
  static const double paddingXS = 4.0;
  static const double paddingS  = 8.0;
  static const double paddingM  = 16.0;
  static const double paddingL  = 24.0;
  static const double paddingXL = 32.0;

  // ── Border radius ──────────────────────────────────────
  static const double radiusS  = 8.0;
  static const double radiusM  = 12.0;
  static const double radiusL  = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 32.0;

  // ── App info ───────────────────────────────────────────
  static const String appName        = 'South Sri Lanka';
  static const String appVersion     = '1.0.0';
  static const String packageName    = 'com.example.south_sri_lanka_app';

  // ── Map tile ───────────────────────────────────────────
  static const String mapTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String mapAttribution = '© OpenStreetMap contributors';

  // ── Asset paths ────────────────────────────────────────
  static const String image1 = 'assets/images/1.jpg';
  static const String image2 = 'assets/images/2.jpg';
  static const String image3 = 'assets/images/3.jpg';
  static const String loginBg = 'assets/images/login_bg.jpg';
}
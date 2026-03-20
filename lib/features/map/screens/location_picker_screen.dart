// ignore_for_file: prefer_const_constructors, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import '../../../core/theme.dart';
import '../../../core/constants.dart';
import '../../../core/services/location_service.dart';

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const LocationPickerScreen({super.key, this.initialLocation});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late final MapController _mapController;
  LatLng? _picked;
  bool _loadingGps = false;
  String? _gpsError;

  static const LatLng _defaultCenter = LatLng(
    AppConstants.defaultLat,
    AppConstants.defaultLng,
  );

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _picked = widget.initialLocation;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onMapTap(TapPosition _, LatLng point) {
    HapticFeedback.selectionClick();
    setState(() => _picked = point);
  }

  Future<void> _goToMyLocation() async {
    setState(() {
      _loadingGps = true;
      _gpsError = null;
    });
    final result = await LocationService().getCurrentLocation();
    if (!mounted) return;
    if (result.isSuccess) {
      final pos = result.position!;
      final ll = LatLng(pos.latitude, pos.longitude);
      _mapController.move(ll, 15);
      setState(() {
        _picked = ll;
        _loadingGps = false;
      });
    } else {
      setState(() {
        _loadingGps = false;
        _gpsError = result.error;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error ?? 'GPS error'),
            backgroundColor: AppTheme.coralRed,
          ),
        );
      }
    }
  }

  void _confirmPick() {
    if (_picked == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tap the map to drop a pin first',
            style: GoogleFonts.nunito(),
          ),
          backgroundColor: AppTheme.coralRed,
        ),
      );
      return;
    }
    Navigator.of(context).pop(_picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.initialLocation ?? _defaultCenter,
              initialZoom: widget.initialLocation != null
                  ? 15
                  : AppConstants.defaultZoom,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: AppConstants.mapTileUrl,
                userAgentPackageName: 'lk.eontech.southsrilanka',
              ),
              if (_picked != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _picked!,
                      width: 60,
                      height: 72,
                      child: const _PinWidget(),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: const _TopBar(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomPanel(
              picked: _picked,
              onConfirm: _confirmPick,
            ),
          ),
          Positioned(
            bottom: 160,
            right: 16,
            child: _GpsFab(
              loading: _loadingGps,
              onTap: _goToMyLocation,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.6),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 4),
              Text(
                'Pick Location',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinWidget extends StatelessWidget {
  const _PinWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.oceanBlue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppTheme.oceanBlue.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.location_on_rounded,
              color: Colors.white, size: 20),
        ),
        CustomPaint(
          size: const Size(16, 12),
          painter: _TrianglePainter(color: AppTheme.oceanBlue),
        ),
      ],
    ).animate().scale(
          duration: 200.ms,
          curve: Curves.elasticOut,
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
        );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  const _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2.0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter old) => old.color != color;
}

class _BottomPanel extends StatelessWidget {
  final LatLng? picked;
  final VoidCallback onConfirm;

  const _BottomPanel({required this.picked, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            picked == null
                ? 'Tap on the map to select a location'
                : 'Location selected',
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.mutedText,
            ),
          ),
          if (picked != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on_rounded,
                    size: 16, color: AppTheme.oceanBlue),
                const SizedBox(width: 4),
                Text(
                  '${picked!.latitude.toStringAsFixed(5)}, '
                  '${picked!.longitude.toStringAsFixed(5)}',
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkInk,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: picked != null
                      ? [AppTheme.oceanBlue, AppTheme.deepTeal]
                      : [AppTheme.mutedText, AppTheme.mutedText],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ElevatedButton.icon(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 20),
                label: Text(
                  'Confirm Location',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .slideY(begin: 1, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }
}

class _GpsFab extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;

  const _GpsFab({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: loading
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppTheme.oceanBlue,
                ),
              )
            : const Icon(Icons.my_location_rounded,
                color: AppTheme.oceanBlue, size: 22),
      ),
    );
  }
}
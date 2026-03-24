import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  static final UrlLauncherService _instance =
      UrlLauncherService._internal();
  factory UrlLauncherService() => _instance;
  UrlLauncherService._internal();

  // ── Phone call ──────────────────────────────────────────────────────────

  Future<bool> callPhone(String phoneNumber) async {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[\s\-()]'), '');
    final uri = Uri(scheme: 'tel', path: cleaned);
    return _launch(uri);
  }

  // ── Website ─────────────────────────────────────────────────────────────

  Future<bool> openWebsite(String url) async {
    String fullUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      fullUrl = 'https://$url';
    }
    final uri = Uri.parse(fullUrl);
    return _launch(uri, mode: LaunchMode.externalApplication);
  }

  // ── Maps / Directions ───────────────────────────────────────────────────

  Future<bool> openDirections({
    required double lat,
    required double lng,
    String? label,
  }) async {
    final query = label != null
        ? Uri.encodeComponent(label)
        : '$lat,$lng';

    // Try Google Maps first
    final googleUri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    if (await canLaunchUrl(googleUri)) {
      return _launch(googleUri, mode: LaunchMode.externalApplication);
    }

    // Fallback to geo URI
    final geoUri = Uri(scheme: 'geo', path: '$lat,$lng', query: 'q=$query');
    return _launch(geoUri);
  }

  // ── Email ───────────────────────────────────────────────────────────────

  Future<bool> sendEmail({
    required String email,
    String? subject,
    String? body,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );
    return _launch(uri);
  }

  // ── WhatsApp ─────────────────────────────────────────────────────────────

  Future<bool> openWhatsApp(String phoneNumber) async {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[\s\-+()]'), '');
    final uri = Uri.parse('https://wa.me/$cleaned');
    return _launch(uri, mode: LaunchMode.externalApplication);
  }

  // ── Internal launch ─────────────────────────────────────────────────────

  Future<bool> _launch(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: mode);
      }
      return false;
    } catch (e) {
      debugPrint('URL launch error: $e');
      return false;
    }
  }
}
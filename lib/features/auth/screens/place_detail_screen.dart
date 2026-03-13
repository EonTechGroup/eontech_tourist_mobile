import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/place.dart';
import '../../../core/theme.dart';
import '../../../core/utils/mock_data.dart';
import '../../../shared/providers/app_provider.dart';

class PlaceDetailScreen extends StatelessWidget {
  final String placeId;
  const PlaceDetailScreen({super.key, required this.placeId});

  Place? _findPlace() {
    try {
      return MockData.places.firstWhere((p) => p.id == placeId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final place = _findPlace();
    if (place == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: const Center(child: Text('Place not found')),
      );
    }

    final provider = context.watch<AppProvider>();
    final isSaved = provider.isSaved(place.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ── Hero image app bar ──────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: AppTheme.darkInk,
                ),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => provider.toggleSave(place.id),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    size: 20,
                    color: isSaved ? AppTheme.oceanBlue : AppTheme.darkInk,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'place_${place.id}',
                    child: Image.asset(
                      place.imagePaths.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppTheme.softGrey,
                        child: const Icon(
                          Icons.image,
                          size: 60,
                          color: AppTheme.mutedText,
                        ),
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.4),
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content ─────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Category + district ─────────────────
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.categoryColor(place.category),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          place.category.toUpperCase(),
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppTheme.mutedText,
                      ),
                      Text(
                        place.district,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: AppTheme.mutedText,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms),

                  const SizedBox(height: 12),

                  // ── Name ────────────────────────────────
                  Text(
                    place.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkInk,
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 80.ms),

                  const SizedBox(height: 8),

                  // ── Rating ──────────────────────────────
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: place.rating,
                        itemBuilder: (_, __) => const Icon(
                          Icons.star,
                          color: Color(0xFFFBBF24),
                        ),
                        itemCount: 5,
                        itemSize: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${place.rating} (${place.reviewCount} reviews)',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: AppTheme.mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms, delay: 120.ms),

                  const SizedBox(height: 16),

                  // ── Info chips ──────────────────────────
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.attach_money,
                        label: place.entryFee,
                        color: place.isFree
                            ? AppTheme.forestGreen
                            : AppTheme.goldenSun,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: _InfoChip(
                          icon: Icons.access_time,
                          label: place.bestTime,
                          color: AppTheme.oceanBlue,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms, delay: 160.ms),

                  const SizedBox(height: 20),

                  // ── About ───────────────────────────────
                  Text(
                    'About',
                    style: GoogleFonts.nunito(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkInk,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    place.description,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: AppTheme.mutedText,
                      height: 1.6,
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 200.ms),

                  const SizedBox(height: 20),

                  // ── Tags ────────────────────────────────
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: place.tags
                        .map((t) => _TagBadge(label: t))
                        .toList(),
                  ).animate().fadeIn(duration: 300.ms, delay: 240.ms),

                  const SizedBox(height: 24),

                  // ── Opening hours ───────────────────────
                  if (place.hours.isNotEmpty) ...[
                    Text(
                      'Opening Hours',
                      style: GoogleFonts.nunito(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkInk,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.softGrey,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: Column(
                        children: place.hours.entries
                            .map(
                              (e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      e.key,
                                      style: GoogleFonts.nunito(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.darkInk,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        e.value,
                                        style: GoogleFonts.nunito(
                                          fontSize: 13,
                                          color: AppTheme.mutedText,
                                        ),
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ).animate().fadeIn(duration: 300.ms, delay: 260.ms),
                    const SizedBox(height: 24),
                  ],

                  // ── Location map ────────────────────────
                  Text(
                    'Location',
                    style: GoogleFonts.nunito(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkInk,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 180,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            place.latitude,
                            place.longitude,
                          ),
                          initialZoom: 13,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.none,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                                'com.example.south_sri_lanka_app',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(
                                  place.latitude,
                                  place.longitude,
                                ),
                                width: 40,
                                height: 40,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: AppTheme.oceanBlue,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 280.ms),

                  const SizedBox(height: 24),

                  // ── Website button ──────────────────────
                  if (place.website != null && place.website!.isNotEmpty)
                    _ContactButton(
                      icon: Icons.language,
                      label: 'Visit Website',
                      isPrimary: false,
                      onTap: () async {
                        final uri = Uri.parse(place.website!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                    ).animate().fadeIn(duration: 300.ms, delay: 300.ms),

                  if (place.website != null && place.website!.isNotEmpty)
                    const SizedBox(height: 12),

                  // ── Call + Directions ───────────────────
                  if (place.contactNumber.isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: _ContactButton(
                            icon: Icons.phone,
                            label: 'Call',
                            onTap: () async {
                              final uri = Uri.parse(
                                'tel:${place.contactNumber}',
                              );
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ContactButton(
                            icon: Icons.directions,
                            label: 'Directions',
                            isPrimary: true,
                            onTap: () async {
                              final uri = Uri.parse(
                                'https://maps.google.com/?q='
                                '${place.latitude},${place.longitude}',
                              );
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 300.ms, delay: 320.ms),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info Chip ─────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tag Badge ─────────────────────────────────────────────────

class _TagBadge extends StatelessWidget {
  final String label;
  const _TagBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.softGrey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Text(
        label,
        style: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.darkInk,
        ),
      ),
    );
  }
}

// ── Contact Button ────────────────────────────────────────────

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ContactButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isPrimary ? AppTheme.oceanBlue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPrimary ? AppTheme.oceanBlue : AppTheme.borderColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isPrimary ? Colors.white : AppTheme.darkInk,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isPrimary ? Colors.white : AppTheme.darkInk,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
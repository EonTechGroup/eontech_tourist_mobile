import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants.dart';
import '../../../core/models/place.dart';
import '../../../core/theme.dart';

class ExploreMapView extends StatefulWidget {
  final List<Place> places;
  const ExploreMapView({super.key, required this.places});

  @override
  State<ExploreMapView> createState() => _ExploreMapViewState();
}

class _ExploreMapViewState extends State<ExploreMapView> {
  Place? _selectedPlace;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(
              AppConstants.defaultLat,
              AppConstants.defaultLng,
            ),
            initialZoom: AppConstants.defaultZoom,
            onTap: (_, __) => setState(() => _selectedPlace = null),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.south_sri_lanka_app',
            ),
            MarkerLayer(
              markers: widget.places.map((place) {
                final isSelected = _selectedPlace?.id == place.id;
                return Marker(
                  point: LatLng(place.latitude, place.longitude),
                  width: isSelected ? 48 : 40,
                  height: isSelected ? 48 : 40,
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPlace = place),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.oceanBlue
                            : AppTheme.categoryColor(place.category),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: isSelected ? 3 : 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        if (_selectedPlace != null)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _MapPlaceCard(
              place: _selectedPlace!,
              onTap: () {
                final placeId = _selectedPlace?.id;
                if (placeId != null) {
                  context.push('/explore/place/$placeId');
                }
              },
              onClose: () => setState(() => _selectedPlace = null),
            ),
          ),

        Positioned(
          bottom: 4,
          right: 8,
          child: Text(
            '© OpenStreetMap',
            style: GoogleFonts.nunito(
              fontSize: 10,
              color: AppTheme.mutedText,
            ),
          ),
        ),
      ],
    );
  }
}

class _MapPlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;
  final VoidCallback onClose;

  const _MapPlaceCard({
    required this.place,
    required this.onTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = place.imagePaths.isNotEmpty ? place.imagePaths.first : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imagePath != null
                  ? Image.asset(
                      imagePath,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 64,
                      height: 64,
                      color: AppTheme.softGrey,
                      child: const Icon(
                        Icons.image,
                        color: AppTheme.mutedText,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkInk,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    place.district,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: AppTheme.mutedText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 13, color: Color(0xFFFBBF24)),
                      const SizedBox(width: 2),
                      Text(
                        place.rating.toString(),
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkInk,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.categoryColor(place.category).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          place.category.toUpperCase(),
                          style: GoogleFonts.nunito(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.categoryColor(place.category),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.close, size: 18, color: AppTheme.mutedText),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.oceanBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'View',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
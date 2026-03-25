import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constants.dart';
import '../../../core/models/business.dart';
import '../../../core/services/url_launcher_service.dart';
import '../../../core/theme.dart';
import '../../../core/utils/mock_data.dart';

class BusinessDetailScreen extends StatefulWidget {
  final String businessId;

  const BusinessDetailScreen({super.key, required this.businessId});

  @override
  State<BusinessDetailScreen> createState() =>
      _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Business business;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    business = MockData.businesses.firstWhere(
      (b) => b.id == widget.businessId,
      orElse: () => MockData.businesses.first,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softGrey,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          _header(),
        ],
        body: Column(
          children: [
            _tabBar(),
            Expanded(child: _tabView()),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  // ───────────────── HEADER ─────────────────
  Widget _header() {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: AppTheme.oceanBlue,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            business.imageUrl.isNotEmpty
                ? Image.network(
                    business.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    business.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: business.rating,
                        itemBuilder: (_, __) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        business.rating.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppTheme.oceanBlue,
      child: const Center(
        child: Icon(Icons.store, size: 60, color: Colors.white54),
      ),
    );
  }

  // ───────────────── TAB BAR ─────────────────
  Widget _tabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.oceanBlue,
        tabs: const [
          Tab(text: "Overview"),
          Tab(text: "Offers"),
          Tab(text: "Location"),
        ],
      ),
    );
  }

  Widget _tabView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _overview(),
        _offers(),
        _location(),
      ],
    );
  }

  // ───────────────── OVERVIEW ─────────────────
  Widget _overview() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          business.description,
          style: GoogleFonts.nunito(fontSize: 14),
        ).animate().fadeIn(),
      ],
    );
  }

  // ───────────────── OFFERS ─────────────────
  Widget _offers() {
    final offers = MockData.offers
        .where((o) => o.businessId == business.id)
        .toList();

    if (offers.isEmpty) {
      return const Center(child: Text("No offers"));
    }

    return ListView.builder(
      itemCount: offers.length,
      itemBuilder: (_, i) {
        final offer = offers[i];

        return ListTile(
          title: Text(offer.title),
          subtitle: Text(offer.description),
          trailing: Text("${offer.discountPercent}%"),
        );
      },
    );
  }

  // ───────────────── LOCATION ─────────────────
  Widget _location() {
    final pos = LatLng(business.latitude, business.longitude);

    return FlutterMap(
      options: MapOptions(
        initialCenter: pos,
        initialZoom: 15,
      ),
      children: [
        TileLayer(
          urlTemplate: AppConstants.mapTileUrl,
          userAgentPackageName: 'app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: pos,
              width: 40,
              height: 40,
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 30,
              ),
            )
          ],
        ),
      ],
    );
  }

  // ───────────────── BOTTOM BAR ─────────────────
  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (business.phone.isNotEmpty)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () =>
                    UrlLauncherService().callPhone(business.phone),
                icon: const Icon(Icons.phone),
                label: const Text("Call"),
              ),
            ),

          const SizedBox(width: 12),

          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => UrlLauncherService().openDirections(
                lat: business.latitude,
                lng: business.longitude,
                label: business.name,
              ),
              icon: const Icon(Icons.map),
              label: const Text("Directions"),
            ),
          ),
        ],
      ),
    );
  }
}
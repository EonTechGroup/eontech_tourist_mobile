import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/models/place.dart';
import '../../../core/theme.dart';
import '../../../core/utils/mock_data.dart';
import '../../../shared/providers/app_provider.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../shared/widgets/place_card.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/explore_map_view.dart';
import '../widgets/search_bar_widget.dart';

import '../../../core/services/socket_service.dart';
import '../../../core/services/location_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AppProvider _provider; 
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _provider = context.read<AppProvider>();

    _tabController = TabController(length: 2, vsync: this);

    _init();
  }

  Future<void> _init() async {
    await _loadData();
    await _connectSocket();

    if (mounted) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _isLoading = false);
      });
    }
  }

  Future<void> _loadData() async {
    await _provider.fetchNearbyPlaces(refresh: false);
  }

  Future<void> _connectSocket() async {
    await SocketService().connect();

    _provider.listenToOffers();

    final pos = LocationService().lastPosition;
    if (pos != null) {
      SocketService().subscribeOffers(
        lat: pos.latitude,
        lng: pos.longitude,
      );
    }
  }

  Future<void> _onRefresh() async {
    await _provider.fetchNearbyPlaces(refresh: true);

    final pos = LocationService().lastPosition;
    if (pos != null) {
      await _provider.fetchNearbyOffers(
        lat: pos.latitude,
        lng: pos.longitude,
        refresh: true,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();

    _provider.stopListeningOffers();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final places = provider.filteredPlaces;
    final featured = provider.featuredPlaces;

    return Scaffold(
      backgroundColor: AppTheme.softGrey,
      body: SafeArea(
        child: Column(
          children: [
            _ExploreHeader(provider: provider),

            /// Search
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SearchBarWidget(onChanged: provider.setSearchQuery),
            ).animate().fadeIn(duration: 300.ms, delay: 100.ms),

            /// Categories
            CategoryFilterBar(
              selected: provider.selectedCategory,
              onSelected: provider.setCategory,
            ).animate().fadeIn(duration: 300.ms, delay: 150.ms),

            /// Tabs
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppTheme.oceanBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.mutedText,
                labelStyle: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                tabs: const [
                  Tab(text: '  🗺️  Map  '),
                  Tab(text: '  📋  List  '),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 200.ms),

            const SizedBox(height: 8),

            /// Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ExploreMapView(places: places),

                  _isLoading
                      ? const _ShimmerList()
                      : RefreshIndicator(
                          onRefresh: _onRefresh,
                          color: AppTheme.oceanBlue,
                          child: _PlaceList(
                            places: places,
                            featured: featured,
                            provider: provider,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreHeader extends StatelessWidget {
  final AppProvider provider;

  const _ExploreHeader({required this.provider});

  @override
  Widget build(BuildContext context) {
    final firstName = provider.currentUser?.name.split(' ').first ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.isLoggedIn
                      ? 'Welcome, $firstName 👋'
                      : 'Explore South Sri Lanka',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkInk,
                  ),
                ),
                Text(
                  '${provider.filteredPlaces.length} places to discover',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: AppTheme.mutedText,
                  ),
                ),
              ],
            ),
          ),
          _DistrictDropdown(
            selected: provider.selectedDistrict,
            onChanged: provider.setDistrict,
          ),
        ],
      ),
    );
  }
}

class _DistrictDropdown extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const _DistrictDropdown({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 16),
          items: MockData.districts
              .map((d) => DropdownMenuItem(value: d, child: Text(d)))
              .toList(),
          onChanged: (v) => onChanged(v ?? 'All'),
        ),
      ),
    );
  }
}

class _PlaceList extends StatelessWidget {
  final List<Place> places;
  final List<Place> featured;
  final AppProvider provider;

  const _PlaceList({
    required this.places,
    required this.featured,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const Center(child: Text('No places found'));
    }

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (featured.isNotEmpty &&
            provider.selectedCategory == 'all' &&
            provider.searchQuery.isEmpty) ...[
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('⭐ Featured'),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: featured.length,
                itemBuilder: (_, i) => PlaceCard(
                  place: featured[i],
                  animIndex: i,
                  isSaved: provider.isSaved(featured[i].id),
                  onSave: () => provider.toggleSave(featured[i].id),
                  onTap: () =>
                      context.push('/explore/place/${featured[i].id}'),
                ),
              ),
            ),
          ),
        ],
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (_, i) => PlaceCard(
                place: places[i],
                animIndex: i,
                isSaved: provider.isSaved(places[i].id),
                onSave: () => provider.toggleSave(places[i].id),
                onTap: () =>
                    context.push('/explore/place/${places[i].id}'),
              ),
              childCount: places.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
          ),
        ),
      ],
    );
  }
}

class _ShimmerList extends StatelessWidget {
  const _ShimmerList();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => LoadingShimmer.card(),
    );
  }
}
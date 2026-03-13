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

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Simulate loading
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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
            // ── Header ───────────────────────────────────
            _ExploreHeader(provider: provider),

            // ── Search bar ───────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SearchBarWidget(
                onChanged: provider.setSearchQuery,
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 100.ms),

            // ── Category filter ───────────────────────────
            CategoryFilterBar(
              selected: provider.selectedCategory,
              onSelected: provider.setCategory,
            ).animate().fadeIn(duration: 300.ms, delay: 150.ms),

            // ── Tab bar ───────────────────────────────────
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
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.mutedText,
                labelStyle: GoogleFonts.nunito(
                  fontSize: 13, fontWeight: FontWeight.w700,
                ),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: '  🗺️  Map  '),
                  Tab(text: '  📋  List  '),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 200.ms),

            const SizedBox(height: 8),

            // ── Tab content ───────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Map tab
                  ExploreMapView(places: places),

                  // List tab
                  _isLoading
                      ? _ShimmerList()
                      : _PlaceList(
                          places: places,
                          featured: featured,
                          provider: provider,
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

// ── Header ────────────────────────────────────────────────────

class _ExploreHeader extends StatelessWidget {
  final AppProvider provider;
  const _ExploreHeader({required this.provider});

  @override
  Widget build(BuildContext context) {
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
                      ? 'Welcome, ${provider.currentUser!.name.split(' ').first} 👋'
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
                    fontSize: 13, color: AppTheme.mutedText,
                  ),
                ),
              ],
            ),
          ),
          // District filter
          _DistrictDropdown(
            selected: provider.selectedDistrict,
            onChanged: provider.setDistrict,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1);
  }
}

// ── District Dropdown ─────────────────────────────────────────

class _DistrictDropdown extends StatelessWidget {
  final String selected;
  final void Function(String) onChanged;
  const _DistrictDropdown({required this.selected, required this.onChanged});

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
          icon: const Icon(Icons.keyboard_arrow_down,
              size: 16, color: AppTheme.mutedText),
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkInk,
          ),
          items: MockData.districts
              .map((d) => DropdownMenuItem(value: d, child: Text(d)))
              .toList(),
          onChanged: (v) => onChanged(v ?? 'All'),
        ),
      ),
    );
  }
}

// ── Place List ────────────────────────────────────────────────

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
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 48, color: AppTheme.mutedText),
            const SizedBox(height: 12),
            Text(
              'No places found',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.mutedText,
              ),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        // Featured section
        if (featured.isNotEmpty &&
            provider.selectedCategory == 'all' &&
            provider.searchQuery.isEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text(
                '⭐ Featured',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.darkInk,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 260,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: featured.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => SizedBox(
                  width: 220,
                  child: PlaceCard(
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'All Places',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.darkInk,
                ),
              ),
            ),
          ),
        ],

        // All places grid
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Shimmer loading list ──────────────────────────────────────

class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => LoadingShimmer.card(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../core/utils/mock_data.dart';
import '../../../shared/providers/app_provider.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final businesses = MockData.businesses;
    final offers = MockData.offers;

    return Scaffold(
      backgroundColor: AppTheme.softGrey,
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppTheme.deepTeal,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.deepTeal, AppTheme.oceanBlue],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Owner Dashboard',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Welcome back, ${provider.currentUser?.name ?? 'Owner'}',
                                  style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    color:
                                        Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                            // Avatar
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  (provider.currentUser?.name ?? 'O')
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: GoogleFonts.nunito(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
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
                ),
              ),
            ),
          ),

          // ── Stats row ────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.deepTeal,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.softGrey,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    _StatCard(
                      label: 'Listings',
                      value: '${businesses.length}',
                      icon: Icons.store_outlined,
                      color: AppTheme.oceanBlue,
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      label: 'Active Offers',
                      value: '${offers.length}',
                      icon: Icons.local_offer_outlined,
                      color: AppTheme.sunsetOrange,
                    ),
                    const SizedBox(width: 12),
                    const _StatCard(
                      label: 'Views Today',
                      value: '48',
                      icon: Icons.visibility_outlined,
                      color: AppTheme.forestGreen,
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              ),
            ),
          ),

          // ── Quick actions ─────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkInk,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickAction(
                          icon: Icons.add_business_outlined,
                          label: 'Add Listing',
                          color: AppTheme.oceanBlue,
                          onTap: () => _showCreateBusinessSheet(context),
                          index: 0,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickAction(
                          icon: Icons.flash_on_outlined,
                          label: 'Flash Offer',
                          color: AppTheme.sunsetOrange,
                          onTap: () => _showCreateOfferSheet(context),
                          index: 1,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickAction(
                          icon: Icons.analytics_outlined,
                          label: 'Analytics',
                          color: AppTheme.forestGreen,
                          onTap: () {},
                          index: 2,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickAction(
                          icon: Icons.reviews_outlined,
                          label: 'Reviews',
                          color: AppTheme.deepTeal,
                          onTap: () {},
                          index: 3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── My listings ───────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Listings',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkInk,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'See all',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.oceanBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final biz = businesses[index];
                  return _BusinessListingCard(
                    business: biz,
                    index: index,
                    onEditTap: () => _showCreateBusinessSheet(context,
                        businessName: biz.name),
                    onOfferTap: () => _showCreateOfferSheet(context),
                  );
                },
                childCount: businesses.length,
              ),
            ),
          ),

          // ── Active offers ─────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Flash Offers',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.darkInk,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showCreateOfferSheet(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.sunsetOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add,
                              size: 13, color: AppTheme.sunsetOrange),
                          const SizedBox(width: 3),
                          Text(
                            'New',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.sunsetOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final offer = offers[index];
                  return _OfferCard(offer: offer, index: index);
                },
                childCount: offers.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateBusinessSheet(BuildContext context,
      {String? businessName}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateBusinessSheet(existingName: businessName),
    );
  }

  void _showCreateOfferSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CreateOfferSheet(),
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.nunito(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppTheme.darkInk,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 11,
                color: AppTheme.mutedText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quick Action ──────────────────────────────────────────────

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final int index;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.darkInk,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(
            duration: 350.ms,
            delay: Duration(milliseconds: 200 + index * 60),
          )
          .slideY(begin: 0.1),
    );
  }
}

// ── Business Listing Card ─────────────────────────────────────

class _BusinessListingCard extends StatelessWidget {
  final dynamic business;
  final int index;
  final VoidCallback onEditTap;
  final VoidCallback onOfferTap;

  const _BusinessListingCard({
    required this.business,
    required this.index,
    required this.onEditTap,
    required this.onOfferTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Business image placeholder
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.oceanBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.store, color: AppTheme.oceanBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.name as String,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkInk,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      business.category as String,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: AppTheme.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              // Active badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.forestGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppTheme.forestGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Active',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.forestGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Info row
          Row(
            children: [
              _InfoPill(
                icon: Icons.star_rounded,
                label: '${business.rating}',
                color: AppTheme.sunsetOrange,
              ),
              const SizedBox(width: 8),
              _InfoPill(
                icon: Icons.place_outlined,
                label: business.district as String,
                color: AppTheme.oceanBlue,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: _OutlineButton(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  color: AppTheme.oceanBlue,
                  onTap: onEditTap,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _OutlineButton(
                  icon: Icons.flash_on_outlined,
                  label: 'Flash Offer',
                  color: AppTheme.sunsetOrange,
                  onTap: onOfferTap,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _OutlineButton(
                  icon: Icons.bar_chart_outlined,
                  label: 'Stats',
                  color: AppTheme.forestGreen,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: 350.ms,
          delay: Duration(milliseconds: index * 80),
        )
        .slideY(begin: 0.05);
  }
}

// ── Offer Card ────────────────────────────────────────────────

class _OfferCard extends StatefulWidget {
  final dynamic offer;
  final int index;

  const _OfferCard({required this.offer, required this.index});

  @override
  State<_OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<_OfferCard> {
  late String _timeLeft;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    final expiry = widget.offer.expiresAt as DateTime;
    final diff = expiry.difference(DateTime.now());
    if (diff.isNegative) {
      _timeLeft = 'Expired';
    } else {
      final h = diff.inHours;
      final m = diff.inMinutes % 60;
      _timeLeft = h > 0 ? '${h}h ${m}m left' : '${m}m left';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.sunsetOrange.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.sunsetOrange, Color(0xFFFF6B35)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${widget.offer.discountPercent}%',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.offer.title as String,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.darkInk,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined,
                        size: 12, color: AppTheme.sunsetOrange),
                    const SizedBox(width: 4),
                    Text(
                      _timeLeft,
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        color: AppTheme.sunsetOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.forestGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Live',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.forestGreen,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {},
                child: const Icon(Icons.more_horiz, color: AppTheme.mutedText),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: 350.ms,
          delay: Duration(milliseconds: widget.index * 80),
        );
  }
}

// ── Helper Widgets ────────────────────────────────────────────

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Create Business Sheet ─────────────────────────────────────

class _CreateBusinessSheet extends StatefulWidget {
  final String? existingName;
  const _CreateBusinessSheet({this.existingName});

  @override
  State<_CreateBusinessSheet> createState() => _CreateBusinessSheetState();
}

class _CreateBusinessSheetState extends State<_CreateBusinessSheet> {
  late final TextEditingController _nameCtrl;
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  String _selectedCategory = 'Restaurant';

  static const List<String> _categories = [
    'Restaurant', 'Accommodation', 'Tours & Activities',
    'Retail', 'Wellness & Spa', 'Water Sports',
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existingName ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              widget.existingName != null
                  ? 'Edit Listing'
                  : 'Create New Listing',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.darkInk,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Fill in your business details',
              style: GoogleFonts.nunito(
                  fontSize: 13, color: AppTheme.mutedText),
            ),
            const SizedBox(height: 20),

            _SheetField(
              label: 'Business Name',
              hint: 'e.g. Surf Shack Weligama',
              controller: _nameCtrl,
              icon: Icons.store_outlined,
            ),
            const SizedBox(height: 14),

            // Category picker
            Text(
              'Category',
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.oceanBlue
                          : AppTheme.softGrey,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.oceanBlue
                            : AppTheme.borderColor,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppTheme.darkInk,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            _SheetField(
              label: 'Description',
              hint: 'Describe your business...',
              controller: _descCtrl,
              icon: Icons.description_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 14),

            _SheetField(
              label: 'Phone Number',
              hint: '+94 77 123 4567',
              controller: _phoneCtrl,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),

            // Location picker placeholder
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.oceanBlue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.oceanBlue.withValues(alpha: 0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: AppTheme.oceanBlue),
                    const SizedBox(width: 10),
                    Text(
                      'Tap to pick location on map',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.oceanBlue,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppTheme.oceanBlue),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Save button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.deepTeal, AppTheme.oceanBlue],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.oceanBlue.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.existingName != null
                        ? 'Save Changes'
                        : 'Create Listing',
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Create Offer Sheet ────────────────────────────────────────

class _CreateOfferSheet extends StatefulWidget {
  const _CreateOfferSheet();

  @override
  State<_CreateOfferSheet> createState() => _CreateOfferSheetState();
}

class _CreateOfferSheetState extends State<_CreateOfferSheet> {
  final TextEditingController _titleCtrl = TextEditingController();
  double _discount = 20;
  double _radius = 1.0;
  int _durationHours = 2;

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.sunsetOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.flash_on,
                      color: AppTheme.sunsetOrange, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  'Create Flash Offer',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkInk,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Broadcast a limited-time deal to nearby tourists',
              style: GoogleFonts.nunito(
                  fontSize: 13, color: AppTheme.mutedText),
            ),
            const SizedBox(height: 20),

            _SheetField(
              label: 'Offer Title',
              hint: 'e.g. 20% off surf lessons today!',
              controller: _titleCtrl,
              icon: Icons.local_offer_outlined,
            ),
            const SizedBox(height: 20),

            // Discount slider
            _SliderSection(
              label: 'Discount',
              value: _discount,
              min: 5,
              max: 80,
              divisions: 15,
              displayValue: '${_discount.round()}%',
              color: AppTheme.sunsetOrange,
              onChanged: (v) => setState(() => _discount = v),
            ),

            const SizedBox(height: 16),

            // Radius slider
            _SliderSection(
              label: 'Broadcast Radius',
              value: _radius,
              min: 0.5,
              max: 10,
              divisions: 19,
              displayValue: '${_radius.toStringAsFixed(1)} km',
              color: AppTheme.oceanBlue,
              onChanged: (v) => setState(() => _radius = v),
            ),

            const SizedBox(height: 16),

            // Duration chips
            Text(
              'Duration',
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [1, 2, 4, 6, 12, 24].map((h) {
                final isSelected = _durationHours == h;
                return GestureDetector(
                  onTap: () => setState(() => _durationHours = h),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.sunsetOrange
                          : AppTheme.softGrey,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.sunsetOrange
                            : AppTheme.borderColor,
                      ),
                    ),
                    child: Text(
                      '${h}h',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color:
                            isSelected ? Colors.white : AppTheme.darkInk,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Preview pill
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.sunsetOrange.withValues(alpha: 0.08),
                    AppTheme.sunsetOrange.withValues(alpha: 0.03),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppTheme.sunsetOrange.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.preview_outlined,
                      color: AppTheme.sunsetOrange, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _titleCtrl.text.isEmpty
                          ? 'Your offer preview will appear here'
                          : '${_discount.round()}% off · ${_radius.toStringAsFixed(1)}km · ${_durationHours}h',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: AppTheme.sunsetOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Broadcast button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.sunsetOrange, Color(0xFFFF6B35)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.sunsetOrange.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.flash_on, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Broadcast Flash Offer',
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sheet Field ───────────────────────────────────────────────

class _SheetField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;

  const _SheetField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.nunito(fontSize: 14, color: AppTheme.darkInk),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.nunito(fontSize: 14, color: AppTheme.mutedText),
            prefixIcon: Icon(icon, size: 18, color: AppTheme.mutedText),
            filled: true,
            fillColor: AppTheme.softGrey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: AppTheme.oceanBlue, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}

// ── Slider Section ────────────────────────────────────────────

class _SliderSection extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String displayValue;
  final Color color;
  final void Function(double) onChanged;

  const _SliderSection({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.displayValue,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF374151),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                displayValue,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.15),
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.1),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
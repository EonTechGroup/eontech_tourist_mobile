import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/models/user.dart';
import '../../shared/providers/app_provider.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/explore'))   return 0;
    if (location.startsWith('/itinerary')) return 1;
    if (location.startsWith('/emergency')) return 2;
    if (location.startsWith('/owner'))     return 3;
    if (location.startsWith('/profile'))   return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final provider   = context.watch<AppProvider>();
    final isOwner    = provider.currentUser?.role == UserRole.businessOwner;
    final location   = GoRouterState.of(context).uri.toString();
    final currentIdx = _locationToIndex(location);

    final tab3Icon    = isOwner ? Icons.store_outlined      : Icons.local_offer_outlined;
    final tab3SelIcon = isOwner ? Icons.store               : Icons.local_offer;
    final tab3Label   = isOwner ? 'Business'                : 'Offers';
    final tab3Route   = isOwner ? '/owner'                  : '/profile';

    return Scaffold(
      extendBody: true,
      backgroundColor: AppTheme.softGrey,
      body: child,
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIdx,
        height: 62,

        // ── Colour scheme ──────────────────────────────────────────────
        color: const Color(0xFF005F87),           // slightly deeper oceanBlue
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: AppTheme.deepTeal,  // teal bubble

        animationDuration: const Duration(milliseconds: 320),
        animationCurve: Curves.easeOutCubic,

        onTap: (index) {
          // light haptic on every tap
          HapticFeedback.lightImpact();
          switch (index) {
            case 0: context.go('/explore');
            case 1: context.go('/itinerary');
            case 2:
              HapticFeedback.heavyImpact(); // extra feedback for SOS
              context.go('/emergency');
            case 3: context.go(tab3Route);
            case 4: context.go('/profile');
          }
        },

        items: [
          // ── 0  Explore ───────────────────────────────────────────────
          _NavItem(
            icon:       currentIdx == 0 ? Icons.explore        : Icons.explore_outlined,
            label:      'Explore',
            isSelected: currentIdx == 0,
          ),

          // ── 1  Itinerary ─────────────────────────────────────────────
          _NavItem(
            icon:       currentIdx == 1 ? Icons.map            : Icons.map_outlined,
            label:      'Plan',
            isSelected: currentIdx == 1,
          ),

          // ── 2  SOS — centre, always red ──────────────────────────────
          _NavItem(
            icon:        Icons.emergency_rounded,
            label:       'SOS',
            isSelected:  currentIdx == 2,
            isEmergency: true,
          ),

          // ── 3  Owner / Offers ─────────────────────────────────────────
          _NavItem(
            icon:       currentIdx == 3 ? tab3SelIcon : tab3Icon,
            label:      tab3Label,
            isSelected: currentIdx == 3,
          ),

          // ── 4  Profile ────────────────────────────────────────────────
          _NavItem(
            icon:       currentIdx == 4 ? Icons.person_rounded : Icons.person_outline_rounded,
            label:      'Profile',
            isSelected: currentIdx == 4,
          ),
        ],
      ),
    );
  }
}

// ── Nav item ─────────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String   label;
  final bool     isSelected;
  final bool     isEmergency;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isSelected   = false,
    this.isEmergency  = false,
  });

  @override
  Widget build(BuildContext context) {
    // ── Colour logic ────────────────────────────────────────────────────
    //  SOS centre button  → always white icon + coralRed label
    //  Active tab         → goldenSun icon + goldenSun label (stands out on teal bubble)
    //  Inactive tab       → white 70% opacity
    final Color iconColor;
    final Color labelColor;
    final double iconSize;

    if (isEmergency) {
      iconColor  = Colors.white;
      labelColor = AppTheme.coralRed;
      iconSize   = 28;
    } else if (isSelected) {
      iconColor  = AppTheme.softGrey;   // #FFB300 — warm gold pops on deepTeal bubble
      labelColor = AppTheme.softGrey;
      iconSize   = 26;
    } else {
      iconColor  = Colors.white.withValues(alpha: 0.75);
      labelColor = Colors.white.withValues(alpha: 0.75);
      iconSize   = 22;
    }

    return Column(
      mainAxisSize:     MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ── SOS gets a pulsing red dot badge ──────────────────────────
        if (isEmergency)
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: iconSize, color: iconColor),
              Positioned(
                top: -2, right: -4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.coralRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          )
        else
          Icon(icon, size: iconSize, color: iconColor),

        const SizedBox(height: 3),

        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize:   isEmergency ? 10 : 9,
            fontWeight: (isSelected || isEmergency)
                ? FontWeight.w800
                : FontWeight.w500,
            color:      labelColor,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
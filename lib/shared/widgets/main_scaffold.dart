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

  // ✅ Maps route → tab index
  int _locationToIndex(String location, bool isOwner) {
    if (location.startsWith('/explore')) return 0;
    if (location.startsWith('/itinerary')) return 1;
    if (location.startsWith('/emergency')) return 2;
    if (isOwner && location.startsWith('/owner')) return 3;
    if (!isOwner && location.startsWith('/offers')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isOwner = provider.currentUser?.role == UserRole.businessOwner;

    // ✅ Current route location
    final location = GoRouterState.of(context).uri.toString();
    final currentIdx = _locationToIndex(location, isOwner);

    // ✅ Dynamic tab (Owner / Offers)
    final tab3Icon =
        isOwner ? Icons.store_outlined : Icons.local_offer_outlined;
    final tab3SelIcon = isOwner ? Icons.store : Icons.local_offer;
    final tab3Label = isOwner ? 'Business' : 'Offers';
    final tab3Route = isOwner ? '/owner' : '/offers';

    return Scaffold(
      extendBody: true,
      backgroundColor: AppTheme.softGrey,

      // 🔹 Current screen
      body: child,

      // 🔻 Bottom Navigation
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: CurvedNavigationBar(
          index: currentIdx,
          height: 65,
          backgroundColor: Colors.transparent,
          color: AppTheme.deepTeal,
          buttonBackgroundColor: AppTheme.deepTeal,
          animationDuration: const Duration(milliseconds: 300),
          animationCurve: Curves.easeOutCubic,

          // ✅ Navigation using GoRouter
          onTap: (index) {
            HapticFeedback.lightImpact();

            switch (index) {
              case 0:
                context.go('/explore');
                break;

              case 1:
                context.go('/itinerary');
                break;

              case 2:
                HapticFeedback.heavyImpact();
                context.go('/emergency');
                break;

              case 3:
                context.go(tab3Route);
                break;

              case 4:
                context.go('/profile');
                break;
            }
          },

          items: [
            _NavItem(
              icon: currentIdx == 0
                  ? Icons.explore
                  : Icons.explore_outlined,
              label: 'Explore',
              isSelected: currentIdx == 0,
            ),
            _NavItem(
              icon: currentIdx == 1
                  ? Icons.map
                  : Icons.map_outlined,
              label: 'Plan',
              isSelected: currentIdx == 1,
            ),
            _NavItem(
              icon: Icons.emergency_rounded,
              label: 'SOS',
              isSelected: currentIdx == 2,
              isEmergency: true,
            ),
            _NavItem(
              icon: currentIdx == 3 ? tab3SelIcon : tab3Icon,
              label: tab3Label,
              isSelected: currentIdx == 3,
            ),
            _NavItem(
              icon: currentIdx == 4
                  ? Icons.person_rounded
                  : Icons.person_outline_rounded,
              label: 'Profile',
              isSelected: currentIdx == 4,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 🔹 Nav Item Widget
// ─────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isEmergency;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.isEmergency = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isEmergency
        ? Colors.white
        : isSelected
            ? AppTheme.softGrey
            : Colors.white.withOpacity(0.75);

    final labelColor = isEmergency
        ? AppTheme.coralRed
        : isSelected
            ? AppTheme.softGrey
            : Colors.white.withOpacity(0.75);

    final iconSize = isEmergency ? 28.0 : isSelected ? 26.0 : 22.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isEmergency)
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: iconSize, color: iconColor),
                Positioned(
                  top: -2,
                  right: -4,
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
              fontSize: isEmergency ? 10 : 9,
              fontWeight: (isSelected || isEmergency)
                  ? FontWeight.w800
                  : FontWeight.w500,
              color: labelColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
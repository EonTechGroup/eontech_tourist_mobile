import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../shared/providers/app_provider.dart';
import '../../../shared/widgets/place_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    if (!provider.isLoggedIn) {
      return _GuestProfile(onLogin: () => context.push('/login'));
    }

    final user = provider.currentUser!;
    final saved = provider.savedPlaces;

    return Scaffold(
      backgroundColor: AppTheme.softGrey,
      body: CustomScrollView(
        slivers: [
          // ── Header ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 24,
                left: 20,
                right: 20,
              ),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppTheme.oceanBlue,
                    child: Text(
                      user.name.isNotEmpty
                          ? user.name[0].toUpperCase()
                          : 'U',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ).animate().scale(duration: 400.ms),

                  const SizedBox(height: 12),

                  Text(
                    user.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkInk,
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 100.ms),

                  Text(
                    user.email,
                    style: GoogleFonts.nunito(
                      fontSize: 14, color: AppTheme.mutedText,
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 150.ms),

                  const SizedBox(height: 16),

                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatChip(
                        icon: Icons.bookmark,
                        label: '${saved.length}',
                        sublabel: 'Saved',
                        color: AppTheme.oceanBlue,
                      ),
                      const SizedBox(width: 16),
                      _StatChip(
                        icon: Icons.check_circle,
                        label: '0',
                        sublabel: 'Visited',
                        color: AppTheme.forestGreen,
                      ),
                      const SizedBox(width: 16),
                      _StatChip(
                        icon: Icons.star,
                        label: '0',
                        sublabel: 'Reviews',
                        color: AppTheme.goldenSun,
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                ],
              ),
            ),
          ),

          // ── Saved places ─────────────────────────────────
          if (saved.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Saved Places',
                  style: GoogleFonts.nunito(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.darkInk,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => PlaceCard(
                    place: saved[i],
                    isSaved: true,
                    onSave: () => provider.toggleSave(saved[i].id),
                    onTap: () =>
                        context.push('/explore/place/${saved[i].id}'),
                  ),
                  childCount: saved.length,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
              ),
            ),
          ],

          // ── Settings section ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                'Settings',
                style: GoogleFonts.nunito(
                  fontSize: 17, fontWeight: FontWeight.w800,
                  color: AppTheme.darkInk,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    label: 'Dark Mode',
                    trailing: Switch(
                      value: provider.themeMode == ThemeMode.dark,
                      onChanged: (_) => provider.toggleTheme(),
                      activeColor: AppTheme.oceanBlue,
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  _SettingsTile(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  _SettingsTile(
                    icon: Icons.language_outlined,
                    label: 'Language',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  _SettingsTile(
                    icon: Icons.info_outline,
                    label: 'About',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  _SettingsTile(
                    icon: Icons.logout,
                    label: 'Sign Out',
                    color: AppTheme.coralRed,
                    onTap: () {
                      provider.logout();
                      context.go('/login');
                    },
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 250.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// ── Stat Chip ─────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 18, fontWeight: FontWeight.w800, color: color,
            ),
          ),
          Text(
            sublabel,
            style: GoogleFonts.nunito(
              fontSize: 11, color: AppTheme.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Settings Tile ─────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? color;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppTheme.darkInk;
    return ListTile(
      leading: Icon(icon, size: 22, color: effectiveColor),
      title: Text(
        label,
        style: GoogleFonts.nunito(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: effectiveColor,
        ),
      ),
      trailing: trailing ??
          const Icon(Icons.chevron_right,
              size: 20, color: AppTheme.mutedText),
      onTap: onTap,
    );
  }
}

// ── Guest Profile ─────────────────────────────────────────────

class _GuestProfile extends StatelessWidget {
  final VoidCallback onLogin;
  const _GuestProfile({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softGrey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppTheme.oceanBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 44,
                  color: AppTheme.oceanBlue,
                ),
              ).animate().scale(duration: 400.ms),

              const SizedBox(height: 20),

              Text(
                'Sign in to unlock\nyour journey',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkInk,
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 100.ms),

              const SizedBox(height: 12),

              Text(
                'Save places, track visits,\nand plan your itinerary.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 14, color: AppTheme.mutedText, height: 1.5,
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 180.ms),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onLogin,
                  child: Text(
                    'Sign In',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 260.ms),
            ],
          ),
        ),
      ),
    );
  }
}
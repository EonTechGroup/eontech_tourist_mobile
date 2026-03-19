import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../../../core/utils/mock_data.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = MockData.emergencyContacts;

    return Scaffold(
      backgroundColor: AppTheme.softGrey,
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppTheme.coralRed,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFD32F2F), AppTheme.coralRed],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.emergency,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Emergency',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sri Lanka emergency contacts & assistance',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── SOS banner ───────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.coralRed,
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: const BoxDecoration(
                  color: AppTheme.softGrey,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: _SosBanner()
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .scale(begin: const Offset(0.95, 0.95)),
                ),
              ),
            ),
          ),

          // ── Contacts grid ─────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                'Emergency Numbers',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.darkInk,
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.55,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final contact = contacts[index];
                  return _ContactCard(
                    contact: contact,
                    index: index,
                  );
                },
                childCount: contacts.length,
              ),
            ),
          ),

          // ── Safety tips ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Text(
                'Safety Tips',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.darkInk,
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SafetyTip(
                  icon: Icons.local_hospital_outlined,
                  title: 'Nearest Hospital',
                  body: 'Karapitiya Teaching Hospital in Galle is the main referral hospital for Southern Province.',
                  color: AppTheme.coralRed,
                  index: 0,
                ),
                _SafetyTip(
                  icon: Icons.water_outlined,
                  title: 'Ocean Safety',
                  body: 'Always swim where lifeguards are present. Rip currents are common near Mirissa and Tangalle.',
                  color: AppTheme.oceanBlue,
                  index: 1,
                ),
                _SafetyTip(
                  icon: Icons.bug_report_outlined,
                  title: 'Wildlife Caution',
                  body: 'Never approach wild elephants or leopards. Keep windows closed near Yala buffer zones.',
                  color: AppTheme.forestGreen,
                  index: 2,
                ),
                _SafetyTip(
                  icon: Icons.thermostat_outlined,
                  title: 'Heat & Humidity',
                  body: 'Drink at least 3L of water daily. Avoid midday sun between 11am–3pm in dry season.',
                  color: AppTheme.sunsetOrange,
                  index: 3,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── SOS Banner ────────────────────────────────────────────────

class _SosBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD32F2F), AppTheme.coralRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.coralRed.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'National Emergency',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '119',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Police • Ambulance • Fire',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.heavyImpact();
              // TODO: launch phone dialer
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.call, color: AppTheme.coralRed, size: 26),
                  const SizedBox(height: 4),
                  Text(
                    'Call Now',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.coralRed,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Contact Card ──────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  final Map<String, String> contact;
  final int index;

  const _ContactCard({
    required this.contact,
    required this.index,
  });

  Color _colorFor(String name) {
    if (name.contains('Police')) return AppTheme.oceanBlue;
    if (name.contains('Ambulance') || name.contains('Hospital')) {
      return AppTheme.coralRed;
    }
    if (name.contains('Fire')) return AppTheme.sunsetOrange;
    if (name.contains('Tourist')) return AppTheme.forestGreen;
    if (name.contains('Coast')) return AppTheme.deepTeal;
    return AppTheme.mutedText;
  }

  IconData _iconFor(String name) {
    if (name.contains('Police')) return Icons.local_police_outlined;
    if (name.contains('Ambulance') || name.contains('Hospital')) {
      return Icons.local_hospital_outlined;
    }
    if (name.contains('Fire')) return Icons.local_fire_department_outlined;
    if (name.contains('Tourist')) return Icons.support_agent_outlined;
    if (name.contains('Coast')) return Icons.sailing_outlined;
    return Icons.phone_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final name = contact['name'] ?? '';
    final number = contact['number'] ?? '';
    final color = _colorFor(name);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // TODO: launch dialer with number
      },
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(_iconFor(name), size: 16, color: color),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.call, size: 10, color: color),
                      const SizedBox(width: 3),
                      Text(
                        'Call',
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkInk,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  number,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: color,
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
            delay: Duration(milliseconds: index * 50),
          )
          .slideY(begin: 0.1),
    );
  }
}

// ── Safety Tip ────────────────────────────────────────────────

class _SafetyTip extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Color color;
  final int index;

  const _SafetyTip({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.darkInk,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: AppTheme.mutedText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: 350.ms,
          delay: Duration(milliseconds: index * 60),
        )
        .slideX(begin: -0.05);
  }
}
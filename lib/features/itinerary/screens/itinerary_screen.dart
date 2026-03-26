import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../shared/providers/app_provider.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  int _selectedDay = 1;
  static const int _totalDays = 5;

  final Map<int, List<_ItineraryEntry>> _itinerary = {
    1: [
      const _ItineraryEntry(
        '09:00',
        'Galle Fort',
        'Start at the iconic Dutch fort',
        Icons.fort,
        AppTheme.oceanBlue,
        true,
      ),
      const _ItineraryEntry(
        '12:30',
        'Unawatuna Beach',
        'Lunch & swimming at the bay',
        Icons.beach_access,
        AppTheme.sunsetOrange,
        false,
      ),
      const _ItineraryEntry(
        '17:00',
        'Jungle Beach',
        'Hidden gem for sunset views',
        Icons.landscape,
        AppTheme.forestGreen,
        false,
      ),
    ],
    2: [
      const _ItineraryEntry(
        '08:00',
        'Mirissa Beach',
        'Morning surf session',
        Icons.surfing,
        AppTheme.oceanBlue,
        true,
      ),
      const _ItineraryEntry(
        '14:00',
        'Whale Watching',
        'Blue whale season tour',
        Icons.sailing,
        AppTheme.deepTeal,
        false,
      ),
    ],
    3: [
      const _ItineraryEntry(
        '06:00',
        'Yala National Park',
        'Safari — leopard territory',
        Icons.pets,
        AppTheme.sunsetOrange,
        true,
      ),
      const _ItineraryEntry(
        '16:00',
        'Kataragama Temple',
        'Sacred pilgrimage site',
        Icons.temple_hindu,
        AppTheme.coralRed,
        false,
      ),
    ],
    4: [
      const _ItineraryEntry(
        '10:00',
        'Sinharaja Forest',
        'UNESCO World Heritage rainforest',
        Icons.forest,
        AppTheme.forestGreen,
        true,
      ),
    ],
    5: [
      const _ItineraryEntry(
        '09:00',
        'Tangalle Beach',
        'Relaxed farewell morning',
        Icons.beach_access,
        AppTheme.oceanBlue,
        false,
      ),
      const _ItineraryEntry(
        '15:00',
        'Rekawa Turtle Watch',
        'Nesting site evening tour',
        Icons.spa,
        AppTheme.deepTeal,
        true,
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final entries = _itinerary[_selectedDay] ?? [];

    return Scaffold(
      backgroundColor: AppTheme.softGrey,
      body: CustomScrollView(
        slivers: [
          //Header 
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: AppTheme.oceanBlue,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.oceanBlue, AppTheme.deepTeal],
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
                            Text(
                              'My Itinerary',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            _AddButton(onTap: () => _showAddDialog(context)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'South Sri Lanka · $_totalDays-Day Trip',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

        
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.oceanBlue,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.softGrey,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Day',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.mutedText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 52,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _totalDays,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final day = i + 1;
                          final isSelected = _selectedDay == day;
                          final count = _itinerary[day]?.length ?? 0;

                          return GestureDetector(
                            onTap: () => setState(() => _selectedDay = day),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),

                             
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),

                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.oceanBlue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.oceanBlue
                                      : AppTheme.borderColor,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppTheme.oceanBlue.withOpacity(
                                            0.3,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : [],
                              ),

                              
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Day $day',
                                      style: GoogleFonts.nunito(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: isSelected
                                            ? Colors.white
                                            : AppTheme.darkInk,
                                      ),
                                    ),
                                    if (count > 0)
                                      Text(
                                        '$count stops',
                                        style: GoogleFonts.nunito(
                                          fontSize: 10,
                                          color: isSelected
                                              ? Colors.white.withOpacity(0.8)
                                              : AppTheme.mutedText,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //Stats Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                children: [
                  _StatChip(
                    icon: Icons.place_outlined,
                    label: '${entries.length} stops',
                    color: AppTheme.oceanBlue,
                  ),
                  const SizedBox(width: 8),
                  _StatChip(
                    icon: Icons.bookmark_outline,
                    label: '${provider.savedPlaces.length} saved',
                    color: AppTheme.sunsetOrange,
                  ),
                  const SizedBox(width: 8),
                  _StatChip(
                    icon: Icons.check_circle_outline,
                    label: '${provider.visitedCount} visited',
                    color: AppTheme.forestGreen,
                  ),
                ],
              ),
            ),
          ),

          //Timeline List
          entries.isEmpty
              ? SliverFillRemaining(
                  child: _EmptyDay(
                    day: _selectedDay,
                    onAdd: () => _showAddDialog(context),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final entry = entries[index];
                      final isLast = index == entries.length - 1;
                      return _TimelineCard(
                        entry: entry,
                        isLast: isLast,
                        index: index,
                      );
                    }, childCount: entries.length),
                  ),
                ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (_) => _AddStopSheet(selectedDay: _selectedDay),
    );
  }
}


//Timeline Card
class _TimelineCard extends StatelessWidget {
  final _ItineraryEntry entry;
  final bool isLast;
  final int index;

  const _TimelineCard({
    required this.entry,
    required this.isLast,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Timeline Column (FIXED) ──────────────
            SizedBox(
              width: 56,
              child: Column(
                mainAxisSize: MainAxisSize.max, 
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    entry.time,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.mutedText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isLast ? Colors.transparent : AppTheme.borderColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            //Card
            Expanded(
              child:
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: entry.isHighlight
                          ? Border.all(
                              color: entry.color.withOpacity(0.4),
                              width: 1.5,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: entry.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(entry.icon, color: entry.color, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.name,
                                      style: GoogleFonts.nunito(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.darkInk,
                                      ),
                                    ),
                                  ),
                                  if (entry.isHighlight)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: entry.color.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Highlight',
                                        style: GoogleFonts.nunito(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: entry.color,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                entry.description,
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: AppTheme.mutedText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.drag_indicator,
                          color: AppTheme.borderColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(
                    duration: 350.ms,
                    delay: Duration(milliseconds: index * 60),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

//Add Button
class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              'Add Stop',
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Stat Chip
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

//Empty Day
class _EmptyDay extends StatelessWidget {
  final int day;
  final VoidCallback onAdd;

  const _EmptyDay({required this.day, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.oceanBlue.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.map_outlined,
              size: 32,
              color: AppTheme.oceanBlue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No stops for Day $day',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkInk,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add places from the Explore tab',
            style: GoogleFonts.nunito(fontSize: 13, color: AppTheme.mutedText),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.oceanBlue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Add Stop',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Add Stop Bottom Sheet
class _AddStopSheet extends StatelessWidget {
  final int selectedDay;
  const _AddStopSheet({required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    final bottomPadding =
        MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom +
        16;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            'Add Stop — Day $selectedDay',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkInk,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Go to Explore tab to add saved places to your itinerary',
            style: GoogleFonts.nunito(fontSize: 13, color: AppTheme.mutedText),
          ),
          const SizedBox(height: 20),

        
          GestureDetector(
            onTap: () {
              // Close bottom sheet
              Navigator.of(context, rootNavigator: true).pop();

              // Navigate to Explore tab
              context.read<AppProvider>().setTab(1);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.oceanBlue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  'Got it',
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Data Model
class _ItineraryEntry {
  final String time;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool isHighlight;

  const _ItineraryEntry(
    this.time,
    this.name,
    this.description,
    this.icon,
    this.color,
    this.isHighlight,
  );
}

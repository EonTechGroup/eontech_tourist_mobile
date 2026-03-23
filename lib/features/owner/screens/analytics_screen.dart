import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';

class AnalyticsScreen extends StatefulWidget {
  final String businessName;
  const AnalyticsScreen({super.key, required this.businessName});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedRange = 7; // days

  // ── Mock data ─────────────────────────────────────────────────────────
  final List<_DayView> _viewsData = [
    const _DayView('Mon', 42), const _DayView('Tue', 78), const _DayView('Wed', 55),
    const _DayView('Thu', 91), const _DayView('Fri', 123), const _DayView('Sat', 148),
    const _DayView('Sun', 105),
  ];

  final List<_StatItem> _kpis = [
    const _StatItem('Total Views', '632', Icons.visibility_rounded, AppTheme.oceanBlue, '+12%'),
    const _StatItem('Saves', '89', Icons.bookmark_rounded, AppTheme.deepTeal, '+5%'),
    const _StatItem('Offer Clicks', '214', Icons.local_offer_rounded, Color(0xFFF57F17), '+34%'),
    const _StatItem('Directions', '47', Icons.directions_rounded, AppTheme.forestGreen, '+8%'),
  ];

  final List<_SourceItem> _sources = [
    const _SourceItem('Map Discovery', 0.44, AppTheme.oceanBlue),
    const _SourceItem('Flash Offers', 0.28, Color(0xFFF57F17)),
    const _SourceItem('Search', 0.18, AppTheme.deepTeal),
    const _SourceItem('Direct Link', 0.10, AppTheme.forestGreen),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: AppTheme.deepTeal,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
            ),
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
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Analytics',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )),
                        Text(widget.businessName,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.8),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Date range chips ──────────────────────────────────
                  _RangeSelector(
                    selected: _selectedRange,
                    onChanged: (v) => setState(() => _selectedRange = v),
                  ),
                  const SizedBox(height: 20),

                  // ── KPI grid ──────────────────────────────────────────
                  const _SectionTitle('Performance'),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _kpis.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.4,
                    ),
                    itemBuilder: (_, i) =>
                        _KpiCard(item: _kpis[i], index: i),
                  ),
                  const SizedBox(height: 24),

                  // ── Views bar chart ───────────────────────────────────
                  const _SectionTitle('Daily Views'),
                  const SizedBox(height: 12),
                  _BarChart(data: _viewsData),
                  const SizedBox(height: 24),

                  // ── Traffic sources ───────────────────────────────────
                  const _SectionTitle('Traffic Sources'),
                  const SizedBox(height: 12),
                  _SourcesList(sources: _sources),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Range Selector ───────────────────────────────────────────────────────────

class _RangeSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _RangeSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final options = [7, 30, 90];
    final labels = ['7 days', '30 days', '90 days'];
    return Row(
      children: List.generate(options.length, (i) {
        final active = selected == options[i];
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onChanged(options[i]),
            child: AnimatedContainer(
              duration: 200.ms,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: active ? AppTheme.oceanBlue : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? AppTheme.oceanBlue : AppTheme.borderColor,
                ),
              ),
              child: Text(
                labels[i],
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : AppTheme.mutedText,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── KPI Card ─────────────────────────────────────────────────────────────────

class _KpiCard extends StatelessWidget {
  final _StatItem item;
  final int index;
  const _KpiCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.color, size: 18),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.forestGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.change,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.forestGreen,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.value,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkInk,
                ),
              ),
              Text(
                item.label,
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: AppTheme.mutedText,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate(delay: (index * 80).ms)
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, end: 0);
  }
}

// ── Bar Chart ────────────────────────────────────────────────────────────────

class _BarChart extends StatelessWidget {
  final List<_DayView> data;
  const _BarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxVal = data.map((e) => e.views).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.asMap().entries.map((entry) {
                final i = entry.key;
                final d = entry.value;
                final ratio = d.views / maxVal;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${d.views}',
                          style: GoogleFonts.nunito(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.mutedText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400 + i * 60),
                          curve: Curves.easeOut,
                          height: 120 * ratio,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppTheme.oceanBlue,
                                AppTheme.deepTeal,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: data
                .map((d) => Expanded(
                      child: Text(
                        d.day,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          color: AppTheme.mutedText,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ── Traffic Sources ───────────────────────────────────────────────────────────

class _SourcesList extends StatelessWidget {
  final List<_SourceItem> sources;
  const _SourcesList({required this.sources});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: sources.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(s.label,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkInk,
                        )),
                    Text('${(s.ratio * 100).toStringAsFixed(0)}%',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: s.color,
                        )),
                  ],
                ),
                const SizedBox(height: 6),
                LayoutBuilder(builder: (_, constraints) {
                  return Stack(children: [
                    Container(
                      height: 8,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        color: AppTheme.softGrey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500 + i * 100),
                      height: 8,
                      width: constraints.maxWidth * s.ratio,
                      decoration: BoxDecoration(
                        color: s.color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ]);
                }),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Section Title ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.playfairDisplay(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppTheme.darkInk,
        ));
  }
}

// ── Data models ───────────────────────────────────────────────────────────────

class _StatItem {
  final String label, value, change;
  final IconData icon;
  final Color color;
  const _StatItem(this.label, this.value, this.icon, this.color, this.change);
}

class _DayView {
  final String day;
  final int views;
  const _DayView(this.day, this.views);
}

class _SourceItem {
  final String label;
  final double ratio;
  final Color color;
  const _SourceItem(this.label, this.ratio, this.color);
}
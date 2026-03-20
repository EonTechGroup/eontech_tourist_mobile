import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';

class ReviewsScreen extends StatefulWidget {
  final String businessName;
  const ReviewsScreen({super.key, required this.businessName});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  String _filter = 'All';

  // ── Mock reviews ────────────────────────────────────────────────────────
  final List<_Review> _reviews = [
    _Review(
      id: 'r1',
      name: 'Priya Sharma',
      initials: 'PS',
      avatarColor: const Color(0xFF7B1FA2),
      rating: 5,
      date: '2 days ago',
      text: 'Absolutely stunning place! The staff was incredibly friendly and the views were breathtaking. Will definitely visit again on my next trip to Sri Lanka.',
      reply: null,
    ),
    _Review(
      id: 'r2',
      name: 'James Miller',
      initials: 'JM',
      avatarColor: AppTheme.oceanBlue,
      rating: 4,
      date: '1 week ago',
      text: 'Great experience overall. The flash offer we found was amazing value. Only minor issue was parking.',
      reply: 'Thank you James! We\'re working on improving the parking situation. Hope to see you again!',
    ),
    _Review(
      id: 'r3',
      name: 'Yuki Tanaka',
      initials: 'YT',
      avatarColor: AppTheme.deepTeal,
      rating: 5,
      date: '2 weeks ago',
      text: 'Perfect for sunset watching. The location is simply magical and very photogenic.',
      reply: null,
    ),
    _Review(
      id: 'r4',
      name: 'Sarah O\'Brien',
      initials: 'SO',
      avatarColor: const Color(0xFFE64A19),
      rating: 3,
      date: '3 weeks ago',
      text: 'Decent spot but gets very crowded on weekends. Better to visit on weekdays for a more peaceful experience.',
      reply: null,
    ),
    _Review(
      id: 'r5',
      name: 'Arjun Patel',
      initials: 'AP',
      avatarColor: AppTheme.forestGreen,
      rating: 5,
      date: '1 month ago',
      text: 'One of the best places I visited in my South Sri Lanka tour. Highly recommend the morning visit.',
      reply: 'Thank you Arjun! Morning is indeed the best time — glad you enjoyed it!',
    ),
  ];

  List<_Review> get _filtered {
    if (_filter == 'All') return _reviews;
    if (_filter == 'Replied') return _reviews.where((r) => r.reply != null).toList();
    if (_filter == 'Pending') return _reviews.where((r) => r.reply == null).toList();
    final stars = int.tryParse(_filter[0]);
    if (stars != null) return _reviews.where((r) => r.rating == stars).toList();
    return _reviews;
  }

  double get _avgRating {
    if (_reviews.isEmpty) return 0;
    return _reviews.map((r) => r.rating).reduce((a, b) => a + b) / _reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: AppTheme.oceanBlue,
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
                    colors: [AppTheme.oceanBlue, AppTheme.deepTeal],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Reviews',
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
                        // Avg rating badge
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              _avgRating.toStringAsFixed(1),
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            RatingBarIndicator(
                              rating: _avgRating,
                              itemBuilder: (_, __) =>
                                  const Icon(Icons.star_rounded,
                                      color: AppTheme.goldenSun),
                              itemCount: 5,
                              itemSize: 16,
                            ),
                            Text(
                              '${_reviews.length} reviews',
                              style: GoogleFonts.nunito(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.7),
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

          // ── Filter chips ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', '5★', '4★', '3★', 'Replied', 'Pending']
                      .map((f) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => setState(() => _filter = f),
                              child: AnimatedContainer(
                                duration: 200.ms,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                  color: _filter == f
                                      ? AppTheme.oceanBlue
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _filter == f
                                        ? AppTheme.oceanBlue
                                        : AppTheme.borderColor,
                                  ),
                                ),
                                child: Text(
                                  f,
                                  style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _filter == f
                                        ? Colors.white
                                        : AppTheme.mutedText,
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),

          // ── Review cards ─────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final r = _filtered[index];
                  return _ReviewCard(
                    review: r,
                    index: index,
                    onReply: (text) =>
                        setState(() => r.reply = text),
                  );
                },
                childCount: _filtered.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Review Card ───────────────────────────────────────────────────────────────

class _ReviewCard extends StatefulWidget {
  final _Review review;
  final int index;
  final ValueChanged<String> onReply;

  const _ReviewCard({
    required this.review,
    required this.index,
    required this.onReply,
  });

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _showReplyBox = false;
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submitReply() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    widget.onReply(text);
    setState(() => _showReplyBox = false);
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.review;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
        children: [
          // ── Reviewer header ────────────────────────────────────────────
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: r.avatarColor,
                child: Text(r.initials,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    )),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.name,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkInk,
                        )),
                    Text(r.date,
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: AppTheme.mutedText,
                        )),
                  ],
                ),
              ),
              RatingBarIndicator(
                rating: r.rating.toDouble(),
                itemBuilder: (_, __) =>
                    const Icon(Icons.star_rounded, color: AppTheme.goldenSun),
                itemCount: 5,
                itemSize: 14,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Review text ────────────────────────────────────────────────
          Text(r.text,
              style: GoogleFonts.nunito(
                fontSize: 13,
                height: 1.5,
                color: AppTheme.darkInk,
              )),

          // ── Existing reply ─────────────────────────────────────────────
          if (r.reply != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.softGrey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppTheme.oceanBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.storefront_rounded,
                        color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Owner reply',
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.oceanBlue,
                            )),
                        const SizedBox(height: 2),
                        Text(r.reply!,
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              height: 1.4,
                              color: AppTheme.darkInk,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Reply actions ──────────────────────────────────────────────
          const SizedBox(height: 10),
          if (!_showReplyBox && r.reply == null)
            GestureDetector(
              onTap: () => setState(() => _showReplyBox = true),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.reply_rounded,
                      size: 16, color: AppTheme.oceanBlue),
                  const SizedBox(width: 4),
                  Text('Reply',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.oceanBlue,
                      )),
                ],
              ),
            ),

          if (_showReplyBox) ...[
            const SizedBox(height: 8),
            TextField(
              controller: _ctrl,
              maxLines: 3,
              style: GoogleFonts.nunito(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Write your reply...',
                hintStyle: GoogleFonts.nunito(
                    color: AppTheme.mutedText, fontSize: 13),
                filled: true,
                fillColor: AppTheme.softGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppTheme.oceanBlue, width: 2),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton(
                  onPressed: () => setState(() => _showReplyBox = false),
                  child: Text('Cancel',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: AppTheme.mutedText,
                      )),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _submitReply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.oceanBlue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Post Reply',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ],
        ],
      ),
    )
        .animate(delay: (widget.index * 80).ms)
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.15, end: 0);
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

class _Review {
  final String id, name, initials, date, text;
  final Color avatarColor;
  final int rating;
  String? reply;

  _Review({
    required this.id,
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.rating,
    required this.date,
    required this.text,
    this.reply,
  });
}
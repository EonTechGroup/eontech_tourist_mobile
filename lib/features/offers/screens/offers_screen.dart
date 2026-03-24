import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../../../core/utils/mock_data.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Update countdown every minute
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _getTimeLeft(DateTime expiresAt) {
    final timeLeft = expiresAt.difference(DateTime.now());
    if (timeLeft.isNegative) return 'Expired';
    final hours = timeLeft.inHours;
    final minutes = timeLeft.inMinutes % 60;
    return hours > 0 ? '${hours}h ${minutes}m left' : '${minutes}m left';
  }

  @override
  Widget build(BuildContext context) {
    final offers = MockData.offers; // List of offers

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
        backgroundColor: AppTheme.sunsetOrange,
      ),
      backgroundColor: AppTheme.softGrey,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: offers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final offer = offers[index];
          final business = MockData.businesses.firstWhere(
            (b) => b.id == offer.businessId,
            orElse: () => MockData.businesses.first,
          );

          final timeLeftLabel = _getTimeLeft(offer.expiresAt);

          return GestureDetector(
            onTap: () => context.go('/offers/${offer.id}'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.oceanBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.local_offer_rounded,
                        color: AppTheme.oceanBlue, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.title,
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.darkInk,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${offer.discountPercent}% OFF at ${business.name}',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: AppTheme.mutedText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.forestGreen,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'LIVE',
                                style: GoogleFonts.nunito(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              timeLeftLabel,
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                color: AppTheme.mutedText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 16, color: AppTheme.mutedText),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
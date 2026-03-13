import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const LoadingShimmer({
    super.key,
    required this.height,
    this.width,
    this.borderRadius = 12,
  });

  // ── Pre-built: place card placeholder ─────────────────
  static Widget card() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8F0),
      highlightColor: const Color(0xFFF8FAFC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          const SizedBox(height: 10),

          // Title placeholder
          Container(
            height: 14,
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          const SizedBox(height: 6),

          // Subtitle placeholder
          Container(
            height: 11,
            width: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          const SizedBox(height: 6),

          // Rating placeholder
          Container(
            height: 11,
            width: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  // ── Pre-built: list tile placeholder ──────────────────
  static Widget listTile() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8F0),
      highlightColor: const Color(0xFFF8FAFC),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Avatar placeholder
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(width: 12),

            // Text placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 11,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Pre-built: text line placeholder ──────────────────
  static Widget line({double width = double.infinity, double height = 14}) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8F0),
      highlightColor: const Color(0xFFF8FAFC),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // ── Pre-built: full page loader ────────────────────────
  static Widget page() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Shimmer.fromColors(
            baseColor: const Color(0xFFE2E8F0),
            highlightColor: const Color(0xFFF8FAFC),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 24,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Grid of cards
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: 6,
              itemBuilder: (_, __) => card(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Generic shimmer box ────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8F0),
      highlightColor: const Color(0xFFF8FAFC),
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_OnboardingPage> _pages = [
    _OnboardingPage(
      tag: 'BEACHES & WILDLIFE',
      title: 'Discover Southern\nSri Lanka',
      subtitle: 'Pristine beaches, whale watching,\nand ancient forts await you.',
      imagePath: 'assets/images/1.jpg',
      accentColor: Color(0xFF006994),
    ),
    _OnboardingPage(
      tag: 'AI POWERED',
      title: 'Smart Trip\nPlanner',
      subtitle: 'Get personalized itineraries\ncrafted by AI just for you.',
      imagePath: 'assets/images/2.jpg',
      accentColor: Color(0xFF00897B),
    ),
    _OnboardingPage(
      tag: 'ALL-IN-ONE',
      title: 'Book Everything\nSeamlessly',
      subtitle: 'Hotels, tours, and restaurants —\nall in one place, instantly.',
      imagePath: 'assets/images/3.jpg',
      accentColor: Color(0xFFE53935),
    ),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //PageView─
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, i) {
              final p = _pages[i];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(p.imagePath, fit: BoxFit.cover),
                  ColoredBox(
                    color: p.accentColor.withValues(alpha: 0.08),
                  ),
                ],
              );
            },
          ),

          // Bottom gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.25),
                    Colors.black.withValues(alpha: 0.88),
                  ],
                  stops: const [0.3, 0.55, 1.0],
                ),
              ),
            ),
          ),

          //   Skip button 
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, right: 20),
                child: TextButton(
                  onPressed: widget.onComplete,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 8,
                    ),
                  ),
                  child: Text(
                    'Skip',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ).animate().fadeIn(delay: 500.ms),
              ),
            ),
          ),

          //  Page counter top-left
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 24),
              child: Text(
                '${_currentPage + 1} / ${_pages.length}',
                style: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.0,
                ),
              ).animate().fadeIn(delay: 500.ms),
            ),
          ),

          // Bottom content panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag chip
                    _TagChip(label: page.tag, color: page.accentColor)
                        .animate(key: ValueKey('tag_$_currentPage'))
                        .fadeIn(duration: 300.ms)
                        .slideX(begin: -0.15, end: 0),

                    const SizedBox(height: 14),

                    // Title
                    Text(
                      page.title,
                      style: GoogleFonts.poppins(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    )
                        .animate(key: ValueKey('title_$_currentPage'))
                        .fadeIn(duration: 400.ms, delay: 80.ms)
                        .slideY(begin: 0.15, end: 0),

                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      page.subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.white.withValues(alpha: 0.72),
                        height: 1.55,
                      ),
                    )
                        .animate(key: ValueKey('sub_$_currentPage'))
                        .fadeIn(duration: 400.ms, delay: 160.ms)
                        .slideY(begin: 0.15, end: 0),

                    const SizedBox(height: 36),

                    // Dots + button row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: _pages.length,
                          effect: ExpandingDotsEffect(
                            activeDotColor: Colors.white,
                            dotColor: Colors.white.withValues(alpha: 0.35),
                            dotHeight: 8,
                            dotWidth: 8,
                            expansionFactor: 3,
                            spacing: 6,
                          ),
                        ),
                        _currentPage == _pages.length - 1
                            ? _GetStartedButton(
                                accentColor: page.accentColor,
                                onTap: _nextPage,
                              )
                                .animate(key: const ValueKey('last_btn'))
                                .fadeIn(duration: 300.ms)
                                .scale(begin: const Offset(0.9, 0.9))
                            : _CircleNextButton(
                                accentColor: page.accentColor,
                                onTap: _nextPage,
                              )
                                .animate(key: ValueKey('btn_$_currentPage'))
                                .fadeIn(duration: 300.ms)
                                .scale(begin: const Offset(0.9, 0.9)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Tag Chip 

class _TagChip extends StatelessWidget {
  final String label;
  final Color color;
  const _TagChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// Circle Next Button 

class _CircleNextButton extends StatelessWidget {
  final Color accentColor;
  final VoidCallback onTap;
  const _CircleNextButton({required this.accentColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_forward_rounded,
          color: accentColor,
          size: 24,
        ),
      ),
    );
  }
}

// Get Started Button 

class _GetStartedButton extends StatelessWidget {
  final Color accentColor;
  final VoidCallback onTap;
  const _GetStartedButton({required this.accentColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Get Started',
              style: GoogleFonts.poppins(
                color: accentColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_rounded,
              color: accentColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

//  Data Model

class _OnboardingPage {
  final String tag;
  final String title;
  final String subtitle;
  final String imagePath;
  final Color accentColor;

  const _OnboardingPage({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.accentColor,
  });
}
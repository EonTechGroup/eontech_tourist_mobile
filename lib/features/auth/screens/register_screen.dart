import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme.dart';
import '../../../shared/providers/app_provider.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _agreedToTerms = false;
  String _selectedNationality = 'Other';

  static const List<String> _nationalities = [
    'Sri Lankan',
    'British',
    'German',
    'French',
    'Australian',
    'American',
    'Indian',
    'Chinese',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                'Please agree to Terms & Privacy Policy',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.coralRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    context.read<AppProvider>().login(
      _emailController.text.trim(),
      _nameController.text.trim(),
    );
    context.go('/explore');
  }

  Future<void> _googleSignIn() async {
    setState(() => _isGoogleLoading = true);
    // TODO: implement Google Sign-In
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isGoogleLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(
              'Google Sign-In coming soon!',
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.darkInk,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softGrey,
      body: CustomScrollView(
        slivers: [
          // ── Curved header ─────────────────────────────
          // ── Image header ──────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.28,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(36),
                    ),
                    child: Image.asset(
                      'assets/images/reg_bg.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Gradient overlay
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(36),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.25),
                            Colors.black.withValues(alpha: 0.65),
                          ],
                        ),
                      ),
                    ),
                  ),

                  

                  // Header text
                  Positioned(
                    bottom: 28,
                    left: 28,
                    right: 28,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Account',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2),
                        const SizedBox(height: 4),
                        Text(
                          'Join thousands exploring South Sri Lanka',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 80.ms),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Form body ─────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Progress steps ──────────────────
                    const _StepIndicator().animate().fadeIn(
                      duration: 400.ms,
                      delay: 100.ms,
                    ),

                    const SizedBox(height: 20),

                    // ── Form card ───────────────────────
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _SectionLabel(
                            icon: Icons.person_outline,
                            label: 'Personal Details',
                          ),
                          const SizedBox(height: 14),

                          // Full name
                          CustomTextField(
                            label: 'Full Name',
                            hint: 'John Doe',
                            controller: _nameController,
                            prefixIcon: Icons.person_outline,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Enter your name';
                              }
                              return null;
                            },
                          ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

                          const SizedBox(height: 14),

                          // Email
                          CustomTextField(
                            label: 'Email Address',
                            hint: 'you@example.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Enter your email';
                              }
                              if (!v.contains('@')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                          const SizedBox(height: 14),

                          // Password
                          CustomTextField(
                            label: 'Password',
                            hint: '••••••••',
                            controller: _passwordController,
                            isPassword: true,
                            prefixIcon: Icons.lock_outline,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Enter a password';
                              }
                              if (v.length < 6) return 'Min 6 characters';
                              return null;
                            },
                          ).animate().fadeIn(duration: 400.ms, delay: 250.ms),

                          const SizedBox(height: 14),

                          // Nationality
                          _NationalityDropdown(
                            selected: _selectedNationality,
                            nationalities: _nationalities,
                            onChanged: (v) => setState(
                              () => _selectedNationality = v ?? 'Other',
                            ),
                          ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Terms checkbox ──────────────────
                    _TermsCheckbox(
                      value: _agreedToTerms,
                      onChanged: (v) =>
                          setState(() => _agreedToTerms = v ?? false),
                    ).animate().fadeIn(duration: 400.ms, delay: 340.ms),

                    const SizedBox(height: 20),

                    // ── Create account button ───────────
                    CustomButton(
                      label: 'Create Account',
                      onPressed: _register,
                      isLoading: _isLoading,
                      icon: Icons.person_add_outlined,
                    ).animate().fadeIn(duration: 400.ms, delay: 380.ms),

                    const SizedBox(height: 20),

                    // ── Or divider ──────────────────────
                    Row(
                      children: [
                        const Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            'or sign up with',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.mutedText,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(thickness: 1)),
                      ],
                    ).animate().fadeIn(duration: 400.ms, delay: 410.ms),

                    const SizedBox(height: 16),

                    // ── Google button ───────────────────
                    _GoogleButton(
                      isLoading: _isGoogleLoading,
                      onTap: _googleSignIn,
                    ).animate().fadeIn(duration: 400.ms, delay: 440.ms),

                    const SizedBox(height: 28),

                    // ── Sign in link ────────────────────
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: AppTheme.mutedText,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.oceanBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 470.ms),
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

// ── Step Indicator ────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _Step(number: '1', label: 'Details', isActive: true, isDone: false),
        _StepLine(isActive: false),
        _Step(number: '2', label: 'Verify', isActive: false, isDone: false),
        _StepLine(isActive: false),
        _Step(number: '3', label: 'Done', isActive: false, isDone: false),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  final String number;
  final String label;
  final bool isActive;
  final bool isDone;

  const _Step({
    required this.number,
    required this.label,
    required this.isActive,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.oceanBlue
                : isDone
                ? AppTheme.forestGreen
                : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive
                  ? AppTheme.oceanBlue
                  : isDone
                  ? AppTheme.forestGreen
                  : AppTheme.borderColor,
              width: 2,
            ),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    number,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isActive ? Colors.white : AppTheme.mutedText,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isActive ? AppTheme.oceanBlue : AppTheme.mutedText,
          ),
        ),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool isActive;
  const _StepLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.oceanBlue : AppTheme.borderColor,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// ── Section Label ─────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppTheme.oceanBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppTheme.oceanBlue),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppTheme.darkInk,
          ),
        ),
      ],
    );
  }
}

// ── Nationality Dropdown ──────────────────────────────────────

class _NationalityDropdown extends StatelessWidget {
  final String selected;
  final List<String> nationalities;
  final void Function(String?) onChanged;

  const _NationalityDropdown({
    required this.selected,
    required this.nationalities,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nationality',
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.flag_outlined,
                size: 20,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  value: selected,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF9CA3AF),
                  ),
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: AppTheme.darkInk,
                  ),
                  items: nationalities
                      .map(
                        (n) => DropdownMenuItem(
                          value: n,
                          child: Text(
                            n,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: AppTheme.darkInk,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Terms Checkbox ────────────────────────────────────────────

class _TermsCheckbox extends StatelessWidget {
  final bool value;
  final void Function(bool?) onChanged;

  const _TermsCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: value
              ? AppTheme.oceanBlue.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value ? AppTheme.oceanBlue : AppTheme.borderColor,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: value ? AppTheme.oceanBlue : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value ? AppTheme.oceanBlue : AppTheme.borderColor,
                  width: 2,
                ),
              ),
              child: value
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: AppTheme.mutedText,
                  ),
                  children: [
                    const TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.oceanBlue,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.oceanBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Google Button ─────────────────────────────────────────────

class _GoogleButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _GoogleButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.mutedText,
                    ),
                  ),
                ),
              )
            : Row(
                children: [
                  // Google logo box
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CustomPaint(painter: _GoogleLogoPainter()),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Continue with Google',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.darkInk,
                          ),
                        ),
                        Text(
                          'Fast & secure sign up',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            color: AppTheme.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Arrow
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.softGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppTheme.mutedText,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Google Logo Painter ───────────────────────────────────────

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const segments = [
      [270.0, 90.0, Color(0xFF4285F4)],
      [180.0, 90.0, Color(0xFFEA4335)],
      [135.0, 45.0, Color(0xFFFBBC05)],
      [90.0, 45.0, Color(0xFF34A853)],
    ];

    for (final seg in segments) {
      final paint = Paint()
        ..color = seg[2] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.18;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.72),
        (seg[0] as double) * 3.14159 / 180,
        (seg[1] as double) * 3.14159 / 180,
        false,
        paint,
      );
    }

    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = size.width * 0.18
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx, center.dy),
      Offset(center.dx + radius * 0.72, center.dy),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

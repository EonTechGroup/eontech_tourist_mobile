import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';

class SearchBarWidget extends StatelessWidget {
  final void Function(String) onChanged;

  const SearchBarWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: GoogleFonts.nunito(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search beaches, temples, wildlife...',
          hintStyle: GoogleFonts.nunito(
            fontSize: 14, color: AppTheme.mutedText,
          ),
          prefixIcon: const Icon(
            Icons.search, color: AppTheme.mutedText, size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14,
          ),
        ),
      ),
    );
  }
}
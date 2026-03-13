import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme.dart';
import '../../../core/utils/mock_data.dart';

class CategoryFilterBar extends StatelessWidget {
  final String selected;
  final void Function(String) onSelected;

  const CategoryFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        scrollDirection: Axis.horizontal,
        itemCount: MockData.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = MockData.categories[i];
          final isSelected = selected == cat['id'];
          return GestureDetector(
            onTap: () => onSelected(cat['id'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.oceanBlue : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.oceanBlue
                      : AppTheme.borderColor,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(cat['icon'] as String,
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    cat['label'] as String,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppTheme.darkInk,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
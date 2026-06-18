import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Top bar showing the project title, back button, and image counter.
class GalleryHeader extends StatelessWidget {
  final String title;
  final int currentIndex;
  final int total;

  const GalleryHeader({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 6, 16, 6),
      decoration: BoxDecoration(
        color: const Color(0xFF080E1A),
        border: Border(
          bottom: BorderSide(color: AppColors.primary.withValues(alpha: 0.18)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.white),
            tooltip: 'Back',
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          _CounterBadge(current: currentIndex + 1, total: total),
        ],
      ),
    );
  }
}

class _CounterBadge extends StatelessWidget {
  final int current;
  final int total;
  const _CounterBadge({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
      ),
      child: Text(
        '$current / $total',
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_localizations.dart';

/// Shared error placeholder shown when an image fails to load.
class GalleryImageError extends StatelessWidget {
  const GalleryImageError({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1C2840),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.broken_image_outlined, size: 60, color: Colors.white24),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.translate('image_not_available'),
            style: const TextStyle(color: Colors.white30, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

/// Small "Tap to zoom" badge shown over the main gallery image.
class GalleryZoomHint extends StatelessWidget {
  const GalleryZoomHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.zoom_out_map_rounded, size: 14, color: Colors.white54),
          const SizedBox(width: 6),
          Text(
            AppLocalizations.of(context)!.translate('tap_to_zoom'),
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

/// Horizontal pill-shaped technology chips row.
class GalleryTechChips extends StatelessWidget {
  final List<String> technologies;
  const GalleryTechChips({super.key, required this.technologies});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: technologies.map((tech) => _Chip(label: tech)).toList(),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.primary.withValues(alpha: 0.9),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

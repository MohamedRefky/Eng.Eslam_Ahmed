import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Horizontal scrollable strip of thumbnail images.
class GalleryThumbnailStrip extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final ScrollController scrollController;
  final ValueChanged<int> onTap;

  const GalleryThumbnailStrip({
    super.key,
    required this.images,
    required this.currentIndex,
    required this.scrollController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF060B14),
        border: Border(
          top: BorderSide(color: AppColors.primary.withValues(alpha: 0.1)),
        ),
      ),
      child: ListView.separated(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) => _ThumbItem(
          imagePath: images[index],
          selected: index == currentIndex,
          onTap: () => onTap(index),
        ),
      ),
    );
  }
}

class _ThumbItem extends StatelessWidget {
  final String imagePath;
  final bool selected;
  final VoidCallback onTap;

  const _ThumbItem({
    required this.imagePath,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          width: selected ? 76 : 64,
          height: selected ? 76 : 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppColors.primary : Colors.white.withValues(alpha: 0.12),
              width: selected ? 2.5 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.45),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 260),
              opacity: selected ? 1.0 : 0.4,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const _ThumbError(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThumbError extends StatelessWidget {
  const _ThumbError();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1C2840),
      child: const Icon(Icons.broken_image_outlined, size: 22, color: Colors.white24),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Circular arrow button used for navigation in both the gallery and lightbox.
///
/// Pass [size] 46 for gallery, 50 for lightbox.
class GalleryArrow extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const GalleryArrow({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 46,
  });

  @override
  State<GalleryArrow> createState() => _GalleryArrowState();
}

class _GalleryArrowState extends State<GalleryArrow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hovered
                ? AppColors.primary.withValues(alpha: 0.22)
                : Colors.black.withValues(alpha: 0.55),
            border: Border.all(
              color: _hovered
                  ? AppColors.primary.withValues(alpha: 0.65)
                  : Colors.white.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          child: Icon(
            widget.icon,
            color: _hovered ? AppColors.primary : Colors.white,
            size: widget.size * 0.43,
          ),
        ),
      ),
    );
  }
}

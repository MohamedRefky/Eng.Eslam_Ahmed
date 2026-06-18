import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../pages/project_gallery_page.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> technologies;
  final List<String> galleryImages;
  final String? playStoreUrl;
  final String? githubUrl;
  final String? liveDemoUrl;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.technologies,
    this.galleryImages = const [],
    this.playStoreUrl,
    this.githubUrl,
    this.liveDemoUrl,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool isHovered = false;


  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isHovered
              ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                    spreadRadius: -2,
                  ),
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                    spreadRadius: -2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: ResponsiveBreakpoints.of(context).isMobile
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        transform: isHovered
            ? (Matrix4.identity()
                ..setEntry(3, 2, 0.0015)
                ..multiply(Matrix4.translationValues(0.0, -8.0, 0.0))
                ..rotateX(-0.02)
                ..rotateY(0.012))
            : Matrix4.identity(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(1.2), // acts as border width
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image Section — fixed height
              SizedBox(
                height: 220,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // The actual project image — static, no zoom
                    widget.imageUrl.startsWith('http')
                        ? Image.network(widget.imageUrl, fit: BoxFit.cover)
                        : Image.asset(widget.imageUrl, fit: BoxFit.cover),

                    // Subtle bottom gradient
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Hover overlay — semi-transparent dark with View Gallery button in center
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 280),
                      opacity: isHovered ? 1.0 : 0.0,
                      child: IgnorePointer(
                        ignoring: !isHovered,
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.38),
                          child: Center(
                            child: widget.galleryImages.isNotEmpty
                                ? _GalleryOverlayButton(
                                    imageCount: widget.galleryImages.length,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (_, anim, _) => ProjectGalleryPage(
                                            title: widget.title,
                                            description: widget.description,
                                            technologies: widget.technologies,
                                            images: widget.galleryImages,
                                          ),
                                          transitionsBuilder: (_, anim, _, child) {
                                            return FadeTransition(
                                              opacity: CurvedAnimation(
                                                parent: anim,
                                                curve: Curves.easeOut,
                                              ),
                                              child: ScaleTransition(
                                                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                                                  CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
                                                ),
                                                child: child,
                                              ),
                                            );
                                          },
                                          transitionDuration: const Duration(milliseconds: 380),
                                        ),
                                      );
                                    },
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),

                    // Floating Glassmorphic Photo Badge (Top-Right) — always visible
                    if (widget.galleryImages.isNotEmpty)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.photo_library_rounded,
                                    size: 13,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${widget.galleryImages.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Info Section — natural height
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title with sliding underline on hover
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          height: 3,
                          width: isHovered ? 64 : 0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1.5),
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.technologies
                        .map(
                          (tech) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              tech,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

// ─────────────────────────────────────────────────────────────────────────────
//  Gallery Overlay Button (shown in center of image on hover)
// ─────────────────────────────────────────────────────────────────────────────

class _GalleryOverlayButton extends StatefulWidget {
  final VoidCallback onTap;
  final int imageCount;

  const _GalleryOverlayButton({
    required this.onTap,
    required this.imageCount,
  });

  @override
  State<_GalleryOverlayButton> createState() => _GalleryOverlayButtonState();
}

class _GalleryOverlayButtonState extends State<_GalleryOverlayButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: _hovered
                    ? const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null,
                color: _hovered ? null : Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: _hovered
                      ? Colors.transparent
                      : Colors.white.withValues(alpha: 0.5),
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _hovered ? Icons.photo_library_rounded : Icons.photo_library_outlined,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'View Gallery',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: _hovered ? 0.28 : 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.imageCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}



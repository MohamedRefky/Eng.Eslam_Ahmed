import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../buttons/primary_button.dart';
import '../buttons/outline_button.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Future<void> _launchUrl(String? urlString) async {
    if (urlString == null) return;
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [
                  BoxShadow(
                    color: ResponsiveBreakpoints.of(context).isMobile
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
          border: Border.all(
            color: isHovered
                ? AppColors.primary.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1,
          ),
        ),
        transform: isHovered
            ? Matrix4.translationValues(0.0, -8.0, 0.0)
            : Matrix4.identity(),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Section — fixed height
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // The actual project image — vivid, no darkening
                  AnimatedScale(
                    duration: const Duration(milliseconds: 500),
                    scale: isHovered ? 1.08 : 1.0,
                    child: widget.imageUrl.startsWith('http')
                        ? Image.network(widget.imageUrl, fit: BoxFit.cover)
                        : Image.asset(widget.imageUrl, fit: BoxFit.cover),
                  ),
                  // Subtle bottom gradient — doesn't wash out image
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.55),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // GitHub button — appears on hover (desktop) or always on mobile
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isHovered ? 1.0 : 0.0,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.35),
                      child: Center(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            if (widget.githubUrl != null)
                              OutlineButton(
                                text: 'GitHub',
                                icon: const FaIcon(
                                  FontAwesomeIcons.github,
                                  size: 16,
                                ),
                                onPressed: () => _launchUrl(widget.githubUrl),
                              ),
                            if (widget.liveDemoUrl != null)
                              PrimaryButton(
                                text: 'Live Demo',
                                icon: const Icon(Icons.open_in_new, size: 16),
                                onPressed: () =>
                                    _launchUrl(widget.liveDemoUrl),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Mobile: GitHub icon button at bottom right (always visible)
                  if (widget.githubUrl != null)
                    Positioned(
                      bottom: 10,
                      right: 12,
                      child: Builder(
                        builder: (context) {
                          final isMobile = ResponsiveBreakpoints.of(context).isMobile;
                          if (!isMobile) return const SizedBox.shrink();
                          return GestureDetector(
                            onTap: () => _launchUrl(widget.githubUrl),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(FontAwesomeIcons.github, size: 14, color: Colors.white),
                                  SizedBox(width: 6),
                                  Text('GitHub', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          );
                        },
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

                  // View Gallery button
                  if (widget.galleryImages.isNotEmpty) ...[  
                    const SizedBox(height: 14),
                    _ViewGalleryButton(
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
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 1),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: anim,
                                  curve: Curves.easeOutCubic,
                                )),
                                child: child,
                              );
                            },
                            transitionDuration: const Duration(milliseconds: 450),
                          ),
                        );
                      },
                      imageCount: widget.galleryImages.length,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  View Gallery Button
// ─────────────────────────────────────────────────────────────────────────────

class _ViewGalleryButton extends StatefulWidget {
  final VoidCallback onTap;
  final int imageCount;

  const _ViewGalleryButton({
    required this.onTap,
    required this.imageCount,
  });

  @override
  State<_ViewGalleryButton> createState() => _ViewGalleryButtonState();
}

class _ViewGalleryButtonState extends State<_ViewGalleryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: _hovered
                ? const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: _hovered ? null : AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered
                  ? Colors.transparent
                  : AppColors.primary.withValues(alpha: 0.35),
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_library_rounded,
                size: 16,
                color: _hovered ? Colors.white : AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'View Gallery',
                style: TextStyle(
                  color: _hovered ? Colors.white : AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _hovered
                      ? Colors.white.withValues(alpha: 0.25)
                      : AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${widget.imageCount}',
                  style: TextStyle(
                    color: _hovered ? Colors.white : AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: _hovered ? Colors.white : AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

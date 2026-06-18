import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/gallery/gallery_header.dart';
import '../widgets/gallery/gallery_arrow.dart';
import '../widgets/gallery/gallery_thumbnail_strip.dart';
import '../widgets/gallery/gallery_widgets.dart';
import '../widgets/gallery/lightbox_viewer.dart';
import '../core/theme/app_colors.dart';

/// Full-screen project gallery page.
///
/// Displays a swipeable [PageView] of project images with a thumbnail strip,
/// keyboard navigation, and a tap-to-zoom lightbox.
class ProjectGalleryPage extends StatefulWidget {
  final String title;
  final String description;
  final List<String> technologies;
  final List<String> images;

  const ProjectGalleryPage({
    super.key,
    required this.title,
    required this.description,
    required this.technologies,
    required this.images,
  });

  @override
  State<ProjectGalleryPage> createState() => _ProjectGalleryPageState();
}

class _ProjectGalleryPageState extends State<ProjectGalleryPage> {
  int _currentIndex = 0;
  late final PageController _pageController;
  final ScrollController _thumbScrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _thumbScrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    if (index < 0 || index >= widget.images.length) return;
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOut,
    );
    _scrollThumbIntoView(index);
  }

  void _scrollThumbIntoView(int index) {
    if (!_thumbScrollController.hasClients) return;
    const itemWidth = 84.0;
    final target = (index * itemWidth) - 150.0;
    _thumbScrollController.animateTo(
      target.clamp(0.0, _thumbScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _openLightbox(int index) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close lightbox',
      barrierColor: Colors.black.withValues(alpha: 0.96),
      transitionDuration: const Duration(milliseconds: 220),
      transitionBuilder: (_, anim, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
        child: child,
      ),
      pageBuilder: (_, _, _) => LightboxViewer(
        images: widget.images,
        initialIndex: index,
        title: widget.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF080E1A),
      body: SafeArea(
        child: KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: (event) {
            if (event is! KeyDownEvent) return;
            if (event.logicalKey == LogicalKeyboardKey.arrowRight) _goTo(_currentIndex + 1);
            if (event.logicalKey == LogicalKeyboardKey.arrowLeft) _goTo(_currentIndex - 1);
            if (event.logicalKey == LogicalKeyboardKey.escape) Navigator.pop(context);
          },
          child: Column(
            children: [
              GalleryHeader(
                title: widget.title,
                currentIndex: _currentIndex,
                total: widget.images.length,
              ),

              Expanded(child: _buildMainImage(isMobile)),

              GalleryThumbnailStrip(
                images: widget.images,
                currentIndex: _currentIndex,
                scrollController: _thumbScrollController,
                onTap: _goTo,
              ),

              if (widget.technologies.isNotEmpty) ...[
                const SizedBox(height: 10),
                GalleryTechChips(technologies: widget.technologies),
              ],

              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainImage(bool isMobile) {
    return Stack(
      children: [
        // Ambient glow
        Positioned.fill(
          child: Center(
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.primary.withValues(alpha: 0.05), Colors.transparent],
                ),
              ),
            ),
          ),
        ),

        // Swipeable main image
        PageView.builder(
          controller: _pageController,
          itemCount: widget.images.length,
          onPageChanged: (i) => setState(() => _currentIndex = i),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => _openLightbox(index),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 32,
                vertical: 12,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  widget.images[index],
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const GalleryImageError(),
                ),
              ),
            ),
          ),
        ),

        // Navigation arrows (desktop only)
        if (!isMobile && _currentIndex > 0)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: GalleryArrow(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => _goTo(_currentIndex - 1),
              ),
            ),
          ),
        if (!isMobile && _currentIndex < widget.images.length - 1)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GalleryArrow(
                icon: Icons.arrow_forward_ios_rounded,
                onTap: () => _goTo(_currentIndex + 1),
              ),
            ),
          ),

        // Zoom hint
        Positioned(
          bottom: 16,
          right: isMobile ? 12 : 44,
          child: const GalleryZoomHint(),
        ),
      ],
    );
  }
}

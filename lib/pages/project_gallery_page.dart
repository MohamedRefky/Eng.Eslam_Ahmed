import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  ProjectGalleryPage
// ─────────────────────────────────────────────────────────────────────────────

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
    const itemWidth = 84.0; // thumb 72 + gap 12
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
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
        child: child,
      ),
      pageBuilder: (_, __, ___) => _LightboxDialog(
        images: widget.images,
        initialIndex: index,
        title: widget.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

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
              // ── Top Header ──────────────────────────────────────────
              _Header(
                title: widget.title,
                currentIndex: _currentIndex,
                total: widget.images.length,
              ),

              // ── Main Image ──────────────────────────────────────────
              Expanded(
                child: Stack(
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
                              colors: [
                                AppColors.primary.withValues(alpha: 0.05),
                                Colors.transparent,
                              ],
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
                      itemBuilder: (context, index) {
                        return GestureDetector(
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
                                errorBuilder: (_, __, ___) =>
                                    const _ImageError(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Prev arrow
                    if (!isMobile && _currentIndex > 0)
                      _GalleryArrow(
                        icon: Icons.arrow_back_ios_new_rounded,
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 12),
                        onTap: () => _goTo(_currentIndex - 1),
                      ),

                    // Next arrow
                    if (!isMobile && _currentIndex < widget.images.length - 1)
                      _GalleryArrow(
                        icon: Icons.arrow_forward_ios_rounded,
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(right: 12),
                        onTap: () => _goTo(_currentIndex + 1),
                      ),

                    // Zoom hint badge
                    Positioned(
                      bottom: 16,
                      right: isMobile ? 12 : 44,
                      child: _ZoomHint(),
                    ),
                  ],
                ),
              ),

              // ── Thumbnail Strip ─────────────────────────────────────
              _ThumbnailStrip(
                images: widget.images,
                currentIndex: _currentIndex,
                scrollController: _thumbScrollController,
                onTap: _goTo,
              ),

              // ── Tech Chips ──────────────────────────────────────────
              if (widget.technologies.isNotEmpty) ...[
                const SizedBox(height: 10),
                _TechChips(technologies: widget.technologies),
              ],

              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Header
// ─────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String title;
  final int currentIndex;
  final int total;

  const _Header({
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
          bottom: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.18),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Colors.white,
            ),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.35),
              ),
            ),
            child: Text(
              '${currentIndex + 1} / $total',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Gallery Arrow Button
// ─────────────────────────────────────────────────────────────────────────────

class _GalleryArrow extends StatefulWidget {
  final IconData icon;
  final Alignment alignment;
  final EdgeInsets margin;
  final VoidCallback onTap;

  const _GalleryArrow({
    required this.icon,
    required this.alignment,
    required this.margin,
    required this.onTap,
  });

  @override
  State<_GalleryArrow> createState() => _GalleryArrowState();
}

class _GalleryArrowState extends State<_GalleryArrow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: Padding(
        padding: widget.margin,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 46,
              height: 46,
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
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Zoom Hint
// ─────────────────────────────────────────────────────────────────────────────

class _ZoomHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.zoom_out_map_rounded, size: 14, color: Colors.white54),
          SizedBox(width: 6),
          Text(
            'Tap to zoom',
            style: TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Thumbnail Strip
// ─────────────────────────────────────────────────────────────────────────────

class _ThumbnailStrip extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final ScrollController scrollController;
  final ValueChanged<int> onTap;

  const _ThumbnailStrip({
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
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected
                      ? AppColors.primary
                      : Colors.white.withValues(alpha: 0.1),
                  width: selected ? 2.5 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.45),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: selected ? 1.0 : 0.45,
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF1C2840),
                      child: const Icon(
                        Icons.broken_image_outlined,
                        size: 22,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Tech Chips
// ─────────────────────────────────────────────────────────────────────────────

class _TechChips extends StatelessWidget {
  final List<String> technologies;
  const _TechChips({required this.technologies});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: technologies.map((tech) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.22),
              ),
            ),
            child: Text(
              tech,
              style: TextStyle(
                color: AppColors.primary.withValues(alpha: 0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Image Error Placeholder
// ─────────────────────────────────────────────────────────────────────────────

class _ImageError extends StatelessWidget {
  const _ImageError();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1C2840),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, size: 60, color: Colors.white24),
          SizedBox(height: 10),
          Text(
            'Image not available',
            style: TextStyle(color: Colors.white30, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Lightbox Dialog
// ─────────────────────────────────────────────────────────────────────────────

class _LightboxDialog extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String title;

  const _LightboxDialog({
    required this.images,
    required this.initialIndex,
    required this.title,
  });

  @override
  State<_LightboxDialog> createState() => _LightboxDialogState();
}

class _LightboxDialogState extends State<_LightboxDialog> {
  late int _index;
  late final PageController _ctrl;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _ctrl = PageController(initialPage: widget.initialIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _go(int index) {
    if (index < 0 || index >= widget.images.length) return;
    setState(() => _index = index);
    _ctrl.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final total = widget.images.length;
    final dotsCount = total.clamp(0, 20);

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is! KeyDownEvent) return;
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) _go(_index + 1);
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) _go(_index - 1);
        if (event.logicalKey == LogicalKeyboardKey.escape) Navigator.pop(context);
      },
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Dismiss tap background
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),

            // Swipeable image with pinch-zoom
            PageView.builder(
              controller: _ctrl,
              itemCount: total,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () {}, // prevent dismiss when tapping image
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 0 : 56,
                      vertical: 56,
                    ),
                    child: InteractiveViewer(
                      minScale: 0.8,
                      maxScale: 6.0,
                      child: Image.asset(
                        widget.images[i],
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const _ImageError(),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Top Bar ──────────────────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 10, 16, 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.85),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        '${_index + 1} / $total',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Prev Arrow ───────────────────────────────────────────
            if (!isMobile && _index > 0)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: _LightboxArrow(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => _go(_index - 1),
                  ),
                ),
              ),

            // ── Next Arrow ───────────────────────────────────────────
            if (!isMobile && _index < total - 1)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _LightboxArrow(
                    icon: Icons.arrow_forward_ios_rounded,
                    onTap: () => _go(_index + 1),
                  ),
                ),
              ),

            // ── Dot Indicator ────────────────────────────────────────
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(dotsCount, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 22 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.primary
                          : Colors.white.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Lightbox Arrow Button
// ─────────────────────────────────────────────────────────────────────────────

class _LightboxArrow extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _LightboxArrow({required this.icon, required this.onTap});

  @override
  State<_LightboxArrow> createState() => _LightboxArrowState();
}

class _LightboxArrowState extends State<_LightboxArrow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hovered
                ? AppColors.primary.withValues(alpha: 0.28)
                : Colors.white.withValues(alpha: 0.1),
            border: Border.all(
              color: _hovered
                  ? AppColors.primary.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Icon(
            widget.icon,
            color: _hovered ? AppColors.primary : Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}

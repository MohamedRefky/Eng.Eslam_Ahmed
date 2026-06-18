import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import 'gallery_arrow.dart';
import 'gallery_widgets.dart';

/// Full-screen lightbox dialog for viewing images with pinch-zoom,
/// swipe navigation, keyboard arrow keys, and animated dot indicators.
class LightboxViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String title;

  const LightboxViewer({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.title,
  });

  @override
  State<LightboxViewer> createState() => _LightboxViewerState();
}

class _LightboxViewerState extends State<LightboxViewer> {
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
    _ctrl.animateToPage(index,
        duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final total = widget.images.length;

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
            // Dismiss tap area
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),

            // Swipeable zoomable images
            PageView.builder(
              controller: _ctrl,
              itemCount: total,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () {}, // block dismiss when tapping image
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
                        errorBuilder: (_, _, _) => const GalleryImageError(),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Top gradient bar
            Positioned(
              top: 0, left: 0, right: 0,
              child: _LightboxTopBar(
                title: widget.title,
                current: _index + 1,
                total: total,
              ),
            ),

            // Prev arrow
            if (!isMobile && _index > 0)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: GalleryArrow(
                    icon: Icons.arrow_back_ios_new_rounded,
                    size: 50,
                    onTap: () => _go(_index - 1),
                  ),
                ),
              ),

            // Next arrow
            if (!isMobile && _index < total - 1)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GalleryArrow(
                    icon: Icons.arrow_forward_ios_rounded,
                    size: 50,
                    onTap: () => _go(_index + 1),
                  ),
                ),
              ),

            // Dot indicator
            Positioned(
              bottom: 20, left: 0, right: 0,
              child: _DotIndicator(
                count: total.clamp(0, 20),
                activeIndex: _index,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

class _LightboxTopBar extends StatelessWidget {
  final String title;
  final int current;
  final int total;

  const _LightboxTopBar({
    required this.title,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.85), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
            ),
            child: Text(
              '$current / $total',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int count;
  final int activeIndex;

  const _DotIndicator({required this.count, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 22 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.white.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

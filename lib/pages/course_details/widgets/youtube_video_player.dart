import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// A premium YouTube video player widget for Flutter Web.
///
/// Shows a YouTube video thumbnail with an animated play button overlay.
/// On click, embeds the YouTube video via iframe for inline playback.
/// Supports fullscreen via YouTube's native controls.
class YouTubeVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const YouTubeVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<YouTubeVideoPlayer>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  bool _isHovering = false;
  late final String _videoId;
  late final String _viewType;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _videoId = _extractVideoId(widget.videoUrl);
    _viewType = 'youtube-player-$_videoId-$hashCode';

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  /// Extracts video ID from various YouTube URL formats.
  String _extractVideoId(String url) {
    // Handle shorts URL: youtube.com/shorts/VIDEO_ID
    final shortsRegex = RegExp(r'youtube\.com\/shorts\/([a-zA-Z0-9_-]+)');
    final shortsMatch = shortsRegex.firstMatch(url);
    if (shortsMatch != null) return shortsMatch.group(1)!;

    // Handle standard URL: youtube.com/watch?v=VIDEO_ID
    final standardRegex = RegExp(r'[?&]v=([a-zA-Z0-9_-]+)');
    final standardMatch = standardRegex.firstMatch(url);
    if (standardMatch != null) return standardMatch.group(1)!;

    // Handle embed URL: youtube.com/embed/VIDEO_ID
    final embedRegex = RegExp(r'youtube\.com\/embed\/([a-zA-Z0-9_-]+)');
    final embedMatch = embedRegex.firstMatch(url);
    if (embedMatch != null) return embedMatch.group(1)!;

    // Handle youtu.be short URL
    final shortUrlRegex = RegExp(r'youtu\.be\/([a-zA-Z0-9_-]+)');
    final shortUrlMatch = shortUrlRegex.firstMatch(url);
    if (shortUrlMatch != null) return shortUrlMatch.group(1)!;

    return url; // Fallback: assume it's already a video ID
  }

  void _registerAndPlay() {
    // Register the platform view with the iframe
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        final iframe = web.document.createElement('iframe') as web.HTMLIFrameElement;
        iframe.src =
            'https://www.youtube.com/embed/$_videoId?autoplay=1&rel=0&modestbranding=1&playsinline=1';
        iframe.style.border = 'none';
        iframe.style.width = '100%';
        iframe.style.height = '100%';
        iframe.style.borderRadius = '12px';
        iframe.allow =
            'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; fullscreen';
        iframe.allowFullscreen = true;
        return iframe;
      },
    );

    setState(() => _isPlaying = true);
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(12);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.35),
              blurRadius: 30,
              spreadRadius: 2,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 20,
              offset: const Offset(4, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(-2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: _isPlaying ? _buildPlayer() : _buildThumbnail(),
        ),
      ),
    );
  }

  /// Builds the embedded YouTube iframe player.
  Widget _buildPlayer() {
    return HtmlElementView(viewType: _viewType);
  }

  /// Builds the video thumbnail preview with play button overlay.
  Widget _buildThumbnail() {
    return GestureDetector(
      onTap: _registerAndPlay,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── YouTube thumbnail image ──────────────────────────────────────
          Image.network(
            'https://img.youtube.com/vi/$_videoId/maxresdefault.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Image.network(
              'https://img.youtube.com/vi/$_videoId/hqdefault.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xFF1a1a2e),
                child: const Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.white38,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),

          // ── Dark gradient overlay ────────────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: _isHovering ? 0.15 : 0.25),
                  Colors.black.withValues(alpha: _isHovering ? 0.35 : 0.5),
                ],
              ),
            ),
          ),

          // ── Shimmer highlight ─────────────────────────────────────────────
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-1.0, -1.0),
                  end: const Alignment(1.0, 1.0),
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.white.withValues(alpha: 0.03),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // ── Top edge highlight ────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),

          // ── Centered play button ──────────────────────────────────────────
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isHovering ? _pulseAnimation.value : 1.0,
                  child: child,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: _isHovering ? 72 : 64,
                height: _isHovering ? 72 : 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withValues(alpha: _isHovering ? 0.95 : 0.85),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: _isHovering ? 0.5 : 0.3),
                      blurRadius: _isHovering ? 28 : 18,
                      spreadRadius: _isHovering ? 4 : 1,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ),

          // ── "Watch Video" badge at bottom ──────────────────────────────
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _isHovering ? 1.0 : 0.8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.play_circle_fill_rounded,
                        color: Colors.red.shade400,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Watch Video',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Video icon badge at top-right ────────────────────────────────
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.videocam_rounded, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'VIDEO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/app_localizations.dart';
import '../../core/widgets/app_drawer.dart';
import '../../core/widgets/buttons/language_switch_button.dart';
import '../../main.dart';

class BookDetailsPage extends StatelessWidget {
  final Map<String, dynamic> book;
  const BookDetailsPage({super.key, required this.book});

  Future<void> _downloadBook() async {
    final Uri url = Uri.parse(book['driveLink'] ?? '');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not open book link');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet =
        MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1024;
    final isMobileOrTablet = isMobile || isTablet;
    final imagePath = book['image'] as String?;
    final hasImage = imagePath != null && imagePath.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          // ── Hero AppBar ───────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: isMobile ? 360 : 360,
            pinned: true,
            backgroundColor: const Color(0xFF0a0a18),
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: LanguageSwitchButton(
                    currentLocale: Localizations.localeOf(context),
                    onLocaleChanged: (newLocale) => appLocale.value = newLocale,
                  ),
                ),
              ),
              if (isMobileOrTablet)
                Builder(
                  builder: (ctx) => IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                )
              else ...[
                ...[
                  'services',
                  'courses',
                  'projects',
                  'files',
                  'reviews',
                  'contact',
                ].map(
                  (key) => _NavBarItem(
                    title: AppLocalizations.of(context)!.translate(key),
                    onPressed: () =>
                        Navigator.of(context).popUntil((r) => r.isFirst),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.3),
                    radius: 1.2,
                    colors: [
                      Color(0xFF151535),
                      Color(0xFF0c0c1e),
                      Color(0xFF080816),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // ── Ambient glow behind book ─────────────────────────────
                    Positioned(
                      top: isMobile ? 75 : 60,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: isMobile ? 180 : 220,
                          height: isMobile ? 140 : 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: 0.25,
                                ),
                                blurRadius: 80,
                                spreadRadius: 20,
                              ),
                              BoxShadow(
                                color: AppColors.secondary.withValues(
                                  alpha: 0.15,
                                ),
                                blurRadius: 60,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── Decorative grid dots ────────────────────────────────
                    Positioned.fill(
                      child: CustomPaint(painter: _DotGridPainter()),
                    ),

                    // ── Main content ────────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        isMobile ? 55 : 45,
                        24,
                        10,
                      ),
                      child: isMobile
                          ? Column(
                              children: [
                                // Floating book cover
                                _PremiumBookCover(
                                  imagePath: hasImage ? imagePath : null,
                                  width: 160,
                                  height: 230,
                                  showReflection: false,
                                ),
                                const SizedBox(height: 12),
                                _BookHeroMeta(book: book, isMobile: true),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Spacer(),
                                _PremiumBookCover(
                                  imagePath: hasImage ? imagePath : null,
                                  width: 180,
                                  height: 250,
                                  showReflection: true,
                                ),
                                const SizedBox(width: 36),
                                Expanded(
                                  flex: 3,
                                  child: _BookHeroMeta(
                                    book: book,
                                    isMobile: false,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 760),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 32,
                  vertical: 36,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // About card
                    if (book['description'] != null &&
                        (book['description'] as String).isNotEmpty) ...[
                      _InfoCard(
                        icon: Icons.menu_book_rounded,
                        title: isArabic ? 'عن الكتاب' : 'About the Book',
                        child: Text(
                          book['description'] ?? '',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            height: 1.9,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Author card
                    if (book['author'] != null) ...[
                      _InfoCard(
                        icon: Icons.person_rounded,
                        title: isArabic ? 'المؤلف' : 'Author',
                        child: Text(
                          book['author'] ?? '',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Download CTA card
                    _DownloadCard(
                      isArabic: isArabic,
                      onDownload: _downloadBook,
                      label:
                          AppLocalizations.of(
                            context,
                          )?.translate('download_book') ??
                          'تحميل الكتاب',
                    ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _downloadBook,
        backgroundColor: AppColors.primary,
        elevation: 6,
        icon: const Icon(Icons.download_rounded, color: Colors.white),
        label: Text(
          AppLocalizations.of(context)?.translate('download_book') ??
              'تحميل الكتاب',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ── Premium Book Cover (3D floating with reflection) ─────────────────────────
class _PremiumBookCover extends StatelessWidget {
  final String? imagePath;
  final double width;
  final double height;
  final bool showReflection;

  const _PremiumBookCover({
    required this.imagePath,
    required this.width,
    required this.height,
    this.showReflection = true,
  });

  @override
  Widget build(BuildContext context) {
    final double reflectionHeight = showReflection ? height * 0.20 : 0.0;
    return SizedBox(
      width: width + 8, // extra space for spine
      height: height + reflectionHeight, // extra space for reflection
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // ── Mirror reflection ──────────────────────────────────────────
          if (showReflection)
            Positioned(
              top: height - 2,
              child: Transform(
                alignment: Alignment.topCenter,
                transform: Matrix4.identity()
                  ..scale(1.0, -1.0)
                  ..rotateX(0.0),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ).createShader(bounds),
                  blendMode: BlendMode.dstIn,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      width: width,
                      height: height * 0.30,
                      child: imagePath != null
                          ? Image.asset(
                              imagePath!,
                              fit: BoxFit.cover,
                              alignment: Alignment.bottomCenter,
                              errorBuilder: (_, _, _) =>
                                  Container(color: const Color(0xFF1a1a2e)),
                            )
                          : Container(color: const Color(0xFF1a1a2e)),
                    ),
                  ),
                ),
              ),
            ),

          // ── Main book cover ────────────────────────────────────────────
          Positioned(
            top: 0,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  // Primary color glow
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 2,
                    offset: const Offset(0, 12),
                  ),
                  // Deep shadow
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 20,
                    offset: const Offset(4, 8),
                  ),
                  // Soft ambient
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(-2, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Book image
                    imagePath != null
                        ? Image.asset(
                            imagePath!,
                            fit: BoxFit.fill,
                            errorBuilder: (_, _, _) => _CoverFallback(),
                          )
                        : _CoverFallback(),

                    // Spine edge (left side dark strip)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black.withValues(alpha: 0.5),
                              Colors.black.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Light shimmer highlight
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: const Alignment(-1.0, -1.0),
                            end: const Alignment(1.0, 1.0),
                            colors: [
                              Colors.white.withValues(alpha: 0.12),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.04),
                            ],
                            stops: const [0.0, 0.3, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Top edge highlight
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cover Fallback ───────────────────────────────────────────────────────────
class _CoverFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1e1e3a), Color(0xFF2a1a4e), Color(0xFF0f2040)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 48,
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
    );
  }
}

// ── Book Hero Meta ───────────────────────────────────────────────────────────
class _BookHeroMeta extends StatelessWidget {
  final Map<String, dynamic> book;
  final bool isMobile;

  const _BookHeroMeta({required this.book, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Category badge
        if (book['category'] != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bookmark_rounded,
                  color: AppColors.primary,
                  size: 12,
                ),
                const SizedBox(width: 5),
                Text(
                  book['category'] ?? '',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        // Title
        Text(
          book['title'] ?? '',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 18 : 24,
            fontWeight: FontWeight.w800,
            height: 1.2,
            letterSpacing: -0.3,
          ),
        ),
        // Author
        if (book['author'] != null) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primary,
                  size: 12,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  book['author'] ?? '',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// ── Dot Grid Painter (subtle decorative background) ─────────────────────────
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    const spacing = 28.0;
    const dotRadius = 1.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Info Card ─────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ── Download Card ─────────────────────────────────────────────────────────────
class _DownloadCard extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onDownload;
  final String label;
  const _DownloadCard({
    required this.isArabic,
    required this.onDownload,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.secondary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.download_rounded,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic
                          ? 'متاح للتحميل المجاني'
                          : 'Free Download Available',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isArabic
                          ? 'يمكنك تحميل هذا الكتاب مباشرة عبر Google Drive'
                          : 'Download this book directly via Google Drive',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onDownload,
                icon: const FaIcon(
                  FontAwesomeIcons.googleDrive,
                  color: Colors.white,
                  size: 18,
                ),
                label: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── _NavBarItem ──────────────────────────────────────────────────────────────
class _NavBarItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const _NavBarItem({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        overlayColor: AppColors.primary,
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }
}

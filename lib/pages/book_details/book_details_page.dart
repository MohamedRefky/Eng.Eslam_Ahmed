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
    final imagePath = book['image'] as String?;
    final hasImage = imagePath != null && imagePath.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          // ── Hero AppBar ───────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: isMobile ? 280 : 380,
            pinned: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(8),
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
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background
                  hasImage
                      ? Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              _BookHeroPlaceholder(isMobile: isMobile),
                        )
                      : _BookHeroPlaceholder(isMobile: isMobile),
                  // Dark overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.1),
                            Colors.black.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Hero metadata
                  Positioned(
                    bottom: 28,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Category badge
                        if (book['category'] != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.secondary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              book['category'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                        Text(
                          book['title'] ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 22 : 28,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                        if (book['author'] != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline_rounded,
                                color: Colors.white70,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                book['author'] ?? '',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
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

// ── Hero Placeholder ──────────────────────────────────────────────────────────
class _BookHeroPlaceholder extends StatelessWidget {
  final bool isMobile;
  const _BookHeroPlaceholder({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a1a2e), AppColors.primary, AppColors.secondary],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: isMobile ? 72 : 110,
          color: Colors.white.withValues(alpha: 0.15),
        ),
      ),
    );
  }
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

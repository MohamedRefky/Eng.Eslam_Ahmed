import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/data/office_data.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/app_localizations.dart';
import '../core/widgets/section_title.dart';
import '../pages/book_details/book_details_page.dart';
import '../pages/all_books/all_books_page.dart';

class BooksSection extends StatelessWidget {
  const BooksSection({super.key});

  static const int _previewCount = 3;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> books = OfficeData.data['books'] ?? [];
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final loc = AppLocalizations.of(context)!;

    final previewBooks = books.length > _previewCount ? books.sublist(0, _previewCount) : books;
    final hasMore = books.length > _previewCount;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: isMobile ? 16 : 24),
      child: Column(
        children: [
          SectionTitle(title: loc.translate('books_title')),
          const SizedBox(height: 12),
          Text(
            loc.translate('books_subtitle'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14.5, height: 1.7),
          ),
          const SizedBox(height: 48),

          if (books.isEmpty)
            Text(
              loc.translate('no_books'),
              style: const TextStyle(color: AppColors.textSecondary),
            )
          else ...[
            // ── Book Cards Grid ────────────────────────────────────────────
            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: previewBooks.asMap().entries.map((entry) {
                return _BookCard(
                  book: entry.value as Map<String, dynamic>,
                  index: entry.key,
                );
              }).toList(),
            ),

            // ── View More Button ───────────────────────────────────────────
            if (hasMore) ...[
              const SizedBox(height: 40),
              _ViewMoreButton(
                label: loc.translate('view_more_books'),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

// ── Book Card ─────────────────────────────────────────────────────────────────
class _BookCard extends StatefulWidget {
  final Map<String, dynamic> book;
  final int index;
  const _BookCard({required this.book, required this.index});

  @override
  State<_BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<_BookCard> {
  bool _isHovered = false;

  static const double _cardWidth = 300;
  static const double _imageHeight = 200;

  @override
  Widget build(BuildContext context) {
    final imagePath = widget.book['image'] as String?;
    final hasImage = imagePath != null && imagePath.isNotEmpty;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailsPage(bookId: widget.book['id']),
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          width: isMobile ? double.infinity : _cardWidth,
          transform: _isHovered
              ? Matrix4.translationValues(0, -10.0, 0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.3),
                blurRadius: _isHovered ? 28 : 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Book Cover ─────────────────────────────────────────────
                SizedBox(
                  height: _imageHeight,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background
                      hasImage
                          ? Image.asset(imagePath, fit: BoxFit.fill,
                              errorBuilder: (_, _, _) => _CoverPlaceholder())
                          : _CoverPlaceholder(),
                      // Gradient overlay
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.55),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Category badge
                      if (widget.book['category'] != null)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, AppColors.secondary],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.book['category'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      // Book icon at bottom
                      Positioned(
                        bottom: 14,
                        right: 14,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.menu_book_rounded, color: Colors.white70, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Book Info ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book['title'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (widget.book['author'] != null)
                        Row(
                          children: [
                            const Icon(Icons.person_outline_rounded,
                                color: AppColors.primary, size: 14),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                widget.book['author'] ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),

                      // Download & Details row
                      Row(
                        children: [
                          // Download button
                          Expanded(
                            child: _QuickDownloadButton(
                              driveLink: widget.book['driveLink'] ?? '',
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Details arrow
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 280),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _isHovered
                                  ? AppColors.primary.withValues(alpha: 0.2)
                                  : AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.25),
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: (widget.index * 100).ms)
        .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: (widget.index * 100).ms);
  }
}

// ── Cover Placeholder ─────────────────────────────────────────────────────────
class _CoverPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), AppColors.primary],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 64,
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
    );
  }
}

// ── Quick Download Button ─────────────────────────────────────────────────────
class _QuickDownloadButton extends StatelessWidget {
  final String driveLink;
  const _QuickDownloadButton({required this.driveLink});

  Future<void> _download() async {
    final Uri url = Uri.parse(driveLink);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not open book link');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: _download,
        icon: const FaIcon(FontAwesomeIcons.googleDrive, color: Colors.white, size: 14),
        label: Text(
          isArabic ? 'تحميل' : 'Download',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ── View More Button ──────────────────────────────────────────────────────────
class _ViewMoreButton extends StatelessWidget {
  final String label;
  const _ViewMoreButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AllBooksPage()),
        ),
        icon: const Icon(Icons.library_books_rounded, color: Colors.white, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

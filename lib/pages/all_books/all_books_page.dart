import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/data/office_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_localizations.dart';
import '../../core/widgets/app_drawer.dart';
import '../../core/widgets/buttons/language_switch_button.dart';
import '../../main.dart';
import '../book_details/book_details_page.dart';

class AllBooksPage extends StatefulWidget {
  const AllBooksPage({super.key});

  @override
  State<AllBooksPage> createState() => _AllBooksPageState();
}

class _AllBooksPageState extends State<AllBooksPage> {
  String _selectedCategory = 'all';
  final _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = Localizations.localeOf(context).languageCode;
    OfficeData.load(lang).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> books = OfficeData.data['books'] ?? [];
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isMobileOrTablet =
        ResponsiveBreakpoints.of(context).isMobile ||
        ResponsiveBreakpoints.of(context).isTablet;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final loc = AppLocalizations.of(context)!;

    // Gather unique categories
    final categories = <String>{
      'all',
      ...books.map(
        (b) => (b as Map<String, dynamic>)['category'] as String? ?? '',
      ),
    };
    final filtered = _selectedCategory == 'all'
        ? books
        : books
              .where(
                (b) =>
                    (b as Map<String, dynamic>)['category'] ==
                    _selectedCategory,
              )
              .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // ── AppBar ─────────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: isMobile ? 180 : 240,
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
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hero gradient background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF0f0f1a),
                          Color(0xFF1a1a2e),
                          Color(0xFF16213e),
                        ],
                      ),
                    ),
                  ),
                  // Decorative circles
                  Positioned(
                    top: -40,
                    right: -40,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    left: -20,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondary.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  // Overlay gradient for text
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Hero content
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.library_books_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isArabic
                                    ? 'المكتبة الهندسية'
                                    : 'Engineering Library',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          loc.translate('books_page_title'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 24 : 32,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${filtered.length} ${isArabic ? 'كتاب' : 'books'}',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Category Filter ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    final label = cat == 'all'
                        ? (isArabic ? 'الكل' : 'All')
                        : cat;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondary,
                                  ],
                                )
                              : null,
                          color: isSelected ? null : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : AppColors.primary.withValues(alpha: 0.2),
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // ── Books Grid ────────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 24,
              vertical: 24,
            ),
            sliver: filtered.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Column(
                          children: [
                            Icon(
                              Icons.library_books_outlined,
                              size: 64,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              loc.translate('no_books'),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: isMobile ? 450 : 350,
                      mainAxisSpacing: 28,
                      crossAxisSpacing: 28,
                      childAspectRatio: 0.92,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final book = filtered[index] as Map<String, dynamic>;
                      return _BookLibraryCard(book: book, index: index);
                    }, childCount: filtered.length),
                  ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }
}

// ── Book Library Card (Vertical Grid Layout) ──────────────────────────────────
class _BookLibraryCard extends StatefulWidget {
  final Map<String, dynamic> book;
  final int index;
  const _BookLibraryCard({required this.book, required this.index});

  @override
  State<_BookLibraryCard> createState() => _BookLibraryCardState();
}

class _BookLibraryCardState extends State<_BookLibraryCard> {
  bool _isHovered = false;

  Future<void> _download() async {
    final Uri url = Uri.parse(widget.book['driveLink'] ?? '');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not open book link');
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = widget.book['image'] as String?;
    final hasImage = imagePath != null && imagePath.isNotEmpty;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

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
              duration: const Duration(milliseconds: 260),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isHovered
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.13),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.25),
                    blurRadius: _isHovered ? 24 : 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Cover Image (Top) ─────────────────────────────────────────
                    Expanded(
                      flex: 5,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          hasImage
                              ? Image.asset(
                                  imagePath,
                                  fit: BoxFit.fill,
                                  errorBuilder: (_, _, _) =>
                                      _CoverPlaceholder(),
                                )
                              : _CoverPlaceholder(),
                          // Index Badge
                          Positioned(
                            top: 10,
                            right: isArabic ? null : 10,
                            left: isArabic ? 10 : null,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Center(
                                child: Text(
                                  '${widget.index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Category badge
                          if (widget.book['category'] != null)
                            Positioned(
                              top: 10,
                              left: isArabic ? null : 10,
                              right: isArabic ? 10 : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
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
                                  widget.book['category'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // ── Content Info (Bottom) ─────────────────────────────────────
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Expanded(
                              child: Text(
                                widget.book['title'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Author
                            if (widget.book['author'] != null)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline_rounded,
                                    color: AppColors.primary,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      widget.book['author'] ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 12),
                            // Action buttons row
                            Row(
                              children: [
                                // Download
                                Expanded(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.primary,
                                          AppColors.secondary,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed: _download,
                                      icon: const FaIcon(
                                        FontAwesomeIcons.googleDrive,
                                        color: Colors.white,
                                        size: 13,
                                      ),
                                      label: Text(
                                        isArabic ? 'تحميل' : 'Download',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Details
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 260),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _isHovered
                                        ? AppColors.primary.withValues(
                                            alpha: 0.2,
                                          )
                                        : AppColors.primary.withValues(
                                            alpha: 0.07,
                                          ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppColors.primary,
                                    size: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: (widget.index * 60).ms)
        .slideY(
          begin: 0.1,
          end: 0,
          duration: 400.ms,
          delay: (widget.index * 60).ms,
        );
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
          size: 40,
          color: Colors.white.withValues(alpha: 0.15),
        ),
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

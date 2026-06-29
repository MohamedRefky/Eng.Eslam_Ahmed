import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/data/office_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_localizations.dart';
import '../../core/widgets/section_title.dart';

class DownloadableProjectsSection extends StatelessWidget {
  const DownloadableProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final downloadableProjects = List<Map<String, dynamic>>.from(
      OfficeData.data['downloadableProjects'] ?? [],
    );

    if (downloadableProjects.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 40 : 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SectionTitle(
            title: AppLocalizations.of(
              context,
            )!.translate('downloadable_projects'),
            lineWidth: 80,
          ),
          SizedBox(height: isMobile ? 40 : 60),
          LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = ResponsiveBreakpoints.of(context).isTablet;

              double cardWidth;
              if (isMobile) {
                cardWidth = constraints.maxWidth;
              } else if (isTablet) {
                cardWidth = (constraints.maxWidth - 32) / 2;
              } else {
                cardWidth = (constraints.maxWidth - 64) / 3;
              }

              return Wrap(
                spacing: 32,
                runSpacing: 32,
                alignment: WrapAlignment.center,
                children: downloadableProjects.asMap().entries.map((entry) {
                  final index = entry.key;
                  final project = entry.value;
                  return SizedBox(
                    width: cardWidth,
                    child: _DownloadableProjectCard(project: project)
                        .animate(delay: (150 * index).ms)
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.15, end: 0),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DownloadableProjectCard extends StatefulWidget {
  final Map<String, dynamic> project;
  const _DownloadableProjectCard({required this.project});

  @override
  State<_DownloadableProjectCard> createState() =>
      __DownloadableProjectCardState();
}

class __DownloadableProjectCardState extends State<_DownloadableProjectCard> {
  bool _isHovered = false;

  Future<void> _openDriveLink() async {
    final urlStr = widget.project['driveLink'] ?? '';
    final Uri url = Uri.parse(urlStr);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch drive link: $urlStr');
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.project['title'] ?? '';
    final description = widget.project['description'] ?? '';
    final imagePath = widget.project['image'] as String?;
    final hasImage = imagePath != null && imagePath.isNotEmpty;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _openDriveLink,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          height: 380,
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
                    ? AppColors.primary.withValues(alpha: 0.25)
                    : Colors.black.withValues(alpha: 0.2),
                blurRadius: _isHovered ? 24 : 16,
                offset: _isHovered ? const Offset(0, 12) : const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Cover Image
                if (hasImage)
                  Image.asset(imagePath, fit: BoxFit.fill)
                else
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),

                // Premium overlay gradient
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          Colors.black.withValues(alpha: 0.6),
                          Colors.black.withValues(alpha: 0.9),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),

                // Glow hover overlay
                AnimatedOpacity(
                  opacity: _isHovered ? 0.05 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(color: AppColors.primary),
                ),

                // Card content
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.googleDrive,
                              size: 11,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isArabic ? "مشروع كامل" : "Full Project",
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Title
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Description
                      Text(
                        description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Download Button
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _isHovered
                                  ? [AppColors.secondary, AppColors.primary]
                                  : [AppColors.primary, AppColors.secondary],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.download_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isArabic
                                    ? "تحميل ملفات المشروع"
                                    : "Download Project Files",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

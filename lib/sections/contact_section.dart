import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/data/office_data.dart';
import '../../core/constants/app_icons.dart';
import '../../core/utils/app_localizations.dart';
import '../core/widgets/buttons/primary_button.dart';
import '../../core/widgets/section_title.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 40 : 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SectionTitle(title: AppLocalizations.of(context)!.translate('get_in_touch')),
          const SizedBox(height: 40),
          Text(
                AppLocalizations.of(context)!.translate('contact_description'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  height: 1.6,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              )
              .animate()
              .fadeIn(delay: 500.ms, duration: 600.ms)
              .slideY(begin: 0.2, end: 0),
          SizedBox(height: isMobile ? 32 : 60),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = isMobile 
                  ? (constraints.maxWidth - 24) / 2 
                  : 240.0;

              final socialLinks = List<Map<String, dynamic>>.from(
                OfficeData.data['socialLinks'] ?? [],
              );

              final List<Widget> cards = socialLinks.map((link) {
                String displayValue = link['url'] ?? '';
                if (displayValue.startsWith('mailto:')) {
                  displayValue = displayValue.replaceAll('mailto:', '');
                } else if (displayValue.contains('linkedin.com/in/')) {
                  displayValue = displayValue.split('linkedin.com/in/').last.replaceAll('/', '');
                } else if (displayValue.contains('github.com/')) {
                  displayValue = displayValue.split('github.com/').last.replaceAll('/', '');
                } else if (displayValue.startsWith('https://wa.me/')) {
                  displayValue = '+${displayValue.replaceAll('https://wa.me/', '')}';
                } else if (displayValue.contains('instagram.com/')) {
                  displayValue = '@${displayValue.split('instagram.com/').last.split('?').first}';
                } else if (displayValue.contains('facebook.com/share/')) {
                  if (link['platform'] == 'Company') {
                    displayValue = AppLocalizations.of(context)!.translate('view_page');
                  } else {
                    displayValue = AppLocalizations.of(context)!.translate('view_profile');
                  }
                }

                return _ContactCard(
                  width: cardWidth,
                  icon: Icon(
                    AppIcons.getIcon(link['icon'] ?? ''),
                    size: 28,
                    color: AppColors.secondary,
                  ),
                  title: link['platform'] ?? '',
                  value: displayValue,
                  onTap: () => _launchUrl(link['url'] ?? ''),
                );
              }).toList();

              // Add Phone Call Card
              cards.add(
                _ContactCard(
                  width: cardWidth,
                  icon: const FaIcon(
                    FontAwesomeIcons.phone,
                    size: 28,
                    color: AppColors.secondary,
                  ),
                  title: AppLocalizations.of(context)!.translate('call'),
                  value: AppConstants.phoneCallUrl.replaceAll('tel:', ''),
                  onTap: () => _launchUrl(AppConstants.phoneCallUrl),
                ),
              );

              return Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: cards.animate(interval: 200.ms).fadeIn(duration: 500.ms).scale(),
              );
            },
          ),
          SizedBox(height: isMobile ? 48 : 80),
          PrimaryButton(
                text: AppLocalizations.of(context)!.translate('say_hello'),
                icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 20),
                onPressed: () => _launchUrl(AppConstants.whatsappUrl),
              )
              .animate()
              .fadeIn(delay: 1000.ms, duration: 500.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 80),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.translate('developer_credit'),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => _launchUrl('https://wa.me/201019964918'),
                borderRadius: BorderRadius.circular(20),
                hoverColor: AppColors.primary.withValues(alpha: 0.1),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.whatsapp,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 6),
                      Text(
                        AppLocalizations.of(context)!.translate('contact_developer'),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ContactCard extends StatefulWidget {
  final Widget icon;
  final String title;
  final String value;
  final VoidCallback onTap;
  final double width;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    required this.width,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return InkWell(
      onTap: widget.onTap,
      onHover: (val) => setState(() => isHovered = val),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.width,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 20, 
          vertical: isMobile ? 20 : 24
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHovered ? AppColors.secondary : Colors.transparent,
            width: 1,
          ),
          boxShadow: isHovered
               ? [
                   BoxShadow(
                     color: AppColors.secondary.withValues(alpha: 0.2),
                     blurRadius: 15,
                     offset: const Offset(0, 8),
                   ),
                 ]
               : [
                   BoxShadow(
                     color: Colors.black.withValues(alpha: 0.1),
                     blurRadius: 10,
                     offset: const Offset(0, 4),
                   ),
                 ],
        ),
        transform: isHovered
            ? Matrix4.translationValues(0.0, -8.0, 0.0)
            : Matrix4.identity(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.icon,
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

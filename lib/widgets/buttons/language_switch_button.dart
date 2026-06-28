import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class LanguageSwitchButton extends StatefulWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const LanguageSwitchButton({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  State<LanguageSwitchButton> createState() => _LanguageSwitchButtonState();
}

class _LanguageSwitchButtonState extends State<LanguageSwitchButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isAr = widget.currentLocale.languageCode == 'ar';
    // Shows the other language to switch to
    final displayLabel = isAr ? 'English' : 'العربية';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.onLocaleChanged(
            isAr ? const Locale('en') : const Locale('ar'),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.cardBackground.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.language,
                size: 15,
                color: _isHovered ? AppColors.primary : AppColors.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                displayLabel,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: isAr ? 0.3 : 0.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

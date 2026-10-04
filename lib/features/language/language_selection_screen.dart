import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../auth/providers/auth_provider.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  final bool isFromSettings;

  const LanguageSelectionScreen({super.key, this.isFromSettings = false});

  @override
  ConsumerState<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends ConsumerState<LanguageSelectionScreen> {
  String _selectedCode = AppConstants.localeEn;

  @override
  void initState() {
    super.initState();
    final currentLocale = ref.read(appLocaleProvider);
    _selectedCode = currentLocale.languageCode;
  }

  Future<void> _handleConfirm() async {
    await ref.read(appLocaleProvider.notifier).setLocale(_selectedCode);
    final storage = ref.read(storageServiceProvider);
    await storage.setHasSelectedLanguage(true);

    if (!mounted) return;

    final isAuth = ref.read(authProvider).isAuthenticated;
    if (widget.isFromSettings || context.canPop()) {
      context.pop();
    } else if (isAuth) {
      context.go(AppRoutes.customerHome);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        title: Text(
          widget.isFromSettings ? context.tr('language') : context.tr('app_name'),
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('select_language'),
                style: AppTypography.displayMedium.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('select_language_subtitle'),
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // English Option Card
              _languageOption(
                code: 'en',
                languageName: 'English',
                nativeScript: 'English',
                subtitle: 'Standard construction logistics in English',
                icon: Icons.language_rounded,
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              // Tamil Option Card
              _languageOption(
                code: 'ta',
                languageName: 'தமிழ்',
                nativeScript: 'Tamil',
                subtitle: 'கட்டுமான தளப் பயன்பாட்டிற்கு ஏற்ற எளிய தமிழ்',
                icon: Icons.translate_rounded,
                isDark: isDark,
              ),

              const Spacer(),

              // Confirm Button
              AppButton(
                text: context.tr('continue_action'),
                onPressed: _handleConfirm,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageOption({
    required String code,
    required String languageName,
    required String nativeScript,
    required String subtitle,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = _selectedCode == code;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedCode = code;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF332014) : AppColors.primaryContainer.withAlpha(80))
              : (isDark ? AppColors.darkSurfaceCard : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : AppColors.border),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : (isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppColors.slateMuted),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        languageName,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '($nativeScript)',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.border),
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

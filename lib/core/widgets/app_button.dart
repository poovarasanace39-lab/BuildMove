import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, outline, danger }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonVariant variant;
  final IconData? icon;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.width,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = onPressed != null && !isLoading;

    Color bg;
    Color fg;
    BorderSide? border;

    switch (variant) {
      case AppButtonVariant.primary:
        bg = isEnabled ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.border);
        fg = isEnabled ? Colors.white : (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary);
        border = null;
        break;
      case AppButtonVariant.secondary:
        bg = isEnabled
            ? (isDark ? AppColors.darkSurfaceVariant : AppColors.secondary)
            : (isDark ? AppColors.darkBorder : AppColors.border);
        fg = isEnabled ? (isDark ? AppColors.darkTextPrimary : Colors.white) : (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary);
        border = null;
        break;
      case AppButtonVariant.outline:
        bg = Colors.transparent;
        fg = isEnabled
            ? (isDark ? AppColors.darkTextPrimary : AppColors.secondary)
            : (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary);
        border = BorderSide(
          color: isEnabled
              ? (isDark ? AppColors.darkBorder : AppColors.border)
              : (isDark ? AppColors.darkBorder : AppColors.border),
        );
        break;
      case AppButtonVariant.danger:
        bg = isEnabled ? AppColors.error : (isDark ? AppColors.darkBorder : AppColors.border);
        fg = isEnabled ? Colors.white : (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary);
        border = null;
        break;
    }

    final childWidget = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: fg),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    text,
                    maxLines: 1,
                    style: TextStyle(
                      color: fg,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ],
          );

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: border ?? BorderSide.none,
        ),
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: childWidget),
          ),
        ),
      ),
    );
  }
}

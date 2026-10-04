import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Border? border;
  final double borderRadius;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.border,
    this.borderRadius = 12,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = color ?? (isDark ? AppColors.darkSurfaceCard : AppColors.surfaceCard);
    final defaultBorderSide = BorderSide(
      color: isDark ? AppColors.darkBorder : AppColors.border,
      width: 1,
    );

    Widget content = Container(
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isDark
            ? null
            : const [
                BoxShadow(
                  color: Color(0x080F172A),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: cardColor,
        shape: border != null
            ? null
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                side: defaultBorderSide,
              ),
        borderRadius: border != null ? BorderRadius.circular(borderRadius) : null,
        clipBehavior: Clip.antiAlias,
        child: border != null
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: border,
                ),
                child: content,
              )
            : content,
      ),
    );
  }
}

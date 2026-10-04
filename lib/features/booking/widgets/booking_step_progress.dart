import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class BookingStepProgress extends StatelessWidget {
  final int currentStep; // 1, 2, 3, 4

  const BookingStepProgress({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final steps = [
      {'number': 1, 'label': context.tr('step_material_short')},
      {'number': 2, 'label': context.tr('step_locations_short')},
      {'number': 3, 'label': context.tr('step_vehicle_short')},
      {'number': 4, 'label': context.tr('step_confirm_short')},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE0E3E7),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Connector line
            final stepIndex = (index ~/ 2) + 1;
            final isPassed = currentStep > stepIndex;
            return Expanded(
              child: Container(
                height: 2.5,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isPassed
                      ? const Color(0xFF00A854)
                      : (isDark ? AppColors.darkBorder : const Color(0xFFE0E3E7)),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }

          final stepItem = steps[index ~/ 2];
          final stepNum = stepItem['number'] as int;
          final stepLabel = stepItem['label'] as String;

          final isActive = currentStep == stepNum;
          final isCompleted = currentStep > stepNum;

          Color circleBg;
          Color circleFg;
          Color textColor;

          if (isCompleted) {
            circleBg = const Color(0xFF00A854);
            circleFg = Colors.white;
            textColor = isDark ? AppColors.darkTextSecondary : const Color(0xFF585F6D);
          } else if (isActive) {
            circleBg = const Color(0xFFCC4900);
            circleFg = Colors.white;
            textColor = const Color(0xFFCC4900);
          } else {
            circleBg = isDark ? AppColors.darkSurfaceVariant : const Color(0xFFE5E8EC);
            circleFg = isDark ? AppColors.darkTextTertiary : const Color(0xFF585F6D);
            textColor = isDark ? AppColors.darkTextTertiary : const Color(0xFF585F6D);
          }

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: circleBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : Text(
                          '$stepNum',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: circleFg,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                stepLabel,
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

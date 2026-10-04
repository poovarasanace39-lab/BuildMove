import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../providers/fleet_provider.dart';

class AdminVerificationsScreen extends ConsumerWidget {
  const AdminVerificationsScreen({super.key});

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    String documentId,
    bool isApproved,
  ) async {
    try {
      final notifier = ref.read(fleetNotifierProvider.notifier);
      final String? driverName = isApproved
          ? await notifier.approveVerification(documentId)
          : await notifier.rejectVerification(documentId);

      if (context.mounted && driverName != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isApproved
                  ? '$driverName documents APPROVED. Driver activated.'
                  : '$driverName documents REJECTED.',
            ),
            backgroundColor: isApproved ? AppColors.success : AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process verification: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fleetState = ref.watch(fleetNotifierProvider);
    final queue = fleetState.verificationQueue;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('verifications')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Queue',
            onPressed: () => ref.read(fleetNotifierProvider.notifier).loadFleetData(),
          ),
        ],
      ),
      body: fleetState.isLoading && queue.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : queue.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified_rounded, size: 52, color: AppColors.success),
                      const SizedBox(height: 12),
                      Text('All Verification Queue Clear', style: AppTypography.titleMedium),
                      const SizedBox(height: 4),
                      const Text(
                        'No pending driver documents awaiting approval.',
                        style: TextStyle(color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: queue.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) {
                    final doc = queue[i];
                    return AppCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                doc.id,
                                style: AppTypography.labelLarge.copyWith(color: AppColors.primaryDark),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.warningLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Awaiting KYC Review',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.warning,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(doc.driverName, style: AppTypography.titleSmall),
                          Text('${doc.phone} • ${doc.vehicleName}', style: AppTypography.bodySmall),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.description_outlined, size: 20, color: AppColors.secondary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(doc.documentType, style: AppTypography.labelMedium),
                                      Text('Plate: ${doc.plateNumber}', style: AppTypography.bodySmall),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  text: context.tr('action_reject'),
                                  variant: AppButtonVariant.danger,
                                  height: 40,
                                  onPressed: () => _handleAction(context, ref, doc.id, false),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: AppButton(
                                  text: context.tr('action_approve'),
                                  variant: AppButtonVariant.primary,
                                  height: 40,
                                  onPressed: () => _handleAction(context, ref, doc.id, true),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

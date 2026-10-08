import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../models/enums.dart';
import '../providers/fleet_provider.dart';

class AdminFleetScreen extends ConsumerWidget {
  const AdminFleetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fleetState = ref.watch(fleetNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('fleet')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Fleet',
            onPressed: () => ref.read(fleetNotifierProvider.notifier).loadFleetData(),
          ),
        ],
      ),
      body: fleetState.isLoading && fleetState.vehicles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : fleetState.vehicles.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_shipping_outlined, size: 52, color: AppColors.slateMuted),
                      const SizedBox(height: 12),
                      Text('No Registered Fleet Vehicles', style: AppTypography.titleMedium),
                      const SizedBox(height: 4),
                      const Text('Vehicles will appear here once approved.', style: TextStyle(color: AppColors.textTertiary)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: fleetState.vehicles.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) {
                    final v = fleetState.vehicles[i];
                    final user = fleetState.getDriverUser(v.driverId);
                    final driver = fleetState.getDriverProfile(v.driverId);

                    final driverName = user?.name ?? 'Assigned Driver';
                    final tripsCount = driver?.totalTrips ?? 0;

                    // Derive operational status
                    final String statusText;
                    final Color statusColor;

                    final bool hasPendingKyc = v.documents.any((d) => d.status == DocumentStatus.pending);
                    final bool hasRejectedKyc = v.documents.any((d) => d.status == DocumentStatus.rejected);

                    if (hasPendingKyc) {
                      statusText = 'Pending KYC Review';
                      statusColor = AppColors.warning;
                    } else if (hasRejectedKyc) {
                      statusText = 'KYC Rejected';
                      statusColor = AppColors.error;
                    } else if (v.isAvailable) {
                      if (driver?.isOnline ?? false) {
                        statusText = 'Available Online';
                        statusColor = AppColors.success;
                      } else {
                        statusText = 'Available (Driver Offline)';
                        statusColor = AppColors.info;
                      }
                    } else {
                      if (driver?.isOnline ?? false) {
                        statusText = 'On Duty (Loaded)';
                        statusColor = AppColors.primaryDark;
                      } else {
                        statusText = 'Off Duty';
                        statusColor = AppColors.slateMuted;
                      }
                    }

                    return AppCard(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.fire_truck_rounded, color: AppColors.secondary, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(v.plateNumber, style: AppTypography.titleSmall),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: statusColor.withAlpha(25),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        statusText,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: statusColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$driverName • ${v.modelName}',
                                  style: AppTypography.bodySmall,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Completed Loads: $tripsCount',
                                      style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                                    ),
                                    if (hasPendingKyc || hasRejectedKyc)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: (hasPendingKyc ? AppColors.warning : AppColors.error).withAlpha(20),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          hasPendingKyc ? 'KYC Required' : 'KYC Rejected',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: hasPendingKyc ? AppColors.warning : AppColors.error,
                                          ),
                                        ),
                                      )
                                    else
                                      InkWell(
                                        borderRadius: BorderRadius.circular(6),
                                        onTap: () async {
                                          await ref
                                              .read(fleetNotifierProvider.notifier)
                                              .toggleVehicleAvailability(v.id);
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '${v.plateNumber} set to ${!v.isAvailable ? "Available" : "Unavailable"}',
                                                ),
                                                duration: const Duration(seconds: 1),
                                              ),
                                            );
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          child: Text(
                                            v.isAvailable ? 'Toggle Off' : 'Toggle On',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: v.isAvailable ? AppColors.warning : AppColors.success,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

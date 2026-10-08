import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../auth/providers/auth_provider.dart';

class DriverProfileScreen extends ConsumerWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.currentUser;
    final locale = ref.watch(appLocaleProvider);
    final isTamil = locale.languageCode == 'ta';

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('profile')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Driver Profile Header Card
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.driverRole.withAlpha(30),
                    child: const Icon(Icons.person, size: 36, color: AppColors.driverRole),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Murugan K.',
                          style: AppTypography.titleMedium,
                        ),
                        Text(
                          '+91 ${user?.phone ?? '9840123456'}',
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isTamil ? 'சரிபார்க்கப்பட்ட கூட்டாளர் ஓட்டுநர்' : 'Verified Partner Driver',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.driverRole,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Vehicle Information Card
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.tr('vehicle_details'), style: AppTypography.titleSmall),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isTamil ? 'ஆர்சி செயலில் உள்ளது' : 'RC ACTIVE',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _vehicleField(isTamil ? 'வாகன மாடல்' : 'Vehicle Model', '6-Wheeler Tipper (10T)'),
                  _vehicleField(isTamil ? 'வண்டி எண்' : 'Plate Number', 'TN-02-AL-8921'),
                  _vehicleField(isTamil ? 'சுமை திறன்' : 'Rated Capacity', isTamil ? '10.0 டன் (10,000 கிலோ)' : '10.0 Tons (10,000 Kg)'),
                  _vehicleField(isTamil ? 'அனுமதி வகை' : 'Permit Type', isTamil ? 'தமிழ்நாடு சரக்கு போக்குவரத்து அனுமதி' : 'Tamil Nadu Goods Carrier Commercial'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // KYC Documents Upload Status
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isTamil ? 'தேவையான ஆவணங்களின் நிலை' : 'Required Documents Status', style: AppTypography.titleSmall),
                  const SizedBox(height: 8),
                  _documentRow(isTamil ? 'ஓட்டுநர் உரிமம் (வணிகம்)' : 'Driving License (Commercial)', isTamil ? 'ஒப்புதல் அளிக்கப்பட்டது' : 'Approved', AppColors.success),
                  const Divider(height: 16),
                  _documentRow(isTamil ? 'பதிவுச் சான்றிதழ் (RC)' : 'RC Certificate', isTamil ? 'ஒப்புதல் அளிக்கப்பட்டது' : 'Approved', AppColors.success),
                  const Divider(height: 16),
                  _documentRow(isTamil ? 'வணிக வாகனக் காப்பீடு' : 'Vehicle Commercial Insurance', isTamil ? 'ஒப்புதல் அளிக்கப்பட்டது' : 'Approved', AppColors.success),
                  const Divider(height: 16),
                  _documentRow(isTamil ? 'புகை பரிசோதனை சான்றிதழ் (PUC)' : 'Pollution Under Control (PUC)', isTamil ? '30 நாட்களில் காலாவதியாகிறது' : 'Expiring in 30 days', AppColors.warning),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Settings & Language
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language, color: AppColors.primary),
                    title: Text(context.tr('language')),
                    subtitle: Text(locale.languageCode == 'ta' ? 'தமிழ் (Tamil)' : 'English'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(AppRoutes.languageSelection),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet_outlined, color: AppColors.secondary),
                    title: Text(isTamil ? 'வங்கி கணக்கு & பணம் செலுத்துதல்' : 'Bank Account & Payouts'),
                    subtitle: const Text('State Bank of India •••• 4092'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout
            AppButton(
              text: context.tr('logout'),
              variant: AppButtonVariant.outline,
              icon: Icons.logout_rounded,
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go(AppRoutes.login);
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _vehicleField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          Text(value, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _documentRow(String docName, String status, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(docName, style: AppTypography.bodySmall),
        Text(
          status,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../models/location_model.dart';
import '../../tracking/widgets/map_placeholder_widget.dart';
import '../providers/booking_flow_provider.dart';
import '../widgets/booking_step_progress.dart';

class BookingLocationsScreen extends ConsumerStatefulWidget {
  const BookingLocationsScreen({super.key});

  @override
  ConsumerState<BookingLocationsScreen> createState() => _BookingLocationsScreenState();
}

class _BookingLocationsScreenState extends ConsumerState<BookingLocationsScreen> {
  late TextEditingController _pickupController;
  late TextEditingController _dropController;
  late TextEditingController _landmarkController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(bookingFlowProvider);
    _pickupController = TextEditingController(
      text: state.pickupLocation?.address ?? 'Dalmia Cement Yard, Koyambedu Wholesale Market',
    );
    _dropController = TextEditingController(
      text: state.dropLocation?.address ?? 'Villa Construction Site 4B, OMR Thoraipakkam',
    );
    _landmarkController = TextEditingController(text: state.siteLandmark);
    _phoneController = TextEditingController(text: state.siteReceiverPhone);
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropController.dispose();
    _landmarkController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final state = ref.read(bookingFlowProvider);

    final pickup = (state.pickupLocation ??
            const LocationModel(
              latitude: 13.0827,
              longitude: 80.2707,
              address: 'Dalmia Cement Yard, Koyambedu Wholesale Market',
            ))
        .copyWith(address: _pickupController.text.trim());

    final drop = (state.dropLocation ??
            const LocationModel(
              latitude: 12.9716,
              longitude: 80.2435,
              address: 'Villa Construction Site 4B, OMR Thoraipakkam',
            ))
        .copyWith(
      address: _dropController.text.trim(),
      siteLandmark: _landmarkController.text.trim(),
    );

    ref.read(bookingFlowProvider.notifier).setLocations(
          pickup: pickup,
          drop: drop,
          landmark: _landmarkController.text.trim(),
          receiverPhone: _phoneController.text.trim(),
        );

    context.push(AppRoutes.customerVehicleSelection);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingFlowProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(context.tr('step_locations')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          const BookingStepProgress(currentStep: 2),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('locations_title'),
                    style: AppTypography.titleLarge.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.tr('locations_subtitle'),
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Route Visual Map Preview
                  MapPlaceholderWidget(
                    pickup: state.pickupLocation,
                    drop: state.dropLocation,
                    distanceKm: state.estimate?.distanceKm ?? 14.5,
                    etaMinutes: state.estimate?.etaMinutes ?? 28,
                  ),

                  const SizedBox(height: 18),

                  // Route Inputs Card
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    color: isDark ? AppColors.darkSurfaceCard : Colors.white,
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pickup Input
                        AppTextField(
                          controller: _pickupController,
                          label: context.tr('pickup_address'),
                          hint: 'Depot, Quarry, or Supplier Store',
                          prefixIcon: const Icon(Icons.storefront_rounded, color: AppColors.success),
                        ),
                        const SizedBox(height: 16),

                        // Delivery Input
                        AppTextField(
                          controller: _dropController,
                          label: context.tr('drop_address'),
                          hint: 'Site Plot, Tower, or Building Project',
                          prefixIcon: const Icon(Icons.location_on_rounded, color: AppColors.error),
                        ),
                        const SizedBox(height: 16),

                        // Landmark Input
                        AppTextField(
                          controller: _landmarkController,
                          label: context.tr('site_landmark'),
                          hint: 'e.g. Opposite Gate 2, near transformer',
                          prefixIcon: const Icon(Icons.flag_rounded, color: AppColors.primary),
                        ),
                        const SizedBox(height: 16),

                        // Receiver Phone
                        AppTextField(
                          controller: _phoneController,
                          label: context.tr('site_contact'),
                          hint: '10-digit mobile',
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(AppConstants.phoneLengthIndia),
                          ],
                          prefixIcon: const Icon(Icons.phone_rounded, color: AppColors.info),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Quick Yard Presets
                  Text(
                    context.tr('frequently_used_depots'),
                    style: AppTypography.titleSmall.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _presetTile(
                    title: 'Dalmia Cement Yard, Koyambedu',
                    subtitle: 'Depot Gate 3 • Wholesale Cement Hub',
                    icon: Icons.warehouse_rounded,
                    isDark: isDark,
                    onTap: () {
                      _pickupController.text = 'Dalmia Cement Yard, Koyambedu Wholesale Market';
                    },
                  ),
                  const SizedBox(height: 8),
                  _presetTile(
                    title: 'JSW Steel Stockyard, Guindy',
                    subtitle: 'Heavy TMT Bars & Structural Rebar Depot',
                    icon: Icons.domain_rounded,
                    isDark: isDark,
                    onTap: () {
                      _pickupController.text = 'JSW Steel Stockyard, Guindy Industrial Estate';
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.tr('estimated_route'),
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '~14.5 km • 28 mins',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text: context.tr('proceed_to_vehicle'),
                      icon: Icons.arrow_forward_rounded,
                      height: 48,
                      onPressed: _onContinue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _presetTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceVariant : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.add_circle_outline, size: 18, color: isDark ? AppColors.darkTextTertiary : AppColors.slateMuted),
          ],
        ),
      ),
    );
  }
}

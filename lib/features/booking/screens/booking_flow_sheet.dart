import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../models/enums.dart';
import '../providers/booking_flow_provider.dart';

class BookingFlowSheet extends ConsumerStatefulWidget {
  const BookingFlowSheet({super.key});

  @override
  ConsumerState<BookingFlowSheet> createState() => _BookingFlowSheetState();
}

class _BookingFlowSheetState extends ConsumerState<BookingFlowSheet> {
  final TextEditingController _quantityController = TextEditingController(text: '1.5');
  final TextEditingController _pickupController =
      TextEditingController(text: 'Dalmia Cement Yard, Koyambedu Wholesale Market');
  final TextEditingController _dropController =
      TextEditingController(text: 'Villa Construction Site 4B, OMR Thoraipakkam');

  int _currentStep = 0; // 0: Material & Locations, 1: Vehicle Selection & Fare

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(bookingFlowProvider.notifier).calculateEstimate();
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _pickupController.dispose();
    _dropController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentStep == 0) {
      final qty = double.tryParse(_quantityController.text) ?? 1.0;
      ref.read(bookingFlowProvider.notifier).setQuantity(qty);
      setState(() => _currentStep = 1);
    } else {
      _confirmBooking();
    }
  }

  Future<void> _confirmBooking() async {
    final booking = await ref.read(bookingFlowProvider.notifier).confirmBooking();
    if (booking != null && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vehicle Request #${booking.id} created! Locating nearby drivers...'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingFlowProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _currentStep == 0 ? 'Book Material Vehicle' : 'Select Matching Vehicle',
                    style: AppTypography.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),

              if (_currentStep == 0) ...[
                // Step 0: Material Selection
                Text(context.tr('select_material'), style: AppTypography.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ConstructionMaterial.values.map((mat) {
                    final isSelected = state.selectedMaterial == mat;
                    return ChoiceChip(
                      label: Text(mat.name),
                      selected: isSelected,
                      selectedColor: AppColors.primaryContainer,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      onSelected: (val) {
                        if (val) {
                          ref.read(bookingFlowProvider.notifier).setMaterial(mat);
                        }
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Quantity / Weight in Tons
                AppTextField(
                  controller: _quantityController,
                  label: context.tr('enter_quantity'),
                  hint: 'e.g. 1.5',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  prefixIcon: const Icon(Icons.scale_rounded, color: AppColors.primary),
                ),

                const SizedBox(height: 16),

                // Pickup Location
                AppTextField(
                  controller: _pickupController,
                  label: context.tr('pickup_site'),
                  hint: 'Cement depot / Quarry / Hardware shop',
                  prefixIcon: const Icon(Icons.store_rounded, color: AppColors.success),
                ),

                const SizedBox(height: 16),

                // Drop Site Location
                AppTextField(
                  controller: _dropController,
                  label: context.tr('drop_site'),
                  hint: 'Construction plot / Site address',
                  prefixIcon: const Icon(Icons.location_on_rounded, color: AppColors.error),
                ),
              ] else ...[
                // Step 1: Vehicle options based on capacity & estimate
                Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Load: ${state.quantityTons} Tons of ${state.selectedMaterial.name}',
                      style: AppTypography.labelMedium.copyWith(color: AppColors.primaryDark),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (state.isCalculating)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (state.estimate != null) ...[
                  Text(
                    '${context.tr('suitable_vehicles')} (${state.estimate!.distanceKm} km • ~${state.estimate!.etaMinutes} mins)',
                    style: AppTypography.labelLarge,
                  ),
                  const SizedBox(height: 10),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.estimate!.vehicleOptions.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final opt = state.estimate!.vehicleOptions[index];
                      final isSelected = state.selectedVehicleType == opt.type;
                      return _vehicleOptionTile(opt, isSelected);
                    },
                  ),
                ],
              ],

              if (state.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(state.errorMessage!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
              ],

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  if (_currentStep == 1) ...[
                    Expanded(
                      flex: 1,
                      child: AppButton(
                        text: 'Back',
                        variant: AppButtonVariant.outline,
                        onPressed: () => setState(() => _currentStep = 0),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      text: _currentStep == 0 ? 'Find Vehicles' : context.tr('confirm'),
                      isLoading: state.isSubmitting,
                      onPressed: _onNext,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vehicleOptionTile(dynamic opt, bool isSelected) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      border: Border.all(
        color: isSelected ? AppColors.primary : AppColors.border,
        width: isSelected ? 2 : 1,
      ),
      color: isSelected ? AppColors.primaryContainer.withAlpha(50) : Colors.white,
      onTap: () {
        ref.read(bookingFlowProvider.notifier).selectVehicle(opt.type);
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.local_shipping_rounded,
              color: isSelected ? Colors.white : AppColors.secondary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        opt.type.name,
                        style: AppTypography.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (opt.isRecommended) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'BEST FIT',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  'Capacity: up to ${opt.type.capacityTons} Tons • ${opt.availableNearbyCount} available',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${AppConstants.currencySymbol}${opt.estimatedFare.toInt()}',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              const Text('Est. Total', style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
            ],
          ),
        ],
      ),
    );
  }
}

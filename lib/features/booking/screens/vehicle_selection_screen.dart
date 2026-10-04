import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../models/enums.dart';
import '../providers/booking_flow_provider.dart';

/// Screen 3 — Customer "Available Vehicles" (Step 2 of 3)
/// Matching reference images:
/// - media_1790854012774.png (Light) & media_1790854017406.png (Dark)
class VehicleSelectionScreen extends ConsumerStatefulWidget {
  const VehicleSelectionScreen({super.key});

  @override
  ConsumerState<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends ConsumerState<VehicleSelectionScreen> {
  static const List<_VehicleDisplayData> _vehicles = [
    _VehicleDisplayData(
      type: VehicleType.tipper6Wheeler,
      title: '6-Wheeler Tipper',
      isBestMatch: true,
      fare: 1850,
      capacity: '10 Tons',
      distance: '2.4 km',
      eta: '12 min',
      modelSubtitle: 'Tata Signa / Ashok Leyland 1615',
      icon: Icons.local_shipping_rounded,
    ),
    _VehicleDisplayData(
      type: VehicleType.pickup8ft,
      title: 'Bolero Maxi / Ace Mega',
      isBestMatch: false,
      fare: 850,
      capacity: '2 Tons',
      distance: '1.8 km',
      eta: '8 min',
      modelSubtitle: 'Light Commercial Vehicle',
      icon: Icons.fire_truck_outlined,
    ),
    _VehicleDisplayData(
      type: VehicleType.tipper10Wheeler,
      title: '10-Wheeler Heavy Dumper',
      isBestMatch: false,
      fare: 2600,
      capacity: '20 Tons',
      distance: '4.1 km',
      eta: '18 min',
      modelSubtitle: 'BharatBenz 2823R / Taurus',
      icon: Icons.local_shipping_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingFlowProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLang = ref.watch(appLocaleProvider).languageCode.toUpperCase();

    final selectedVehicle = state.selectedVehicleType ?? VehicleType.tipper6Wheeler;
    final selectedData = _vehicles.firstWhere(
      (v) => v.type == selectedVehicle,
      orElse: () => _vehicles.first,
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          context.tr('available_vehicles'),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        actions: [
          // Theme Toggle
          IconButton(
            icon: Icon(
              isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
              size: 18,
              color: isDark ? Colors.amber : AppColors.secondary,
            ),
            onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(context),
          ),
          // Language Capsule
          InkWell(
            onTap: () {
              final currentCode = ref.read(appLocaleProvider).languageCode;
              ref.read(appLocaleProvider.notifier).setLocale(currentCode == 'en' ? 'ta' : 'en');
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceVariant : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentLang,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.signal_cellular_alt_rounded,
                    size: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.primaryContainer,
              child: const Icon(Icons.person, size: 18, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
            // Step 2 of 3 Progress Header + GPS Live Radar Active
            Container(
              color: isDark ? AppColors.darkSurface : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'STEP 2 OF 3',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEA580C),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            context.tr('gps_live_radar_active'),
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFFF97316) : const Color(0xFFEA580C),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Orange Indicator Line (2 of 3)
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable Vehicle Options
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  // Title Row: "Choose Vehicle" + "For 5 Tons Cement" pill
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          context.tr('choose_vehicle'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF332014) : const Color(0xFFFFEDE4),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.inventory_2_outlined,
                              size: 11,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'For ${state.quantityTons.toStringAsFixed(state.quantityTons.truncateToDouble() == state.quantityTons ? 0 : 1)} Tons ${state.selectedMaterial.name.split(" ").first}',
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Vehicle Cards List
                  ..._vehicles.map((v) {
                    final isSelected = selectedVehicle == v.type;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceCard : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
                          width: isSelected ? 1.8 : 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top: Title, Best Match badge, Fare
                          Row(
                            children: [
                              Expanded(
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 6,
                                  runSpacing: 2,
                                  children: [
                                    Text(
                                      v.title,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                      ),
                                    ),
                                    if (v.isBestMatch)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isDark ? const Color(0xFFB45309) : const Color(0xFFEA580C),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          context.tr('best_match'),
                                          style: const TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '₹${v.fare.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Mid Row: Truck illustration + Metrics (Capacity, Distance, ETA)
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurfaceVariant : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  v.icon,
                                  size: 26,
                                  color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : Colors.black54),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Capacity
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Capacity',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                                      ),
                                    ),
                                    Text(
                                      v.capacity,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Distance
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Distance',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                                      ),
                                    ),
                                    Text(
                                      v.distance,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // ETA
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ETA',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                                      ),
                                    ),
                                    Text(
                                      v.eta,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          const SizedBox(height: 10),

                          // Bottom Row: Model Subtitle + Select / Selected Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  v.modelSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              isSelected
                                  ? ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.check, size: 14, color: Colors.white),
                                      label: Text(
                                        context.tr('selected_status'),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        elevation: 0,
                                        minimumSize: const Size(86, 32),
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                    )
                                  : OutlinedButton(
                                      onPressed: () {
                                        ref.read(bookingFlowProvider.notifier).selectVehicle(v.type);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: isDark ? Colors.white : Colors.black87,
                                        minimumSize: const Size(80, 32),
                                        side: BorderSide(
                                          color: isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 14),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                      child: Text(
                                        context.tr('select_action'),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 10),

                  // BuildMove Price Guarantee Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF131B2A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.verified_outlined,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              context.tr('price_guarantee_title'),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check, size: 12, color: Color(0xFF16A34A)),
                                const SizedBox(width: 4),
                                Text(
                                  context.tr('crew_included'),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check, size: 12, color: Color(0xFF16A34A)),
                                const SizedBox(width: 4),
                                Text(
                                  context.tr('free_buffer_60'),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Sticky Bottom Bar: "6-Wheeler Tipper ₹1,850 est." + "Proceed to Review Booking ->"
          SafeArea(
            top: false,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_shipping_rounded,
                              size: 15,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              selectedData.title,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '₹${selectedData.fare.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} est.',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          context.push(AppRoutes.customerBookingConfirmation);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                context.tr('proceed_to_review'),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
                          ],
                        ),
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
}

class _VehicleDisplayData {
  final VehicleType type;
  final String title;
  final bool isBestMatch;
  final int fare;
  final String capacity;
  final String distance;
  final String eta;
  final String modelSubtitle;
  final IconData icon;

  const _VehicleDisplayData({
    required this.type,
    required this.title,
    required this.isBestMatch,
    required this.fare,
    required this.capacity,
    required this.distance,
    required this.eta,
    required this.modelSubtitle,
    required this.icon,
  });
}

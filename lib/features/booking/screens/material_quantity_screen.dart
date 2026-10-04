import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../models/enums.dart';
import '../providers/booking_flow_provider.dart';

/// Screen 2 — Customer "Material & Quantity" (Step 1 of 3)
/// Matching reference images:
/// - Screenshot 2026-10-01 164948.png (Light) & Screenshot 2026-10-01 165000.png (Dark)
class MaterialQuantityScreen extends ConsumerStatefulWidget {
  const MaterialQuantityScreen({super.key});

  @override
  ConsumerState<MaterialQuantityScreen> createState() => _MaterialQuantityScreenState();
}

class _MaterialQuantityScreenState extends ConsumerState<MaterialQuantityScreen> {
  String _selectedUnit = 'TONS (Metric)';

  void _adjustQuantity(double delta) {
    final current = ref.read(bookingFlowProvider).quantityTons;
    final updated = (current + delta).clamp(0.5, 30.0);
    final rounded = double.parse(updated.toStringAsFixed(1));
    ref.read(bookingFlowProvider.notifier).setQuantity(rounded);
  }

  void _setPreset(double val) {
    ref.read(bookingFlowProvider.notifier).setQuantity(val);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingFlowProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLang = ref.watch(appLocaleProvider).languageCode.toUpperCase();

    final pickup = state.pickupLocation?.address ?? 'Dalmia Cement Depot, Ambattur';
    final drop = state.dropLocation?.address ?? 'Sri Sai Site, OMR Thoraipakkam';

    final int bagsCount = (state.quantityTons * 20).round();
    final String suggestedTruck = state.quantityTons <= 2.0
        ? 'Bolero Maxi / Ace Mega (2T)'
        : state.quantityTons <= 10.0
            ? '6-Wheeler Medium Tipper (6T)'
            : '10-Wheeler Heavy Dumper (20T)';

    final materialItems = [
      _MaterialCardData(
        material: ConstructionMaterial.cement,
        titleEn: 'Cement',
        titleTa: 'சிமெண்ட்',
        desc: '50kg Standard Bags',
        icon: Icons.inventory_2_outlined,
      ),
      _MaterialCardData(
        material: ConstructionMaterial.sand,
        titleEn: 'M-Sand',
        titleTa: 'மணல்',
        desc: 'Fine Aggregate',
        icon: Icons.landscape_outlined,
      ),
      _MaterialCardData(
        material: ConstructionMaterial.steel,
        titleEn: 'TMT Steel 550D',
        titleTa: 'கம்பிகள்',
        desc: 'Bundles & Rods',
        icon: Icons.view_column_outlined,
      ),
      _MaterialCardData(
        material: ConstructionMaterial.bricks,
        titleEn: 'Fly Ash Bricks',
        titleTa: 'செங்கல்',
        desc: 'Stacked Pavers',
        icon: Icons.grid_view_outlined,
      ),
      _MaterialCardData(
        material: ConstructionMaterial.aggregates,
        titleEn: '20mm Aggregates',
        titleTa: 'ஜல்லி',
        desc: 'Coarse Blue Metal',
        icon: Icons.grain_outlined,
      ),
      _MaterialCardData(
        material: ConstructionMaterial.debris,
        titleEn: 'Debris Removal',
        titleTa: 'கட்டுமான கழிவு',
        desc: 'Site Disposal',
        icon: Icons.delete_sweep_outlined,
      ),
      _MaterialCardData(
        material: ConstructionMaterial.tiles,
        titleEn: 'Ceramic Tiles',
        titleTa: 'டைல்ஸ்',
        desc: 'Palletized Boxes',
        icon: Icons.layers_outlined,
      ),
      _MaterialCardData(
        material: ConstructionMaterial.timber,
        titleEn: 'Timber & Plywood',
        titleTa: 'மரம்',
        desc: 'Scaffolding & Boards',
        icon: Icons.forest_outlined,
      ),
    ];

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
          context.tr('material_and_quantity'),
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
          // Step 1 of 3 Progress Header
          Container(
            color: isDark ? AppColors.darkSurface : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'STEP 1 OF 3',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Material & Load',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Orange Indicator Line (1 of 3)
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
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

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route Preview Card (Pickup & Drop)
                  InkWell(
                    onTap: () => context.push(AppRoutes.customerLocations),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceCard : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0284C7),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'PICKUP',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  pickup,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'DROP',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                                ),
                              ),
                              const SizedBox(width: 22),
                              Expanded(
                                child: Text(
                                  drop,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // "What are you transporting?"
                  Text(
                    context.tr('what_are_you_transporting'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2-Column x 4-Row Grid (8 Categories)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: materialItems.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.45,
                    ),
                    itemBuilder: (context, index) {
                      final item = materialItems[index];
                      final isSelected = state.selectedMaterial == item.material;
                      final isTamil = Localizations.maybeLocaleOf(context)?.languageCode == 'ta';

                      return InkWell(
                        onTap: () {
                          ref.read(bookingFlowProvider.notifier).setMaterial(item.material);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceCard : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
                              width: isSelected ? 1.8 : 1.0,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? AppColors.darkSurfaceVariant
                                              : (isSelected ? const Color(0xFFFFEDE4) : const Color(0xFFF8FAFC)),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          item.icon,
                                          color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : Colors.black87),
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isTamil ? item.titleTa : item.titleEn,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        item.desc,
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 22),

                  // "How much do you need to move?"
                  Text(
                    context.tr('how_much_to_move'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.tr('approx_weight_sub'),
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Segmented unit tabs: TONS (Metric), BAGS (50kg), LOADS (CFT)
                  Row(
                    children: [
                      _unitTab('TONS (Metric)', isDark),
                      const SizedBox(width: 8),
                      _unitTab('BAGS (50kg)', isDark),
                      const SizedBox(width: 8),
                      _unitTab('LOADS (CFT)', isDark),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Big Quantity Counter Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceCard : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: state.quantityTons.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                ),
                              ),
                              const TextSpan(
                                text: ' TONS',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Approx. $bagsCount bags • $suggestedTruck',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Stepper buttons row
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: OutlinedButton(
                                  onPressed: () => _adjustQuantity(-0.5),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: isDark ? Colors.white : Colors.black87,
                                    side: BorderSide(
                                      color: isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    '- 0.5 T',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () => _adjustQuantity(0.5),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    '+ 0.5 T',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Quick Presets: 1 Ton, 3 Tons, 5 Tons, 10 Tons, 16 Tons
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _presetChip('1 Ton', 1.0, state.quantityTons, isDark),
                              const SizedBox(width: 8),
                              _presetChip('3 Tons', 3.0, state.quantityTons, isDark),
                              const SizedBox(width: 8),
                              _presetChip('5 Tons', 5.0, state.quantityTons, isDark),
                              const SizedBox(width: 8),
                              _presetChip('10 Tons', 10.0, state.quantityTons, isDark),
                              const SizedBox(width: 8),
                              _presetChip('16 Tons', 16.0, state.quantityTons, isDark),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Zero-Overload Guarantee Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2638) : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? const Color(0xFF2A3A5A) : const Color(0xFFBFDBFE),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          size: 16,
                          color: AppColors.secondaryBlue,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.tr('zero_overload_guarantee'),
                            style: TextStyle(
                              fontSize: 10.5,
                              color: isDark ? AppColors.darkTextSecondary : const Color(0xFF1E3A8A),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // SUGGESTED FLEET TYPE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          context.tr('suggested_fleet_type'),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        context.tr('immediate_dispatch'),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceCard : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceVariant : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.local_shipping_rounded,
                            size: 24,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                suggestedTruck,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Payload fit: ${state.quantityTons} Tons • $bagsCount Bags',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '12 mins away',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Sticky Bottom Bar
          Container(
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
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${context.tr('configured_load')}: ${state.selectedMaterial.name.split(" ").first} • ${state.quantityTons} Tons',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
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
                      context.push(AppRoutes.customerVehicleSelection);
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
                            context.tr('continue_to_select_vehicle'),
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
        ],
      ),
    );
  }

  Widget _unitTab(String label, bool isDark) {
    final isSelected = _selectedUnit == label;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedUnit = label),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                : (isDark ? AppColors.darkSurfaceCard : Colors.white),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                  : (isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1)),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? (isDark ? Colors.black87 : Colors.white)
                    : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _presetChip(String label, double val, double currentVal, bool isDark) {
    final isSelected = (val - currentVal).abs() < 0.05;
    return InkWell(
      onTap: () => _setPreset(val),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : const Color(0xFF0F172A))
              : (isDark ? AppColors.darkSurfaceVariant : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? (isDark ? Colors.black87 : Colors.white)
                : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}

class _MaterialCardData {
  final ConstructionMaterial material;
  final String titleEn;
  final String titleTa;
  final String desc;
  final IconData icon;

  const _MaterialCardData({
    required this.material,
    required this.titleEn,
    required this.titleTa,
    required this.desc,
    required this.icon,
  });
}

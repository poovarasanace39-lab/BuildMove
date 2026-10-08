import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/enums.dart';
import '../../booking/providers/booking_flow_provider.dart';
import '../providers/customer_notifications_provider.dart';

/// Customer Home Dashboard strictly matching BuildMove Reference Design
/// (Screenshot 2026-10-01 164948.png & Screenshot 2026-10-01 165000.png)
/// - Top brand bar: Logo, "BuildMove", "Customer Home" subtitle, Theme toggle, Language pill, Notification bell, Avatar with "TN Fleet" badge
/// - Contractor Greeting: ", Rajesh Good morning", "Kavitha Constructions • GST Verified", "TN Fleet" pill
/// - Hero Route Booking Card: "Where are you moving materials?", Loading Point (Dalmia Cement Depot, Ambattur • GPS Auto), Unloading Site (Site Phase 2, OMR Navalur • Recent), "BOOK A VEHICLE ->" CTA, "3 min dispatch" & "Digital Weigh-Slip"
/// - "What are you moving?" 2-column grid of 6 materials with Tamil subtext (Cement, M-Sand, TMT Steel, Bricks, Blue Metal, Tiles & Granite)
/// - "Recent Booking" card with "Cement (5 Tons)", "₹1,850", "Ambattur Depot -> Navalur Phase 2", "Delivered yesterday, 4:30 PM", "Delivered" badge, and "Reorder" button
/// - Proper pull-to-refresh awaiting the provider future (no frozen spinner)
class CustomerHomeDashboard extends ConsumerWidget {
  const CustomerHomeDashboard({super.key});

  void _startBookingFlow(BuildContext context, WidgetRef ref, [ConstructionMaterial? material]) {
    if (material != null) {
      ref.read(bookingFlowProvider.notifier).setMaterial(material);
    }
    context.push(AppRoutes.customerMaterialQuantity);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bookingFlowState = ref.watch(bookingFlowProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(activeBookingsProvider);
          try {
            await ref.read(activeBookingsProvider.future);
          } catch (_) {}
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header Bar (Branding & Controls)
              _buildTopBar(context, ref, isDark),

              const SizedBox(height: 16),

              // 2. Contractor Greeting & Identity Row
              _buildContractorGreeting(context, isDark),

              const SizedBox(height: 18),

              // 3. Hero Route Booking Card
              _buildHeroBookingCard(context, ref, bookingFlowState, isDark),

              const SizedBox(height: 22),

              // 4. "What are you moving?" 2-Column Grid
              _buildMaterialsGridSection(context, ref, isDark),

              const SizedBox(height: 22),

              // 5. Recent Booking Section
              _buildRecentBookingSection(context, ref, isDark),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. Top Bar: App Logo, Title + Subtitle, Notification Bell, Avatar
  Widget _buildTopBar(BuildContext context, WidgetRef ref, bool isDark) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Logo + "BuildMove" + Subtitle "Customer Home"
        Expanded(
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.local_shipping_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'Build',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        const Text(
                          'Move',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Customer Home',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Right Controls: Single Notification Entry Point + Avatar
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Notification Bell (48x48 touch target, clear entry point)
            InkWell(
              key: const Key('home_notification_bell'),
              onTap: () {
                ref.read(customerShellTabProvider.notifier).state = 2;
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceVariant : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    size: 18,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Profile Avatar (48x48 touch target)
            InkWell(
              onTap: () {
                ref.read(customerShellTabProvider.notifier).state = 3;
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: isDark
                      ? AppColors.primary.withAlpha(40)
                      : AppColors.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 18,
                    color: isDark ? AppColors.primaryLight : AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 2. Contractor Greeting: "Hi, Ramesh Good morning" + "BuildCon Infra Pvt Ltd • GST Verified"
  Widget _buildContractorGreeting(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Hi, Ramesh',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      Localizations.maybeLocaleOf(context)?.languageCode == 'ta'
                          ? 'காலை வணக்கம்'
                          : 'Good morning',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.check_circle_rounded, size: 12, color: AppColors.secondaryBlue),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'BuildCon Infra Pvt Ltd',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      context.tr('gst_verified_badge'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFF60A5FA) : AppColors.secondaryBlue,
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
      ],
    );
  }

  /// 3. Hero Route Booking Card matching Reference Design
  Widget _buildHeroBookingCard(
    BuildContext context,
    WidgetRef ref,
    BookingFlowState state,
    bool isDark,
  ) {
    final pickupAddress = state.pickupLocation?.address ?? 'Dalmia Cement Depot, Ambattur';
    final dropAddress = state.dropLocation?.address ?? 'Site Phase 2, OMR Navalur';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0x22000000) : const Color(0x08000000),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            context.tr('where_are_you_moving_materials'),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          // Route Inner Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceVariant : const Color(0xFFF1F4F8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                width: 0.8,
              ),
            ),
            child: Column(
              children: [
                // Loading Point
                InkWell(
                  onTap: () => context.push(AppRoutes.customerLocations),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0284C7),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      context.tr('loading_point_tag'),
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                        color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Row(
                                          children: [
                                            const Icon(Icons.gps_fixed, color: Color(0xFF0284C7), size: 20),
                                            const SizedBox(width: 8),
                                            Text(context.tr('gps_demo_title'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        content: Text(context.tr('gps_demo_msg')),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(ctx).pop(),
                                            child: Text(context.tr('confirm')),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFE0F2FE),
                                      borderRadius: BorderRadius.circular(4),
                                      border: isDark ? Border.all(color: const Color(0xFF0284C7).withAlpha(80), width: 0.8) : null,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.gps_fixed, size: 9, color: isDark ? Colors.lightBlueAccent : const Color(0xFF0284C7)),
                                        const SizedBox(width: 3),
                                        Text(
                                          context.tr('gps_auto_badge'),
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: isDark ? Colors.lightBlueAccent : const Color(0xFF0284C7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              pickupAddress,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Connector Line
                Padding(
                  padding: const EdgeInsets.only(left: 4.5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 1.5,
                      height: 18,
                      color: isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1),
                    ),
                  ),
                ),

                // Unloading Site
                InkWell(
                  onTap: () => context.push(AppRoutes.customerLocations),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      context.tr('unloading_site_tag'),
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                        color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Row(
                                          children: [
                                            const Icon(Icons.history_rounded, color: AppColors.primary, size: 20),
                                            const SizedBox(width: 8),
                                            Text(context.tr('recent_site_title'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        content: Text(context.tr('recent_site_msg')),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(ctx).pop(),
                                            child: Text(context.tr('confirm')),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF332014) : const Color(0xFFFFEDE4),
                                      borderRadius: BorderRadius.circular(4),
                                      border: isDark ? Border.all(color: AppColors.primary.withAlpha(80), width: 0.8) : null,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.history_rounded, size: 9, color: AppColors.primary),
                                        const SizedBox(width: 3),
                                        Text(
                                          context.tr('recent_badge'),
                                          style: const TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              dropAddress,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Primary "BOOK A VEHICLE ->" CTA
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _startBookingFlow(context, ref),
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
                children: [
                  const Icon(Icons.local_shipping_rounded, size: 19, color: Colors.white),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      context.tr('book_a_vehicle'),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Sub-CTA Guarantee Row: "3 min dispatch" • "Digital Weigh-Slip"
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 14,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.alarm_rounded, size: 13, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    context.tr('min_dispatch_pill'),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.scale_rounded, size: 13, color: AppColors.secondaryBlue),
                  const SizedBox(width: 4),
                  Text(
                    context.tr('digital_weigh_slip_pill'),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 4. "What are you moving?" 2-Column Grid with Tamil Subtitles
  Widget _buildMaterialsGridSection(BuildContext context, WidgetRef ref, bool isDark) {
    final materials = [
      _MaterialItem(
        material: ConstructionMaterial.cement,
        nameEn: 'Cement',
        nameTa: 'சிமெண்ட்',
        icon: Icons.inventory_2_outlined,
      ),
      _MaterialItem(
        material: ConstructionMaterial.sand,
        nameEn: 'M-Sand',
        nameTa: 'மணல்',
        icon: Icons.landscape_outlined,
      ),
      _MaterialItem(
        material: ConstructionMaterial.steel,
        nameEn: 'TMT Steel',
        nameTa: 'கம்பிகள்',
        icon: Icons.view_column_outlined,
      ),
      _MaterialItem(
        material: ConstructionMaterial.bricks,
        nameEn: 'Bricks',
        nameTa: 'செங்கல்',
        icon: Icons.grid_view_outlined,
      ),
      _MaterialItem(
        material: ConstructionMaterial.aggregates,
        nameEn: 'Blue Metal',
        nameTa: 'ஜல்லி',
        icon: Icons.grain_outlined,
      ),
      _MaterialItem(
        material: ConstructionMaterial.tiles,
        nameEn: 'Tiles & Granite',
        nameTa: 'டைல்ஸ்',
        icon: Icons.layers_outlined,
      ),
      _MaterialItem(
        material: ConstructionMaterial.timber,
        nameEn: 'Timber & Plywood',
        nameTa: 'மரம் & பிளைவுட்',
        icon: Icons.forest_outlined,
      ),
      _MaterialItem(
        material: ConstructionMaterial.debris,
        nameEn: 'Site Debris',
        nameTa: 'கட்டுமான கழிவு',
        icon: Icons.delete_sweep_outlined,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                context.tr('what_are_you_moving'),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 2-Column Grid
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: materials.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.25,
          ),
          itemBuilder: (context, index) {
            final item = materials[index];
            return InkWell(
              onTap: () => _startBookingFlow(context, ref, item.material),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceCard : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceVariant : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.icon,
                        color: isDark ? AppColors.primaryLight : AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Localizations.maybeLocaleOf(context)?.languageCode == 'ta'
                                ? item.nameTa
                                : item.nameEn,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// 5. Recent Booking Section
  Widget _buildRecentBookingSection(BuildContext context, WidgetRef ref, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr('recent_trips'),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            InkWell(
              onTap: () {
                context.push('${AppRoutes.customerBookings}?tab=history');
              },
              child: Row(
                children: [
                  Text(
                    context.tr('view_all'),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF60A5FA) : AppColors.secondaryBlue,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 14,
                    color: isDark ? const Color(0xFF60A5FA) : AppColors.secondaryBlue,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceCard : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceVariant : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.local_shipping_outlined,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Localizations.maybeLocaleOf(context)?.languageCode == 'ta'
                                    ? 'சிமெண்ட் (5 டன்)'
                                    : 'Cement (5 Tons)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Ambattur Depot → Navalur Phase 2',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹1,850',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(height: 1, color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            context.tr('deliv_yesterday'),
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF052E16) : const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(4),
                            border: isDark
                                ? Border.all(color: const Color(0xFF16A34A).withAlpha(80), width: 0.8)
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check,
                                size: 10,
                                color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                context.tr('delivered_status'),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Reorder Button
                  InkWell(
                    onTap: () {
                      ref.read(bookingFlowProvider.notifier).setMaterial(ConstructionMaterial.cement);
                      ref.read(bookingFlowProvider.notifier).setQuantity(5.0);
                      context.push(AppRoutes.customerMaterialQuantity);
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceVariant : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh_rounded,
                            size: 12,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.tr('reorder'),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MaterialItem {
  final ConstructionMaterial material;
  final String nameEn;
  final String nameTa;
  final IconData icon;

  const _MaterialItem({
    required this.material,
    required this.nameEn,
    required this.nameTa,
    required this.icon,
  });
}

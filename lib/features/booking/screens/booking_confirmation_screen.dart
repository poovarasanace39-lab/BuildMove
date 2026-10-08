import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/enums.dart';
import '../providers/booking_flow_provider.dart';

/// Screen 4 — Customer "Booking Confirmation"
/// Matching reference images:
/// - Screenshot 2026-10-01 164948.png (Light) & Screenshot 2026-10-01 165000.png (Dark)
class BookingConfirmationScreen extends ConsumerStatefulWidget {
  const BookingConfirmationScreen({super.key});

  @override
  ConsumerState<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends ConsumerState<BookingConfirmationScreen> {
  int _selectedPaymentMethodIndex = 0; // 0: Cash, 1: UPI, 2: Credit
  bool _isConfirming = false;

  void _onConfirmBooking() async {
    setState(() => _isConfirming = true);

    final booking = await ref.read(bookingFlowProvider.notifier).confirmBooking();

    if (!mounted) return;
    setState(() => _isConfirming = false);

    if (booking != null) {
      context.go(AppRoutes.customerLiveTrackingPath(booking.id));
    } else {
      // Fallback if null, navigate to default trip
      context.go(AppRoutes.customerLiveTrackingPath('BM-8492'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingFlowProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langCode = ref.watch(appLocaleProvider).languageCode;

    final pickup = state.pickupLocation?.address ?? 'Dalmia Cement Depot, Ambattur';
    final drop = state.dropLocation?.address ?? 'Construction Site, OMR Thoraipakkam';
    final materialName = state.selectedMaterial.localizedName(langCode);
    final vehicleName = state.selectedVehicleType == VehicleType.pickup8ft
        ? 'Bolero Maxi / Ace Mega (2T)'
        : state.selectedVehicleType == VehicleType.tipper10Wheeler
            ? '10-Wheeler Heavy Dumper (20T)'
            : '6-Wheeler Tipper (10T)';

    final totalFare = state.selectedVehicleType == VehicleType.pickup8ft
        ? 850
        : state.selectedVehicleType == VehicleType.tipper10Wheeler
            ? 2600
            : 1850;

    final baseFare = totalFare == 850
        ? 550
        : totalFare == 2600
            ? 1700
            : 1200;
    final surchargeFare = totalFare == 850
        ? 200
        : totalFare == 2600
            ? 600
            : 450;
    final taxFare = totalFare - baseFare - surchargeFare;

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
          context.tr('review_confirm'),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Verified Trip #BM-8492 + Escrow Shield
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF132A1C) : const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isDark ? const Color(0xFF166534) : const Color(0xFF86EFAC),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified_rounded, size: 12, color: Color(0xFF16A34A)),
                            const SizedBox(width: 4),
                            Text(
                              'VERIFIED TRIP   #BM-8492',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF15803D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.shield_outlined,
                        size: 18,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Review & Confirm Title
                  Text(
                    context.tr('review_confirm'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 1. Haulage Summary Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceCard : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
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
                                  Icon(
                                    Icons.local_shipping_outlined,
                                    size: 15,
                                    color: isDark ? AppColors.primaryLight : AppColors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      context.tr('haulage_summary'),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF332014) : const Color(0xFFFFEDE4),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                context.tr('ready_to_dispatch'),
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Material
                        _summaryRow(
                          icon: Icons.inventory_2_outlined,
                          label: 'MATERIAL',
                          value: '$materialName • ${state.quantityTons} Tons',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),

                        // Pickup
                        _summaryRow(
                          icon: Icons.radio_button_checked_rounded,
                          label: 'PICKUP',
                          value: pickup,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),

                        // Delivery
                        _summaryRow(
                          icon: Icons.location_on_outlined,
                          label: 'DELIVERY',
                          value: drop,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),

                        // Vehicle
                        _summaryRow(
                          icon: Icons.fire_truck_outlined,
                          label: 'VEHICLE',
                          value: vehicleName,
                          isDark: isDark,
                        ),

                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 10),

                        // Assigned Driver sub-card: Murugan K. ★ 4.9
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurfaceVariant : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                      child: const Icon(Icons.person, size: 16, color: AppColors.primary),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            context.tr('assigned_driver'),
                                            style: TextStyle(
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.4,
                                              color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                                            ),
                                          ),
                                          Text(
                                            'Murugan K.',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                          Text(
                                            'TN-02-AL-8921 • $vehicleName',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w600,
                                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF332014) : const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.star_rounded, size: 12, color: Color(0xFFD97706)),
                                    SizedBox(width: 2),
                                    Text(
                                      '4.9',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFFD97706),
                                      ),
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

                  // 2. Total Fare Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceCard : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.receipt_outlined,
                                  size: 15,
                                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  context.tr('total_fare'),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '₹${totalFare.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 8),

                        _fareRow('Base Transport (up to 10 km)', '₹${baseFare.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', isDark),
                        const SizedBox(height: 5),
                        _fareRow('Distance Surcharge (8.5 km extra)', '₹${surchargeFare.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', isDark),
                        const SizedBox(height: 5),
                        _fareRow('Loading / Unloading Buffer', '60 mins Free', isDark, isHighlight: true),
                        const SizedBox(height: 5),
                        _fareRow('Taxes & Site Cess', '₹${taxFare.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', isDark),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 3. Settlement Method Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceCard : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                context.tr('settlement_method'),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.shield_outlined, size: 12, color: AppColors.primary),
                                const SizedBox(width: 3),
                                Text(
                                  context.tr('escrow_safe'),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Option 1: Cash after Unloading
                        _paymentOptionTile(
                          index: 0,
                          title: context.tr('cash_after_unloading'),
                          subtitle: context.tr('digital_receipt_verified'),
                          icon: Icons.payments_outlined,
                          isDark: isDark,
                        ),

                        const SizedBox(height: 8),

                        // Option 2: Instant UPI (GPay / PhonePe)
                        _paymentOptionTile(
                          index: 1,
                          title: context.tr('instant_upi'),
                          subtitle: context.tr('pay_on_arrival'),
                          icon: Icons.qr_code_2_rounded,
                          isDark: isDark,
                        ),

                        const SizedBox(height: 8),

                        // Option 3: Contractor Credit Line (15-DAY)
                        _paymentOptionTile(
                          index: 2,
                          title: context.tr('contractor_credit'),
                          subtitle: context.tr('available_credit_balance'),
                          badge: '15-DAY',
                          icon: Icons.credit_card_outlined,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Persistent Sticky Confirmation Bar
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    offset: const Offset(0, -3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sub-CTA: Edit Details & 100% Guaranteed Dispatch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SizedBox(
                          height: 48,
                          child: TextButton.icon(
                            key: const Key('edit_details_button'),
                            onPressed: () => context.pop(),
                            style: TextButton.styleFrom(
                              minimumSize: const Size(48, 48),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                              foregroundColor: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                            icon: Icon(
                              Icons.edit_outlined,
                              size: 16,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                            label: Text(
                              context.tr('edit_details'),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Row(
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
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                context.tr('guaranteed_dispatch_100'),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Confirm Booking CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      key: const Key('confirm_booking_button'),
                      onPressed: _isConfirming ? null : _onConfirmBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isConfirming
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock_outline_rounded, size: 16, color: Colors.white),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    '${context.tr('confirm')} · ₹${totalFare.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w800,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 13,
          color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fareRow(String label, String value, bool isDark, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isHighlight
                ? const Color(0xFF16A34A)
                : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _paymentOptionTile({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDark,
    String? badge,
  }) {
    final isSelected = _selectedPaymentMethodIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethodIndex = index),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkSurfaceVariant : const Color(0xFFF8FAFC))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
            width: isSelected ? 1.5 : 0.8,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : const Color(0xFF94A3B8),
                  width: isSelected ? 4.5 : 1.5,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              icon,
              size: 18,
              color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

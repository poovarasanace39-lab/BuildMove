import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/contact_action_helper.dart';
import '../../booking/providers/booking_flow_provider.dart';

/// Screen 5 — Customer "Live Trip Tracking"
/// Matching reference images:
/// - Screenshot 2026-10-01 164948.png (Light) & Screenshot 2026-10-01 165000.png (Dark)
class LiveTrackingScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const LiveTrackingScreen({
    super.key,
    required this.bookingId,
  });

  @override
  ConsumerState<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends ConsumerState<LiveTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLang = ref.watch(appLocaleProvider).languageCode.toUpperCase();
    final bookingFlowState = ref.watch(bookingFlowProvider);

    final materialName = bookingFlowState.selectedMaterial.name.split(" ").first;
    final quantityTons = bookingFlowState.quantityTons;

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
          onPressed: () => context.go(AppRoutes.customerHome),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFEA580C),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                context.tr('live_tracking'),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ),
          ],
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
          // 1. Interactive Live Map Canvas Area (takes ~45% - 50% of the screen height)
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                // Custom Map Background with Roads & Landmark Labels
                Positioned.fill(
                  child: CustomPaint(
                    painter: _LiveTrackingMapPainter(
                      isDark: isDark,
                      pulseProgress: _animController.value,
                    ),
                  ),
                ),

                // Top Left Overlay: GPS Live Radar • 2.4 km away
                Positioned(
                  top: 12,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xCC0B0F19) : const Color(0xEEFFFFFF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? const Color(0xFF263347) : const Color(0xFFCBD5E1),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
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
                        const SizedBox(width: 5),
                        Text(
                          'GPS Live Radar • 2.4 km away',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Top Right Floating Controls (SOS HELP or Map Buttons)
                Positioned(
                  top: 12,
                  right: 14,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEA580C),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33EA580C),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.emergency, size: 12, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'SOS HELP',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Floating map tool icons
                      _floatingToolBtn(Icons.explore_outlined, isDark),
                      const SizedBox(height: 6),
                      _floatingToolBtn(Icons.traffic_rounded, isDark),
                      const SizedBox(height: 6),
                      _floatingToolBtn(Icons.layers_outlined, isDark),
                    ],
                  ),
                ),

                // Bottom Left Overlay on Map: Smooth Traffic • 2.4 km left
                Positioned(
                  bottom: 12,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xCC0B0F19) : const Color(0xEEFFFFFF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? const Color(0xFF263347) : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF16A34A),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Smooth Traffic • 2.4 km left',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Sliding Logistics Details Bottom Sheet
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Top Row: "Vehicle arriving / 6-Wheeler Tipper TN 09 BK 4821" + "11:42 AM TARGET ETA"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEA580C),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      context.tr('vehicle_arriving'),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '6-Wheeler Tipper   TN 09 BK 4821',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '11:42 AM',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              context.tr('target_eta'),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Manifest Pill: "✓ Cement • 5 Tons | Digital Weigh-Slip" with "CLEARED" badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceVariant : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.check, size: 12, color: Color(0xFF16A34A)),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    '$materialName • $quantityTons Tons | Digital Weigh-Slip',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              context.tr('cleared_status'),
                              style: const TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF16A34A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 5-Stage Horizontal Status Tracker
                    _buildTrackingPipeline(isDark),

                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 10),

                    // Driver Card: Murugan K., ★ 4.9, ID: DLM-482, 1,240+ trips
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                          child: const Icon(Icons.person, size: 22, color: AppColors.primary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Murugan K.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF332014) : const Color(0xFFFEF3C7),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.star_rounded, size: 10, color: Color(0xFFD97706)),
                                        SizedBox(width: 2),
                                        Text(
                                          '4.9',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFFD97706),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 1),
                              Text(
                                'Dalmia Logistics Partner • 1,240+ trips',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'ID: DLM-482',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Action Buttons: Call Driver (Orange) + Message (Outlined)
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ContactActionHelper.showCallDemo(
                                  context,
                                  'Murugan K.',
                                  '+91 98401 23456',
                                );
                              },
                              icon: const Icon(Icons.phone, size: 14, color: Colors.white),
                              label: Text(
                                context.tr('call_driver'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ContactActionHelper.showMessageDemo(
                                  context,
                                  'Murugan K.',
                                  '+91 98401 23456',
                                );
                              },
                              icon: Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 14,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              label: Text(
                                context.tr('message_action'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Destination Gate: Site Bay 03, Tower B with Gate Pass >
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 12, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Destination Gate: Site Bay 03, Tower B',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Gate Pass #GP-9014 verified by Security Desk')),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                context.tr('gate_pass'),
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.secondaryBlue,
                                ),
                              ),
                              const Icon(Icons.chevron_right, size: 12, color: AppColors.secondaryBlue),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingToolBtn(IconData icon, bool isDark) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xCC0B0F19) : const Color(0xEEFFFFFF),
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? const Color(0xFF263347) : const Color(0xFFCBD5E1),
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 15,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTrackingPipeline(bool isDark) {
    final stages = [
      {'title': 'Assigned', 'isDone': true, 'isCurrent': false},
      {'title': 'Arriving', 'isDone': false, 'isCurrent': true},
      {'title': 'Pickup', 'isDone': false, 'isCurrent': false},
      {'title': 'In Transit', 'isDone': false, 'isCurrent': false},
      {'title': 'Delivered', 'isDone': false, 'isCurrent': false},
    ];

    return Row(
      children: stages.map((s) {
        final isDone = s['isDone'] as bool;
        final isCurrent = s['isCurrent'] as bool;
        final title = s['title'] as String;

        return Expanded(
          child: Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? const Color(0xFF16A34A)
                      : (isCurrent ? AppColors.primary : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0))),
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.primary
                        : (isDone ? const Color(0xFF16A34A) : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1))),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 11, color: Colors.white)
                      : (isCurrent
                          ? Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                  color: isCurrent
                      ? AppColors.primary
                      : (isDone
                          ? (isDark ? Colors.white : Colors.black87)
                          : (isDark ? AppColors.darkTextTertiary : AppColors.textTertiary)),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Custom Vector Map Painter rendering Chennai logistics route matching reference images
class _LiveTrackingMapPainter extends CustomPainter {
  final bool isDark;
  final double pulseProgress;

  _LiveTrackingMapPainter({
    required this.isDark,
    required this.pulseProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Background Fill
    final bgPaint = Paint()..color = isDark ? const Color(0xFF0F1523) : const Color(0xFFE8EEF5);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. Coastal / Water Area on the right
    final waterPaint = Paint()..color = isDark ? const Color(0xFF0B1B33) : const Color(0xFFD6E4F0);
    final waterPath = Path()
      ..moveTo(size.width * 0.78, 0)
      ..quadraticBezierTo(size.width * 0.74, size.height * 0.45, size.width * 0.82, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(waterPath, waterPaint);

    // 3. Grid / Minor Roads
    final roadPaint = Paint()
      ..color = isDark ? const Color(0xFF1E283C) : const Color(0xFFCBD5E1)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (double y = 40; y < size.height; y += 45) {
      canvas.drawLine(Offset(0, y), Offset(size.width * 0.78, y + 10), roadPaint);
    }
    for (double x = 40; x < size.width * 0.78; x += 55) {
      canvas.drawLine(Offset(x, 0), Offset(x + 15, size.height), roadPaint);
    }

    // 4. Primary Active Route (Dalmia Depot -> Site OMR)
    final routeStart = Offset(size.width * 0.28, size.height * 0.22);
    final truckPos = Offset(size.width * 0.52, size.height * 0.42);
    final routeEnd = Offset(size.width * 0.65, size.height * 0.72);

    final routePath = Path()
      ..moveTo(routeStart.dx, routeStart.dy)
      ..quadraticBezierTo(size.width * 0.45, size.height * 0.28, truckPos.dx, truckPos.dy)
      ..quadraticBezierTo(size.width * 0.58, size.height * 0.55, routeEnd.dx, routeEnd.dy);

    // Route Glow
    final glowPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.3)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(routePath, glowPaint);

    // Route Main
    final mainRoutePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(routePath, mainRoutePaint);

    // 5. Waypoint 1: Dalmia Depot
    final ptPaint = Paint()..color = const Color(0xFF0284C7);
    canvas.drawCircle(routeStart, 5, ptPaint);
    _drawText(canvas, 'Dalmia Depot', routeStart.dx + 8, routeStart.dy - 6, isDark);

    // 6. Waypoint 2: Site - OMR
    final dropPaint = Paint()..color = const Color(0xFFEA580C);
    canvas.drawCircle(routeEnd, 5, dropPaint);
    _drawText(canvas, 'Site - OMR', routeEnd.dx + 8, routeEnd.dy - 6, isDark);

    // 7. Pulse Ring at Truck Position
    final pulsePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: (1.0 - pulseProgress).clamp(0.0, 0.6))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(truckPos, 14 + (16 * pulseProgress), pulsePaint);

    // 8. Vehicle Position Marker
    final truckCirclePaint = Paint()..color = AppColors.primary;
    canvas.drawCircle(truckPos, 10, truckCirclePaint);

    // Speed Tag next to truck: "38 km/h • Tipper"
    final tagRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(truckPos.dx + 12, truckPos.dy - 9, 86, 18),
      const Radius.circular(9),
    );
    final tagBg = Paint()..color = isDark ? const Color(0xDD000000) : const Color(0xEEFFFFFF);
    canvas.drawRRect(tagRect, tagBg);
    _drawSpeedText(canvas, '38 km/h • Tipper', truckPos.dx + 18, truckPos.dy - 5, isDark);
  }

  void _drawText(Canvas canvas, String text, double x, double y, bool isDark) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.black87,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x, y));
  }

  void _drawSpeedText(Canvas canvas, String text, double x, double y, bool isDark) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 8,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant _LiveTrackingMapPainter oldDelegate) => true;
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/location_model.dart';

class MapPlaceholderWidget extends StatefulWidget {
  final LocationModel? pickup;
  final LocationModel? drop;
  final double? distanceKm;
  final int? etaMinutes;
  final bool isLiveTracking;

  const MapPlaceholderWidget({
    super.key,
    this.pickup,
    this.drop,
    this.distanceKm,
    this.etaMinutes,
    this.isLiveTracking = false,
  });

  @override
  State<MapPlaceholderWidget> createState() => _MapPlaceholderWidgetState();
}

class _MapPlaceholderWidgetState extends State<MapPlaceholderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _radarController;
  late Animation<double> _pulseAnimation;
  bool _showTraffic = true;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.6).animate(
      CurvedAnimation(parent: _radarController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF131A26) : const Color(0xFFE8EEF5);
    final gridColor = isDark ? const Color(0xFF1E2838) : const Color(0xFFD3DDE8);
    final routeColor = const Color(0xFF0051D5);

    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE0E3E7),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // 1. Vector Map Grid & Roads Painter
            CustomPaint(
              size: const Size(double.infinity, 250),
              painter: _MapRoadsPainter(
                gridColor: gridColor,
                isDark: isDark,
                showTraffic: _showTraffic,
              ),
            ),

            // 2. Interactive Route Polyline & Markers
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Origin Yard Marker
                    _locationMarker(
                      label: 'Pickup Yard',
                      color: const Color(0xFF00A854),
                      icon: Icons.storefront_rounded,
                      isDark: isDark,
                    ),

                    // Central Route & Vehicle Marker
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Route line with dashed style
                          Container(
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: routeColor.withAlpha(160),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),

                          // Animated Radar Waves
                          AnimatedBuilder(
                            animation: _radarController,
                            builder: (context, child) {
                              return Container(
                                width: 44 * _pulseAnimation.value,
                                height: 44 * _pulseAnimation.value,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: routeColor.withValues(
                                    alpha: (1.0 - (_pulseAnimation.value - 0.8) / 0.8).clamp(0.0, 0.4),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Moving Vehicle Marker
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCC4900),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFCC4900).withAlpha(100),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.local_shipping_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Destination Site Marker
                    _locationMarker(
                      label: 'Delivery Site',
                      color: const Color(0xFFCC4900),
                      icon: Icons.location_on_rounded,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),

            // 3. Top Floating Banner: GPS Live Radar Active & ETA
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Live Radar Status Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF111E2E) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFF0051D5).withAlpha(60),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00C853),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.isLiveTracking ? 'GPS RADAR ACTIVE' : 'ROUTE MAP',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Color(0xFF0051D5),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Distance & ETA Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF111E2E) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer_outlined, size: 14, color: Color(0xFFCC4900)),
                        const SizedBox(width: 4),
                        Text(
                          '~${widget.etaMinutes ?? 18} mins',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF181C1F),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '• ${widget.distanceKm ?? 14.5} km',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.darkTextSecondary : const Color(0xFF585F6D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 4. Floating Map Controls (Zoom / Traffic / Recenter)
            Positioned(
              bottom: 12,
              right: 12,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _mapButton(
                    icon: _showTraffic ? Icons.traffic_rounded : Icons.traffic_outlined,
                    color: _showTraffic ? const Color(0xFF00A854) : Colors.grey,
                    onTap: () => setState(() => _showTraffic = !_showTraffic),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _mapButton(
                    icon: Icons.my_location_rounded,
                    color: const Color(0xFF0051D5),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Centered on live vehicle position')),
                      );
                    },
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            // 5. Telemetry tag
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black54 : Colors.white.withAlpha(220),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Live Telemetry 10Hz • High Precision GPS',
                  style: TextStyle(
                    fontSize: 9,
                    color: isDark ? Colors.white70 : const Color(0xFF585F6D),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2838) : Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(color: Color(0x1F000000), blurRadius: 4),
          ],
          border: Border.all(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE0E3E7),
          ),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _locationMarker({
    required String label,
    required Color color,
    required IconData icon,
    required bool isDark,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 6),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2838) : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : const Color(0xFFE0E3E7),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : const Color(0xFF181C1F),
            ),
          ),
        ),
      ],
    );
  }
}

class _MapRoadsPainter extends CustomPainter {
  final Color gridColor;
  final bool isDark;
  final bool showTraffic;

  _MapRoadsPainter({
    required this.gridColor,
    required this.isDark,
    required this.showTraffic,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = gridColor.withAlpha(isDark ? 80 : 120)
      ..strokeWidth = 1.0;

    // Minor grid
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Arterial road vector lines
    final roadPaint = Paint()
      ..color = isDark ? const Color(0xFF2B3A4F) : const Color(0xFFCBD5E1)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.cubicTo(
      size.width * 0.3,
      size.height * 0.65,
      size.width * 0.6,
      size.height * 0.4,
      size.width,
      size.height * 0.35,
    );
    canvas.drawPath(path, roadPaint);

    // Cross arterial
    final crossPath = Path();
    crossPath.moveTo(size.width * 0.2, 0);
    crossPath.cubicTo(
      size.width * 0.35,
      size.height * 0.45,
      size.width * 0.75,
      size.height * 0.55,
      size.width * 0.85,
      size.height,
    );
    canvas.drawPath(crossPath, roadPaint);

    // Green traffic flow overlay
    if (showTraffic) {
      final trafficPaint = Paint()
        ..color = const Color(0xFF00C853).withAlpha(160)
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, trafficPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MapRoadsPainter oldDelegate) =>
      oldDelegate.gridColor != gridColor ||
      oldDelegate.isDark != isDark ||
      oldDelegate.showTraffic != showTraffic;
}

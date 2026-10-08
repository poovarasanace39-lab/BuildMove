import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/contact_action_helper.dart';
import '../../../models/enums.dart';
import '../../../services/auth/dev_auth_service.dart';
import '../../../services/demo/demo_data_service.dart';
import '../../../services/booking/mock_booking_service.dart';
import '../../../services/fleet/mock_fleet_service.dart';
import '../../admin/providers/fleet_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../booking/providers/booking_flow_provider.dart';
import '../providers/customer_notifications_provider.dart';

class CustomerProfileScreen extends ConsumerStatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  ConsumerState<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends ConsumerState<CustomerProfileScreen> {
  String _companyName = 'BuildCon Infra Pvt Ltd';
  String _gstNumber = '33AAAAA0000A1Z5';
  String _panNumber = 'AAAAA0000A';
  String _billingAddress = 'Plot 42, Guindy Industrial Estate, Chennai 600032';

  void _showLanguageSelector(BuildContext context) {
    final currentCode = ref.read(appLocaleProvider).languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.tr('select_language'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _LanguageTile(
                  title: 'English',
                  code: 'en',
                  selected: currentCode == 'en',
                  isDark: isDark,
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await ref.read(appLocaleProvider.notifier).setLocale('en');
                  },
                ),
                const SizedBox(height: 10),
                _LanguageTile(
                  title: 'தமிழ்',
                  code: 'ta',
                  selected: currentCode == 'ta',
                  isDark: isDark,
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await ref.read(appLocaleProvider.notifier).setLocale('ta');
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCompanyDetails(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameCtrl = TextEditingController(text: _companyName);
    final gstCtrl = TextEditingController(text: _gstNumber);
    final panCtrl = TextEditingController(text: _panNumber);
    final addrCtrl = TextEditingController(text: _billingAddress);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('company_details_title'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          context.tr('gst_verified_badge'),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: context.tr('company_name_label'),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: gstCtrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: context.tr('gst_label'),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().length != 15) {
                        return context.tr('gst_invalid');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: panCtrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: context.tr('pan_label'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: addrCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: context.tr('billing_address'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          setState(() {
                            _companyName = nameCtrl.text.trim();
                            _gstNumber = gstCtrl.text.trim().toUpperCase();
                            _panNumber = panCtrl.text.trim().toUpperCase();
                            _billingAddress = addrCtrl.text.trim();
                          });
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.tr('company_updated')),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: Text(
                        context.tr('save_changes'),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSavedSites(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('registered_sites_title'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _SiteCard(
                  name: context.tr('site_phase_2'),
                  address: 'Plot 18, Block B, OMR Navalur IT Corridor, Chennai',
                  manager: 'Sundaram M.',
                  phone: '+91 94441 56789',
                  isDark: isDark,
                  onCall: () => ContactActionHelper.showCallDemo(context, 'Sundaram M.', '+91 94441 56789'),
                  onMessage: () => ContactActionHelper.showMessageDemo(context, 'Sundaram M.', '+91 94441 56789'),
                ),
                const SizedBox(height: 12),
                _SiteCard(
                  name: context.tr('site_ambattur'),
                  address: 'Main Gate 1, Ambattur Industrial Estate 3rd Cross, Chennai',
                  manager: 'Karthik R.',
                  phone: '+91 98840 12345',
                  isDark: isDark,
                  onCall: () => ContactActionHelper.showCallDemo(context, 'Karthik R.', '+91 98840 12345'),
                  onMessage: () => ContactActionHelper.showMessageDemo(context, 'Karthik R.', '+91 98840 12345'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSiteManagerContacts(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('contact_details_title'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _ContactTile(
                  name: 'Sundaram M.',
                  role: '${context.tr('site_manager_label')} • ${context.tr('site_phase_2')}',
                  phone: '+91 94441 56789',
                  isDark: isDark,
                  onCall: () => ContactActionHelper.showCallDemo(context, 'Sundaram M.', '+91 94441 56789'),
                  onMessage: () => ContactActionHelper.showMessageDemo(context, 'Sundaram M.', '+91 94441 56789'),
                ),
                const SizedBox(height: 12),
                _ContactTile(
                  name: 'Karthik R.',
                  role: '${context.tr('site_receiver_label')} • ${context.tr('site_ambattur')}',
                  phone: '+91 98840 12345',
                  isDark: isDark,
                  onCall: () => ContactActionHelper.showCallDemo(context, 'Karthik R.', '+91 98840 12345'),
                  onMessage: () => ContactActionHelper.showMessageDemo(context, 'Karthik R.', '+91 98840 12345'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showHelpSupport(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('help_logistics_support'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Demo Hotline Cards
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF3B82F6).withAlpha(80)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.support_agent_rounded, color: Color(0xFF2563EB), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                context.tr('support_phone_mock'),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          context.tr('support_email_mock'),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : const Color(0xFF1E40AF),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => ContactActionHelper.showCallDemo(context, 'BuildMove Support', '+91 44 2800 1234'),
                                icon: const Icon(Icons.phone, size: 14),
                                label: Text(context.tr('call_phone')),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => ContactActionHelper.showMessageDemo(context, 'BuildMove Support', '+91 44 2800 1234'),
                                icon: const Icon(Icons.chat, size: 14),
                                label: Text(context.tr('send_message')),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
                  Text(
                    context.tr('support_faq_title'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _FaqTile(
                    question: context.tr('faq_q1'),
                    answer: context.tr('faq_a1'),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  _FaqTile(
                    question: context.tr('faq_q2'),
                    answer: context.tr('faq_a2'),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  _FaqTile(
                    question: context.tr('faq_q3'),
                    answer: context.tr('faq_a3'),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDemoDataControls(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Demo / Test Data Control',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      key: const Key('modal_reset_demo_data_btn'),
                      icon: const Icon(Icons.restore_rounded),
                      label: const Text('RESET ALL DEMO DATA'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        DemoDataService.instance.resetToInitialState();
                        ref.read(customerNotificationsProvider.notifier).resetToDemo();
                        ref.invalidate(activeBookingsProvider);
                        ref.invalidate(bookingHistoryProvider);
                        ref.invalidate(driverIncomingRequestsProvider);
                        ref.read(fleetNotifierProvider.notifier).loadFleetData();
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Demo data reset to initial test state'),
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Notifications State:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          key: const Key('btn_empty_notifications'),
                          onPressed: () {
                            ref.read(customerNotificationsProvider.notifier).clearAll();
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Empty (0)'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          key: const Key('btn_populate_notifications'),
                          onPressed: () {
                            ref.read(customerNotificationsProvider.notifier).resetToDemo();
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Populated (3)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Bookings State:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          key: const Key('btn_empty_bookings'),
                          onPressed: () {
                            MockBookingService.setBookingsEmpty(true);
                            ref.invalidate(activeBookingsProvider);
                            ref.invalidate(bookingHistoryProvider);
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Empty Bookings'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          key: const Key('btn_populate_bookings'),
                          onPressed: () {
                            MockBookingService.setBookingsEmpty(false);
                            ref.invalidate(activeBookingsProvider);
                            ref.invalidate(bookingHistoryProvider);
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Populated Bookings'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Primary Booking (BM-8492) State:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ActionChip(
                        key: const Key('chip_booking_created'),
                        label: const Text('Created'),
                        onPressed: () {
                          MockBookingService.setBookingStatus('BM-8492', BookingStatus.pending);
                          ref.invalidate(activeBookingsProvider);
                          ref.invalidate(bookingHistoryProvider);
                          Navigator.of(ctx).pop();
                        },
                      ),
                      ActionChip(
                        key: const Key('chip_booking_assigned'),
                        label: const Text('Driver Assigned'),
                        onPressed: () {
                          MockBookingService.setBookingStatus('BM-8492', BookingStatus.accepted);
                          ref.invalidate(activeBookingsProvider);
                          ref.invalidate(bookingHistoryProvider);
                          Navigator.of(ctx).pop();
                        },
                      ),
                      ActionChip(
                        key: const Key('chip_booking_intransit'),
                        label: const Text('In Transit'),
                        onPressed: () {
                          MockBookingService.setBookingStatus('BM-8492', BookingStatus.inProgress);
                          ref.invalidate(activeBookingsProvider);
                          ref.invalidate(bookingHistoryProvider);
                          Navigator.of(ctx).pop();
                        },
                      ),
                      ActionChip(
                        key: const Key('chip_booking_delivered'),
                        label: const Text('Delivered'),
                        onPressed: () {
                          MockBookingService.setBookingStatus('BM-8492', BookingStatus.completed);
                          ref.invalidate(activeBookingsProvider);
                          ref.invalidate(bookingHistoryProvider);
                          Navigator.of(ctx).pop();
                        },
                      ),
                      ActionChip(
                        key: const Key('chip_booking_cancelled'),
                        label: const Text('Cancelled'),
                        onPressed: () {
                          MockBookingService.setBookingStatus('BM-8492', BookingStatus.cancelled);
                          ref.invalidate(activeBookingsProvider);
                          ref.invalidate(bookingHistoryProvider);
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Fleet & KYC State:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          key: const Key('btn_empty_fleet'),
                          onPressed: () {
                            MockFleetService.setFleetEmpty(true);
                            ref.read(fleetNotifierProvider.notifier).loadFleetData();
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Empty Fleet'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          key: const Key('btn_reset_fleet'),
                          onPressed: () {
                            MockFleetService.setFleetEmpty(false);
                            ref.read(fleetNotifierProvider.notifier).loadFleetData();
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Populated Fleet (8)'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr('logout_confirm_title')),
        content: Text(context.tr('logout_confirm_msg')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.tr('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
            child: Text(context.tr('logout')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.currentUser;
    final customerUser = (user != null && user.role == UserRole.customer)
        ? user
        : DevAuthService.mockUsers[UserRole.customer];
    final locale = ref.watch(appLocaleProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final rawName = customerUser?.name ?? 'Ramesh Sundaram';
    final displayName = rawName.contains('Site Engineer') ? rawName : '$rawName (Site Engineer)';

    final companySub = locale.languageCode == 'ta'
        ? '$_companyName • $_gstNumber'
        : '$_companyName • $_gstNumber';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('profile'),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? Colors.amber : AppColors.secondary,
            ),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Header Card
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: isDark
                        ? AppColors.customerRole.withAlpha(45)
                        : AppColors.customerRole.withAlpha(30),
                    child: Icon(
                      Icons.person,
                      size: 36,
                      color: isDark ? const Color(0xFF60A5FA) : AppColors.customerRole,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: AppTypography.titleMedium.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '+91 ${customerUser?.phone ?? '9876543210'}',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.customerRole.withAlpha(35)
                                : AppColors.infoLight,
                            borderRadius: BorderRadius.circular(4),
                            border: isDark
                                ? Border.all(color: AppColors.customerRole.withAlpha(70), width: 1)
                                : null,
                          ),
                          child: Text(
                            'Customer',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isDark ? const Color(0xFF60A5FA) : AppColors.info,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Settings & Preferences
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    key: const Key('profile_theme_tile'),
                    leading: Icon(
                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: isDark ? Colors.amber : AppColors.secondary,
                    ),
                    title: Text(
                      context.tr('theme'),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      isDark ? context.tr('theme_dark') : context.tr('theme_light'),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                    trailing: Switch.adaptive(
                      value: isDark,
                      activeTrackColor: AppColors.primary,
                      activeThumbColor: Colors.white,
                      onChanged: (_) {
                        ref.read(themeModeProvider.notifier).toggleTheme(context);
                      },
                    ),
                    onTap: () => ref.read(themeModeProvider.notifier).toggleTheme(context),
                  ),
                  Divider(
                    height: 1,
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                  ListTile(
                    key: const Key('profile_language_tile'),
                    leading: const Icon(Icons.language, color: AppColors.primary),
                    title: Text(
                      context.tr('language'),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      locale.languageCode == 'ta' ? 'தமிழ்' : 'English',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.slateMuted,
                    ),
                    onTap: () => _showLanguageSelector(context),
                  ),
                  Divider(
                    height: 1,
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.business_rounded,
                      color: isDark ? const Color(0xFF94A3B8) : AppColors.secondary,
                    ),
                    title: Text(
                      context.tr('company_gst_details'),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      companySub,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.slateMuted,
                    ),
                    onTap: () => _showCompanyDetails(context),
                  ),
                  Divider(
                    height: 1,
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.pin_drop_rounded,
                      color: isDark ? const Color(0xFFF87171) : AppColors.error,
                    ),
                    title: Text(
                      context.tr('saved_construction_sites'),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      context.tr('registered_sites_sub'),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.slateMuted,
                    ),
                    onTap: () => _showSavedSites(context),
                  ),
                  Divider(
                    height: 1,
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.contact_phone_rounded,
                      color: isDark ? const Color(0xFFF59E0B) : const Color(0xFFD97706),
                    ),
                    title: Text(
                      context.tr('site_manager_contacts'),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      context.tr('site_manager_contacts_sub'),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.slateMuted,
                    ),
                    onTap: () => _showSiteManagerContacts(context),
                  ),
                  Divider(
                    height: 1,
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.headset_mic_rounded,
                      color: isDark ? const Color(0xFF60A5FA) : AppColors.info,
                    ),
                    title: Text(
                      context.tr('help_logistics_support'),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      context.tr('help_logistics_sub'),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.slateMuted,
                    ),
                    onTap: () => _showHelpSupport(context),
                  ),
                  Divider(
                    height: 1,
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                  ListTile(
                    key: const Key('demo_data_control_tile'),
                    leading: const Icon(
                      Icons.science_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text(
                      'Demo / Test Data Control',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: const Text(
                      'Deterministic fixtures, empty states & reset',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: isDark ? AppColors.darkTextTertiary : AppColors.slateMuted,
                    ),
                    onTap: () => _showDemoDataControls(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Reset Test / Demo Data Button
            AppButton(
              key: const Key('reset_demo_data_btn'),
              text: 'Demo Data: RESET',
              variant: AppButtonVariant.outline,
              icon: Icons.restore_rounded,
              onPressed: () {
                DemoDataService.instance.resetToInitialState();
                ref.read(customerNotificationsProvider.notifier).resetToDemo();
                ref.invalidate(activeBookingsProvider);
                ref.invalidate(bookingHistoryProvider);
                ref.invalidate(driverIncomingRequestsProvider);
                ref.read(fleetNotifierProvider.notifier).loadFleetData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Demo data RESET to initial test state'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            // Version info
            Text(
              '${AppConstants.appName} • ${AppConstants.appVersion}',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 16),

            // Logout Button
            AppButton(
              text: context.tr('logout'),
              variant: AppButtonVariant.outline,
              icon: Icons.logout_rounded,
              onPressed: () => _confirmLogout(context),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final String code;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.title,
    required this.code,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? (isDark ? const Color(0xFF332014) : const Color(0xFFFFEDE4))
              : (isDark ? AppColors.darkSurfaceCard : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                color: selected
                    ? AppColors.primary
                    : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SiteCard extends StatelessWidget {
  final String name;
  final String address;
  final String manager;
  final String phone;
  final bool isDark;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  const _SiteCard({
    required this.name,
    required this.address,
    required this.manager,
    required this.phone,
    required this.isDark,
    required this.onCall,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceCard : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_rounded, size: 16, color: AppColors.error),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            address,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '$manager • $phone',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.phone, size: 16, color: AppColors.primary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onCall,
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.chat, size: 16, color: Color(0xFF0284C7)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final String name;
  final String role;
  final String phone;
  final bool isDark;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  const _ContactTile({
    required this.name,
    required this.role,
    required this.phone,
    required this.isDark,
    required this.onCall,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceCard : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryContainer,
            child: const Icon(Icons.person, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
                Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.phone, size: 18, color: AppColors.primary),
            onPressed: onCall,
          ),
          IconButton(
            icon: const Icon(Icons.chat, size: 18, color: Color(0xFF0284C7)),
            onPressed: onMessage,
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  final bool isDark;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceCard : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.35,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

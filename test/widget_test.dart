import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/features/auth/providers/auth_provider.dart';

void main() {
  testWidgets('BuildMove smoke test - app launches and renders splash', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const BuildMoveApp(),
      ),
    );

    // Initial pump
    await tester.pump();
    expect(find.byType(BuildMoveApp), findsOneWidget);

    // Advance past splash delay
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
  });
}

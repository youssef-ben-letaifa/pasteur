// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:pasteur/main.dart';

void main() {
  testWidgets('App launch smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PasteurApp());

    // Allow the splash screen animation/timer to start
    await tester.pump(const Duration(milliseconds: 100));

    // Verify that the splash screen shows up (looking for the medical emoji or welcome text)
    expect(find.text('🩺'), findsOneWidget);
    expect(find.text('Welcome to Pasteur'), findsOneWidget);

    // Wait for the splash screen timer to complete to avoid pending timer error
    // We do not use pumpAndSettle because the next screen might have infinite animations
    await tester.pump(const Duration(seconds: 4));
  });
}

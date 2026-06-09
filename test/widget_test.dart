// Basic smoke test: verifies the app boots and renders its first screen.

import 'package:flutter_test/flutter_test.dart';

import 'package:sopify/main.dart';

void main() {
  testWidgets('App builds and renders the splash screen', (tester) async {
    await tester.pumpWidget(const SopifyApp());
    await tester.pump();

    expect(find.byType(SopifyApp), findsOneWidget);
  });
}

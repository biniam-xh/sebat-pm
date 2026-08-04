import 'package:flutter_test/flutter_test.dart';

import 'package:sebatpm/app/app.dart';

void main() {
  testWidgets('placeholder home screen launches', (WidgetTester tester) async {
    await tester.pumpWidget(const SebatPmApp());

    expect(find.text('SebatPM'), findsWidgets);
    expect(
      find.textContaining('Flutter app shell is ready'),
      findsOneWidget,
    );
  });
}

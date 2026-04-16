import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/main.dart';

void main() {
  testWidgets('App shows Personal News title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Personal News'), findsOneWidget);
    expect(find.text('Search by title...'), findsOneWidget);
  });
}

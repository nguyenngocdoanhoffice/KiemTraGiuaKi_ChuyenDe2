import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/main.dart';

void main() {
  testWidgets('Ứng dụng hiển thị tiêu đề tiếng Việt', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Tin tức cá nhân'), findsOneWidget);
    expect(find.text('Tìm theo tiêu đề...'), findsOneWidget);
  });
}

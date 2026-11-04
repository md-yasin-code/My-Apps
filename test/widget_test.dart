import 'package:flutter_test/flutter_test.dart';
import 'package:deutsch_bangla/app.dart';

void main() {
  testWidgets('App title is visible', (tester) async {
    await tester.pumpWidget(const DeutschBanglaApp());
    expect(find.text('Deutsch Bangla'), findsOneWidget);
  });
}

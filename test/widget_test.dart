import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deutsch_bangla/screens/home_screen.dart';

void main() {
  testWidgets('Home dashboard shows the app name and learning sections',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // Allow the dashboard's entrance animations to finish.
    await tester.pumpAndSettle();

    expect(find.text('Deutsch Bangla'), findsOneWidget);
    expect(find.text('অক্ষর ও উচ্চারণ'), findsOneWidget);
    expect(find.text('শব্দভান্ডার'), findsOneWidget);
    expect(find.text('গ্রামার ও লেসন'), findsOneWidget);
    expect(find.text('অনুশীলন পরীক্ষা'), findsOneWidget);
    expect(find.text('শব্দ পুনরাবৃত্তি'), findsOneWidget);
    expect(find.text('আমার অগ্রগতি'), findsOneWidget);
    expect(find.text('পছন্দের তালিকা'), findsOneWidget);
    expect(find.text('সেটিংস'), findsOneWidget);
  });
}

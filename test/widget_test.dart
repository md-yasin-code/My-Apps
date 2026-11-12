import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deutsch_bangla/screens/home_screen.dart';

void main() {
  testWidgets('Home dashboard shows the app name and learning sections',
      (tester) async {
    await tester.view.setPhysicalSize(const Size(1080, 2400));
    await tester.view.setDevicePixelRatio(1);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Deutsch Bangla'), findsOneWidget);

    // ListView lazily builds children only when they enter the viewport.
    // Scroll to each section before asserting that it is present.
    const sections = [
      'অক্ষর ও উচ্চারণ',
      'শব্দভান্ডার',
      'গ্রামার ও লেসন',
      'অনুশীলন পরীক্ষা',
      'শব্দ পুনরাবৃত্তি',
      'আমার অগ্রগতি',
      'পছন্দের তালিকা',
      'সেটিংস',
    ];

    for (final section in sections) {
      final finder = find.text(section);
      await tester.scrollUntilVisible(
        finder,
        300,
        scrollable: find.descendant(
          of: find.byType(HomeScreen),
          matching: find.byType(Scrollable),
        ).first,
      );
      expect(finder, findsOneWidget, reason: 'Missing Home section: $section');
    }
  });
}

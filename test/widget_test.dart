import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:deutsch_bangla/screens/home_screen.dart';

void main() {
  testWidgets('Home dashboard shows the app name and learning sections',
      (tester) async {
    // Give the dashboard enough vertical space so ListView builds every tile.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );
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

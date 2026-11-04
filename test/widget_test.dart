import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:deutsch_bangla/screens/home_screen.dart';

void main() {
  testWidgets('Home dashboard shows the app name and learning sections', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.text('Deutsch Bangla'), findsOneWidget);
    expect(find.text('শব্দভান্ডার'), findsOneWidget);
    expect(find.text('অনুশীলন পরীক্ষা'), findsOneWidget);
  });
}
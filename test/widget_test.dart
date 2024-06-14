// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:home/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  testWidgets('App starts with Active Tasks screen',
      (WidgetTester tester) async {

    await tester.runAsync(() async {
      databaseFactory = databaseFactoryFfi;
      await tester.pumpWidget(const MyApp(true));
      expect(find.text('Active Tasks'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
    });
  });
}

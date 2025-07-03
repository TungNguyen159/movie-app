// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/app_module.dart';

import 'package:movie_app/main.dart';

void main() {
  testWidgets('Đăng nhập và chuyển sang trang chính',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ModularApp(
        module: AppModule(),
        child: const MyApp(),
      ),
    );

    final emailField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);
    final loginButton = find.byType(ElevatedButton);

    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, '123456');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Trang chủ'), findsOneWidget);
  });
}

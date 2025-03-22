import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shurakhsa_kavach/main.dart';
import 'package:shurakhsa_kavach/repositories/auth_repository.dart';
import 'package:shurakhsa_kavach/repositories/database_repository.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    final authRepository = AuthRepository();
    final databaseRepository = DatabaseRepository();
    await tester.pumpWidget(MyApp(
      prefs: prefs,
      authRepository: authRepository,
      databaseRepository: databaseRepository,
    ));

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

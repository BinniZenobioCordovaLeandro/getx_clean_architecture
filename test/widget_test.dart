import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyApp compiled', (WidgetTester tester) async { // TODO: nedd test to MyApp
    WidgetsFlutterBinding.ensureInitialized();
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Firestore Example',
      ),
    );
  });
}

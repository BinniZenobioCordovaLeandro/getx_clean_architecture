import 'package:flutter_test/flutter_test.dart';
import 'package:pickpointer/main.dart';

void main() {
  testWidgets('MyApp compiled', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
  });
}

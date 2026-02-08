import 'package:flutter_test/flutter_test.dart';
import 'package:unsaid/main.dart';

void main() {
  testWidgets('App loads and shows home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const UnsaidApp());
    expect(find.text('Unsaid'), findsOneWidget);
    expect(find.text('Start Game'), findsOneWidget);
  });
}

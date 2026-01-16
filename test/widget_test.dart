import 'package:flutter_test/flutter_test.dart';
import 'package:bunga_fix/main.dart';

void main() {
  testWidgets('App can be built', (WidgetTester tester) async {
    await tester.pumpWidget(const RecipeApp());
    expect(find.byType(RecipeApp), findsOneWidget);
  });
}

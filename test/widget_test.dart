import 'package:flutter_test/flutter_test.dart';
import 'package:pastel_shop/main.dart';

void main() {
  testWidgets('App tampil', (WidgetTester tester) async {
    await tester.pumpWidget(const PastelShopApp());
    expect(find.text('Pastel Shop'), findsOneWidget);
  });
}
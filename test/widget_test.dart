import 'package:flutter_test/flutter_test.dart';
import 'package:latres_dari_ikram/main.dart';

void main() {
  testWidgets('Login page smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ShopediaApp(isLoggedIn: false));

    expect(find.text('Shopedia'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}

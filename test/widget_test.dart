import 'package:flutter_test/flutter_test.dart';
import 'package:alu_connect/app.dart';

void main() {
  testWidgets('App launches splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AluConnectApp());
    await tester.pump();

    expect(find.text('ALU Connect'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:leo_workstation/main.dart';

void main() {
  testWidgets('renders workstation shell', (WidgetTester tester) async {
    await tester.pumpWidget(const LeoWorkstationApp());

    expect(find.text('Leo Workstation'), findsOneWidget);
    expect(find.text('Workstation shell'), findsOneWidget);
  });
}

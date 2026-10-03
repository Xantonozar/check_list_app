import 'package:flutter_test/flutter_test.dart';

import 'package:muhasabat/app.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MuhasabatApp());
    await tester.pumpAndSettle();

    expect(find.text('মুহাসাবাত'), findsOneWidget);
  });
}

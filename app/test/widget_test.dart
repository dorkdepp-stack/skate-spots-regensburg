// Basic smoke test — boots the app and checks the map screen (the
// initial `screen: 'map'` state) renders its "tag a spot" action and
// bottom nav.

import 'package:flutter_test/flutter_test.dart';

import 'package:spotapp/main.dart';

void main() {
  testWidgets('SpotApp boots to the map screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SpotApp());
    await tester.pump();

    expect(find.text('tag a spot'), findsOneWidget);
    expect(find.text('MAP'), findsOneWidget);
    expect(find.text('YARD'), findsOneWidget);
  });
}

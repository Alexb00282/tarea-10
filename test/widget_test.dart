import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:villa01/main.dart';

void main() {
  testWidgets('Catalog app renders a list of hardware components', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Catálogo de Hardware'), findsOneWidget);
    expect(find.text('Ryzen 9 7900X'), findsOneWidget);
    expect(find.text('RTX 4070 Super'), findsOneWidget);
  });
}

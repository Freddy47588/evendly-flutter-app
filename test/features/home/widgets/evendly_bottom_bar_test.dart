import 'package:evendly_app/features/home/widgets/evendly_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('notifies the selected navigation index', (tester) async {
    int? selectedIndex;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: EvendlyBottomBar(
            currentIndex: 0,
            onChanged: (index) => selectedIndex = index,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.favorite_border));

    expect(selectedIndex, 2);
  });
}

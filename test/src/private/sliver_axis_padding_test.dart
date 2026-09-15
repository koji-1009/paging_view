import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/private/sliver_axis_padding.dart';

void main() {
  group('SliverAxisPadding', () {
    const marker = ValueKey('marker');
    const padding = EdgeInsets.only(top: 10, bottom: 30);

    Widget buildWidget(SliverAxisPaddingPart part) {
      return MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAxisPadding(padding: padding, part: part),
              const SliverToBoxAdapter(
                child: SizedBox(key: marker, height: 50),
              ),
            ],
          ),
        ),
      );
    }

    testWidgets('updates the applied part when it changes', (tester) async {
      await tester.pumpWidget(buildWidget(SliverAxisPaddingPart.leading));
      expect(tester.getTopLeft(find.byKey(marker)).dy, 10);

      await tester.pumpWidget(buildWidget(SliverAxisPaddingPart.trailing));
      expect(tester.getTopLeft(find.byKey(marker)).dy, 30);

      // The cross axis part has no main axis extent.
      await tester.pumpWidget(buildWidget(SliverAxisPaddingPart.crossAxis));
      expect(tester.getTopLeft(find.byKey(marker)).dy, 0);
    });
  });
}

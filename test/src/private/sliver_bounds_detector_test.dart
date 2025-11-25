import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/private/sliver_bounds_detector.dart';

void main() {
  group('SliverBoundsDetector', () {
    testWidgets('onVisibilityChanged callback is triggered by scrolling', (
      tester,
    ) async {
      final visibilityNotifier = ValueNotifier<bool?>(null);
      final scrollController = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: CustomScrollView(
            cacheExtent: 0.0,
            controller: scrollController,
            slivers: <Widget>[
              const SliverToBoxAdapter(child: SizedBox(height: 800)),
              SliverBoundsDetector(
                onVisibilityChanged: (isVisible) {
                  visibilityNotifier.value = isVisible;
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 800)),
            ],
          ),
        ),
      );

      // Initially, the detector is not visible, and the callback has not been called.
      expect(visibilityNotifier.value, null);

      // Scroll down to make the detector visible.
      scrollController.jumpTo(800);
      await tester.pumpAndSettle();

      // The detector is now visible.
      expect(visibilityNotifier.value, true);

      // Scroll back to the top.
      scrollController.jumpTo(0);
      await tester.pumpAndSettle();

      // The detector is no longer visible.
      expect(visibilityNotifier.value, false);

      // Scroll far down.
      scrollController.jumpTo(1600);
      await tester.pumpAndSettle();

      // The detector is no longer visible.
      expect(visibilityNotifier.value, false);

      scrollController.dispose();
    });

    testWidgets(
      'onVisibilityChanged callback is triggered early with cacheExtent',
      (tester) async {
        final visibilityNotifier = ValueNotifier<bool?>(null);
        final scrollController = ScrollController();
        const sliverStartOffset = 800.0;
        const cacheExtent = 200.0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                cacheExtent: cacheExtent,
                controller: scrollController,
                slivers: <Widget>[
                  const SliverToBoxAdapter(
                    child: SizedBox(height: sliverStartOffset),
                  ),
                  SliverBoundsDetector(
                    onVisibilityChanged: (isVisible) {
                      visibilityNotifier.value = isVisible;
                    },
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 800)),
                ],
              ),
            ),
          ),
        );

        // The default viewport size in the test environment is 800x600.
        final viewPortHeight =
            tester.view.physicalSize.height / tester.view.devicePixelRatio;

        // The detector is at scroll offset 800.
        // The viewport (without cache) initially covers scroll offsets 0 to 600.
        // The cache area extends 200 pixels before and after the viewport.
        // The viewport with trailing cache covers up to 600 + 200 = 800.
        // So, the detector is exactly at the edge of the cache area.

        // We need to scroll just enough for the viewport to move and the sliver
        // at offset 800 to be inside the trailing cache area.
        final scrollPositionToShowInCache =
            sliverStartOffset - viewPortHeight - cacheExtent;

        // Scroll just past the point where it should become visible.
        scrollController.jumpTo(scrollPositionToShowInCache + 1);
        await tester.pumpAndSettle();

        expect(
          visibilityNotifier.value,
          true,
          reason: 'Should be visible when entering the bottom cache extent',
        );

        // Scroll back to a position where it's not in the cache extent.
        scrollController.jumpTo(scrollPositionToShowInCache - 1);
        await tester.pumpAndSettle();
        expect(
          visibilityNotifier.value,
          false,
          reason: 'Should become invisible when leaving the cache extent',
        );

        scrollController.dispose();
      },
    );
  });
}

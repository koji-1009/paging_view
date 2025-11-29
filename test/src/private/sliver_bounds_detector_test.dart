import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/private/sliver_bounds_detector.dart';

void main() {
  group('SliverBoundsDetector', () {
    const viewportHeight = 600.0;
    const sliverOffset = 800.0;

    Widget buildWidget({
      required ScrollController controller,
      required SliverVisibilityCallback onVisibilityChanged,
      double cacheExtent = 0.0,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            controller: controller,
            cacheExtent: cacheExtent,
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: sliverOffset)),
              SliverBoundsDetector(onVisibilityChanged: onVisibilityChanged),
              const SliverToBoxAdapter(child: SizedBox(height: sliverOffset)),
            ],
          ),
        ),
      );
    }

    testWidgets('callback is called with true when sliver becomes visible', (
      tester,
    ) async {
      final visibilityLog = <bool>[];
      final controller = ScrollController();

      await tester.pumpWidget(
        buildWidget(
          controller: controller,
          onVisibilityChanged: visibilityLog.add,
        ),
      );

      expect(visibilityLog, isEmpty);

      controller.jumpTo(sliverOffset - viewportHeight + 1);
      await tester.pumpAndSettle();

      expect(visibilityLog, [true]);

      controller.dispose();
    });

    testWidgets('callback is called with false when sliver becomes invisible', (
      tester,
    ) async {
      final visibilityLog = <bool>[];
      final controller = ScrollController(initialScrollOffset: sliverOffset);

      await tester.pumpWidget(
        buildWidget(
          controller: controller,
          onVisibilityChanged: visibilityLog.add,
        ),
      );
      await tester.pumpAndSettle();

      expect(visibilityLog, [true]);

      controller.jumpTo(0);
      await tester.pumpAndSettle();
      expect(visibilityLog, [true, false]);

      controller.jumpTo(sliverOffset);
      await tester.pumpAndSettle();
      expect(visibilityLog, [true, false, true]);

      controller.jumpTo(sliverOffset + 1);
      await tester.pumpAndSettle();
      expect(visibilityLog, [true, false, true, false]);

      controller.dispose();
    });

    testWidgets('callback is not called if visibility does not change', (
      tester,
    ) async {
      final visibilityLog = <bool>[];
      final controller = ScrollController();

      await tester.pumpWidget(
        buildWidget(
          controller: controller,
          onVisibilityChanged: visibilityLog.add,
        ),
      );
      await tester.pumpAndSettle();

      controller.jumpTo(100);
      await tester.pumpAndSettle();
      expect(visibilityLog, isEmpty);

      controller.jumpTo(sliverOffset);
      await tester.pumpAndSettle();
      expect(visibilityLog, [true]);

      controller.jumpTo(sliverOffset - 100);
      await tester.pumpAndSettle();
      expect(visibilityLog, [true]);

      controller.dispose();
    });

    testWidgets('works correctly with non-zero cacheExtent', (tester) async {
      final visibilityLog = <bool>[];
      final controller = ScrollController();
      const cacheExtent = 250.0;

      await tester.pumpWidget(
        buildWidget(
          controller: controller,
          onVisibilityChanged: visibilityLog.add,
          cacheExtent: cacheExtent,
        ),
      );
      await tester.pumpAndSettle();

      // Becomes visible once it enters the cache extent
      // Viewport is 0 to 600. Cache area is 0 to 850. Sliver at 800.
      // So it is already visible at scroll 0.
      expect(visibilityLog, [true]);

      // Scroll to a point where the sliver is outside the leading cache extent
      // Viewport ends at scrollOffset + 600.
      // Leading cache starts at scrollOffset - 250.
      // To make sliver at 800 invisible, we need 800 < scrollOffset - 250
      // => scrollOffset > 1050
      controller.jumpTo(1051);
      await tester.pumpAndSettle();
      expect(visibilityLog, [true, false]);

      controller.dispose();
    });

    testWidgets('updates callback when widget is rebuilt', (tester) async {
      final log1 = <bool>[];
      final log2 = <bool>[];
      final controller = ScrollController();

      await tester.pumpWidget(
        buildWidget(controller: controller, onVisibilityChanged: log1.add),
      );

      // Trigger first callback
      controller.jumpTo(sliverOffset);
      await tester.pumpAndSettle();
      expect(log1, [true]);
      expect(log2, isEmpty);

      // Rebuild with a new callback
      await tester.pumpWidget(
        buildWidget(controller: controller, onVisibilityChanged: log2.add),
      );

      // Trigger visibility change again
      controller.jumpTo(0);
      await tester.pumpAndSettle();

      // Only the new callback should be called
      expect(log1, [true]);
      expect(log2, [false]);

      controller.dispose();
    });

    testWidgets('callback is not called after widget is detached', (
      tester,
    ) async {
      final visibilityLog = <bool>[];
      final controller = ScrollController();

      await tester.pumpWidget(
        buildWidget(
          controller: controller,
          onVisibilityChanged: visibilityLog.add,
        ),
      );

      // Make it visible
      controller.jumpTo(sliverOffset);
      await tester.pumpAndSettle();
      expect(visibilityLog, [true]);

      // Remove the widget from the tree
      await tester.pumpWidget(MaterialApp(home: Container()));
      await tester.pumpAndSettle();

      // No new callbacks should be fired
      expect(visibilityLog, [true]);

      controller.dispose();
    });
  });
}

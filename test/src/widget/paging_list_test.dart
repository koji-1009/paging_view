import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/paging_view.dart';

import '../../helper/test_data_source.dart';

void main() {
  group('PagingList', () {
    Widget createPagingList({
      required TestDataSource dataSource,
      IndexedWidgetBuilder? separatorBuilder,
      bool fillRemainErrorWidget = true,
      bool fillRemainEmptyWidget = true,
      EdgeInsets padding = EdgeInsets.zero,
      bool autoLoadPrepend = true,
      bool autoLoadAppend = true,
      Axis scrollDirection = Axis.vertical,
      bool reverse = false,
      ScrollController? controller,
      ScrollCacheExtent? scrollCacheExtent,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: separatorBuilder != null
              ? PagingList.separated(
                  dataSource: dataSource,
                  builder: (context, item, index) =>
                      SizedBox(height: 50, child: Text(item)),
                  separatorBuilder: separatorBuilder,
                  errorBuilder: (context, error, stackTrace) =>
                      const Text('Error'),
                  initialLoadingWidget: const Text('Initial Loading'),
                  prependLoadingWidget: const Text('Prepending'),
                  appendLoadingWidget: const Text('Appending'),
                  emptyWidget: const Text('No Data'),
                  fillRemainErrorWidget: fillRemainErrorWidget,
                  fillRemainEmptyWidget: fillRemainEmptyWidget,
                  padding: padding,
                  autoLoadPrepend: autoLoadPrepend,
                  autoLoadAppend: autoLoadAppend,
                  scrollDirection: scrollDirection,
                  reverse: reverse,
                  controller: controller,
                  scrollCacheExtent: scrollCacheExtent,
                )
              : PagingList(
                  dataSource: dataSource,
                  builder: (context, item, index) =>
                      SizedBox(height: 50, child: Text(item)),
                  errorBuilder: (context, error, stackTrace) =>
                      const Text('Error'),
                  initialLoadingWidget: const Text('Initial Loading'),
                  prependLoadingWidget: const Text('Prepending'),
                  appendLoadingWidget: const Text('Appending'),
                  emptyWidget: const Text('No Data'),
                  fillRemainErrorWidget: fillRemainErrorWidget,
                  fillRemainEmptyWidget: fillRemainEmptyWidget,
                  padding: padding,
                  autoLoadPrepend: autoLoadPrepend,
                  autoLoadAppend: autoLoadAppend,
                  scrollDirection: scrollDirection,
                  reverse: reverse,
                  controller: controller,
                  scrollCacheExtent: scrollCacheExtent,
                ),
        ),
      );
    }

    testWidgets('displays initial loading, then items', (tester) async {
      final dataSource = TestDataSource(
        refreshDelay: const Duration(milliseconds: 100),
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(createPagingList(dataSource: dataSource));
      await tester.pump();
      expect(find.text('Initial Loading'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Initial Loading'), findsNothing);
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('displays empty widget when initial data is empty', (
      tester,
    ) async {
      final dataSource = TestDataSource(initialItems: []);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(createPagingList(dataSource: dataSource));
      await tester.pumpAndSettle();
      expect(find.text('No Data'), findsOneWidget);
    });

    testWidgets('displays error widget on initial load error', (tester) async {
      final dataSource = TestDataSource(hasErrorOnRefresh: true);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(createPagingList(dataSource: dataSource));
      await tester.pumpAndSettle();
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('displays separators when using PagingList.separated', (
      tester,
    ) async {
      final dataSource = TestDataSource(maxAppendPages: 0, maxPrependPages: 0);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createPagingList(
          dataSource: dataSource,
          separatorBuilder: (context, index) =>
              const Divider(key: Key('separator')),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('separator')), findsNWidgets(2));
    });

    testWidgets('renders items in reverse when reverse is true', (
      tester,
    ) async {
      final dataSource = TestDataSource(maxAppendPages: 0, maxPrependPages: 0);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createPagingList(dataSource: dataSource, reverse: true),
      );
      await tester.pumpAndSettle();

      final item1Pos = tester.getTopLeft(find.text('Item 1'));
      final item2Pos = tester.getTopLeft(find.text('Item 2'));
      expect(item1Pos.dy, greaterThan(item2Pos.dy));
    });

    testWidgets('loads prepend when scrolled into the leading cache extent', (
      tester,
    ) async {
      final dataSource = TestDataSource(
        initialItems: [for (var i = 1; i <= 20; i++) 'Item $i'],
        maxAppendPages: 0,
        maxPrependPages: 1,
      );
      addTearDown(dataSource.dispose);
      final controller = ScrollController();
      addTearDown(controller.dispose);
      const scrollCacheExtent = ScrollCacheExtent.pixels(250);

      // Load the first page without the prepend trigger, which would fire at
      // the initial offset, and scroll beyond the leading cache extent.
      await tester.pumpWidget(
        createPagingList(
          dataSource: dataSource,
          controller: controller,
          scrollCacheExtent: scrollCacheExtent,
          autoLoadPrepend: false,
        ),
      );
      await tester.pumpAndSettle();
      controller.jumpTo(400);
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        createPagingList(
          dataSource: dataSource,
          controller: controller,
          scrollCacheExtent: scrollCacheExtent,
        ),
      );
      // The prepended item is laid out in the leading cache area, so include
      // offstage widgets.
      final prependedItem = find.text('Prepended Item -1', skipOffstage: false);
      await tester.pumpAndSettle();
      expect(prependedItem, findsNothing);

      // The trigger at offset 0 is still outside the leading cache extent.
      controller.jumpTo(251);
      await tester.pumpAndSettle();
      expect(prependedItem, findsNothing);

      // The trigger enters the leading cache extent before the viewport
      // reaches it.
      controller.jumpTo(250);
      await tester.pumpAndSettle();
      expect(prependedItem, findsOneWidget);
    });
  });
}

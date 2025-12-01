import 'package:flutter/material.dart';
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
  });
}

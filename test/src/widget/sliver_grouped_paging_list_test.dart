import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/paging_view.dart';

import '../../helper/test_data_source.dart';

void main() {
  group('SliverGroupedPagingList', () {
    Widget createSliverGroupedPagingList({
      required TestGroupedDataSource dataSource,
      IndexedWidgetBuilder? separatorBuilder,
      bool fillRemainErrorWidget = true,
      bool fillRemainEmptyWidget = true,
      EdgeInsets padding = EdgeInsets.zero,
      bool autoLoadPrepend = true,
      bool autoLoadAppend = true,
      ScrollController? controller,
      bool stickyHeader = false,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            controller: controller,
            slivers: [
              separatorBuilder != null
                  ? SliverGroupedPagingList.separated(
                      dataSource: dataSource,
                      headerBuilder: (context, group, index) => Text(group),
                      itemBuilder: (context, item, itemIndex, groupIndex) =>
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
                      stickyHeader: stickyHeader,
                      stickyHeaderMinExtentPrototype: const SizedBox(
                        height: 30,
                      ),
                    )
                  : SliverGroupedPagingList<int, String, String>(
                      dataSource: dataSource,
                      headerBuilder: (context, group, index) => Text(group),
                      itemBuilder: (context, item, itemIndex, groupIndex) =>
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
                      stickyHeader: stickyHeader,
                      stickyHeaderMinExtentPrototype: const SizedBox(
                        height: 30,
                      ),
                    ),
            ],
          ),
        ),
      );
    }

    testWidgets('displays initial loading, then items and headers', (
      tester,
    ) async {
      final dataSource = TestGroupedDataSource(
        refreshDelay: const Duration(milliseconds: 100),
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createSliverGroupedPagingList(dataSource: dataSource),
      );
      await tester.pump();
      expect(find.text('Initial Loading'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Initial Loading'), findsNothing);
      expect(find.text('A1'), findsOneWidget);
      expect(find.text('Group A'), findsOneWidget);
      expect(find.text('Group B'), findsOneWidget);
    });

    testWidgets('displays empty widget when initial data is empty', (
      tester,
    ) async {
      final dataSource = TestGroupedDataSource(initialItems: []);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createSliverGroupedPagingList(dataSource: dataSource),
      );
      await tester.pumpAndSettle();
      expect(find.text('No Data'), findsOneWidget);
    });

    testWidgets('displays error widget on initial load error', (tester) async {
      final dataSource = TestGroupedDataSource(hasErrorOnRefresh: true);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createSliverGroupedPagingList(dataSource: dataSource),
      );
      await tester.pumpAndSettle();
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('displays separators when using .separated constructor', (
      tester,
    ) async {
      final dataSource = TestGroupedDataSource();
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createSliverGroupedPagingList(
          dataSource: dataSource,
          separatorBuilder: (context, index) => const Divider(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('loads more items on scroll (append)', (tester) async {
      final dataSource = TestGroupedDataSource(maxAppendPages: 1);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createSliverGroupedPagingList(dataSource: dataSource),
      );
      await tester.pumpAndSettle();

      expect(find.text('Grouped Appended Item  1'), findsNothing);

      await tester.fling(
        find.byType(CustomScrollView),
        const Offset(0, -500),
        1000,
      );
      await tester.pumpAndSettle();

      expect(find.text('Grouped Appended Item 1'), findsOneWidget);
    });

    testWidgets('loads more items on scroll (prepend)', (tester) async {
      final dataSource = TestGroupedDataSource(
        maxPrependPages: 1,
        initialItems: const [
          'A1',
          'A2',
          'A3',
          'A4',
          'B1',
          'B2',
          'B3',
          'B4',
          'C1',
          'C2',
          'C3',
          'C4',
        ],
      );
      addTearDown(dataSource.dispose);

      final controller = ScrollController(initialScrollOffset: 1000.0);
      await tester.pumpWidget(
        createSliverGroupedPagingList(
          dataSource: dataSource,
          controller: controller,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Grouped Prepended Item -1'), findsNothing);

      await tester.fling(
        find.byType(CustomScrollView),
        const Offset(0, 500),
        1000,
      );
      await tester.pumpAndSettle();

      expect(find.text('Grouped Prepended Item -1'), findsOneWidget);
    });

    testWidgets('displays append loading widget during append', (tester) async {
      final dataSource = TestGroupedDataSource(
        maxAppendPages: 1,
        appendDelay: const Duration(milliseconds: 100),
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createSliverGroupedPagingList(
          dataSource: dataSource,
          autoLoadAppend: false,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Appending'), findsNothing);

      dataSource.append();
      await tester.pump(Duration.zero);
      await tester.pump();
      expect(find.text('Appending'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Appending'), findsNothing);
      expect(find.text('Grouped Appended Item 1'), findsOneWidget);
    });

    testWidgets('displays prepend loading widget during prepend', (
      tester,
    ) async {
      final dataSource = TestGroupedDataSource(
        maxPrependPages: 1,
        prependDelay: const Duration(milliseconds: 100),
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createSliverGroupedPagingList(
          dataSource: dataSource,
          autoLoadPrepend: false,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Prepending'), findsNothing);

      dataSource.prepend();
      await tester.pump(Duration.zero);
      await tester.pump();
      expect(find.text('Prepending'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Prepending'), findsNothing);
      expect(find.text('Grouped Prepended Item -1'), findsOneWidget);
    });

    testWidgets('applies padding correctly', (tester) async {
      final dataSource = TestGroupedDataSource(
        maxAppendPages: 0,
        maxPrependPages: 0,
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createSliverGroupedPagingList(
          dataSource: dataSource,
          padding: const EdgeInsets.all(20.0),
        ),
      );
      await tester.pumpAndSettle();
      final headerFinder = find.text('Group A');
      expect(headerFinder, findsOneWidget);

      final headerRect = tester.getRect(headerFinder);
      expect(headerRect.top, 20.0);
      expect(headerRect.left, 20.0);

      final itemFinder = find.text('A1');
      expect(itemFinder, findsOneWidget);
      final itemRect = tester.getRect(itemFinder);
      expect(itemRect.left, 20.0);
      expect(itemRect.top, greaterThan(headerRect.top));
    });

    testWidgets(
      'error widget fills remaining space if fillRemainErrorWidget is true',
      (tester) async {
        final dataSource = TestGroupedDataSource(hasErrorOnRefresh: true);
        addTearDown(dataSource.dispose);

        await tester.pumpWidget(
          createSliverGroupedPagingList(
            dataSource: dataSource,
            fillRemainErrorWidget: true,
          ),
        );
        await tester.pumpAndSettle();

        final errorWidget = find.text('Error');
        expect(
          tester.getSize(errorWidget).height,
          equals(tester.getSize(find.byType(CustomScrollView)).height),
        );
      },
    );

    testWidgets(
      'empty widget fills remaining space if fillRemainEmptyWidget is true',
      (tester) async {
        final dataSource = TestGroupedDataSource(initialItems: const []);
        addTearDown(dataSource.dispose);

        await tester.pumpWidget(
          createSliverGroupedPagingList(
            dataSource: dataSource,
            fillRemainEmptyWidget: true,
          ),
        );
        await tester.pumpAndSettle();

        final emptyWidget = find.text('No Data');
        expect(
          tester.getSize(emptyWidget).height,
          equals(tester.getSize(find.byType(CustomScrollView)).height),
        );
      },
    );

    testWidgets(
      'error widget does not fill remaining space if fillRemainErrorWidget is false',
      (tester) async {
        final dataSource = TestGroupedDataSource(hasErrorOnRefresh: true);
        addTearDown(dataSource.dispose);

        await tester.pumpWidget(
          createSliverGroupedPagingList(
            dataSource: dataSource,
            fillRemainErrorWidget: false,
          ),
        );
        await tester.pumpAndSettle();

        final errorWidget = find.text('Error');
        expect(
          tester.getSize(errorWidget).height,
          lessThan(tester.getSize(find.byType(CustomScrollView)).height),
        );
      },
    );

    testWidgets(
      'empty widget does not fill remaining space if fillRemainEmptyWidget is false',
      (tester) async {
        final dataSource = TestGroupedDataSource(initialItems: const []);
        addTearDown(dataSource.dispose);

        await tester.pumpWidget(
          createSliverGroupedPagingList(
            dataSource: dataSource,
            fillRemainEmptyWidget: false,
          ),
        );
        await tester.pumpAndSettle();

        final emptyWidget = find.text('No Data');
        expect(
          tester.getSize(emptyWidget).height,
          lessThan(tester.getSize(find.byType(CustomScrollView)).height),
        );
      },
    );

    testWidgets('sticky header remains visible on scroll', (tester) async {
      final dataSource = TestGroupedDataSource(
        initialItems: List.generate(20, (i) => 'A${i + 1}'),
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createSliverGroupedPagingList(
          dataSource: dataSource,
          stickyHeader: true,
        ),
      );
      await tester.pumpAndSettle();

      final headerFinder = find.text('Group A');
      expect(headerFinder, findsOneWidget);

      await tester.fling(
        find.byType(CustomScrollView),
        const Offset(0, -500),
        1000,
      );
      await tester.pumpAndSettle();

      expect(headerFinder, findsOneWidget);

      final headerRect = tester.getRect(headerFinder);
      expect(headerRect.top, 0.0);
    });
  });
}

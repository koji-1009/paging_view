import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/paging_view.dart';

import '../../helper/test_center_data_source.dart';

void main() {
  group('CenterPagingList', () {
    Widget createCenterPagingList({
      required TestCenterDataSource dataSource,
      EdgeInsets padding = EdgeInsets.zero,
      bool autoLoadPrepend = true,
      bool autoLoadAppend = true,
      Axis scrollDirection = Axis.vertical,
      bool reverse = false,
      ScrollController? controller,
      IndexedWidgetBuilder? separatorBuilder,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: separatorBuilder != null
              ? CenterPagingList.separated(
                  dataSource: dataSource,
                  builder: (context, item, index) =>
                      SizedBox(height: 50, child: Text(item)),
                  errorBuilder: (context, error, stackTrace) =>
                      const Text('Error'),
                  initialLoadingWidget: const Text('Initial Loading'),
                  emptyWidget: const Text('No Data'),
                  prependLoadStateBuilder: (context, hasMore, isLoading) {
                    if (isLoading) return const Text('Prepending');
                    if (!hasMore) return const Text('No More Prepend');
                    return const Text('Can Prepend');
                  },
                  appendLoadStateBuilder: (context, hasMore, isLoading) {
                    if (isLoading) return const Text('Appending');
                    if (!hasMore) return const Text('No More Append');
                    return const Text('Can Append');
                  },
                  padding: padding,
                  autoLoadPrepend: autoLoadPrepend,
                  autoLoadAppend: autoLoadAppend,
                  scrollDirection: scrollDirection,
                  reverse: reverse,
                  controller: controller,
                  separatorBuilder: separatorBuilder,
                )
              : CenterPagingList(
                  dataSource: dataSource,
                  builder: (context, item, index) =>
                      SizedBox(height: 50, child: Text(item)),
                  errorBuilder: (context, error, stackTrace) =>
                      const Text('Error'),
                  initialLoadingWidget: const Text('Initial Loading'),
                  emptyWidget: const Text('No Data'),
                  prependLoadStateBuilder: (context, hasMore, isLoading) {
                    if (isLoading) return const Text('Prepending');
                    if (!hasMore) return const Text('No More Prepend');
                    return const Text('Can Prepend');
                  },
                  appendLoadStateBuilder: (context, hasMore, isLoading) {
                    if (isLoading) return const Text('Appending');
                    if (!hasMore) return const Text('No More Append');
                    return const Text('Can Append');
                  },
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
      final dataSource = TestCenterDataSource(
        refreshDelay: const Duration(milliseconds: 100),
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(createCenterPagingList(dataSource: dataSource));
      await tester.pump();
      expect(find.text('Initial Loading'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Initial Loading'), findsNothing);
      expect(find.text('Center 1'), findsOneWidget);
      expect(find.text('Center 2'), findsOneWidget);
    });

    testWidgets('displays empty widget when initial data is empty', (
      tester,
    ) async {
      final dataSource = TestCenterDataSource(initialItems: []);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(createCenterPagingList(dataSource: dataSource));
      await tester.pumpAndSettle();
      expect(find.text('No Data'), findsOneWidget);
    });

    testWidgets('displays error widget on initial load error', (tester) async {
      final dataSource = TestCenterDataSource(hasErrorOnRefresh: true);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(createCenterPagingList(dataSource: dataSource));
      await tester.pumpAndSettle();
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('displays prepend load state correctly', (tester) async {
      final dataSource = TestCenterDataSource(
        maxPrependPages: 1,
        prependDelay: const Duration(milliseconds: 100),
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createCenterPagingList(dataSource: dataSource, autoLoadPrepend: false),
      );
      await tester.pumpAndSettle();

      // Scroll up to reveal the prepend section
      await tester.drag(find.byType(CustomScrollView), const Offset(0, 200));
      await tester.pumpAndSettle();

      // Should show "Can Prepend" when there's more data
      expect(find.text('Can Prepend'), findsOneWidget);
    });

    testWidgets('displays append load state correctly', (tester) async {
      final dataSource = TestCenterDataSource(
        maxAppendPages: 1,
        appendDelay: const Duration(milliseconds: 100),
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createCenterPagingList(dataSource: dataSource, autoLoadAppend: false),
      );
      await tester.pumpAndSettle();

      // Should show "Can Append" when there's more data
      expect(find.text('Can Append'), findsOneWidget);
    });

    testWidgets('shows no more prepend when reached beginning', (tester) async {
      final dataSource = TestCenterDataSource(maxPrependPages: 0);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createCenterPagingList(dataSource: dataSource, autoLoadPrepend: false),
      );
      await tester.pumpAndSettle();

      // Scroll up to reveal the prepend section
      await tester.drag(find.byType(CustomScrollView), const Offset(0, 200));
      await tester.pumpAndSettle();

      expect(find.text('No More Prepend'), findsOneWidget);
    });

    testWidgets('shows no more append when reached end', (tester) async {
      final dataSource = TestCenterDataSource(maxAppendPages: 0);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createCenterPagingList(dataSource: dataSource, autoLoadAppend: false),
      );
      await tester.pumpAndSettle();

      expect(find.text('No More Append'), findsOneWidget);
    });

    testWidgets('renders items in reverse when reverse is true', (
      tester,
    ) async {
      final dataSource = TestCenterDataSource(
        maxAppendPages: 0,
        maxPrependPages: 0,
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createCenterPagingList(dataSource: dataSource, reverse: true),
      );
      await tester.pumpAndSettle();

      final item1Pos = tester.getTopLeft(find.text('Center 1'));
      final item2Pos = tester.getTopLeft(find.text('Center 2'));
      expect(item1Pos.dy, greaterThan(item2Pos.dy));
    });

    testWidgets('applies padding correctly', (tester) async {
      final dataSource = TestCenterDataSource(
        maxAppendPages: 0,
        maxPrependPages: 0,
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createCenterPagingList(
          dataSource: dataSource,
          padding: const EdgeInsets.all(16),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Center 1'), findsOneWidget);
    });

    testWidgets('displays loading state during prepend', (tester) async {
      final dataSource = TestCenterDataSource(
        maxPrependPages: 2,
        prependDelay: const Duration(milliseconds: 100),
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createCenterPagingList(dataSource: dataSource, autoLoadPrepend: false),
      );
      await tester.pumpAndSettle();

      // Scroll up to reveal the prepend section first
      await tester.drag(find.byType(CustomScrollView), const Offset(0, 200));
      await tester.pumpAndSettle();

      // Trigger prepend manually
      dataSource.prepend();
      await tester.pump();

      expect(find.text('Prepending'), findsOneWidget);

      // Let the operation complete
      await tester.pumpAndSettle();
    });

    testWidgets('displays loading state during append', (tester) async {
      final dataSource = TestCenterDataSource(
        maxAppendPages: 2,
        appendDelay: const Duration(milliseconds: 100),
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createCenterPagingList(dataSource: dataSource, autoLoadAppend: false),
      );
      await tester.pumpAndSettle();

      // Trigger append manually
      dataSource.append();
      await tester.pump();

      expect(find.text('Appending'), findsOneWidget);

      // Let the operation complete
      await tester.pumpAndSettle();
    });

    testWidgets('manual prepend adds items', (tester) async {
      final dataSource = TestCenterDataSource(maxPrependPages: 2);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createCenterPagingList(dataSource: dataSource, autoLoadPrepend: false),
      );
      await tester.pumpAndSettle();

      expect(find.text('Prepended -1'), findsNothing);

      dataSource.prepend();
      await tester.pumpAndSettle();

      // Scroll up to reveal the prepended items
      await tester.drag(find.byType(CustomScrollView), const Offset(0, 200));
      await tester.pumpAndSettle();

      expect(find.text('Prepended -1'), findsOneWidget);
    });

    testWidgets('manual append adds items', (tester) async {
      final dataSource = TestCenterDataSource(maxAppendPages: 2);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createCenterPagingList(dataSource: dataSource, autoLoadAppend: false),
      );
      await tester.pumpAndSettle();

      expect(find.text('Appended 1'), findsNothing);

      dataSource.append();
      await tester.pumpAndSettle();

      expect(find.text('Appended 1'), findsOneWidget);
    });

    testWidgets('centerKey is used for center sliver', (tester) async {
      final dataSource = TestCenterDataSource();
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(createCenterPagingList(dataSource: dataSource));
      await tester.pumpAndSettle();

      // The centerKey should be attached to a widget
      expect(dataSource.centerKey.currentContext, isNotNull);
    });

    testWidgets('handles scroll direction horizontal', (tester) async {
      final dataSource = TestCenterDataSource(
        maxAppendPages: 0,
        maxPrependPages: 0,
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createCenterPagingList(
          dataSource: dataSource,
          scrollDirection: Axis.horizontal,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Center 1'), findsOneWidget);
    });

    testWidgets('controller can be provided', (tester) async {
      final dataSource = TestCenterDataSource();
      final controller = ScrollController();
      addTearDown(() {
        dataSource.dispose();
        controller.dispose();
      });

      await tester.pumpWidget(
        createCenterPagingList(dataSource: dataSource, controller: controller),
      );
      await tester.pumpAndSettle();

      expect(controller.hasClients, isTrue);
    });

    testWidgets('displays separators when using CenterPagingList.separated', (
      tester,
    ) async {
      final dataSource = TestCenterDataSource(
        initialItems: ['Center 1', 'Center 2', 'Center 3'],
        maxAppendPages: 2,
        maxPrependPages: 2,
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createCenterPagingList(
          dataSource: dataSource,
          autoLoadPrepend: false,
          autoLoadAppend: false,
          separatorBuilder: (context, index) {
            return Text('Separator $index', key: Key('separator-$index'));
          },
        ),
      );
      await tester.pumpAndSettle();

      // Center section has 3 items (indices 0, 1, 2), so 2 separators at indices 0 and 1
      expect(find.text('Separator 0'), findsOneWidget);
      expect(find.text('Separator 1'), findsOneWidget);

      // Load prepend items (first page, which adds 2 items)
      dataSource.prepend();
      await tester.pumpAndSettle();

      // Scroll up to reveal prepend items
      await tester.fling(
        find.byType(CustomScrollView),
        const Offset(0, 500),
        1000,
      );
      await tester.pumpAndSettle();

      // Verify prepended items are visible
      expect(find.text('Prepended -1'), findsOneWidget);
      expect(find.text('Prepended -1b'), findsOneWidget);

      expect(find.text('Separator 2'), findsOneWidget); // within prepend
      expect(
        find.text('Separator 1'),
        findsOneWidget,
      ); // between prepend-center
      expect(find.text('Separator 2'), findsOneWidget); // within center
      expect(find.text('Separator 3'), findsOneWidget); // within center

      // Load append items (which adds 2 items)
      dataSource.append();
      await tester.pumpAndSettle();

      // Verify appended items are visible
      expect(find.text('Appended 1'), findsOneWidget);
      expect(find.text('Appended 1b'), findsOneWidget);

      expect(find.text('Separator 4'), findsOneWidget); // between center-append
      expect(find.text('Separator 5'), findsOneWidget); // within append
    });
  });
}

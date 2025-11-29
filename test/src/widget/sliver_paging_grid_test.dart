import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/paging_view.dart';

import '../../helper/test_data_source.dart';

void main() {
  group('SliverPagingGrid', () {
    Widget createSliverPagingGrid({
      required TestDataSource dataSource,
      bool fillRemainErrorWidget = true,
      bool fillRemainEmptyWidget = true,
      EdgeInsets padding = EdgeInsets.zero,
      bool autoLoadPrepend = true,
      bool autoLoadAppend = true,
      bool reverse = false,
      ScrollController? controller,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            controller: controller,
            reverse: reverse,
            slivers: [
              SliverPagingGrid<int, String>(
                dataSource: dataSource,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
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
              ),
            ],
          ),
        ),
      );
    }

    testWidgets('renders items in reverse when reverse is true', (
      tester,
    ) async {
      final dataSource = TestDataSource(maxAppendPages: 0, maxPrependPages: 0);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createSliverPagingGrid(dataSource: dataSource, reverse: true),
      );
      await tester.pumpAndSettle();

      final item1Pos = tester.getTopLeft(find.text('Item 1'));
      final item2Pos = tester.getTopLeft(find.text('Item 3'));
      expect(item1Pos.dy, greaterThan(item2Pos.dy));
    });

    testWidgets('displays initial loading, then items', (tester) async {
      final dataSource = TestDataSource(
        refreshDelay: const Duration(milliseconds: 100),
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(createSliverPagingGrid(dataSource: dataSource));
      await tester.pump();
      expect(find.text('Initial Loading'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Initial Loading'), findsNothing);
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('displays empty widget when initial data is empty', (
      tester,
    ) async {
      final dataSource = TestDataSource(initialItems: const []);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(createSliverPagingGrid(dataSource: dataSource));
      await tester.pumpAndSettle();
      expect(find.text('No Data'), findsOneWidget);
    });

    testWidgets('displays error widget on initial load error', (tester) async {
      final dataSource = TestDataSource(hasErrorOnRefresh: true);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(createSliverPagingGrid(dataSource: dataSource));
      await tester.pumpAndSettle();
      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('loads more items on scroll (append)', (tester) async {
      final dataSource = TestDataSource(
        maxAppendPages: 1,
        initialItems: List.generate(6, (index) => 'Item $index'),
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(createSliverPagingGrid(dataSource: dataSource));
      await tester.pumpAndSettle();

      expect(find.text('Appended Item 1'), findsNothing);

      await tester.fling(
        find.byType(CustomScrollView),
        const Offset(0, -500),
        1000,
      );
      await tester.pumpAndSettle();

      expect(find.text('Appended Item 1'), findsOneWidget);
    });

    testWidgets('loads more items on scroll (prepend)', (tester) async {
      final dataSource = TestDataSource(
        maxPrependPages: 1,
        initialItems: List.generate(6, (index) => 'Item $index'),
      );
      addTearDown(dataSource.dispose);

      final controller = ScrollController(initialScrollOffset: 1000.0);
      await tester.pumpWidget(
        createSliverPagingGrid(dataSource: dataSource, controller: controller),
      );
      await tester.pumpAndSettle();
      expect(find.text('Prepended Item -1'), findsNothing);

      await tester.fling(
        find.byType(CustomScrollView),
        const Offset(0, 500),
        1000,
      );
      await tester.pumpAndSettle();

      expect(find.text('Prepended Item -1'), findsOneWidget);
    });

    testWidgets('displays append loading widget during append', (tester) async {
      final dataSource = TestDataSource(
        maxAppendPages: 1,
        initialItems: const ['Item 1'],
        appendDelay: const Duration(microseconds: 100),
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createSliverPagingGrid(dataSource: dataSource, autoLoadAppend: false),
      );
      await tester.pumpAndSettle();
      expect(find.text('Appending'), findsNothing);

      dataSource.append();
      await tester.pump();
      expect(find.text('Appending'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Appending'), findsNothing);
      expect(find.text('Appended Item 1'), findsOneWidget);
    });

    testWidgets('displays prepend loading widget during prepend', (
      tester,
    ) async {
      final dataSource = TestDataSource(
        maxPrependPages: 1,
        prependDelay: const Duration(microseconds: 100),
      );
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createSliverPagingGrid(dataSource: dataSource, autoLoadPrepend: false),
      );
      await tester.pumpAndSettle();
      expect(find.text('Prepending'), findsNothing);

      dataSource.prepend();
      await tester.pump();
      expect(find.text('Prepending'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Prepending'), findsNothing);
      expect(find.text('Prepended Item -1'), findsOneWidget);
    });

    testWidgets('applies padding correctly', (tester) async {
      final dataSource = TestDataSource(maxAppendPages: 0, maxPrependPages: 0);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createSliverPagingGrid(
          dataSource: dataSource,
          padding: const EdgeInsets.all(20.0),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Item 1'), findsOneWidget);

      final item1Rect = tester.getRect(find.text('Item 1'));
      expect(item1Rect.left, 20.0);
      expect(item1Rect.top, 20.0);
    });

    testWidgets(
      'error widget fills remaining space if fillRemainErrorWidget is true',
      (tester) async {
        final dataSource = TestDataSource(hasErrorOnRefresh: true);
        addTearDown(dataSource.dispose);

        await tester.pumpWidget(
          createSliverPagingGrid(
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
        final dataSource = TestDataSource(initialItems: const []);
        addTearDown(dataSource.dispose);

        await tester.pumpWidget(
          createSliverPagingGrid(
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
        final dataSource = TestDataSource(hasErrorOnRefresh: true);
        addTearDown(dataSource.dispose);

        await tester.pumpWidget(
          createSliverPagingGrid(
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
        final dataSource = TestDataSource(initialItems: const []);
        addTearDown(dataSource.dispose);

        await tester.pumpWidget(
          createSliverPagingGrid(
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
  });
}

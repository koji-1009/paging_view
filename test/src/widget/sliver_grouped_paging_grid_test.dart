import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/paging_view.dart';

import '../../helper/test_data_source.dart';

void main() {
  group('SliverGroupedPagingGrid', () {
    Widget createSliverGroupedPagingGrid({
      required TestGroupedDataSource dataSource,
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
              SliverGroupedPagingGrid<int, String, String>(
                dataSource: dataSource,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                headerBuilder: (context, group, index) => Text('Group $group'),
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
        createSliverGroupedPagingGrid(dataSource: dataSource),
      );
      await tester.pump();
      expect(find.text('Initial Loading'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Initial Loading'), findsNothing);
      expect(find.text('A1'), findsOneWidget);
      expect(find.text('Group Group A'), findsOneWidget);
      expect(find.text('Group Group B'), findsOneWidget);
    });

    testWidgets('displays empty widget when initial data is empty', (
      tester,
    ) async {
      final dataSource = TestGroupedDataSource(initialItems: []);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createSliverGroupedPagingGrid(dataSource: dataSource),
      );
      await tester.pumpAndSettle();
      expect(find.text('No Data'), findsOneWidget);
    });

    testWidgets('displays error widget on initial load error', (tester) async {
      final dataSource = TestGroupedDataSource(hasErrorOnRefresh: true);
      addTearDown(dataSource.dispose);

      await tester.pumpWidget(
        createSliverGroupedPagingGrid(dataSource: dataSource),
      );
      await tester.pumpAndSettle();
      expect(find.text('Error'), findsOneWidget);
    });
  });
}

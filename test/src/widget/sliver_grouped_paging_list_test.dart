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
      bool reverse = false,
      ScrollController? controller,
      bool stickyHeader = false,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            controller: controller,
            reverse: reverse,
            slivers: [
              separatorBuilder != null
                  ? SliverGroupedPagingList.separated(
                      dataSource: dataSource,
                      headerBuilder: (context, group, index) =>
                          Text('Group $group'),
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
                    )
                  : SliverGroupedPagingList<int, String, String>(
                      dataSource: dataSource,
                      headerBuilder: (context, group, index) =>
                          Text('Group $group'),
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
      expect(find.text('Group Group A'), findsOneWidget);
      expect(find.text('Group Group B'), findsOneWidget);
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
  });
}

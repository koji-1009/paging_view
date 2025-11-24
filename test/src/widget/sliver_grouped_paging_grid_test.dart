import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/paging_view.dart';

import '../../helper/test_data_source.dart';

void main() {
  const gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
  );

  group('SliverGroupedPagingGrid', () {
    testWidgets('displays grouped items in sliver', (tester) async {
      final dataSource = TestGroupedDataSource();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverGroupedPagingGrid<int, String, String>(
                  gridDelegate: gridDelegate,
                  dataSource: dataSource,
                  headerBuilder: (context, groupKey, index) =>
                      Text('Header: $groupKey'),
                  itemBuilder: (context, item, globalIndex, localIndex) =>
                      Text(item),
                  errorBuilder: (context, error, stackTrace) =>
                      Text('Error: $error'),
                  initialLoadingWidget: const CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Header: Group A'), findsOneWidget);
      expect(find.text('Header: Group B'), findsOneWidget);
      expect(find.text('A1'), findsOneWidget);
      expect(find.text('A2'), findsOneWidget);
      expect(find.text('B1'), findsOneWidget);
      expect(find.text('B2'), findsOneWidget);
      dataSource.dispose();
    });

    testWidgets('displays error widget on error', (tester) async {
      final dataSource = TestGroupedDataSource(hasErrorOnRefresh: true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverGroupedPagingGrid<int, String, String>(
                  gridDelegate: gridDelegate,
                  dataSource: dataSource,
                  headerBuilder: (context, groupKey, index) =>
                      Text('Header: $groupKey'),
                  itemBuilder: (context, item, globalIndex, localIndex) =>
                      Text(item),
                  errorBuilder: (context, error, stackTrace) =>
                      const Text('Error on Refresh'),
                  initialLoadingWidget: const CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Error on Refresh'), findsOneWidget);
      dataSource.dispose();
    });

    testWidgets('displays emptyWidget for empty list', (tester) async {
      final dataSource = TestGroupedDataSource(initialItems: const []);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverGroupedPagingGrid<int, String, String>(
                  gridDelegate: gridDelegate,
                  dataSource: dataSource,
                  headerBuilder: (context, groupKey, index) =>
                      Text('Header: $groupKey'),
                  itemBuilder: (context, item, globalIndex, localIndex) =>
                      Text(item),
                  errorBuilder: (context, error, stackTrace) =>
                      Text('Error: $error'),
                  initialLoadingWidget: const CircularProgressIndicator(),
                  emptyWidget: const Text('Empty'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Empty'), findsOneWidget);
      dataSource.dispose();
    });

    testWidgets('displays single group', (tester) async {
      final dataSource = TestGroupedDataSource(
        initialItems: const ['X1', 'X2'],
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverGroupedPagingGrid<int, String, String>(
                  gridDelegate: gridDelegate,
                  dataSource: dataSource,
                  headerBuilder: (context, groupKey, index) =>
                      Text('Header: $groupKey'),
                  itemBuilder: (context, item, globalIndex, localIndex) =>
                      Text(item),
                  errorBuilder: (context, error, stackTrace) =>
                      Text('Error: $error'),
                  initialLoadingWidget: const CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Header: Group A'), findsNothing);
      expect(find.text('Header: Other'), findsOneWidget);
      expect(find.text('X1'), findsOneWidget);
      expect(find.text('X2'), findsOneWidget);
      dataSource.dispose();
    });
  });
}

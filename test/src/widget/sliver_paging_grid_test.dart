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

  group('SliverPagingGrid', () {
    testWidgets('displays items in sliver grid', (tester) async {
      final dataSource = TestDataSource();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverPagingGrid<int, String>(
                  gridDelegate: gridDelegate,
                  dataSource: dataSource,
                  builder: (context, item, index) => Text(item),
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
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
      dataSource.dispose();
    });

    testWidgets('displays empty widget in sliver grid when no data', (
      tester,
    ) async {
      final dataSource = TestDataSource(initialItems: const []);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverPagingGrid<int, String>(
                  gridDelegate: gridDelegate,
                  dataSource: dataSource,
                  builder: (context, item, index) => Text(item),
                  errorBuilder: (context, error, stackTrace) =>
                      Text('Error: $error'),
                  initialLoadingWidget: const CircularProgressIndicator(),
                  emptyWidget: const Text('No data'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No data'), findsOneWidget);
      dataSource.dispose();
    });

    testWidgets('displays error widget in sliver grid on error', (
      tester,
    ) async {
      final dataSource = TestDataSource(hasErrorOnRefresh: true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverPagingGrid<int, String>(
                  gridDelegate: gridDelegate,
                  dataSource: dataSource,
                  builder: (context, item, index) => Text(item),
                  errorBuilder: (context, error, stackTrace) =>
                      const Text('Error occurred'),
                  initialLoadingWidget: const CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Error occurred'), findsOneWidget);
      dataSource.dispose();
    });
  });
}

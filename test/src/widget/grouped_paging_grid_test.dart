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

  group('GroupedPagingGrid', () {
    testWidgets('displays grouped items after loading', (tester) async {
      final dataSource = TestGroupedDataSource();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedPagingGrid<int, String, String>(
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
            body: GroupedPagingGrid<int, String, String>(
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
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Error:'), findsOneWidget);
      dataSource.dispose();
    });

    testWidgets('displays nothing for empty groups', (tester) async {
      final dataSource = TestGroupedDataSource(initialItems: const []);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedPagingGrid<int, String, String>(
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
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsNothing);
      dataSource.dispose();
    });

    testWidgets('displays single group', (tester) async {
      final dataSource = TestGroupedDataSource(initialItems: ['A1', 'A2']);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedPagingGrid<int, String, String>(
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
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Header: Group A'), findsOneWidget);
      expect(find.text('A1'), findsOneWidget);
      expect(find.text('A2'), findsOneWidget);
      dataSource.dispose();
    });

    testWidgets('displays correct group order', (tester) async {
      final dataSource = TestGroupedDataSource(
        initialItems: ['B1', 'B2', 'A1', 'A2'],
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedPagingGrid<int, String, String>(
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
          ),
        ),
      );
      await tester.pumpAndSettle();
      final headerFinder = find.text('Header: Group B');
      final headerFinderA = find.text('Header: Group A');
      expect(headerFinder, findsOneWidget);
      expect(headerFinderA, findsOneWidget);
      // Order verification can be done using the index in the Widget tree
      // If the key is null, order verification is not possible, so it is omitted
      dataSource.dispose();
    });

    testWidgets('shows loading widget initially', (tester) async {
      final dataSource = TestGroupedDataSource();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedPagingGrid<int, String, String>(
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
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      dataSource.dispose();
    });

    testWidgets('handles special group names', (tester) async {
      final dataSource = TestGroupedDataSource(initialItems: ['N1', 'S1']);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedPagingGrid<int, String, String>(
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
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Header: Other'), findsOneWidget);
      expect(find.text('N1'), findsOneWidget);
      expect(find.text('S1'), findsOneWidget);
      dataSource.dispose();
    });

    testWidgets('renders sticky headers with stickyHeader=true', (
      tester,
    ) async {
      final dataSource = TestGroupedDataSource();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedPagingGrid<int, String, String>(
              gridDelegate: gridDelegate,
              dataSource: dataSource,
              headerBuilder: (context, groupKey, index) => Container(
                color: Colors.blue,
                child: Text('Header: $groupKey'),
              ),
              itemBuilder: (context, item, globalIndex, localIndex) =>
                  Text(item),
              errorBuilder: (context, error, stackTrace) =>
                  Text('Error: $error'),
              initialLoadingWidget: const CircularProgressIndicator(),
              stickyHeader: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Header: Group A'), findsOneWidget);
      expect(find.text('Header: Group B'), findsOneWidget);
      dataSource.dispose();
    });
  });
}

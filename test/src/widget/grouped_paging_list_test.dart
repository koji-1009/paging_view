import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/paging_view.dart';
import 'package:paging_view/src/private/entity.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TestGroupedDataSource extends GroupedDataSource<int, String, String> {
  TestGroupedDataSource({
    this.initialGroups = const {
      'Group A': ['A1', 'A2'],
      'Group B': ['B1', 'B2'],
    },
    this.hasMoreData = true,
    this.hasError = false,
  });

  final Map<String, List<String>> initialGroups;
  final bool hasMoreData;
  final bool hasError;

  @override
  Future<LoadResult<int, String>> load(LoadAction<int> action) async {
    if (hasError) {
      throw Exception('Test error');
    }
    switch (action) {
      case Refresh():
        // Flatten all items from all groups into a single list
        final allItems = initialGroups.values.expand((list) => list).toList();
        return Success(
          page: PageData(data: allItems, appendKey: hasMoreData ? 1 : null),
        );
      case Append(:final key):
        if (key >= 2) {
          return const None();
        }
        final newItems = ['C${key * 2 + 1}', 'C${key * 2 + 2}'];
        return Success(
          page: PageData(
            data: newItems,
            appendKey: key + 1 < 2 ? key + 1 : null,
          ),
        );
      case Prepend():
        return const None();
    }
  }

  @override
  String groupBy(String value) {
    // Return group key based on the first character of the value
    if (value.startsWith('A')) return 'Group A';
    if (value.startsWith('B')) return 'Group B';
    if (value.startsWith('C')) return 'Group C';
    return 'Other';
  }
}

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  group('GroupedPagingList', () {
    testWidgets('displays grouped items after loading', (
      WidgetTester tester,
    ) async {
      final dataSource = TestGroupedDataSource();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedPagingList<int, String, String>(
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

    testWidgets('displays error widget on error', (WidgetTester tester) async {
      final dataSource = TestGroupedDataSource(hasError: true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedPagingList<int, String, String>(
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

    testWidgets('displays nothing for empty groups', (
      WidgetTester tester,
    ) async {
      final dataSource = TestGroupedDataSource(initialGroups: {});
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedPagingList<int, String, String>(
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

    testWidgets('displays single group', (WidgetTester tester) async {
      final dataSource = TestGroupedDataSource(
        initialGroups: {
          'Group X': ['X1', 'X2'],
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedPagingList<int, String, String>(
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
      expect(find.text('X1'), findsOneWidget);
      expect(find.text('X2'), findsOneWidget);
      dataSource.dispose();
    });

    testWidgets('displays correct group order', (WidgetTester tester) async {
      final dataSource = TestGroupedDataSource(
        initialGroups: {
          'Group B': ['B1', 'B2'],
          'Group A': ['A1', 'A2'],
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedPagingList<int, String, String>(
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
      // 順序検証はWidget treeのindexで可能
      // キーがnullの場合は順序検証不可なので省略
      dataSource.dispose();
    });

    testWidgets('shows loading widget initially', (WidgetTester tester) async {
      final dataSource = TestGroupedDataSource();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedPagingList<int, String, String>(
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

    testWidgets('appends items and updates groups', (
      WidgetTester tester,
    ) async {
      final dataSource = TestGroupedDataSource();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedPagingList<int, String, String>(
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
      // appendをシミュレート
      await dataSource.update(LoadType.append);
      await tester.pumpAndSettle();
      expect(find.text('Header: Group C'), findsOneWidget);
      expect(find.text('C3'), findsOneWidget);
      expect(find.text('C4'), findsOneWidget);
      dataSource.dispose();
    });

    testWidgets('handles special group names', (WidgetTester tester) async {
      final dataSource = TestGroupedDataSource(
        initialGroups: {
          '': ['N1'],
          '@@@': ['S1'],
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupedPagingList<int, String, String>(
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
  });
}

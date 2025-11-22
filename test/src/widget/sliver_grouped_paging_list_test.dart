import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/paging_view.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TestGroupedDataSource extends GroupedDataSource<int, String, String> {
  TestGroupedDataSource({
    this.items = const ['A1', 'A2', 'B1', 'B2'],
    this.hasError = false,
  });

  final List<String> items;
  final bool hasError;

  @override
  Future<LoadResult<int, String>> load(LoadAction<int> action) async {
    if (hasError) {
      throw Exception('Test error');
    }
    switch (action) {
      case Refresh():
        return Success(page: PageData(data: items, appendKey: null));
      default:
        return const None();
    }
  }

  @override
  String groupBy(String value) {
    return value.startsWith('A') ? 'Group A' : 'Group B';
  }
}

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  group('SliverGroupedPagingList', () {
    testWidgets('displays grouped items in sliver', (
      WidgetTester tester,
    ) async {
      final dataSource = TestGroupedDataSource();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverGroupedPagingList<int, String, String>(
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

    testWidgets('displays error widget on error', (WidgetTester tester) async {
      final dataSource = TestGroupedDataSource(hasError: true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverGroupedPagingList<int, String, String>(
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
      expect(find.textContaining('Error:'), findsOneWidget);
      dataSource.dispose();
    });

    testWidgets('displays nothing for empty groups', (
      WidgetTester tester,
    ) async {
      final dataSource = TestGroupedDataSource(items: []);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverGroupedPagingList<int, String, String>(
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
      expect(find.byType(Text), findsNothing);
      dataSource.dispose();
    });

    testWidgets('displays single group', (WidgetTester tester) async {
      final dataSource = TestGroupedDataSource(items: ['X1', 'X2']);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverGroupedPagingList<int, String, String>(
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
      expect(find.text('Header: Group B'), findsOneWidget);
      expect(find.text('X1'), findsOneWidget);
      expect(find.text('X2'), findsOneWidget);
      dataSource.dispose();
    });

    testWidgets('handles special group names', (WidgetTester tester) async {
      final dataSource = TestGroupedDataSource(items: ['', '@@@']);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverGroupedPagingList<int, String, String>(
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
      expect(find.text('Header: Group B'), findsOneWidget);
      expect(find.text(''), findsOneWidget);
      expect(find.text('@@@'), findsOneWidget);
      dataSource.dispose();
    });

    testWidgets('shows loading widget initially', (WidgetTester tester) async {
      final dataSource = TestGroupedDataSource();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverGroupedPagingList<int, String, String>(
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
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      dataSource.dispose();
    });
  });
}

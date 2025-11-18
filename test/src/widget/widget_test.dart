import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/paging_view.dart';

class TestWidgetDataSource extends DataSource<int, String> {
  TestWidgetDataSource({
    this.initialData = const ['Item 1', 'Item 2', 'Item 3'],
    this.hasMoreData = true,
  });

  final List<String> initialData;
  final bool hasMoreData;

  @override
  Future<LoadResult<int, String>> load(LoadAction<int> action) async {
    await Future.delayed(const Duration(milliseconds: 10));

    switch (action) {
      case Refresh():
        return Success(
          page: PageData(data: initialData, appendKey: hasMoreData ? 1 : null),
        );
      case Append(:final key):
        if (key >= 3) {
          return const None();
        }
        return Success(
          page: PageData(
            data: [
              'Item ${key * 3 + 1}',
              'Item ${key * 3 + 2}',
              'Item ${key * 3 + 3}',
            ],
            appendKey: key + 1 < 3 ? key + 1 : null,
          ),
        );
      case Prepend():
        return const None();
    }
  }
}

void main() {
  group('PagingList', () {
    testWidgets('displays initial loading widget', (WidgetTester tester) async {
      final dataSource = TestWidgetDataSource();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PagingList<int, String>(
              dataSource: dataSource,
              builder: (context, item, index) => Text(item),
              errorBuilder: (context, error, stackTrace) =>
                  Text('Error: $error'),
              initialLoadingWidget: const CircularProgressIndicator(),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for all pending async operations to complete
      await tester.pumpAndSettle(const Duration(seconds: 1));

      dataSource.dispose();
    });

    testWidgets('displays items after loading', (WidgetTester tester) async {
      final dataSource = TestWidgetDataSource();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PagingList<int, String>(
              dataSource: dataSource,
              builder: (context, item, index) => Text(item),
              errorBuilder: (context, error, stackTrace) =>
                  Text('Error: $error'),
              initialLoadingWidget: const CircularProgressIndicator(),
            ),
          ),
        ),
      );

      // Wait for auto-loading to complete
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);

      dataSource.dispose();
    });

    testWidgets('displays empty widget when no data', (
      WidgetTester tester,
    ) async {
      final dataSource = TestWidgetDataSource(initialData: const []);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PagingList<int, String>(
              dataSource: dataSource,
              builder: (context, item, index) => Text(item),
              errorBuilder: (context, error, stackTrace) =>
                  Text('Error: $error'),
              initialLoadingWidget: const CircularProgressIndicator(),
              emptyWidget: const Text('No data'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('No data'), findsOneWidget);

      dataSource.dispose();
    });

    testWidgets('displays error widget on error', (WidgetTester tester) async {
      final dataSource = TestWidgetDataSource();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PagingList<int, String>(
              dataSource: dataSource,
              builder: (context, item, index) => Text(item),
              errorBuilder: (context, error, stackTrace) =>
                  const Text('Error occurred'),
              initialLoadingWidget: const CircularProgressIndicator(),
            ),
          ),
        ),
      );

      dataSource.notifier.setError(
        error: Exception('Test error'),
        stackTrace: null,
      );
      await tester.pump();

      expect(find.text('Error occurred'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 1));
      dataSource.dispose();
    });
  });

  group('PagingGrid', () {
    testWidgets('displays items in grid after loading', (
      WidgetTester tester,
    ) async {
      final dataSource = TestWidgetDataSource();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PagingGrid<int, String>(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              dataSource: dataSource,
              builder: (context, item, index) => Text(item),
              errorBuilder: (context, error, stackTrace) =>
                  Text('Error: $error'),
              initialLoadingWidget: const CircularProgressIndicator(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);

      dataSource.dispose();
    });
  });

  group('SliverPagingList', () {
    testWidgets('displays items in sliver list', (WidgetTester tester) async {
      final dataSource = TestWidgetDataSource();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverPagingList<int, String>(
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

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);

      dataSource.dispose();
    });
  });

  group('SliverPagingGrid', () {
    testWidgets('displays items in sliver grid', (WidgetTester tester) async {
      final dataSource = TestWidgetDataSource();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverPagingGrid<int, String>(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
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

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);

      dataSource.dispose();
    });
  });
}

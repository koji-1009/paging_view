import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/paging_view.dart';

class TestWidgetDataSource extends DataSource<int, String> {
  TestWidgetDataSource({
    this.initialData = const ['Item 1', 'Item 2', 'Item 3'],
    this.hasMoreData = true,
    this.hasError = false,
  });

  final List<String> initialData;
  final bool hasMoreData;
  final bool hasError;

  @override
  Future<LoadResult<int, String>> load(LoadAction<int> action) async {
    if (hasError) {
      throw Exception('Test error');
    }

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
  group('PagingGrid', () {
    testWidgets('displays items in grid after loading', (tester) async {
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

      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);

      dataSource.dispose();
    });

    testWidgets('displays initial loading widget in grid', (tester) async {
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

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);

      dataSource.dispose();
    });

    testWidgets('displays empty widget in grid when no data', (tester) async {
      final dataSource = TestWidgetDataSource(initialData: const []);

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
              emptyWidget: const Text('No data'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No data'), findsOneWidget);

      dataSource.dispose();
    });

    testWidgets('displays error widget in grid on error', (tester) async {
      final dataSource = TestWidgetDataSource(hasError: true);

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
                  const Text('Error occurred'),
              initialLoadingWidget: const CircularProgressIndicator(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Error occurred'), findsOneWidget);

      dataSource.dispose();
    });

    testWidgets('renders grid items in reverse when reverse is true', (
      tester,
    ) async {
      final dataSource = TestWidgetDataSource(
        initialData: const ['Item 1', 'Item 2', 'Item 3', 'Item 4'],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PagingGrid<int, String>(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              dataSource: dataSource,
              reverse: true,
              builder: (context, item, index) => Text(item),
              errorBuilder: (context, error, stackTrace) =>
                  Text('Error: $error'),
              initialLoadingWidget: const CircularProgressIndicator(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Get the positions of items in the first and second rows.
      final item1Pos = tester.getTopLeft(find.text('Item 1'));
      final item3Pos = tester.getTopLeft(find.text('Item 3'));

      // In a reversed grid, the row containing Item 3 should be physically
      // above the row containing Item 1.
      expect(item3Pos.dy, lessThan(item1Pos.dy));

      dataSource.dispose();
    });
  });
}

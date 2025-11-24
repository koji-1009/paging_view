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
  group('PagingList', () {
    testWidgets('displays initial loading widget', (tester) async {
      final dataSource = TestWidgetDataSource();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PagingList(
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

    testWidgets('displays items after loading', (tester) async {
      final dataSource = TestWidgetDataSource();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PagingList(
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

    testWidgets('displays empty widget when no data', (tester) async {
      final dataSource = TestWidgetDataSource(initialData: const []);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PagingList(
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

    testWidgets('displays error widget on error', (tester) async {
      final dataSource = TestWidgetDataSource(hasError: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PagingList(
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

    testWidgets('loads more items when scrolled', (tester) async {
      final dataSource = TestWidgetDataSource();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PagingList(
              dataSource: dataSource,
              builder: (context, item, index) =>
                  SizedBox(height: 100, child: Text(item)),
              errorBuilder: (context, error, stackTrace) =>
                  Text('Error: $error'),
              initialLoadingWidget: const CircularProgressIndicator(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the first items are displayed
      expect(find.text('Item 1'), findsOneWidget);

      // Scroll down to load more items
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      // Verify additional items are displayed
      expect(find.text('Item 4'), findsOneWidget);
      expect(find.text('Item 5'), findsOneWidget);
      expect(find.text('Item 6'), findsOneWidget);

      dataSource.dispose();
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/paging_view.dart';
import 'package:paging_view/src/private/entity.dart';

import '../../helper/test_data_source.dart';

void main() {
  group('PrependLoadStateBuilder', () {
    testWidgets('shows button when hasMore is true and isLoading is false', (
      WidgetTester tester,
    ) async {
      final dataSource = TestDataSource();
      await dataSource.refresh();

      await tester.pumpWidget(
        MaterialApp(
          home: PrependLoadStateBuilder<int, String>(
            dataSource: dataSource,
            builder: (context, hasMore, isLoading) {
              if (!hasMore) return const SizedBox.shrink();
              return ElevatedButton(
                onPressed: isLoading ? null : () => dataSource.prepend(),
                child: const Text('Load Previous'),
              );
            },
          ),
        ),
      );

      expect(find.text('Load Previous'), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNotNull,
      );
    });

    testWidgets('hides button when hasMore is false', (
      WidgetTester tester,
    ) async {
      final dataSource = TestDataSource(prependedItems: []);
      await dataSource.refresh();
      await dataSource.prepend();

      await tester.pumpWidget(
        MaterialApp(
          home: PrependLoadStateBuilder<int, String>(
            dataSource: dataSource,
            builder: (context, hasMore, isLoading) {
              if (!hasMore) return const SizedBox.shrink();
              return ElevatedButton(
                onPressed: isLoading ? null : () => dataSource.prepend(),
                child: const Text('Load Previous'),
              );
            },
          ),
        ),
      );

      expect(find.text('Load Previous'), findsNothing);
    });

    testWidgets('disables button when isLoading is true', (
      WidgetTester tester,
    ) async {
      final dataSource = TestDataSource();
      await dataSource.refresh();
      // Simulate loading state
      dataSource.notifier.value = Paging(
        state: LoadStateLoading(state: LoadType.prepend),
        data: [PageData(data: [], prependKey: 0)],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: PrependLoadStateBuilder<int, String>(
            dataSource: dataSource,
            builder: (context, hasMore, isLoading) {
              if (!hasMore) return const SizedBox.shrink();
              return ElevatedButton(
                onPressed: isLoading ? null : () => dataSource.prepend(),
                child: const Text('Load Previous'),
              );
            },
          ),
        ),
      );

      expect(find.text('Load Previous'), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull,
      );
    });
  });

  group('AppendLoadStateBuilder', () {
    testWidgets('shows button when hasMore is true and isLoading is false', (
      WidgetTester tester,
    ) async {
      final dataSource = TestDataSource();
      await dataSource.refresh();

      await tester.pumpWidget(
        MaterialApp(
          home: AppendLoadStateBuilder<int, String>(
            dataSource: dataSource,
            builder: (context, hasMore, isLoading) {
              if (!hasMore) return const SizedBox.shrink();
              return ElevatedButton(
                onPressed: isLoading ? null : () => dataSource.append(),
                child: const Text('Load More'),
              );
            },
          ),
        ),
      );

      expect(find.text('Load More'), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNotNull,
      );
    });

    testWidgets('hides button when hasMore is false', (
      WidgetTester tester,
    ) async {
      final dataSource = TestDataSource(appendedItems: []);
      await dataSource.refresh();
      await dataSource.append();

      await tester.pumpWidget(
        MaterialApp(
          home: AppendLoadStateBuilder<int, String>(
            dataSource: dataSource,
            builder: (context, hasMore, isLoading) {
              if (!hasMore) return const SizedBox.shrink();
              return ElevatedButton(
                onPressed: isLoading ? null : () => dataSource.append(),
                child: const Text('Load More'),
              );
            },
          ),
        ),
      );

      expect(find.text('Load More'), findsNothing);
    });

    testWidgets('disables button when isLoading is true', (
      WidgetTester tester,
    ) async {
      final dataSource = TestDataSource();
      await dataSource.refresh();
      // Simulate loading state
      dataSource.notifier.value = Paging(
        state: LoadStateLoading(state: LoadType.append),
        data: [PageData(data: [], appendKey: 1)],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: AppendLoadStateBuilder<int, String>(
            dataSource: dataSource,
            builder: (context, hasMore, isLoading) {
              if (!hasMore) return const SizedBox.shrink();
              return ElevatedButton(
                onPressed: isLoading ? null : () => dataSource.append(),
                child: const Text('Load More'),
              );
            },
          ),
        ),
      );

      expect(find.text('Load More'), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull,
      );
    });
  });
}

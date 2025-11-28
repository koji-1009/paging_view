import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/paging_view.dart';
import 'package:paging_view/src/private/entity.dart';

import '../../helper/test_data_source.dart';

void main() {
  group('PrependLoadStateBuilder', () {
    late TestDataSource dataSource;

    setUp(() {
      dataSource = TestDataSource();
    });

    tearDown(() {
      dataSource.dispose();
    });

    Widget createPrependLoadStateBuilder() {
      return MaterialApp(
        home: PrependLoadStateBuilder<int, String>(
          dataSource: dataSource,
          builder: (context, hasMore, isLoading) {
            if (!hasMore) return const Text('No more prepend');
            return ElevatedButton(
              onPressed: isLoading ? null : () {},
              child: Text(isLoading ? 'Loading Previous' : 'Load Previous'),
            );
          },
        ),
      );
    }

    testWidgets('shows load button when hasMore is true and not loading', (
      tester,
    ) async {
      // Simulate initial data with prependKey
      dataSource.notifier.value = Paging(
        state: const LoadStateLoaded(),
        data: [
          PageData(data: const ['Item 1'], prependKey: 0),
        ],
      );
      await tester.pumpWidget(createPrependLoadStateBuilder());
      expect(find.text('Load Previous'), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNotNull,
      );
    });

    testWidgets('shows loading text when isLoading is true', (tester) async {
      // Simulate loading state
      dataSource.notifier.value = Paging(
        state: const LoadStateLoading(state: LoadType.prepend),
        data: [
          PageData(data: const ['Item 1'], prependKey: 0),
        ],
      );
      await tester.pumpWidget(createPrependLoadStateBuilder());
      expect(find.text('Loading Previous'), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull,
      );
    });

    testWidgets('shows "No more prepend" when hasMore is false', (
      tester,
    ) async {
      // Simulate no more prepend pages
      dataSource.notifier.value = Paging(
        state: const LoadStateLoaded(),
        data: [
          PageData(data: const ['Item 1']),
        ],
      );
      await tester.pumpWidget(createPrependLoadStateBuilder());
      expect(find.text('No more prepend'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('shows shrink box when dataSource is in Warning state', (
      tester,
    ) async {
      dataSource.notifier.value = Warning<int, String>(
        error: Exception('Test Error'),
        stackTrace: null,
      );
      await tester.pumpWidget(createPrependLoadStateBuilder());
      // A SizedBox.shrink is effectively findsNothing in tests if it's the only widget.
      // We can assert it's not the button or "No more prepend" text.
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.text('No more prepend'), findsNothing);
    });
  });

  group('AppendLoadStateBuilder', () {
    late TestDataSource dataSource;

    setUp(() {
      dataSource = TestDataSource();
    });

    tearDown(() {
      dataSource.dispose();
    });

    Widget createAppendLoadStateBuilder() {
      return MaterialApp(
        home: AppendLoadStateBuilder<int, String>(
          dataSource: dataSource,
          builder: (context, hasMore, isLoading) {
            if (!hasMore) return const Text('No more append');
            return ElevatedButton(
              onPressed: isLoading ? null : () {},
              child: Text(isLoading ? 'Loading More' : 'Load More'),
            );
          },
        ),
      );
    }

    testWidgets('shows load button when hasMore is true and not loading', (
      tester,
    ) async {
      // Simulate initial data with appendKey
      dataSource.notifier.value = Paging(
        state: const LoadStateLoaded(),
        data: [
          PageData(data: const ['Item 1'], appendKey: 1),
        ],
      );
      await tester.pumpWidget(createAppendLoadStateBuilder());
      expect(find.text('Load More'), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNotNull,
      );
    });

    testWidgets('shows loading text when isLoading is true', (tester) async {
      // Simulate loading state
      dataSource.notifier.value = Paging(
        state: const LoadStateLoading(state: LoadType.append),
        data: [
          PageData(data: const ['Item 1'], appendKey: 1),
        ],
      );
      await tester.pumpWidget(createAppendLoadStateBuilder());
      expect(find.text('Loading More'), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull,
      );
    });

    testWidgets('shows "No more append" when hasMore is false', (tester) async {
      // Simulate no more append pages
      dataSource.notifier.value = Paging(
        state: const LoadStateLoaded(),
        data: [
          PageData(data: const ['Item 1']),
        ],
      );
      await tester.pumpWidget(createAppendLoadStateBuilder());
      expect(find.text('No more append'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('shows shrink box when dataSource is in Warning state', (
      tester,
    ) async {
      dataSource.notifier.value = Warning<int, String>(
        error: Exception('Test Error'),
        stackTrace: null,
      );
      await tester.pumpWidget(createAppendLoadStateBuilder());
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.text('No more append'), findsNothing);
    });
  });
}

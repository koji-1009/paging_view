import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/data_source.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';

// A flexible TestDataSource to mock different load scenarios.
class TestDataSource extends DataSource<int, String> {
  TestDataSource({this.onLoad, super.errorPolicy});

  Future<LoadResult<int, String>> Function(LoadAction<int> action)? onLoad;

  @override
  Future<LoadResult<int, String>> load(LoadAction<int> action) async {
    if (onLoad != null) {
      return onLoad!(action);
    }
    // Default success implementation
    return switch (action) {
      Refresh() => const Success(
        page: PageData(data: ['0', '1', '2'], prependKey: -1, appendKey: 1),
      ),
      Prepend(:final key) => Success(
        page: PageData(
          data: ['p$key'],
          prependKey: key > -3 ? key - 1 : null,
          appendKey: key + 1,
        ),
      ),
      Append(:final key) => Success(
        page: PageData(
          data: ['a$key'],
          prependKey: key - 1,
          appendKey: key < 3 ? key + 1 : null,
        ),
      ),
    };
  }
}

void main() {
  late TestDataSource dataSource;

  setUp(() {
    dataSource = TestDataSource();
  });

  tearDown(() {
    dataSource.dispose();
  });

  group('DataSource Initialization and State', () {
    test('should start with LoadStateInit', () {
      final state = dataSource.notifier.value;
      expect(state, isA<Paging>());
      expect((state as Paging).state, isA<LoadStateInit>());
      expect(dataSource.notifier.values, isEmpty);
    });

    test('dispose should work correctly', () {
      final localDataSource = TestDataSource();
      // Simply check that it doesn't throw
      expect(() => localDataSource.dispose(), returnsNormally);
    });

    test('listeners should be added and removed', () {
      var callCount = 0;
      int listener() => callCount++;

      dataSource.addListener(listener);
      // Directly trigger a change in the underlying notifier to test the listener
      dataSource.refresh();
      // Use a short delay to allow the async refresh to complete
      expect(callCount, greaterThan(0));

      final lastCount = callCount;
      dataSource.removeListener(listener);
      dataSource.refresh();
      expect(callCount, lastCount);
    });
  });

  group('Data Loading: Refresh', () {
    test('successful refresh should populate data and set keys', () async {
      await dataSource.refresh();
      final state = dataSource.notifier.value;
      expect(state, isA<Paging>());
      expect((state as Paging).state, isA<LoadStateLoaded>());
      expect(dataSource.notifier.values, ['0', '1', '2']);
      expect(dataSource.notifier.prependPageKey, -1);
      expect(dataSource.notifier.appendPageKey, 1);
    });

    test('refresh returning None should result in empty list', () async {
      dataSource.onLoad = (_) async => const None();
      await dataSource.refresh();
      final state = dataSource.notifier.value;
      expect(state, isA<Paging>());
      expect((state as Paging).state, isA<LoadStateLoaded>());
      expect(dataSource.notifier.values, isEmpty);
      expect(dataSource.notifier.prependPageKey, isNull);
      expect(dataSource.notifier.appendPageKey, isNull);
    });

    test('refresh returning Failure should set error state', () async {
      final error = Exception('Failure');
      dataSource.onLoad = (_) async => Failure(error: error);
      await dataSource.refresh();
      final state = dataSource.notifier.value;
      expect(state, isA<Warning>());
      expect((state as Warning).error, error);
    });

    test('refresh throwing exception should set error state', () async {
      final error = Exception('Thrown');
      dataSource.onLoad = (_) => throw error;
      await dataSource.refresh();
      final state = dataSource.notifier.value;
      expect(state, isA<Warning>());
      expect((state as Warning).error, error);
    });

    test('calling refresh while loading should be a no-op', () async {
      final completer = Completer<LoadResult<int, String>>();
      dataSource.onLoad = (_) => completer.future;

      // Do not await
      final future = dataSource.refresh();

      expect(dataSource.notifier.isLoading, isTrue);

      // This call should do nothing
      await dataSource.refresh();

      completer.complete(const None());
      await future;

      expect(dataSource.notifier.isLoading, isFalse);
    });
  });

  group('Data Loading: Append', () {
    setUp(() async {
      await dataSource.refresh(); // Initial data: ['0', '1', '2'], appendKey: 1
    });

    test('successful append should add data and update key', () async {
      await dataSource.append(); // Appends ['a1'], appendKey: 2
      expect(dataSource.notifier.values, ['0', '1', '2', 'a1']);
      expect(dataSource.notifier.appendPageKey, 2);
    });

    test('append returning None should not change appendKey', () async {
      dataSource.onLoad = (action) async {
        if (action is Append) {
          return const None();
        }
        return const Success(page: PageData(data: ['0'], appendKey: 1));
      };
      await dataSource.refresh();
      final originalKey = dataSource.notifier.appendPageKey;
      expect(originalKey, 1);

      await dataSource.append();
      // The key should remain unchanged
      expect(dataSource.notifier.appendPageKey, originalKey);
    });

    test('append should not be called if appendKey is null', () async {
      await dataSource.append(); // key: 2
      await dataSource.append(); // key: 3
      await dataSource.append(); // key is now null
      expect(dataSource.notifier.values, ['0', '1', '2', 'a1', 'a2', 'a3']);

      var loadCalled = false;
      dataSource.onLoad = (action) async {
        if (action is! Refresh) {
          loadCalled = true;
        }
        return const None();
      };
      await dataSource.append();
      expect(loadCalled, isFalse);
    });

    test('failed append should set error state', () async {
      final error = Exception('Append failed');
      dataSource.onLoad = (action) async {
        if (action is Append) {
          return Failure(error: error);
        }
        return const Success(page: PageData(data: ['0'], appendKey: 1));
      };
      await dataSource.refresh();
      await dataSource.append();

      final state = dataSource.notifier.value;
      expect(state, isA<Warning>());
      expect((state as Warning).error, error);
    });
  });

  group('Data Loading: Prepend', () {
    setUp(() async {
      await dataSource
          .refresh(); // Initial data: ['0', '1', '2'], prependKey: -1
    });

    test('successful prepend should add data and update key', () async {
      await dataSource.prepend(); // Prepends ['p-1'], prependKey: -2
      expect(dataSource.notifier.values, ['p-1', '0', '1', '2']);
      expect(dataSource.notifier.prependPageKey, -2);
    });

    test('prepend returning None should not change prependKey', () async {
      dataSource.onLoad = (action) async {
        if (action is Prepend) {
          return const None();
        }
        return const Success(page: PageData(data: ['0'], prependKey: -1));
      };
      await dataSource.refresh();
      final originalKey = dataSource.notifier.prependPageKey;
      expect(originalKey, -1);

      await dataSource.prepend();
      // The key should remain unchanged
      expect(dataSource.notifier.prependPageKey, originalKey);
    });

    test('prepend should not be called if prependKey is null', () async {
      await dataSource.prepend(); // key: -2
      await dataSource.prepend(); // key: -3
      await dataSource.prepend(); // key is now null
      expect(dataSource.notifier.values, ['p-3', 'p-2', 'p-1', '0', '1', '2']);

      var loadCalled = false;
      dataSource.onLoad = (action) async {
        if (action is! Refresh) {
          loadCalled = true;
        }
        return const None();
      };
      await dataSource.prepend();
      expect(loadCalled, isFalse);
    });
  });

  group('Item Manipulation', () {
    setUp(() async {
      await dataSource.refresh(); // Initial data: ['0', '1', '2']
    });

    test('updateItem should modify a single item', () {
      dataSource.updateItem(1, (item) => 'X');
      expect(dataSource.notifier.values, ['0', 'X', '2']);
    });

    test('updateItems should modify all items', () {
      dataSource.updateItems((index, item) => '$index:$item');
      expect(dataSource.notifier.values, ['0:0', '1:1', '2:2']);
    });

    test('removeItem should remove a single item', () {
      dataSource.removeItem(1);
      expect(dataSource.notifier.values, ['0', '2']);
    });

    test('removeItems should remove matching items', () {
      dataSource.removeItems((index, item) => item == '1' || index == 0);
      expect(dataSource.notifier.values, ['2']);
    });

    test('insertItem should add an item at an index', () {
      dataSource.insertItem(1, 'X');
      expect(dataSource.notifier.values, ['0', 'X', '1', '2']);
    });

    test('manipulation with out-of-bounds index should set error', () {
      dataSource.updateItem(99, (_) => 'X');
      final state = dataSource.notifier.value;
      expect(state, isA<Warning>());
      expect((state as Warning).error, isA<RangeError>());
    });
  });

  group('Error Recovery', () {
    test(
      'fetch with .ignoreRefresh keeps previous data on exception',
      () async {
        final dataSource = TestDataSource(
          errorPolicy: {LoadErrorPolicy.ignoreRefresh},
        );
        await dataSource.refresh(); // Initial load

        dataSource.onLoad = (action) async {
          if (action is Refresh) {
            throw Exception('Refresh failed');
          }
          return const Success(page: PageData(data: ['0'], appendKey: 1));
        };

        await dataSource.refresh();

        // Check that the state is still Loaded with previous data
        final state = dataSource.notifier.value;
        expect(state, isA<Paging>());
        expect((state as Paging).state, isA<LoadStateLoaded>());
        expect(dataSource.notifier.values, ['0', '1', '2']);

        dataSource.dispose();
      },
    );

    test(
      'append with .ignoreAppend reverts to loaded state on exception',
      () async {
        LoadResult<int, String>? capturedResult;
        LoadAction<int>? capturedAction;
        final dataSource = TestDataSource(
          errorPolicy: {LoadErrorPolicy.ignoreAppend},
        );
        dataSource.onLoadFinished = (action, result) {
          capturedAction = action;
          capturedResult = result;
        };
        dataSource.onLoad = (action) async {
          if (action is Append) {
            throw Exception('Append failed');
          }
          return const Success(page: PageData(data: ['0'], appendKey: 1));
        };

        await dataSource.refresh();
        await dataSource.append();

        // Check that the callback was called with a Failure
        expect(capturedResult, isA<Failure>());
        expect((capturedResult as Failure).error, isA<Exception>());
        expect(capturedAction, isA<Append>());

        // Check that the state reverted to Loaded, not Warning
        final state = dataSource.notifier.value;
        expect(state, isA<Paging>());
        expect((state as Paging).state, isA<LoadStateLoaded>());
        expect(dataSource.notifier.isLoading, isFalse);

        dataSource.dispose();
      },
    );

    test(
      'prepend with .ignorePrepend reverts to loaded state on exception',
      () async {
        LoadResult<int, String>? capturedResult;
        LoadAction<int>? capturedAction;
        final dataSource = TestDataSource(
          errorPolicy: {LoadErrorPolicy.ignorePrepend},
        );
        dataSource.onLoadFinished = (action, result) {
          capturedAction = action;
          capturedResult = result;
        };
        dataSource.onLoad = (action) async {
          if (action is Prepend) {
            throw Exception('Prepend failed');
          }
          return const Success(page: PageData(data: ['0'], prependKey: -1));
        };

        await dataSource.refresh();
        await dataSource.prepend();

        expect(capturedResult, isA<Failure>());
        expect((capturedResult as Failure).error, isA<Exception>());
        expect(capturedAction, isA<Prepend>());

        final state = dataSource.notifier.value;
        expect(state, isA<Paging>());
        expect((state as Paging).state, isA<LoadStateLoaded>());
        expect(dataSource.notifier.isLoading, isFalse);

        dataSource.dispose();
      },
    );

    test('default errorPolicy mode sets Warning state on failure', () async {
      LoadResult<int, String>? capturedResult;
      LoadAction<int>? capturedAction;
      final dataSource = TestDataSource();
      dataSource.onLoadFinished = (action, result) {
        capturedAction = action;
        capturedResult = result;
      };
      dataSource.onLoad = (action) async {
        if (action is Append) {
          throw Exception('Append failed');
        }
        return const Success(page: PageData(data: ['0'], appendKey: 1));
      };

      await dataSource.refresh();
      await dataSource.append();

      // Check that the state is Warning
      final state = dataSource.notifier.value;
      expect(state, isA<Warning>());
      expect((state as Warning).error, isA<Exception>());
      expect(capturedResult, isA<Failure>());
      expect(capturedAction, isA<Append>());

      dataSource.dispose();
    });
  });
}

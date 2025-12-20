import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/center_data_source.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/center_page_manager.dart';
import 'package:paging_view/src/private/entity.dart';

// A flexible TestCenterDataSource to mock different load scenarios.
class TestCenterDataSource extends CenterDataSource<int, String> {
  TestCenterDataSource({this.onLoad, super.errorPolicy});

  Future<LoadResult<int, String>> Function(LoadAction<int> action)? onLoad;

  @override
  Future<LoadResult<int, String>> load(LoadAction<int> action) async {
    if (onLoad != null) {
      return onLoad!(action);
    }
    // Default success implementation
    return switch (action) {
      Refresh() => const Success(
        page: PageData(
          data: ['center1', 'center2'],
          prependKey: -1,
          appendKey: 1,
        ),
      ),
      Prepend(:final key) => Success(
        page: PageData(
          data: ['prepend$key'],
          prependKey: key > -3 ? key - 1 : null,
          appendKey: null,
        ),
      ),
      Append(:final key) => Success(
        page: PageData(
          data: ['append$key'],
          prependKey: null,
          appendKey: key < 3 ? key + 1 : null,
        ),
      ),
    };
  }
}

void main() {
  late TestCenterDataSource dataSource;

  setUp(() {
    dataSource = TestCenterDataSource();
  });

  tearDown(() {
    dataSource.dispose();
  });

  group('CenterDataSource Initialization and State', () {
    test('should start with LoadStateInit', () {
      final state = dataSource.notifier.value;
      expect(state, isA<CenterPaging>());
      expect((state as CenterPaging).state, isA<LoadStateInit>());
      expect(state.centerItems, isEmpty);
    });

    test(
      'update(LoadType.init) should populate center data on success',
      () async {
        await dataSource.update(LoadType.init);
        final state = dataSource.notifier.value;
        expect(state, isA<CenterPaging>());
        expect((state as CenterPaging).state, isA<LoadStateLoaded>());
        expect(state.centerItems, ['center1', 'center2']);
        expect(state.prependItems, isEmpty);
        expect(state.appendItems, isEmpty);
      },
    );

    test(
      'update(LoadType.init) with None should result in empty list',
      () async {
        dataSource.onLoad = (_) async => const None();
        await dataSource.update(LoadType.init);
        final state = dataSource.notifier.value;
        expect(state, isA<CenterPaging>());
        expect((state as CenterPaging).state, isA<LoadStateLoaded>());
        expect(state.allItems, isEmpty);
      },
    );

    test('update(LoadType.init) with Failure should set error state', () async {
      final error = Exception('Init Failure');
      dataSource.onLoad = (_) async => Failure(error: error);
      await dataSource.update(LoadType.init);
      final state = dataSource.notifier.value;
      expect(state, isA<CenterWarning>());
      expect((state as CenterWarning).error, error);
    });

    test(
      'update(LoadType.init) with exception should set error state',
      () async {
        LoadAction<int>? capturedAction;
        LoadResult<int, String>? capturedResult;
        dataSource.onLoadFinished = (action, result) {
          capturedAction = action;
          capturedResult = result;
        };

        final error = Exception('Init Thrown');
        dataSource.onLoad = (_) => throw error;
        await dataSource.update(LoadType.init);
        final state = dataSource.notifier.value;
        expect(state, isA<CenterWarning>());
        expect((state as CenterWarning).error, error);

        expect(capturedAction, isA<Refresh>());
        expect(capturedResult, isA<Failure>());
        expect((capturedResult as Failure).error, error);
      },
    );

    test('dispose should work correctly', () {
      final localDataSource = TestCenterDataSource();
      expect(() => localDataSource.dispose(), returnsNormally);
    });

    test('centerKey should be a GlobalKey', () {
      expect(dataSource.centerKey, isNotNull);
    });

    test('listeners should be added and removed', () async {
      var callCount = 0;
      void listener() => callCount++;

      dataSource.addListener(listener);
      await dataSource.refresh();
      expect(callCount, greaterThan(0));

      final lastCount = callCount;
      dataSource.removeListener(listener);
      await dataSource.refresh();
      expect(callCount, lastCount);
    });
  });

  group('update method', () {
    test('should call _refresh on LoadType.refresh', () async {
      await dataSource.update(LoadType.refresh);
      expect(dataSource.notifier.value.centerItems, ['center1', 'center2']);
    });

    test('should call _prepend on LoadType.prepend', () async {
      await dataSource.refresh();
      await dataSource.update(LoadType.prepend);
      expect(dataSource.notifier.value.prependItems, ['prepend-1']);
      expect(dataSource.notifier.value.centerItems, ['center1', 'center2']);
    });

    test('should call _append on LoadType.append', () async {
      await dataSource.refresh();
      await dataSource.update(LoadType.append);
      expect(dataSource.notifier.value.centerItems, ['center1', 'center2']);
      expect(dataSource.notifier.value.appendItems, ['append1']);
    });
  });

  group('Data Loading: Refresh', () {
    test(
      'successful refresh should populate center data and set keys',
      () async {
        await dataSource.refresh();
        final state = dataSource.notifier.value;
        expect(state, isA<CenterPaging>());
        expect((state as CenterPaging).state, isA<LoadStateLoaded>());
        expect(state.centerItems, ['center1', 'center2']);
        expect(dataSource.notifier.prependPageKey, -1);
        expect(dataSource.notifier.appendPageKey, 1);
      },
    );

    test('refresh returning None should result in empty list', () async {
      dataSource.onLoad = (_) async => const None();
      await dataSource.refresh();
      final state = dataSource.notifier.value;
      expect(state, isA<CenterPaging>());
      expect((state as CenterPaging).state, isA<LoadStateLoaded>());
      expect(state.allItems, isEmpty);
      expect(dataSource.notifier.prependPageKey, isNull);
      expect(dataSource.notifier.appendPageKey, isNull);
    });

    test('refresh returning Failure should set error state', () async {
      final error = Exception('Failure');
      dataSource.onLoad = (_) async => Failure(error: error);
      await dataSource.refresh();
      final state = dataSource.notifier.value;
      expect(state, isA<CenterWarning>());
      expect((state as CenterWarning).error, error);
    });

    test('refresh throwing exception should set error state', () async {
      final error = Exception('Thrown');
      dataSource.onLoad = (_) => throw error;
      await dataSource.refresh();
      final state = dataSource.notifier.value;
      expect(state, isA<CenterWarning>());
      expect((state as CenterWarning).error, error);
    });

    test('calling refresh while loading should be a no-op', () async {
      final completer = Completer<LoadResult<int, String>>();
      dataSource.onLoad = (_) => completer.future;

      final future = dataSource.refresh();
      expect(dataSource.notifier.isLoading, isTrue);

      // This call should do nothing
      await dataSource.refresh();

      completer.complete(const None());
      await future;

      expect(dataSource.notifier.isLoading, isFalse);
    });
  });

  group('Data Loading: Prepend', () {
    setUp(() async {
      await dataSource.refresh();
    });

    test('successful prepend should add data to prependPages', () async {
      await dataSource.prepend();
      expect(dataSource.notifier.value.prependItems, ['prepend-1']);
      expect(dataSource.notifier.value.centerItems, ['center1', 'center2']);
    });

    test('prepend returning None should not add data', () async {
      dataSource.onLoad = (action) async {
        if (action is Prepend) return const None();
        return const Success(
          page: PageData(data: ['center'], prependKey: -1, appendKey: 1),
        );
      };
      await dataSource.refresh();
      await dataSource.prepend();
      expect(dataSource.notifier.value.prependItems, isEmpty);
    });

    test('prepend returning Failure should set error state', () async {
      dataSource.onLoad = (action) async {
        if (action is Prepend) return Failure(error: Exception('fail'));
        return const Success(
          page: PageData(data: ['center'], prependKey: -1, appendKey: 1),
        );
      };
      await dataSource.refresh();
      await dataSource.prepend();
      expect(dataSource.notifier.isLoading, isFalse);
      expect(dataSource.notifier.value, isA<CenterWarning>());
    });

    test('prepend throwing exception should set error state', () async {
      dataSource.onLoad = (action) async {
        if (action is Prepend) throw Exception('thrown');
        return const Success(
          page: PageData(data: ['center'], prependKey: -1, appendKey: 1),
        );
      };
      await dataSource.refresh();
      await dataSource.prepend();
      expect(dataSource.notifier.isLoading, isFalse);
      expect(dataSource.notifier.value, isA<CenterWarning>());
    });

    test('prepend without prependPageKey should be a no-op', () async {
      dataSource.onLoad = (_) async => const Success(
        page: PageData(data: ['center'], prependKey: null, appendKey: 1),
      );
      await dataSource.refresh();
      await dataSource.prepend();
      expect(dataSource.notifier.value.prependItems, isEmpty);
    });

    test('calling prepend while loading should be a no-op', () async {
      final completer = Completer<LoadResult<int, String>>();
      dataSource.onLoad = (action) {
        if (action is Prepend) return completer.future;
        return Future.value(
          const Success(
            page: PageData(data: ['center'], prependKey: -1, appendKey: 1),
          ),
        );
      };

      await dataSource.refresh();
      final future = dataSource.prepend();
      expect(dataSource.notifier.isLoading, isTrue);

      // This call should do nothing
      await dataSource.prepend();

      completer.complete(const None());
      await future;
    });

    test('multiple prepends move data correctly', () async {
      // First prepend
      await dataSource.prepend();
      expect(dataSource.notifier.value.prependItems, ['prepend-1']);
      expect(dataSource.notifier.value.centerItems, ['center1', 'center2']);

      // Second prepend: previous prependPages should move to centerPages
      await dataSource.prepend();
      expect(dataSource.notifier.value.prependItems, ['prepend-2']);
      expect(dataSource.notifier.value.centerItems, [
        'prepend-1',
        'center1',
        'center2',
      ]);
      expect(dataSource.notifier.value.allItems, [
        'prepend-2',
        'prepend-1',
        'center1',
        'center2',
      ]);
    });
  });

  group('Data Loading: Append', () {
    setUp(() async {
      await dataSource.refresh();
    });

    test('successful append should add data to appendPages', () async {
      await dataSource.append();
      expect(dataSource.notifier.value.centerItems, ['center1', 'center2']);
      expect(dataSource.notifier.value.appendItems, ['append1']);
    });

    test('append returning None should not add data', () async {
      dataSource.onLoad = (action) async {
        if (action is Append) return const None();
        return const Success(
          page: PageData(data: ['center'], prependKey: -1, appendKey: 1),
        );
      };
      await dataSource.refresh();
      await dataSource.append();
      expect(dataSource.notifier.value.appendItems, isEmpty);
    });

    test('append returning Failure should set error state', () async {
      dataSource.onLoad = (action) async {
        if (action is Append) return Failure(error: Exception('fail'));
        return const Success(
          page: PageData(data: ['center'], prependKey: -1, appendKey: 1),
        );
      };
      await dataSource.refresh();
      await dataSource.append();
      expect(dataSource.notifier.isLoading, isFalse);
      expect(dataSource.notifier.value, isA<CenterWarning>());
    });

    test('append throwing exception should set error state', () async {
      dataSource.onLoad = (action) async {
        if (action is Append) throw Exception('thrown');
        return const Success(
          page: PageData(data: ['center'], prependKey: -1, appendKey: 1),
        );
      };
      await dataSource.refresh();
      await dataSource.append();
      expect(dataSource.notifier.isLoading, isFalse);
      expect(dataSource.notifier.value, isA<CenterWarning>());
    });

    test('append without appendPageKey should be a no-op', () async {
      dataSource.onLoad = (_) async => const Success(
        page: PageData(data: ['center'], prependKey: -1, appendKey: null),
      );
      await dataSource.refresh();
      await dataSource.append();
      expect(dataSource.notifier.value.appendItems, isEmpty);
    });

    test('calling append while loading should be a no-op', () async {
      final completer = Completer<LoadResult<int, String>>();
      dataSource.onLoad = (action) {
        if (action is Append) return completer.future;
        return Future.value(
          const Success(
            page: PageData(data: ['center'], prependKey: -1, appendKey: 1),
          ),
        );
      };

      await dataSource.refresh();
      final future = dataSource.append();
      expect(dataSource.notifier.isLoading, isTrue);

      // This call should do nothing
      await dataSource.append();

      completer.complete(const None());
      await future;
    });

    test('multiple appends move data correctly', () async {
      // First append
      await dataSource.append();
      expect(dataSource.notifier.value.centerItems, ['center1', 'center2']);
      expect(dataSource.notifier.value.appendItems, ['append1']);

      // Second append: previous appendPages should move to centerPages
      await dataSource.append();
      expect(dataSource.notifier.value.centerItems, [
        'center1',
        'center2',
        'append1',
      ]);
      expect(dataSource.notifier.value.appendItems, ['append2']);
      expect(dataSource.notifier.value.allItems, [
        'center1',
        'center2',
        'append1',
        'append2',
      ]);
    });
  });

  group('Combined operations', () {
    test('prepend and append work together correctly', () async {
      await dataSource.refresh();

      // Prepend
      await dataSource.prepend();
      expect(dataSource.notifier.value.prependItems, ['prepend-1']);
      expect(dataSource.notifier.value.centerItems, ['center1', 'center2']);
      expect(dataSource.notifier.value.appendItems, isEmpty);

      // Append
      await dataSource.append();
      expect(dataSource.notifier.value.prependItems, ['prepend-1']);
      expect(dataSource.notifier.value.centerItems, ['center1', 'center2']);
      expect(dataSource.notifier.value.appendItems, ['append1']);

      // All items in order
      expect(dataSource.notifier.value.allItems, [
        'prepend-1',
        'center1',
        'center2',
        'append1',
      ]);
    });

    test('refresh clears all segments', () async {
      await dataSource.refresh();
      await dataSource.prepend();
      await dataSource.append();

      expect(dataSource.notifier.value.prependItems, isNotEmpty);
      expect(dataSource.notifier.value.appendItems, isNotEmpty);

      await dataSource.refresh();

      expect(dataSource.notifier.value.prependItems, isEmpty);
      expect(dataSource.notifier.value.appendItems, isEmpty);
      expect(dataSource.notifier.value.centerItems, ['center1', 'center2']);
    });
  });

  group('CenterWarning state', () {
    test('CenterWarning extension getters return empty lists', () {
      final warning = CenterWarning<int, String>(
        error: Exception('test'),
        stackTrace: StackTrace.current,
      );
      expect(warning.prependPages, isEmpty);
      expect(warning.centerPages, isEmpty);
      expect(warning.appendPages, isEmpty);
      expect(warning.prependItems, isEmpty);
      expect(warning.centerItems, isEmpty);
      expect(warning.appendItems, isEmpty);
      expect(warning.allItems, isEmpty);
      expect(warning.prependPageKey, isNull);
      expect(warning.appendPageKey, isNull);
      expect(warning.isLoading, isFalse);
    });

    test('CenterWarning equality with different stackTraces', () {
      final error = Exception('test');
      final stackTrace1 = StackTrace.fromString('stack1');
      final stackTrace2 = StackTrace.fromString('stack2');

      final warning1 = CenterWarning<int, String>(
        error: error,
        stackTrace: stackTrace1,
      );
      final warning2 = CenterWarning<int, String>(
        error: error,
        stackTrace: stackTrace2,
      );
      final warning3 = CenterWarning<int, String>(
        error: error,
        stackTrace: stackTrace1,
      );

      expect(warning1 == warning2, isFalse);
      expect(warning1 == warning3, isTrue);
      expect(warning1.hashCode, warning3.hashCode);
    });

    test('CenterWarning toString', () {
      final error = Exception('test error');
      final stackTrace = StackTrace.fromString('test stack');
      final warning = CenterWarning<int, String>(
        error: error,
        stackTrace: stackTrace,
      );
      expect(
        warning.toString(),
        'CenterWarning(error: $error, stackTrace: $stackTrace)',
      );
    });
  });

  group('Error Recovery', () {
    test(
      'refresh with .ignoreRefresh keeps previous data on exception',
      () async {
        LoadResult<int, String>? capturedResult;
        LoadAction<int>? capturedAction;
        final dataSource = TestCenterDataSource(
          errorPolicy: {LoadErrorPolicy.ignoreRefresh},
        );
        await dataSource.refresh(); // Initial load
        dataSource.onLoadFinished = (action, result) {
          capturedAction = action;
          capturedResult = result;
        };
        expect(dataSource.notifier.value.centerItems, ['center1', 'center2']);

        // Cause an exception
        final error = Exception('Refresh failed');
        dataSource.onLoad = (_) => throw error;

        await dataSource.refresh();

        // Check that the state is still Loaded with previous data
        final state = dataSource.notifier.value;
        expect(state, isA<CenterPaging>());
        expect((state as CenterPaging).state, isA<LoadStateLoaded>());
        expect(state.centerItems, ['center1', 'center2']);

        // Verify callback was invoked with Failure
        expect(capturedAction, isA<Refresh>());
        expect(capturedResult, isA<Failure>());
        expect((capturedResult as Failure).error, error);

        dataSource.dispose();
      },
    );

    test(
      'refresh with .ignoreRefresh keeps previous data on Failure',
      () async {
        final dataSource = TestCenterDataSource(
          errorPolicy: {LoadErrorPolicy.ignoreRefresh},
        );
        await dataSource.refresh(); // Initial load

        dataSource.onLoad = (action) async {
          if (action is Refresh) {
            return Failure(error: Exception('Refresh failed'));
          }
          return const Success(
            page: PageData(
              data: ['center1', 'center2'],
              prependKey: -1,
              appendKey: 1,
            ),
          );
        };

        await dataSource.refresh();

        // Check that the state is still Loaded with previous data
        final state = dataSource.notifier.value;
        expect(state, isA<CenterPaging>());
        expect((state as CenterPaging).state, isA<LoadStateLoaded>());
        expect(state.centerItems, ['center1', 'center2']);

        dataSource.dispose();
      },
    );

    test(
      'prepend with .ignorePrepend reverts to loaded state on exception',
      () async {
        LoadAction<int>? capturedAction;
        LoadResult<int, String>? capturedResult;
        final dataSource = TestCenterDataSource(
          errorPolicy: {LoadErrorPolicy.ignorePrepend},
        );
        await dataSource.refresh();
        dataSource.onLoadFinished = (action, result) {
          capturedAction = action;
          capturedResult = result;
        };
        expect(dataSource.notifier.value.centerItems, ['center1', 'center2']);

        // Cause an exception on prepend
        final error = Exception('Prepend failed');
        dataSource.onLoad = (action) async {
          if (action is Prepend) {
            throw error;
          }
          return const Success(
            page: PageData(
              data: ['center1', 'center2'],
              prependKey: -1,
              appendKey: 1,
            ),
          );
        };

        await dataSource.prepend();

        // Check that the state is still Loaded with previous data
        final state = dataSource.notifier.value;
        expect(state, isA<CenterPaging>());
        expect((state as CenterPaging).state, isA<LoadStateLoaded>());
        expect(state.prependItems, isEmpty);
        expect(state.centerItems, ['center1', 'center2']);

        // Verify callback was invoked
        expect(capturedAction, isA<Prepend>());
        expect(capturedResult, isA<Failure>());
        expect((capturedResult as Failure).error, error);

        dataSource.dispose();
      },
    );

    test(
      'prepend with .ignorePrepend reverts to loaded state on Failure',
      () async {
        final dataSource = TestCenterDataSource(
          errorPolicy: {LoadErrorPolicy.ignorePrepend},
        );
        await dataSource.refresh();

        dataSource.onLoad = (action) async {
          if (action is Prepend) {
            return Failure(error: Exception('Prepend failed'));
          }
          return const Success(
            page: PageData(
              data: ['center1', 'center2'],
              prependKey: -1,
              appendKey: 1,
            ),
          );
        };

        await dataSource.prepend();

        final state = dataSource.notifier.value;
        expect(state, isA<CenterPaging>());
        expect((state as CenterPaging).state, isA<LoadStateLoaded>());
        expect(state.prependItems, isEmpty);
        expect(state.centerItems, ['center1', 'center2']);

        dataSource.dispose();
      },
    );

    test(
      'append with .ignoreAppend reverts to loaded state on exception',
      () async {
        LoadAction<int>? capturedAction;
        LoadResult<int, String>? capturedResult;
        final dataSource = TestCenterDataSource(
          errorPolicy: {LoadErrorPolicy.ignoreAppend},
        );
        await dataSource.refresh();
        dataSource.onLoadFinished = (action, result) {
          capturedAction = action;
          capturedResult = result;
        };
        expect(dataSource.notifier.value.centerItems, ['center1', 'center2']);

        // Cause an exception on append
        final error = Exception('Append failed');
        dataSource.onLoad = (action) async {
          if (action is Append) {
            throw error;
          }
          return const Success(
            page: PageData(
              data: ['center1', 'center2'],
              prependKey: -1,
              appendKey: 1,
            ),
          );
        };

        await dataSource.append();

        // Check that the state is still Loaded with previous data
        final state = dataSource.notifier.value;
        expect(state, isA<CenterPaging>());
        expect((state as CenterPaging).state, isA<LoadStateLoaded>());
        expect(state.appendItems, isEmpty);
        expect(state.centerItems, ['center1', 'center2']);

        // Verify callback was invoked
        expect(capturedAction, isA<Append>());
        expect(capturedResult, isA<Failure>());
        expect((capturedResult as Failure).error, error);

        dataSource.dispose();
      },
    );

    test(
      'append with .ignoreAppend reverts to loaded state on Failure',
      () async {
        final dataSource = TestCenterDataSource(
          errorPolicy: {LoadErrorPolicy.ignoreAppend},
        );
        await dataSource.refresh();

        dataSource.onLoad = (action) async {
          if (action is Append) {
            return Failure(error: Exception('Append failed'));
          }
          return const Success(
            page: PageData(
              data: ['center1', 'center2'],
              prependKey: -1,
              appendKey: 1,
            ),
          );
        };

        await dataSource.append();

        final state = dataSource.notifier.value;
        expect(state, isA<CenterPaging>());
        expect((state as CenterPaging).state, isA<LoadStateLoaded>());
        expect(state.appendItems, isEmpty);
        expect(state.centerItems, ['center1', 'center2']);

        dataSource.dispose();
      },
    );

    test(
      'default errorPolicy mode sets CenterWarning state on failure (init)',
      () async {
        LoadResult<int, String>? capturedResult;
        LoadAction<int>? capturedAction;
        final dataSource = TestCenterDataSource();
        dataSource.onLoadFinished = (action, result) {
          capturedAction = action;
          capturedResult = result;
        };

        final error = Exception('Init failed');
        dataSource.onLoad = (_) async => Failure(error: error);

        await dataSource.update(LoadType.init);

        final state = dataSource.notifier.value;
        expect(state, isA<CenterWarning>());
        expect((state as CenterWarning).error, error);

        expect(capturedAction, isA<Refresh>());
        expect(capturedResult, isA<Failure>());

        dataSource.dispose();
      },
    );

    test(
      'default errorPolicy mode sets CenterWarning state on failure (refresh)',
      () async {
        LoadResult<int, String>? capturedResult;
        LoadAction<int>? capturedAction;
        final dataSource = TestCenterDataSource();
        await dataSource.refresh();
        dataSource.onLoadFinished = (action, result) {
          capturedAction = action;
          capturedResult = result;
        };

        final error = Exception('Refresh failed');
        dataSource.onLoad = (_) async => Failure(error: error);

        await dataSource.refresh();

        final state = dataSource.notifier.value;
        expect(state, isA<CenterWarning>());
        expect((state as CenterWarning).error, error);

        expect(capturedAction, isA<Refresh>());
        expect(capturedResult, isA<Failure>());

        dataSource.dispose();
      },
    );

    test(
      'default errorPolicy mode sets CenterWarning state on failure (prepend)',
      () async {
        LoadResult<int, String>? capturedResult;
        LoadAction<int>? capturedAction;
        final dataSource = TestCenterDataSource();
        await dataSource.refresh();
        dataSource.onLoadFinished = (action, result) {
          capturedAction = action;
          capturedResult = result;
        };

        final error = Exception('Prepend failed');
        dataSource.onLoad = (action) async {
          if (action is Prepend) {
            return Failure(error: error);
          }
          return const Success(
            page: PageData(
              data: ['center1', 'center2'],
              prependKey: -1,
              appendKey: 1,
            ),
          );
        };

        await dataSource.prepend();

        final state = dataSource.notifier.value;
        expect(state, isA<CenterWarning>());
        expect((state as CenterWarning).error, error);

        expect(capturedAction, isA<Prepend>());
        expect(capturedResult, isA<Failure>());

        dataSource.dispose();
      },
    );

    test(
      'default errorPolicy mode sets CenterWarning state on failure (append)',
      () async {
        LoadResult<int, String>? capturedResult;
        LoadAction<int>? capturedAction;
        final dataSource = TestCenterDataSource();
        await dataSource.refresh();
        dataSource.onLoadFinished = (action, result) {
          capturedAction = action;
          capturedResult = result;
        };

        final error = Exception('Append failed');
        dataSource.onLoad = (action) async {
          if (action is Append) {
            return Failure(error: error);
          }
          return const Success(
            page: PageData(
              data: ['center1', 'center2'],
              prependKey: -1,
              appendKey: 1,
            ),
          );
        };

        await dataSource.append();

        final state = dataSource.notifier.value;
        expect(state, isA<CenterWarning>());
        expect((state as CenterWarning).error, error);

        expect(capturedAction, isA<Append>());
        expect(capturedResult, isA<Failure>());

        dataSource.dispose();
      },
    );
  });

  group('Runtime errorPolicy Mutation', () {
    test(
      'add ignoreRefresh prevents CenterWarning on subsequent failure',
      () async {
        final dataSource = TestCenterDataSource();
        // Initial successful load
        await dataSource.refresh();
        expect(dataSource.notifier.value.centerItems, isNotEmpty);

        // Fail refresh without policy -> CenterWarning
        dataSource.onLoad = (action) async {
          if (action is Refresh) {
            return Failure(error: Exception('Fail'));
          }
          return const Success(
            page: PageData(
              data: ['center1', 'center2'],
              prependKey: -1,
              appendKey: 1,
            ),
          );
        };
        await dataSource.refresh();
        expect(dataSource.notifier.value, isA<CenterWarning>());

        // Recover with a successful refresh so we have a loaded state again
        dataSource.onLoad = (action) async => const Success(
          page: PageData(
            data: ['center1', 'center2'],
            prependKey: -1,
            appendKey: 1,
          ),
        );
        await dataSource.refresh();
        final loadedState = dataSource.notifier.value;
        expect(loadedState, isA<CenterPaging>());
        expect((loadedState as CenterPaging).state, isA<LoadStateLoaded>());

        // Mutate errorPolicy at runtime to ignore refresh failures
        dataSource.errorPolicy = {LoadErrorPolicy.ignoreRefresh};
        // Cause a refresh failure again
        dataSource.onLoad = (action) async {
          if (action is Refresh) {
            return Failure(error: Exception('Fail'));
          }
          return const Success(
            page: PageData(
              data: ['center1', 'center2'],
              prependKey: -1,
              appendKey: 1,
            ),
          );
        };
        await dataSource.refresh();

        // Should remain loaded with previous data, not CenterWarning
        final stateAfterFailure = dataSource.notifier.value;
        expect(stateAfterFailure, isA<CenterPaging>());
        expect(
          (stateAfterFailure as CenterPaging).state,
          isA<LoadStateLoaded>(),
        );
        expect(stateAfterFailure.centerItems, ['center1', 'center2']);
        dataSource.dispose();
      },
    );

    test('toggle ignoreAppend affects failure handling', () async {
      final dataSource = TestCenterDataSource();
      // Initial load
      dataSource.onLoad = (action) async => const Success(
        page: PageData(
          data: ['center1', 'center2'],
          prependKey: -1,
          appendKey: 1,
        ),
      );
      await dataSource.refresh();

      // Failure without ignoreAppend -> CenterWarning
      dataSource.onLoad = (action) async {
        if (action is Append) {
          return Failure(error: Exception('Fail'));
        }
        return const Success(
          page: PageData(
            data: ['center1', 'center2'],
            prependKey: -1,
            appendKey: 1,
          ),
        );
      };
      await dataSource.append();
      expect(dataSource.notifier.value, isA<CenterWarning>());

      // Recover to loaded state
      dataSource.onLoad = (action) async => const Success(
        page: PageData(
          data: ['center1', 'center2'],
          prependKey: -1,
          appendKey: 2,
        ),
      );
      await dataSource.refresh();
      expect(dataSource.notifier.value.centerItems, ['center1', 'center2']);

      // Enable ignoreAppend
      dataSource.errorPolicy = {LoadErrorPolicy.ignoreAppend};
      // Trigger append failure again
      dataSource.onLoad = (action) async {
        if (action is Append) {
          return Failure(error: Exception('Fail'));
        }
        return const Success(
          page: PageData(
            data: ['center1', 'center2'],
            prependKey: -1,
            appendKey: 2,
          ),
        );
      };
      await dataSource.append();

      // Should stay loaded with previous values
      final stateAfterFailure = dataSource.notifier.value;
      expect(stateAfterFailure, isA<CenterPaging>());
      expect((stateAfterFailure as CenterPaging).state, isA<LoadStateLoaded>());
      expect(stateAfterFailure.centerItems, ['center1', 'center2']);

      // Disable ignoreAppend and fail again -> CenterWarning
      dataSource.errorPolicy = {};
      await dataSource.append();
      expect(dataSource.notifier.value, isA<CenterWarning>());
      dataSource.dispose();
    });

    test('toggle ignorePrepend affects failure handling', () async {
      final dataSource = TestCenterDataSource();
      // Initial load
      dataSource.onLoad = (action) async => const Success(
        page: PageData(
          data: ['center1', 'center2'],
          prependKey: -1,
          appendKey: 1,
        ),
      );
      await dataSource.refresh();

      // Failure without ignorePrepend -> CenterWarning
      dataSource.onLoad = (action) async {
        if (action is Prepend) {
          return Failure(error: Exception('Fail'));
        }
        return const Success(
          page: PageData(
            data: ['center1', 'center2'],
            prependKey: -1,
            appendKey: 1,
          ),
        );
      };
      await dataSource.prepend();
      expect(dataSource.notifier.value, isA<CenterWarning>());

      // Recover to loaded state
      dataSource.onLoad = (action) async => const Success(
        page: PageData(
          data: ['center1', 'center2'],
          prependKey: -2,
          appendKey: 1,
        ),
      );
      await dataSource.refresh();
      expect(dataSource.notifier.value.centerItems, ['center1', 'center2']);

      // Enable ignorePrepend
      dataSource.errorPolicy = {LoadErrorPolicy.ignorePrepend};
      // Trigger prepend failure again
      dataSource.onLoad = (action) async {
        if (action is Prepend) {
          return Failure(error: Exception('Fail'));
        }
        return const Success(
          page: PageData(
            data: ['center1', 'center2'],
            prependKey: -2,
            appendKey: 1,
          ),
        );
      };
      await dataSource.prepend();

      // Should stay loaded with previous values
      final stateAfterFailure = dataSource.notifier.value;
      expect(stateAfterFailure, isA<CenterPaging>());
      expect((stateAfterFailure as CenterPaging).state, isA<LoadStateLoaded>());
      expect(stateAfterFailure.centerItems, ['center1', 'center2']);

      // Disable ignorePrepend and fail again -> CenterWarning
      dataSource.errorPolicy = {};
      await dataSource.prepend();
      expect(dataSource.notifier.value, isA<CenterWarning>());
      dataSource.dispose();
    });
  });

  group('onLoadFinished callback', () {
    test('onLoadFinished should be called on successful refresh', () async {
      LoadAction<int>? capturedAction;
      LoadResult<int, String>? capturedResult;

      dataSource.onLoadFinished = (action, result) {
        capturedAction = action;
        capturedResult = result;
      };

      await dataSource.refresh();

      expect(capturedAction, isA<Refresh>());
      expect(capturedResult, isA<Success>());
      expect((capturedResult as Success).page.data, ['center1', 'center2']);
    });

    test('onLoadFinished should be called on refresh failure', () async {
      LoadAction<int>? capturedAction;
      LoadResult<int, String>? capturedResult;

      final error = Exception('Test Error');
      dataSource.onLoad = (_) async => Failure(error: error);
      dataSource.onLoadFinished = (action, result) {
        capturedAction = action;
        capturedResult = result;
      };

      await dataSource.refresh();

      expect(capturedAction, isA<Refresh>());
      expect(capturedResult, isA<Failure>());
      expect((capturedResult as Failure).error, error);
    });

    test('onLoadFinished should be called on prepend', () async {
      await dataSource.refresh();

      LoadAction<int>? capturedAction;
      LoadResult<int, String>? capturedResult;

      dataSource.onLoadFinished = (action, result) {
        capturedAction = action;
        capturedResult = result;
      };

      await dataSource.prepend();

      expect(capturedAction, isA<Prepend>());
      expect((capturedAction as Prepend).key, -1);
      expect(capturedResult, isA<Success>());
    });

    test('onLoadFinished should be called on append', () async {
      await dataSource.refresh();

      LoadAction<int>? capturedAction;
      LoadResult<int, String>? capturedResult;

      dataSource.onLoadFinished = (action, result) {
        capturedAction = action;
        capturedResult = result;
      };

      await dataSource.append();

      expect(capturedAction, isA<Append>());
      expect((capturedAction as Append).key, 1);
      expect(capturedResult, isA<Success>());
    });

    test('onLoadFinished should be called when exception is thrown', () async {
      LoadAction<int>? capturedAction;
      LoadResult<int, String>? capturedResult;

      final error = Exception('Thrown Error');
      dataSource.onLoad = (_) => throw error;
      dataSource.onLoadFinished = (action, result) {
        capturedAction = action;
        capturedResult = result;
      };

      await dataSource.refresh();

      expect(capturedAction, isA<Refresh>());
      expect(capturedResult, isA<Failure>());
      expect((capturedResult as Failure).error, error);
    });

    test('onLoadFinished should be cleared on dispose', () {
      final testDataSource = TestCenterDataSource();
      var callCount = 0;
      testDataSource.onLoadFinished = (_, _) => callCount++;

      expect(testDataSource.onLoadFinished, isNotNull);
      testDataSource.dispose();
      expect(testDataSource.onLoadFinished, isNull);
    });
  });

  group('onLoadStarted callback', () {
    test('onLoadStarted should be called on successful refresh', () async {
      var callCount = 0;
      LoadAction<int>? capturedAction;
      dataSource.onLoadStarted = (action) {
        callCount++;
        capturedAction = action;
      };

      await dataSource.refresh();

      expect(callCount, 1);
      expect(capturedAction, isA<Refresh>());
    });

    test('onLoadStarted should be called on refresh failure', () async {
      dataSource.onLoad = (_) async => Failure(error: Exception('Failure'));

      var callCount = 0;
      LoadAction<int>? capturedAction;
      dataSource.onLoadStarted = (action) {
        callCount++;
        capturedAction = action;
      };

      await dataSource.refresh();

      expect(callCount, 1);
      expect(capturedAction, isA<Refresh>());
    });

    test('onLoadStarted should be called on prepend', () async {
      await dataSource.refresh();

      var callCount = 0;
      LoadAction<int>? capturedAction;
      dataSource.onLoadStarted = (action) {
        callCount++;
        capturedAction = action;
      };

      await dataSource.prepend();

      expect(callCount, 1);
      expect(capturedAction, isA<Prepend>());
      expect((capturedAction as Prepend).key, -1);
    });

    test('onLoadStarted should be called on append', () async {
      await dataSource.refresh();

      var callCount = 0;
      LoadAction<int>? capturedAction;
      dataSource.onLoadStarted = (action) {
        callCount++;
        capturedAction = action;
      };

      await dataSource.append();

      expect(callCount, 1);
      expect(capturedAction, isA<Append>());
      expect((capturedAction as Append).key, 1);
    });

    test('onLoadStarted should be cleared on dispose', () {
      final testDataSource = TestCenterDataSource();
      var callCount = 0;
      testDataSource.onLoadStarted = (_) => callCount++;
      expect(testDataSource.onLoadStarted, isNotNull);
      testDataSource.dispose();
      expect(testDataSource.onLoadStarted, isNull);
    });
  });
}

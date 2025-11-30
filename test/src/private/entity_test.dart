import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';

void main() {
  group('LoadState', () {
    group('LoadStateInit', () {
      const state = LoadStateInit();
      test('should have correct properties', () {
        expect(state.isInit, isTrue);
        expect(state.isLoaded, isFalse);
        expect(state.isInitLoading, isFalse);
        expect(state.isRefreshLoading, isFalse);
        expect(state.isPrependLoading, isFalse);
        expect(state.isAppendLoading, isFalse);
      });

      test('should have correct toString() representation', () {
        expect(state.toString(), 'LoadStateInit()');
      });
    });

    group('LoadStateLoaded', () {
      const state = LoadStateLoaded();
      test('should have correct properties', () {
        expect(state.isInit, isFalse);
        expect(state.isLoaded, isTrue);
        expect(state.isInitLoading, isFalse);
        expect(state.isRefreshLoading, isFalse);
        expect(state.isPrependLoading, isFalse);
        expect(state.isAppendLoading, isFalse);
      });

      test('should have correct toString() representation', () {
        expect(state.toString(), 'LoadStateLoaded()');
      });
    });

    group('LoadStateLoading', () {
      test('with LoadType.init should have correct properties', () {
        const state = LoadStateLoading(state: LoadType.init);
        expect(state.isInit, isFalse);
        expect(state.isLoaded, isFalse);
        expect(state.isInitLoading, isTrue);
        expect(state.isRefreshLoading, isFalse);
        expect(state.isPrependLoading, isFalse);
        expect(state.isAppendLoading, isFalse);
        expect(state.toString(), 'LoadStateLoading(state: LoadType.init)');
      });

      test('with LoadType.refresh should have correct properties', () {
        const state = LoadStateLoading(state: LoadType.refresh);
        expect(state.isInitLoading, isFalse);
        expect(state.isRefreshLoading, isTrue);
        expect(state.isPrependLoading, isFalse);
        expect(state.isAppendLoading, isFalse);
        expect(state.toString(), 'LoadStateLoading(state: LoadType.refresh)');
      });

      test('with LoadType.prepend should have correct properties', () {
        const state = LoadStateLoading(state: LoadType.prepend);
        expect(state.isInitLoading, isFalse);
        expect(state.isRefreshLoading, isFalse);
        expect(state.isPrependLoading, isTrue);
        expect(state.isAppendLoading, isFalse);
        expect(state.toString(), 'LoadStateLoading(state: LoadType.prepend)');
      });

      test('with LoadType.append should have correct properties', () {
        const state = LoadStateLoading(state: LoadType.append);
        expect(state.isInitLoading, isFalse);
        expect(state.isRefreshLoading, isFalse);
        expect(state.isPrependLoading, isFalse);
        expect(state.isAppendLoading, isTrue);
        expect(state.toString(), 'LoadStateLoading(state: LoadType.append)');
      });
    });
  });

  group('PageManagerState', () {
    group('Paging', () {
      final page1 = PageData<int, String>(
        data: ['a', 'b'],
        prependKey: 0,
        appendKey: 2,
      );
      final page2 = PageData<int, String>(
        data: ['c', 'd'],
        prependKey: 1,
        appendKey: 3,
      );

      test('init() factory should create an initial Paging state', () {
        final paging = Paging<int, String>.init();
        expect(paging.state, isA<LoadStateInit>());
        expect(paging.data, isEmpty);
      });

      test('should have correct toString() representation', () {
        final paging = Paging(state: const LoadStateLoaded(), data: [page1]);
        expect(
          paging.toString(),
          'Paging(state: $LoadStateLoaded(), data: [$page1])',
        );
      });

      test('should be equal if state and data are equal', () {
        final paging1 = Paging(state: const LoadStateLoaded(), data: [page1]);
        final paging2 = Paging(state: const LoadStateLoaded(), data: [page1]);
        expect(paging1, equals(paging2));
        expect(paging1.hashCode, equals(paging2.hashCode));
      });

      test('should not be equal if state is different', () {
        final paging1 = Paging(state: const LoadStateLoaded(), data: [page1]);
        final paging2 = Paging(state: const LoadStateInit(), data: [page1]);
        expect(paging1, isNot(equals(paging2)));
        expect(paging1.hashCode, isNot(equals(paging2.hashCode)));
      });

      test('should not be equal if data is different', () {
        final paging1 = Paging(state: const LoadStateLoaded(), data: [page1]);
        final paging2 = Paging(state: const LoadStateLoaded(), data: [page2]);
        expect(paging1, isNot(equals(paging2)));
        expect(paging1.hashCode, isNot(equals(paging2.hashCode)));
      });

      test('should not be equal if data order is different', () {
        final paging1 = Paging(
          state: const LoadStateLoaded(),
          data: [page1, page2],
        );
        final paging2 = Paging(
          state: const LoadStateLoaded(),
          data: [page2, page1],
        );
        expect(paging1, isNot(equals(paging2)));
        expect(paging1.hashCode, isNot(equals(paging2.hashCode)));
      });
    });

    group('Warning', () {
      final error = Exception('Test Error');
      final stackTrace = StackTrace.current;

      test('should have correct toString() representation', () {
        final warning = Warning<int, String>(
          error: error,
          stackTrace: stackTrace,
        );
        expect(
          warning.toString(),
          'Warning(error: $error, stackTrace: $stackTrace)',
        );
      });

      test('should be equal if error and stackTrace are equal', () {
        final warning1 = Warning<int, String>(
          error: error,
          stackTrace: stackTrace,
        );
        final warning2 = Warning<int, String>(
          error: error,
          stackTrace: stackTrace,
        );
        expect(warning1, equals(warning2));
        expect(warning1.hashCode, equals(warning2.hashCode));
      });

      test('should not be equal if error is different', () {
        final warning1 = Warning<int, String>(
          error: error,
          stackTrace: stackTrace,
        );
        final warning2 = Warning<int, String>(
          error: Exception('Other Error'),
          stackTrace: stackTrace,
        );
        expect(warning1, isNot(equals(warning2)));
      });

      test('should not be equal if stackTrace is different', () {
        final warning1 = Warning<int, String>(
          error: error,
          stackTrace: stackTrace,
        );
        final warning2 = Warning<int, String>(error: error, stackTrace: null);
        expect(warning1, isNot(equals(warning2)));
      });
    });
  });

  group('PagingStateExt', () {
    final page1 = PageData<int, String>(
      data: ['a', 'b'],
      prependKey: 0,
      appendKey: 2,
    );
    final page2 = PageData<int, String>(
      data: ['c', 'd'],
      prependKey: 1,
      appendKey: 3,
    );
    final error = Exception('Test Error');

    test('isLoading should be true for any loading state', () {
      expect(
        Paging<int, String>(
          state: const LoadStateLoading(state: LoadType.init),
          data: [],
        ).isLoading,
        isTrue,
      );
      expect(
        Paging<int, String>(
          state: const LoadStateLoading(state: LoadType.refresh),
          data: [],
        ).isLoading,
        isTrue,
      );
      expect(
        Paging<int, String>(
          state: const LoadStateLoading(state: LoadType.prepend),
          data: [],
        ).isLoading,
        isTrue,
      );
      expect(
        Paging<int, String>(
          state: const LoadStateLoading(state: LoadType.append),
          data: [],
        ).isLoading,
        isTrue,
      );
    });

    test('isLoading should be false for non-loading states', () {
      expect(
        Paging<int, String>(state: const LoadStateInit(), data: []).isLoading,
        isFalse,
      );
      expect(
        Paging<int, String>(state: const LoadStateLoaded(), data: []).isLoading,
        isFalse,
      );
      expect(
        Warning<int, String>(error: error, stackTrace: null).isLoading,
        isFalse,
      );
    });

    test('prependPageKey should return the prependKey of the first page', () {
      final state = Paging<int, String>(
        state: const LoadStateLoaded(),
        data: [page1, page2],
      );
      expect(state.prependPageKey, 0);
    });

    test('prependPageKey should return null if there are no pages', () {
      final state = Paging<int, String>.init();
      expect(state.prependPageKey, isNull);
    });

    test('appendPageKey should return the appendKey of the last page', () {
      final state = Paging<int, String>(
        state: const LoadStateLoaded(),
        data: [page1, page2],
      );
      expect(state.appendPageKey, 3);
    });

    test('appendPageKey should return null if there are no pages', () {
      final state = Paging<int, String>.init();
      expect(state.appendPageKey, isNull);
    });

    test('pages should return the list of pages for Paging state', () {
      final state = Paging<int, String>(
        state: const LoadStateLoaded(),
        data: [page1, page2],
      );
      expect(state.pages, [page1, page2]);
    });

    test('pages should return an empty list for Warning state', () {
      final state = Warning<int, String>(error: error, stackTrace: null);
      expect(state.pages, isEmpty);
    });

    test('items should return a flattened list of all items in pages', () {
      final state = Paging<int, String>(
        state: const LoadStateLoaded(),
        data: [page1, page2],
      );
      expect(state.items, ['a', 'b', 'c', 'd']);
    });

    test('items should return an empty list if there are no pages', () {
      final state = Paging<int, String>.init();
      expect(state.items, isEmpty);
    });

    test('items should return an empty list for Warning state', () {
      final state = Warning<int, String>(error: error, stackTrace: null);
      expect(state.items, isEmpty);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/entity.dart';

void main() {
  group('PageData', () {
    test('creates empty PageData with default values', () {
      const pageData = PageData<int, String>();

      expect(pageData.data, isEmpty);
      expect(pageData.prependKey, isNull);
      expect(pageData.appendKey, isNull);
    });

    test('creates PageData with data', () {
      const pageData = PageData<int, String>(
        data: ['a', 'b', 'c'],
        prependKey: 1,
        appendKey: 2,
      );

      expect(pageData.data, ['a', 'b', 'c']);
      expect(pageData.prependKey, 1);
      expect(pageData.appendKey, 2);
    });

    test('equality works correctly', () {
      const pageData1 = PageData<int, String>(
        data: ['a', 'b'],
        prependKey: 1,
        appendKey: 2,
      );
      const pageData2 = PageData<int, String>(
        data: ['a', 'b'],
        prependKey: 1,
        appendKey: 2,
      );
      const pageData3 = PageData<int, String>(
        data: ['a', 'b', 'c'],
        prependKey: 1,
        appendKey: 2,
      );

      expect(pageData1, equals(pageData2));
      expect(pageData1, isNot(equals(pageData3)));
    });

    test('hashCode works correctly', () {
      const pageData1 = PageData<int, String>(
        data: ['a', 'b'],
        prependKey: 1,
        appendKey: 2,
      );
      const pageData2 = PageData<int, String>(
        data: ['a', 'b'],
        prependKey: 1,
        appendKey: 2,
      );

      expect(pageData1.hashCode, equals(pageData2.hashCode));
    });

    test('toString returns correct string representation', () {
      const pageData = PageData<int, String>(
        data: ['a', 'b'],
        prependKey: 1,
        appendKey: 2,
      );

      expect(
        pageData.toString(),
        "PageData(data: [a, b], prependKey: 1, appendKey: 2)",
      );
    });
  });

  group('LoadAction', () {
    test('Refresh is created correctly', () {
      const refresh = Refresh<int>();
      expect(refresh, isA<LoadAction<int>>());
      expect(refresh, isA<Refresh<int>>());
    });

    test('Prepend is created with key', () {
      const prepend = Prepend<int>(key: 42);
      expect(prepend, isA<LoadAction<int>>());
      expect(prepend, isA<Prepend<int>>());
      expect(prepend.key, 42);
    });

    test('Append is created with key', () {
      const append = Append<int>(key: 99);
      expect(append, isA<LoadAction<int>>());
      expect(append, isA<Append<int>>());
      expect(append.key, 99);
    });
  });

  group('LoadResult', () {
    test('Success is created with page data', () {
      const page = PageData<int, String>(data: ['a', 'b']);
      const success = Success<int, String>(page: page);

      expect(success, isA<LoadResult<int, String>>());
      expect(success, isA<Success<int, String>>());
      expect(success.page, page);
    });

    test('Failure is created with error', () {
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;
      final failure = Failure<int, String>(
        error: error,
        stackTrace: stackTrace,
      );

      expect(failure, isA<LoadResult<int, String>>());
      expect(failure, isA<Failure<int, String>>());
      expect(failure.error, error);
      expect(failure.stackTrace, stackTrace);
    });

    test('Failure can be created without stackTrace', () {
      final error = Exception('Test error');
      final failure = Failure<int, String>(error: error);

      expect(failure.error, error);
      expect(failure.stackTrace, isNull);
    });

    test('None is created correctly', () {
      const none = None<int, String>();
      expect(none, isA<LoadResult<int, String>>());
      expect(none, isA<None<int, String>>());
    });
  });
}

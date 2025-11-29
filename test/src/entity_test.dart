import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/entity.dart';

void main() {
  group('LoadAction', () {
    test('Refresh action should be correctly identified', () {
      const action = Refresh<int>();
      expect(action, isA<LoadAction<int>>());
      expect(action, isA<Refresh<int>>());
    });

    test('Prepend action should hold the correct key', () {
      const action = Prepend<int>(key: 1);
      expect(action, isA<LoadAction<int>>());
      expect(action, isA<Prepend<int>>());
      expect(action.key, 1);
    });

    test('Append action should hold the correct key', () {
      const action = Append<int>(key: 10);
      expect(action, isA<LoadAction<int>>());
      expect(action, isA<Append<int>>());
      expect(action.key, 10);
    });
  });

  group('PageData', () {
    test('should be created with default empty list and null keys', () {
      const page = PageData<int, String>();
      expect(page.data, isEmpty);
      expect(page.prependKey, isNull);
      expect(page.appendKey, isNull);
    });

    test('should hold provided data and keys', () {
      const page = PageData<int, String>(
        data: ['item1', 'item2'],
        prependKey: 1,
        appendKey: 3,
      );
      expect(page.data, ['item1', 'item2']);
      expect(page.prependKey, 1);
      expect(page.appendKey, 3);
    });

    test('== operator should compare value equality', () {
      const page1 = PageData<int, String>(
        data: ['item1'],
        prependKey: 1,
        appendKey: 2,
      );
      const page2 = PageData<int, String>(
        data: ['item1'],
        prependKey: 1,
        appendKey: 2,
      );
      const page3 = PageData<int, String>(
        data: ['item2'],
        prependKey: 1,
        appendKey: 2,
      );
      const page4 = PageData<int, String>(
        data: ['item1'],
        prependKey: 0,
        appendKey: 2,
      );
      const page5 = PageData<int, String>(
        data: ['item1'],
        prependKey: 1,
        appendKey: 3,
      );

      expect(page1 == page2, isTrue);
      expect(page1 == page3, isFalse);
      expect(page1 == page4, isFalse);
      expect(page1 == page5, isFalse);
    });

    test('hashCode should be consistent with == operator', () {
      const page1 = PageData<int, String>(
        data: ['item1'],
        prependKey: 1,
        appendKey: 2,
      );
      const page2 = PageData<int, String>(
        data: ['item1'],
        prependKey: 1,
        appendKey: 2,
      );
      const page3 = PageData<int, String>(
        data: ['item2'],
        prependKey: 1,
        appendKey: 2,
      );

      expect(page1.hashCode, page2.hashCode);
      expect(page1.hashCode, isNot(page3.hashCode));
    });

    test('toString should return a readable string representation', () {
      const page = PageData<int, String>(
        data: ['a'],
        prependKey: 1,
        appendKey: 2,
      );
      expect(
        page.toString(),
        'PageData(data: [a], prependKey: 1, appendKey: 2)',
      );
    });
  });

  group('LoadResult', () {
    test('Success should contain page data', () {
      const page = PageData<int, String>(data: ['item']);
      const result = Success<int, String>(page: page);
      expect(result, isA<LoadResult<int, String>>());
      expect(result, isA<Success<int, String>>());
      expect(result.page, page);
    });

    test('Failure should contain error and optional stackTrace', () {
      final error = Exception('Network error');
      final stackTrace = StackTrace.current;
      final resultWithStackTrace =
          Failure<int, String>(error: error, stackTrace: stackTrace);
      final resultWithoutStackTrace = Failure<int, String>(error: error);

      expect(resultWithStackTrace, isA<LoadResult<int, String>>());
      expect(resultWithStackTrace, isA<Failure<int, String>>());
      expect(resultWithStackTrace.error, error);
      expect(resultWithStackTrace.stackTrace, stackTrace);

      expect(resultWithoutStackTrace.stackTrace, isNull);
    });

    test('None should represent an empty or unnecessary result', () {
      const result = None<int, String>();
      expect(result, isA<LoadResult<int, String>>());
      expect(result, isA<None<int, String>>());
    });
  });
}
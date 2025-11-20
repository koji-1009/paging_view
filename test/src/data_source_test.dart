import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/data_source.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';

class TestDataSource extends DataSource<int, String> {
  TestDataSource({this.onLoad, this.throwError = false});

  final Future<LoadResult<int, String>> Function(LoadAction<int> action)?
  onLoad;
  final bool throwError;

  @override
  Future<LoadResult<int, String>> load(LoadAction<int> action) async {
    if (throwError) {
      throw Exception('Load error');
    }

    if (onLoad != null) {
      return onLoad!(action);
    }

    // Default implementation
    switch (action) {
      case Refresh():
        return const Success(
          page: PageData(data: ['1', '2', '3'], appendKey: 2),
        );
      case Prepend(:final key):
        if (key <= 0) {
          return const None();
        }
        return Success(
          page: PageData(
            data: ['${key - 1}a', '${key - 1}b'],
            prependKey: key - 1,
            appendKey: key,
          ),
        );
      case Append(:final key):
        if (key >= 10) {
          return const None();
        }
        return Success(
          page: PageData(
            data: ['${key}a', '${key}b'],
            prependKey: key,
            appendKey: key + 1,
          ),
        );
    }
  }
}

void main() {
  group('DataSource', () {
    test('initial state is init', () {
      final dataSource = TestDataSource();

      expect(dataSource.notifier.value, isA<Paging<int, String>>());
      final state = dataSource.notifier.value as Paging<int, String>;
      expect(state.state, isA<LoadStateInit>());

      dataSource.dispose();
    });

    test('update with LoadType.init loads initial data', () async {
      final dataSource = TestDataSource();

      await dataSource.update(LoadType.init);

      expect(dataSource.notifier.value, isA<Paging<int, String>>());
      final state = dataSource.notifier.value as Paging<int, String>;
      expect(state.state, isA<LoadStateLoaded>());
      expect(dataSource.notifier.values, ['1', '2', '3']);

      dataSource.dispose();
    });

    test('dispose cleans up resources', () {
      final dataSource = TestDataSource();

      expect(() => dataSource.dispose(), returnsNormally);
    });

    test('updateItem updates single item', () async {
      final dataSource = TestDataSource();
      await dataSource.update(LoadType.init);

      dataSource.updateItem(1, (item) => item.toUpperCase());

      expect(dataSource.notifier.values, ['1', '2', '3']);
      dataSource.dispose();
    });

    test('updateItems updates all items with index', () async {
      final dataSource = TestDataSource();
      await dataSource.update(LoadType.init);

      dataSource.updateItems((index, item) => '$index:$item');

      expect(dataSource.notifier.values, ['0:1', '1:2', '2:3']);
      dataSource.dispose();
    });

    test('removeItem removes single item', () async {
      final dataSource = TestDataSource();
      await dataSource.update(LoadType.init);

      dataSource.removeItem(1);

      expect(dataSource.notifier.values, ['1', '3']);
      dataSource.dispose();
    });

    test('removeItems removes items matching condition', () async {
      final dataSource = TestDataSource();
      await dataSource.update(LoadType.init);

      dataSource.removeItems((index, item) => item == '2');

      expect(dataSource.notifier.values, ['1', '3']);
      dataSource.dispose();
    });

    test('insertItem inserts item at specified index', () async {
      final dataSource = TestDataSource();
      await dataSource.update(LoadType.init);

      dataSource.insertItem(1, 'x');

      expect(dataSource.notifier.values, ['1', 'x', '2', '3']);
      dataSource.dispose();
    });
  });
}

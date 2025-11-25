import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';
import 'package:paging_view/src/private/page_manager.dart';

void main() {
  group('PageManager', () {
    test('initial state is Paging.init', () {
      final manager = PageManager<int, String>();

      expect(manager.value, isA<Paging<int, String>>());
      final state = manager.value as Paging<int, String>;
      expect(state.state, isA<LoadStateInit>());
      expect(state.data, isEmpty);
    });

    test('isLoading returns correct value', () {
      final manager = PageManager<int, String>();
      expect(manager.isLoading, false);

      manager.changeState(type: LoadType.init);
      expect(manager.isLoading, true);
    });

    test('changeState updates state to loading', () {
      final manager = PageManager<int, String>();

      manager.changeState(type: LoadType.refresh);

      expect(manager.value, isA<Paging<int, String>>());
      final state = manager.value as Paging<int, String>;
      expect(state.state, isA<LoadStateLoading>());
      expect((state.state as LoadStateLoading).state, LoadType.refresh);
    });

    test('setError updates state to Warning', () {
      final manager = PageManager<int, String>();
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;

      manager.setError(error: error, stackTrace: stackTrace);

      expect(manager.value, isA<Warning<int, String>>());
      final state = manager.value as Warning<int, String>;
      expect(state.error, error);
      expect(state.stackTrace, stackTrace);
    });

    test('refresh with null replaces with empty data', () {
      final manager = PageManager<int, String>();

      manager.refresh(newPage: null);

      expect(manager.value, isA<Paging<int, String>>());
      final state = manager.value as Paging<int, String>;
      expect(state.state, isA<LoadStateLoaded>());
      expect(state.data, isEmpty);
    });

    test('refresh with page data replaces existing data', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b', 'c'], appendKey: 2);

      manager.refresh(newPage: page);

      expect(manager.value, isA<Paging<int, String>>());
      final state = manager.value as Paging<int, String>;
      expect(state.state, isA<LoadStateLoaded>());
      expect(state.data, [page]);
      expect(manager.values, ['a', 'b', 'c']);
    });

    test('append with null keeps existing data', () async {
      final manager = PageManager<int, String>();
      const page1 = PageData<int, String>(data: ['a', 'b']);
      manager.refresh(newPage: page1);

      await manager.append(newPage: null);

      expect(manager.value, isA<Paging<int, String>>());
      final state = manager.value as Paging<int, String>;
      expect(state.data, [page1]);
    });

    test('append adds page data to the end', () async {
      final manager = PageManager<int, String>();
      const page1 = PageData<int, String>(data: ['a', 'b'], appendKey: 2);
      const page2 = PageData<int, String>(data: ['c', 'd']);

      manager.refresh(newPage: page1);
      await manager.append(newPage: page2);

      expect(manager.value, isA<Paging<int, String>>());
      final state = manager.value as Paging<int, String>;
      expect(state.data, [page1, page2]);
      expect(manager.values, ['a', 'b', 'c', 'd']);
    });

    test('prepend with null keeps existing data', () async {
      final manager = PageManager<int, String>();
      const page1 = PageData<int, String>(data: ['a', 'b']);
      manager.refresh(newPage: page1);

      await manager.prepend(newPage: null);

      expect(manager.value, isA<Paging<int, String>>());
      final state = manager.value as Paging<int, String>;
      expect(state.data, [page1]);
    });

    test('prepend adds page data to the beginning', () async {
      final manager = PageManager<int, String>();
      const page1 = PageData<int, String>(data: ['c', 'd'], prependKey: 0);
      const page2 = PageData<int, String>(data: ['a', 'b']);

      manager.refresh(newPage: page1);
      await manager.prepend(newPage: page2);

      expect(manager.value, isA<Paging<int, String>>());
      final state = manager.value as Paging<int, String>;
      expect(state.data, [page2, page1]);
      expect(manager.values, ['a', 'b', 'c', 'd']);
    });

    test('updateItem updates item at specified index', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b', 'c']);
      manager.refresh(newPage: page);

      manager.updateItem(1, (item) => item.toUpperCase());

      expect(manager.values, ['a', 'B', 'c']);
    });

    test('updateItem works across multiple pages', () async {
      final manager = PageManager<int, String>();
      const page1 = PageData<int, String>(data: ['a', 'b'], appendKey: 2);
      const page2 = PageData<int, String>(data: ['c', 'd']);

      manager.refresh(newPage: page1);
      await manager.append(newPage: page2);

      manager.updateItem(2, (item) => item.toUpperCase());

      expect(manager.values, ['a', 'b', 'C', 'd']);
    });

    test('updateItem with invalid index sets error', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b']);
      manager.refresh(newPage: page);

      manager.updateItem(5, (item) => item.toUpperCase());

      expect(manager.value, isA<Warning<int, String>>());
      final state = manager.value as Warning<int, String>;
      expect(state.error, isA<RangeError>());
    });

    test('updateItem with negative index sets error', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b']);
      manager.refresh(newPage: page);

      manager.updateItem(-1, (item) => item.toUpperCase());

      expect(manager.value, isA<Warning<int, String>>());
      final state = manager.value as Warning<int, String>;
      expect(state.error, isA<RangeError>());
    });

    test('updateItem when update function throws sets error', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b']);
      manager.refresh(newPage: page);

      manager.updateItem(0, (item) => throw Exception('Update error'));

      expect(manager.value, isA<Warning<int, String>>());
      final state = manager.value as Warning<int, String>;
      expect(state.error, isA<Exception>());
    });

    test('updateItems updates all items with index', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b', 'c']);
      manager.refresh(newPage: page);

      manager.updateItems((index, item) => '$index:${item.toUpperCase()}');

      expect(manager.values, ['0:A', '1:B', '2:C']);
    });

    test('updateItems works across multiple pages', () async {
      final manager = PageManager<int, String>();
      const page1 = PageData<int, String>(data: ['a', 'b'], appendKey: 2);
      const page2 = PageData<int, String>(data: ['c', 'd']);

      manager.refresh(newPage: page1);
      await manager.append(newPage: page2);

      manager.updateItems((index, item) => '$index:${item.toUpperCase()}');

      expect(manager.values, ['0:A', '1:B', '2:C', '3:D']);
    });

    test('updateItems when update function throws sets error', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b']);
      manager.refresh(newPage: page);

      manager.updateItems((index, item) => throw Exception('Update error'));

      expect(manager.value, isA<Warning<int, String>>());
      final state = manager.value as Warning<int, String>;
      expect(state.error, isA<Exception>());
    });

    test('removeItem removes item at specified index', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b', 'c']);
      manager.refresh(newPage: page);

      manager.removeItem(1);

      expect(manager.values, ['a', 'c']);
    });

    test('removeItem works across multiple pages', () async {
      final manager = PageManager<int, String>();
      const page1 = PageData<int, String>(data: ['a', 'b'], appendKey: 2);
      const page2 = PageData<int, String>(data: ['c', 'd']);

      manager.refresh(newPage: page1);
      await manager.append(newPage: page2);

      manager.removeItem(2);

      expect(manager.values, ['a', 'b', 'd']);
    });

    test('removeItem removes page when last item is removed', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a']);
      manager.refresh(newPage: page);

      manager.removeItem(0);

      expect(manager.values, isEmpty);
    });

    test('removeItem with invalid index sets error', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b']);
      manager.refresh(newPage: page);

      manager.removeItem(5);

      expect(manager.value, isA<Warning<int, String>>());
      final state = manager.value as Warning<int, String>;
      expect(state.error, isA<RangeError>());
    });

    test('removeItem with negative index sets error', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b']);
      manager.refresh(newPage: page);

      manager.removeItem(-1);

      expect(manager.value, isA<Warning<int, String>>());
      final state = manager.value as Warning<int, String>;
      expect(state.error, isA<RangeError>());
    });

    test('removeItems removes items matching condition', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b', 'c', 'd']);
      manager.refresh(newPage: page);

      manager.removeItems((index, item) => item == 'b' || item == 'd');

      expect(manager.values, ['a', 'c']);
    });

    test('removeItems works across multiple pages', () async {
      final manager = PageManager<int, String>();
      const page1 = PageData<int, String>(data: ['a', 'b'], appendKey: 2);
      const page2 = PageData<int, String>(data: ['c', 'd']);

      manager.refresh(newPage: page1);
      await manager.append(newPage: page2);

      manager.removeItems((index, item) => index % 2 == 0);

      expect(manager.values, ['b', 'd']);
    });

    test('removeItems removes empty pages', () async {
      final manager = PageManager<int, String>();
      const page1 = PageData<int, String>(data: ['a', 'b'], appendKey: 2);
      const page2 = PageData<int, String>(data: ['c', 'd']);

      manager.refresh(newPage: page1);
      await manager.append(newPage: page2);

      manager.removeItems((index, item) => item == 'a' || item == 'b');

      expect(manager.values, ['c', 'd']);
      final state = manager.value as Paging<int, String>;
      expect(state.data.length, 1); // page1 should be removed
    });

    test('removeItems when test function throws sets error', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b']);
      manager.refresh(newPage: page);

      manager.removeItems((index, item) => throw Exception('Test error'));

      expect(manager.value, isA<Warning<int, String>>());
      final state = manager.value as Warning<int, String>;
      expect(state.error, isA<Exception>());
    });

    test('insertItem inserts item at specified index', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b', 'c']);
      manager.refresh(newPage: page);

      manager.insertItem(1, 'x');

      expect(manager.values, ['a', 'x', 'b', 'c']);
    });

    test('insertItem at beginning', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b']);
      manager.refresh(newPage: page);

      manager.insertItem(0, 'x');

      expect(manager.values, ['x', 'a', 'b']);
    });

    test('insertItem at end', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b']);
      manager.refresh(newPage: page);

      manager.insertItem(2, 'x');

      expect(manager.values, ['a', 'b', 'x']);
    });

    test('insertItem in empty list', () {
      final manager = PageManager<int, String>();
      manager.refresh(newPage: null);

      manager.insertItem(0, 'x');

      expect(manager.values, ['x']);
    });

    test('insertItem works across multiple pages', () async {
      final manager = PageManager<int, String>();
      const page1 = PageData<int, String>(data: ['a', 'b'], appendKey: 2);
      const page2 = PageData<int, String>(data: ['c', 'd']);

      manager.refresh(newPage: page1);
      await manager.append(newPage: page2);

      manager.insertItem(2, 'x');

      expect(manager.values, ['a', 'b', 'x', 'c', 'd']);
    });

    test('insertItem with invalid index sets error', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b']);
      manager.refresh(newPage: page);

      manager.insertItem(5, 'x');

      expect(manager.value, isA<Warning<int, String>>());
      final state = manager.value as Warning<int, String>;
      expect(state.error, isA<RangeError>());
    });

    test('insertItem with negative index sets error', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b']);
      manager.refresh(newPage: page);

      manager.insertItem(-1, 'x');

      expect(manager.value, isA<Warning<int, String>>());
      final state = manager.value as Warning<int, String>;
      expect(state.error, isA<RangeError>());
    });

    test('insertItem at page boundary', () async {
      final manager = PageManager<int, String>();
      const page1 = PageData<int, String>(data: ['a', 'b'], appendKey: 2);
      const page2 = PageData<int, String>(data: ['c', 'd']);

      manager.refresh(newPage: page1);
      await manager.append(newPage: page2);

      // Insert at the boundary (index 2, start of page2)
      manager.insertItem(2, 'x');

      expect(manager.values, ['a', 'b', 'x', 'c', 'd']);
    });

    test('updateItem after dispose does nothing', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b']);
      manager.refresh(newPage: page);

      manager.dispose();
      manager.updateItem(0, (item) => 'changed');

      expect(manager.values, ['a', 'b']); // unchanged
    });

    test('removeItem after dispose does nothing', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b']);
      manager.refresh(newPage: page);

      manager.dispose();
      manager.removeItem(0);

      expect(manager.values, ['a', 'b']); // unchanged
    });

    test('insertItem after dispose does nothing', () {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b']);
      manager.refresh(newPage: page);

      manager.dispose();
      manager.insertItem(0, 'x');

      expect(manager.values, ['a', 'b']); // unchanged
    });

    test('updateItem in Warning state does nothing', () {
      final manager = PageManager<int, String>();
      manager.setError(error: Exception('error'), stackTrace: null);

      manager.updateItem(0, (item) => 'changed');

      expect(manager.value, isA<Warning<int, String>>()); // still Warning
    });

    test('removeItem in Warning state does nothing', () {
      final manager = PageManager<int, String>();
      manager.setError(error: Exception('error'), stackTrace: null);

      manager.removeItem(0);

      expect(manager.value, isA<Warning<int, String>>()); // still Warning
    });

    test('insertItem in Warning state does nothing', () {
      final manager = PageManager<int, String>();
      manager.setError(error: Exception('error'), stackTrace: null);

      manager.insertItem(0, 'x');

      expect(manager.value, isA<Warning<int, String>>()); // still Warning
    });

    test('multiple operations work correctly', () {
      final manager = PageManager<int, String>();
      manager.refresh(newPage: null);

      manager.insertItem(0, 'a');
      manager.insertItem(1, 'b');
      manager.insertItem(2, 'c');
      manager.updateItem(1, (item) => item.toUpperCase());
      manager.removeItem(2);

      expect(manager.values, ['a', 'B']);
    });

    test('prependPageKey returns first page prependKey', () async {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b'], prependKey: 42);

      manager.refresh(newPage: page);

      expect(manager.prependPageKey, 42);
    });

    test('appendPageKey returns last page appendKey', () async {
      final manager = PageManager<int, String>();
      const page = PageData<int, String>(data: ['a', 'b'], appendKey: 99);

      manager.refresh(newPage: page);

      expect(manager.appendPageKey, 99);
    });

    test('values returns all items from all pages', () async {
      final manager = PageManager<int, String>();
      const page1 = PageData<int, String>(data: ['a', 'b'], appendKey: 2);
      const page2 = PageData<int, String>(data: ['c', 'd']);

      manager.refresh(newPage: page1);
      await manager.append(newPage: page2);

      expect(manager.values, ['a', 'b', 'c', 'd']);
    });

    test('dispose sets _disposed flag', () {
      final manager = PageManager<int, String>();
      manager.dispose();

      // After dispose, operations should not update state
      manager.changeState(type: LoadType.refresh);
      expect(manager.value, isA<Paging<int, String>>());
      final state = manager.value as Paging<int, String>;
      expect(state.state, isA<LoadStateInit>());
    });

    test('listener is notified on state change', () {
      final manager = PageManager<int, String>();
      var notified = false;
      manager.addListener(() {
        notified = true;
      });

      manager.changeState(type: LoadType.refresh);

      expect(notified, true);
    });

    test('removeListener prevents notification', () {
      final manager = PageManager<int, String>();
      var notified = false;
      void listener() {
        notified = true;
      }

      manager.addListener(listener);
      manager.removeListener(listener);

      manager.changeState(type: LoadType.refresh);

      expect(notified, false);
    });
  });

  group('PagingStateExt', () {
    test('isLoading returns true for LoadStateLoading', () {
      const state = Paging<int, String>(
        state: LoadStateLoading(state: LoadType.append),
        data: [],
      );

      expect(state.isLoading, true);
    });

    test('isLoading returns false for LoadStateLoaded', () {
      const state = Paging<int, String>(state: LoadStateLoaded(), data: []);

      expect(state.isLoading, false);
    });

    test('isLoading returns false for Warning', () {
      final state = Warning<int, String>(
        error: Exception('error'),
        stackTrace: null,
      );

      expect(state.isLoading, false);
    });

    test('items returns flattened list of all page data', () {
      const page1 = PageData<int, String>(data: ['a', 'b']);
      const page2 = PageData<int, String>(data: ['c', 'd']);
      const state = Paging<int, String>(
        state: LoadStateLoaded(),
        data: [page1, page2],
      );

      expect(state.items, ['a', 'b', 'c', 'd']);
    });

    test('items returns empty list for Warning', () {
      final state = Warning<int, String>(
        error: Exception('error'),
        stackTrace: null,
      );

      expect(state.items, isEmpty);
    });

    test('prependPageKey returns first page prependKey', () {
      const page1 = PageData<int, String>(data: ['a', 'b'], prependKey: 42);
      const page2 = PageData<int, String>(data: ['c', 'd']);
      const state = Paging<int, String>(
        state: LoadStateLoaded(),
        data: [page1, page2],
      );

      expect(state.prependPageKey, 42);
    });

    test('appendPageKey returns last page appendKey', () {
      const page1 = PageData<int, String>(data: ['a', 'b']);
      const page2 = PageData<int, String>(data: ['c', 'd'], appendKey: 99);
      const state = Paging<int, String>(
        state: LoadStateLoaded(),
        data: [page1, page2],
      );

      expect(state.appendPageKey, 99);
    });
  });

  group('LoadState', () {
    test('LoadStateLoading has correct state properties', () {
      const loading = LoadStateLoading(state: LoadType.init);
      expect(loading.isInit, true);
      expect(loading.isRefresh, false);
      expect(loading.isPrepend, false);
      expect(loading.isAppend, false);
    });

    test('LoadStateLoading identifies refresh correctly', () {
      const loading = LoadStateLoading(state: LoadType.refresh);
      expect(loading.isInit, false);
      expect(loading.isRefresh, true);
      expect(loading.isPrepend, false);
      expect(loading.isAppend, false);
    });

    test('LoadStateLoading identifies prepend correctly', () {
      const loading = LoadStateLoading(state: LoadType.prepend);
      expect(loading.isInit, false);
      expect(loading.isRefresh, false);
      expect(loading.isPrepend, true);
      expect(loading.isAppend, false);
    });

    test('LoadStateLoading identifies append correctly', () {
      const loading = LoadStateLoading(state: LoadType.append);
      expect(loading.isInit, false);
      expect(loading.isRefresh, false);
      expect(loading.isPrepend, false);
      expect(loading.isAppend, true);
    });
  });

  group('PageManager API flags', () {
    late PageManager<int, String> manager;

    setUp(() {
      manager = PageManager<int, String>();
    });

    test('isRefreshing is true during refresh', () async {
      manager.changeState(type: LoadType.refresh);
      expect(manager.isRefreshing, isTrue);
      expect(manager.isPrepending, isFalse);
      expect(manager.isAppending, isFalse);
    });

    test('isPrepending is true during prepend', () async {
      manager.changeState(type: LoadType.prepend);
      expect(manager.isPrepending, isTrue);
      expect(manager.isRefreshing, isFalse);
      expect(manager.isAppending, isFalse);
    });

    test('isAppending is true during append', () async {
      manager.changeState(type: LoadType.append);
      expect(manager.isAppending, isTrue);
      expect(manager.isRefreshing, isFalse);
      expect(manager.isPrepending, isFalse);
    });

    test('All flags are false when loaded', () async {
      manager.value = Paging(state: const LoadStateLoaded(), data: []);
      expect(manager.isRefreshing, isFalse);
      expect(manager.isPrepending, isFalse);
      expect(manager.isAppending, isFalse);
    });
  });
}

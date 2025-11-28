import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';
import 'package:paging_view/src/private/page_manager.dart';

void main() {
  group('PageManager', () {
    late PageManager<int, String> manager;
    const page1 = PageData<int, String>(
      data: ['a', 'b'],
      prependKey: 0,
      appendKey: 2,
    );
    const page2 = PageData<int, String>(
      data: ['c', 'd'],
      prependKey: 1,
      appendKey: 3,
    );
    const page3 = PageData<int, String>(
      data: ['e', 'f'],
      prependKey: 2,
      appendKey: 4,
    );

    setUp(() {
      manager = PageManager<int, String>();
    });

    test('initial state is Paging.init', () {
      expect(manager.value, Paging<int, String>.init());
      expect(manager.isLoading, isFalse);
      expect(manager.prependPageKey, isNull);
      expect(manager.appendPageKey, isNull);
      expect(manager.values, isEmpty);
      manager.dispose();
    });

    test('dispose() prevents further state changes', () {
      manager.dispose();
      manager.changeState(type: LoadType.init);
      expect(manager.value, Paging<int, String>.init());
    });

    test('changeState() updates the state to loading', () {
      manager.changeState(type: LoadType.refresh);
      expect(manager.value, isA<Paging<int, String>>());
      final paging = manager.value as Paging<int, String>;
      expect(paging.state, isA<LoadStateLoading>());
      expect((paging.state as LoadStateLoading).state, LoadType.refresh);
      expect(manager.isLoading, isTrue);
      manager.dispose();
    });

    test('setError() updates the state to Warning', () {
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;
      manager.setError(error: error, stackTrace: stackTrace);

      expect(manager.value, isA<Warning<int, String>>());
      final warning = manager.value as Warning<int, String>;
      expect(warning.error, error);
      expect(warning.stackTrace, stackTrace);
      expect(manager.isLoading, isFalse);
      manager.dispose();
    });

    group('Operations on disposed manager', () {
      setUp(() {
        manager.refresh(newPage: page1);
        manager.dispose();
      });

      test('changeState does nothing', () {
        manager.changeState(type: LoadType.init);
        expect(manager.values, ['a', 'b']);
      });
      test('setError does nothing', () {
        manager.setError(error: 'e', stackTrace: null);
        expect(manager.values, ['a', 'b']);
      });
      test('refresh does nothing', () {
        manager.refresh(newPage: page2);
        expect(manager.values, ['a', 'b']);
      });
      test('prepend does nothing', () {
        manager.prepend(newPage: page2);
        expect(manager.values, ['a', 'b']);
      });
      test('append does nothing', () {
        manager.append(newPage: page2);
        expect(manager.values, ['a', 'b']);
      });
      test('updateItem does nothing', () {
        manager.updateItem(0, (_) => 'z');
        expect(manager.values, ['a', 'b']);
      });
      test('updateItems does nothing', () {
        manager.updateItems((_, _) => 'z');
        expect(manager.values, ['a', 'b']);
      });
      test('removeItem does nothing', () {
        manager.removeItem(0);
        expect(manager.values, ['a', 'b']);
      });
      test('removeItems does nothing', () {
        manager.removeItems((_, _) => true);
        expect(manager.values, ['a', 'b']);
      });
      test('insertItem does nothing', () {
        manager.insertItem(0, 'z');
        expect(manager.values, ['a', 'b']);
      });
    });

    group('Page manipulation', () {
      tearDown(() {
        manager.dispose();
      });

      test('refresh() with data replaces all pages', () {
        manager.append(newPage: page1);
        manager.refresh(newPage: page2);
        expect(manager.values, ['c', 'd']);
        expect(manager.value.pages, [page2]);
      });

      test('refresh() with null clears all pages', () {
        manager.append(newPage: page1);
        manager.refresh(newPage: null);
        expect(manager.values, isEmpty);
        expect(manager.value.pages, isEmpty);
      });

      test('prepend() adds a page to the beginning', () {
        manager.append(newPage: page2);
        manager.prepend(newPage: page1);
        expect(manager.values, ['a', 'b', 'c', 'd']);
        expect(manager.value.pages, [page1, page2]);
        expect(manager.prependPageKey, 0);
        expect(manager.appendPageKey, 3);
      });

      test('prepend() with null does nothing', () {
        manager.append(newPage: page1);
        manager.prepend(newPage: null);
        expect(manager.values, ['a', 'b']);
      });

      test('append() adds a page to the end', () {
        manager.append(newPage: page1);
        manager.append(newPage: page2);
        expect(manager.values, ['a', 'b', 'c', 'd']);
        expect(manager.value.pages, [page1, page2]);
        expect(manager.prependPageKey, 0);
        expect(manager.appendPageKey, 3);
      });

      test('append() with null does nothing', () {
        manager.append(newPage: page1);
        manager.append(newPage: null);
        expect(manager.values, ['a', 'b']);
      });
    });

    group('Item manipulation', () {
      setUp(() {
        manager.refresh(newPage: page1);
        manager.append(newPage: page2);
        manager.append(newPage: page3);
        // State: ['a', 'b'], ['c', 'd'], ['e', 'f']
      });

      tearDown(() {
        manager.dispose();
      });

      // --- updateItem ---
      test('updateItem() updates item in the first page', () {
        manager.updateItem(1, (item) => item.toUpperCase());
        expect(manager.values, ['a', 'B', 'c', 'd', 'e', 'f']);
      });

      test('updateItem() updates item in the last page', () {
        manager.updateItem(4, (item) => item.toUpperCase());
        expect(manager.values, ['a', 'b', 'c', 'd', 'E', 'f']);
      });

      test('updateItem() with invalid index throws and sets Warning', () {
        manager.updateItem(10, (_) => 'z');
        expect(manager.value, isA<Warning>());
        expect((manager.value as Warning).error, isA<RangeError>());
      });

      test('updateItem() when not in Paging state does nothing', () {
        manager.setError(error: 'e', stackTrace: null);
        manager.updateItem(0, (_) => 'z');
        expect(manager.value, isA<Warning>());
      });

      // --- updateItems ---
      test('updateItems() updates all items across all pages', () {
        manager.updateItems((index, item) => '$item$index');
        expect(manager.values, ['a0', 'b1', 'c2', 'd3', 'e4', 'f5']);
      });

      test('updateItems() when function throws sets Warning', () {
        manager.updateItems((index, item) {
          if (index == 3) throw 'Error';
          return item;
        });
        expect(manager.value, isA<Warning>());
      });

      // --- removeItem ---
      test('removeItem() removes an item and shrinks the page', () {
        manager.removeItem(2); // remove 'c'
        expect(manager.values, ['a', 'b', 'd', 'e', 'f']);
        expect(manager.value.pages[1].data, ['d']);
      });

      test('removeItem() removes a page if it becomes empty', () {
        manager.removeItem(0); // remove 'a'
        manager.removeItem(0); // remove 'b'
        expect(manager.values, ['c', 'd', 'e', 'f']);
        expect(manager.value.pages.length, 2);
        expect(manager.value.pages[0].data, ['c', 'd']);
      });

      test('removeItem() with invalid index throws and sets Warning', () {
        manager.removeItem(-1);
        expect(manager.value, isA<Warning>());
        expect((manager.value as Warning).error, isA<RangeError>());
      });

      // --- removeItems ---
      test('removeItems() removes items based on a predicate', () {
        manager.removeItems(
          (index, item) => item == 'a' || item == 'd' || item == 'f',
        );
        expect(manager.values, ['b', 'c', 'e']);
      });

      test('removeItems() removes pages if they become empty', () {
        manager.removeItems((_, item) => item == 'c' || item == 'd');
        expect(manager.values, ['a', 'b', 'e', 'f']);
        expect(manager.value.pages.length, 2);
        expect(manager.value.pages.map((p) => p.data.join()), ['ab', 'ef']);
      });

      test('removeItems() when predicate throws sets Warning', () {
        manager.removeItems((index, item) {
          if (item == 'd') throw 'Error';
          return false;
        });
        expect(manager.value, isA<Warning>());
      });

      // --- insertItem ---
      test('insertItem() at the beginning of a page', () {
        manager.insertItem(2, 'x'); // before 'c'
        expect(manager.values, ['a', 'b', 'x', 'c', 'd', 'e', 'f']);
        expect(manager.value.pages[1].data, ['x', 'c', 'd']);
      });

      test('insertItem() in the middle of a page', () {
        manager.insertItem(3, 'y'); // after 'c'
        expect(manager.values, ['a', 'b', 'c', 'y', 'd', 'e', 'f']);
        expect(manager.value.pages[1].data, ['c', 'y', 'd']);
      });

      test('insertItem() at the very end of all items', () {
        manager.insertItem(6, 'z'); // after 'f'
        expect(manager.values, ['a', 'b', 'c', 'd', 'e', 'f', 'z']);
        expect(manager.value.pages.last.data, ['e', 'f', 'z']);
      });

      test('insertItem() into an empty manager', () {
        manager.refresh(newPage: null);
        manager.insertItem(0, 'x');
        expect(manager.values, ['x']);
        expect(manager.value.pages.length, 1);
        expect(manager.value.pages.first.data, ['x']);
      });

      test('insertItem() with invalid index throws and sets Warning', () {
        manager.insertItem(10, 'z');
        expect(manager.value, isA<Warning>());
        expect((manager.value as Warning).error, isA<RangeError>());
      });
    });

    group('Listener notifications', () {
      tearDown(() {
        manager.dispose();
      });

      test('listener is notified on state change', () {
        var notified = false;
        manager.addListener(() => notified = true);
        manager.refresh(newPage: page1);
        expect(notified, isTrue);
      });

      test('removeListener() stops notifications', () {
        var notified = false;
        void listener() => notified = true;
        manager.addListener(listener);
        manager.removeListener(listener);
        manager.refresh(newPage: page1);
        expect(notified, isFalse);
      });
    });
  });
}

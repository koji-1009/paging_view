import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/center_page_manager.dart';
import 'package:paging_view/src/private/entity.dart';

void main() {
  group('CenterPageManager', () {
    late CenterPageManager<int, String> manager;
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
      manager = CenterPageManager<int, String>();
    });

    test('initial state is CenterPaging.init', () {
      expect(manager.value, CenterPaging<int, String>.init());
      expect(manager.isLoading, isFalse);
      expect(manager.prependPageKey, isNull);
      expect(manager.appendPageKey, isNull);
      manager.dispose();
    });

    test('dispose() prevents further state changes', () {
      manager.dispose();
      manager.changeState(type: LoadType.init);
      expect(manager.value, CenterPaging<int, String>.init());
    });

    test('changeState() updates the state to loading', () {
      manager.changeState(type: LoadType.refresh);
      expect(manager.value, isA<CenterPaging<int, String>>());
      final paging = manager.value as CenterPaging<int, String>;
      expect(paging.state, isA<LoadStateLoading>());
      expect((paging.state as LoadStateLoading).state, LoadType.refresh);
      expect(manager.isLoading, isTrue);
      manager.dispose();
    });

    test('setError() updates the state to CenterWarning', () {
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;
      manager.setError(error: error, stackTrace: stackTrace);

      expect(manager.value, isA<CenterWarning<int, String>>());
      final warning = manager.value as CenterWarning<int, String>;
      expect(warning.error, error);
      expect(warning.stackTrace, stackTrace);
      expect(manager.isLoading, isFalse);
      manager.dispose();
    });

    group('Operations on disposed manager', () {
      setUp(() {
        manager.setCenter(newPage: page1);
        manager.dispose();
      });

      test('changeState does nothing', () {
        manager.changeState(type: LoadType.init);
        expect(manager.value.centerItems, ['a', 'b']);
      });
      test('setError does nothing', () {
        manager.setError(error: 'e', stackTrace: null);
        expect(manager.value.centerItems, ['a', 'b']);
      });
      test('setCenter does nothing', () {
        manager.setCenter(newPage: page2);
        expect(manager.value.centerItems, ['a', 'b']);
      });
      test('refresh does nothing', () {
        manager.refresh(newPage: page2);
        expect(manager.value.centerItems, ['a', 'b']);
      });
      test('prepend does nothing', () {
        manager.prepend(newPage: page2);
        expect(manager.value.centerItems, ['a', 'b']);
      });
      test('append does nothing', () {
        manager.append(newPage: page2);
        expect(manager.value.centerItems, ['a', 'b']);
      });
      test('revertLoad does nothing', () {
        manager.revertLoad();
        expect(manager.value.centerItems, ['a', 'b']);
      });
    });

    group('Center page manipulation', () {
      tearDown(() {
        manager.dispose();
      });

      test('setCenter() with data sets center pages', () {
        manager.setCenter(newPage: page1);
        expect(manager.value.centerItems, ['a', 'b']);
        expect(manager.value.prependItems, isEmpty);
        expect(manager.value.appendItems, isEmpty);
        expect(manager.prependPageKey, 0);
        expect(manager.appendPageKey, 2);
      });

      test('setCenter() with null clears all pages', () {
        manager.setCenter(newPage: page1);
        manager.setCenter(newPage: null);
        expect(manager.value.centerItems, isEmpty);
        expect(manager.value.allItems, isEmpty);
      });

      test('refresh() with data replaces all pages', () {
        manager.setCenter(newPage: page1);
        manager.prepend(newPage: page2);
        manager.append(newPage: page3);
        manager.refresh(newPage: page1);
        expect(manager.value.centerItems, ['a', 'b']);
        expect(manager.value.prependItems, isEmpty);
        expect(manager.value.appendItems, isEmpty);
      });

      test('refresh() with null clears all pages', () {
        manager.setCenter(newPage: page1);
        manager.refresh(newPage: null);
        expect(manager.value.allItems, isEmpty);
      });
    });

    group('Prepend page manipulation', () {
      setUp(() {
        manager.setCenter(newPage: page1);
      });

      tearDown(() {
        manager.dispose();
      });

      test('prepend() adds a page to prependPages', () {
        manager.prepend(newPage: page2);
        expect(manager.value.prependItems, ['c', 'd']);
        expect(manager.value.centerItems, ['a', 'b']);
        expect(manager.prependPageKey, 1);
      });

      test('prepend() with null does nothing to data', () {
        manager.prepend(newPage: null);
        expect(manager.value.prependItems, isEmpty);
        expect(manager.value.centerItems, ['a', 'b']);
      });

      test('changeState(prepend) moves prependPages to centerPages', () {
        manager.prepend(newPage: page2);
        expect(manager.value.prependItems, ['c', 'd']);
        expect(manager.value.centerItems, ['a', 'b']);

        manager.changeState(type: LoadType.prepend);
        expect(manager.value.prependItems, isEmpty);
        expect(manager.value.centerItems, ['c', 'd', 'a', 'b']);
      });

      test('multiple prepends work correctly with changeState', () {
        // First prepend
        manager.prepend(newPage: page2);
        expect(manager.value.prependItems, ['c', 'd']);
        expect(manager.value.centerItems, ['a', 'b']);

        // Second prepend: changeState moves prependPages to center
        manager.changeState(type: LoadType.prepend);
        expect(manager.value.prependItems, isEmpty);
        expect(manager.value.centerItems, ['c', 'd', 'a', 'b']);

        // Complete second prepend
        manager.prepend(newPage: page3);
        expect(manager.value.prependItems, ['e', 'f']);
        expect(manager.value.centerItems, ['c', 'd', 'a', 'b']);
        expect(manager.value.allItems, ['e', 'f', 'c', 'd', 'a', 'b']);
      });

      test('prepend on non-Paging state does nothing', () {
        manager.setError(error: 'e', stackTrace: null);
        manager.prepend(newPage: page2);
        expect(manager.value, isA<CenterWarning<int, String>>());
      });
    });

    group('Append page manipulation', () {
      setUp(() {
        manager.setCenter(newPage: page1);
      });

      tearDown(() {
        manager.dispose();
      });

      test('append() adds a page to appendPages', () {
        manager.append(newPage: page2);
        expect(manager.value.appendItems, ['c', 'd']);
        expect(manager.value.centerItems, ['a', 'b']);
        expect(manager.appendPageKey, 3);
      });

      test('append() with null does nothing to data', () {
        manager.append(newPage: null);
        expect(manager.value.appendItems, isEmpty);
        expect(manager.value.centerItems, ['a', 'b']);
      });

      test('append moves existing appendPages to centerPages', () {
        manager.append(newPage: page2);
        expect(manager.value.appendItems, ['c', 'd']);
        expect(manager.value.centerItems, ['a', 'b']);

        // Second append
        manager.append(newPage: page3);
        expect(manager.value.appendItems, ['e', 'f']);
        expect(manager.value.centerItems, ['a', 'b', 'c', 'd']);
        expect(manager.value.allItems, ['a', 'b', 'c', 'd', 'e', 'f']);
      });

      test('append on non-Paging state does nothing', () {
        manager.setError(error: 'e', stackTrace: null);
        manager.append(newPage: page2);
        expect(manager.value, isA<CenterWarning<int, String>>());
      });
    });

    group('revertLoad', () {
      setUp(() {
        manager.setCenter(newPage: page1);
      });

      tearDown(() {
        manager.dispose();
      });

      test('revertLoad() reverts loading state to loaded', () {
        manager.changeState(type: LoadType.append);
        expect(manager.isLoading, isTrue);
        manager.revertLoad();
        expect(manager.isLoading, isFalse);
        final paging = manager.value as CenterPaging<int, String>;
        expect(paging.state, isA<LoadStateLoaded>());
      });

      test('revertLoad() does nothing when not loading', () {
        manager.revertLoad();
        final paging = manager.value as CenterPaging<int, String>;
        expect(paging.state, isA<LoadStateLoaded>());
      });

      test('revertLoad() on non-Paging state does nothing', () {
        manager.setError(error: 'e', stackTrace: null);
        manager.revertLoad();
        expect(manager.value, isA<CenterWarning<int, String>>());
      });
    });

    group('Item manipulation', () {
      setUp(() {
        manager.setCenter(newPage: page1); // ['a', 'b']
        manager.prepend(newPage: page2); // ['c', 'd'] at prepend
        manager.append(newPage: page3); // ['e', 'f'] at append
        // allItems: ['c', 'd', 'a', 'b', 'e', 'f']
      });

      tearDown(() {
        manager.dispose();
      });

      test('updateItem() updates an item in prepend segment', () {
        manager.updateItem(0, (item) => '${item}X');
        expect(manager.value.allItems, ['cX', 'd', 'a', 'b', 'e', 'f']);
      });

      test('updateItem() updates an item in center segment', () {
        manager.updateItem(2, (item) => '${item}X');
        expect(manager.value.allItems, ['c', 'd', 'aX', 'b', 'e', 'f']);
      });

      test('updateItem() updates an item in append segment', () {
        manager.updateItem(5, (item) => '${item}X');
        expect(manager.value.allItems, ['c', 'd', 'a', 'b', 'e', 'fX']);
      });

      test('updateItems() updates all specified items', () {
        manager.updateItems(
          (index, item) => index % 2 == 0 ? '${item}X' : item,
        );
        expect(manager.value.allItems, ['cX', 'd', 'aX', 'b', 'eX', 'f']);
      });

      test('removeItem() removes an item from prepend segment', () {
        manager.removeItem(1); // 'd'
        expect(manager.value.allItems, ['c', 'a', 'b', 'e', 'f']);
      });

      test('removeItem() removes an item from center segment', () {
        manager.removeItem(2); // 'a'
        expect(manager.value.allItems, ['c', 'd', 'b', 'e', 'f']);
      });

      test('removeItem() removes an item from append segment', () {
        manager.removeItem(4); // 'e'
        expect(manager.value.allItems, ['c', 'd', 'a', 'b', 'f']);
      });

      test('removeItems() removes all matching items', () {
        manager.removeItems((index, item) => item == 'a' || item == 'f');
        expect(manager.value.allItems, ['c', 'd', 'b', 'e']);
      });

      test('insertItem() inserts an item into prepend segment', () {
        manager.insertItem(1, 'X');
        expect(manager.value.allItems, ['c', 'X', 'd', 'a', 'b', 'e', 'f']);
      });

      test('insertItem() inserts an item into center segment', () {
        manager.insertItem(2, 'X');
        expect(manager.value.allItems, ['c', 'd', 'X', 'a', 'b', 'e', 'f']);
      });

      test('insertItem() inserts an item into append segment', () {
        manager.insertItem(5, 'X');
        expect(manager.value.allItems, ['c', 'd', 'a', 'b', 'e', 'X', 'f']);
      });

      test('insertItem() at the very end adds to the last segment', () {
        manager.insertItem(6, 'X');
        expect(manager.value.allItems, ['c', 'd', 'a', 'b', 'e', 'f', 'X']);
        expect(manager.value.appendItems, ['e', 'f', 'X']);
      });

      test(
        'insertItem() at the very end when only center exists adding to centerPages',
        () {
          manager.setCenter(newPage: page1);
          manager.insertItem(2, 'X');
          expect(manager.value.allItems, ['a', 'b', 'X']);
          expect(manager.value.centerItems, ['a', 'b', 'X']);
        },
      );

      test(
        'insertItem() at the very end when only prepend exists adding to prependPages',
        () {
          manager.setCenter(newPage: null);
          manager.changeState(type: LoadType.prepend);
          manager.prepend(newPage: page1);
          manager.insertItem(2, 'X');
          expect(manager.value.allItems, ['a', 'b', 'X']);
          expect(manager.value.prependItems, ['a', 'b', 'X']);
        },
      );

      test('insertItem() on empty state sets center', () {
        manager.dispose();
        manager = CenterPageManager<int, String>();
        manager.insertItem(0, 'X');
        expect(manager.value.centerItems, ['X']);
      });

      test('manipulation with out-of-bounds index sets error', () {
        manager.updateItem(99, (item) => item);
        expect(manager.value, isA<CenterWarning<int, String>>());

        manager.setCenter(newPage: page1);
        manager.removeItem(99);
        expect(manager.value, isA<CenterWarning<int, String>>());

        manager.setCenter(newPage: page1);
        manager.insertItem(99, 'X');
        expect(manager.value, isA<CenterWarning<int, String>>());
      });

      test('manipulation with inner exceptions sets error', () {
        manager.updateItems((index, item) => throw Exception('test'));
        expect(manager.value, isA<CenterWarning<int, String>>());

        manager.setCenter(newPage: page1);
        manager.removeItems((index, item) => throw Exception('test'));
        expect(manager.value, isA<CenterWarning<int, String>>());
      });

      test('methods do nothing when state is not CenterPaging', () {
        manager.setError(error: 'err', stackTrace: null);

        manager.updateItem(0, (item) => item);
        manager.updateItems((index, item) => item);
        manager.removeItem(0);
        manager.removeItems((index, item) => false);
        manager.insertItem(0, 'X');

        expect(manager.value, isA<CenterWarning<int, String>>());
      });
    });
  });

  group('CenterPageManagerState extension', () {
    test('isLoading returns correct values', () {
      final init = CenterPaging<int, String>(
        state: const LoadStateInit(),
        prependPages: const [],
        centerPages: const [],
        appendPages: const [],
      );
      final loaded = CenterPaging<int, String>(
        state: const LoadStateLoaded(),
        prependPages: const [],
        centerPages: const [],
        appendPages: const [],
      );
      final loading = CenterPaging<int, String>(
        state: const LoadStateLoading(state: LoadType.append),
        prependPages: const [],
        centerPages: const [],
        appendPages: const [],
      );
      const warning = CenterWarning<int, String>(
        error: 'error',
        stackTrace: null,
      );

      expect(init.isLoading, isFalse);
      expect(loaded.isLoading, isFalse);
      expect(loading.isLoading, isTrue);
      expect(warning.isLoading, isFalse);
    });

    test('prependPageKey returns correct key', () {
      const page1 = PageData<int, String>(
        data: ['a'],
        prependKey: 1,
        appendKey: 2,
      );
      const page2 = PageData<int, String>(
        data: ['b'],
        prependKey: 0,
        appendKey: 3,
      );

      // From prependPages first
      final withPrepend = CenterPaging<int, String>(
        state: const LoadStateLoaded(),
        prependPages: const [page2],
        centerPages: const [page1],
        appendPages: const [],
      );
      expect(withPrepend.prependPageKey, 0);

      // From centerPages if no prependPages
      final withoutPrepend = CenterPaging<int, String>(
        state: const LoadStateLoaded(),
        prependPages: const [],
        centerPages: const [page1],
        appendPages: const [],
      );
      expect(withoutPrepend.prependPageKey, 1);

      // Null from warning
      const warning = CenterWarning<int, String>(
        error: 'error',
        stackTrace: null,
      );
      expect(warning.prependPageKey, isNull);
    });

    test('appendPageKey returns correct key', () {
      const page1 = PageData<int, String>(
        data: ['a'],
        prependKey: 1,
        appendKey: 2,
      );
      const page2 = PageData<int, String>(
        data: ['b'],
        prependKey: 0,
        appendKey: 3,
      );

      // From appendPages last
      final withAppend = CenterPaging<int, String>(
        state: const LoadStateLoaded(),
        prependPages: const [],
        centerPages: const [page1],
        appendPages: const [page2],
      );
      expect(withAppend.appendPageKey, 3);

      // From centerPages if no appendPages
      final withoutAppend = CenterPaging<int, String>(
        state: const LoadStateLoaded(),
        prependPages: const [],
        centerPages: const [page1],
        appendPages: const [],
      );
      expect(withoutAppend.appendPageKey, 2);

      // Null from warning
      const warning = CenterWarning<int, String>(
        error: 'error',
        stackTrace: null,
      );
      expect(warning.appendPageKey, isNull);
    });

    test('allItems returns items in correct order', () {
      const page1 = PageData<int, String>(data: ['a', 'b']);
      const page2 = PageData<int, String>(data: ['c', 'd']);
      const page3 = PageData<int, String>(data: ['e', 'f']);

      final paging = CenterPaging<int, String>(
        state: const LoadStateLoaded(),
        prependPages: const [page1],
        centerPages: const [page2],
        appendPages: const [page3],
      );

      expect(paging.prependItems, ['a', 'b']);
      expect(paging.centerItems, ['c', 'd']);
      expect(paging.appendItems, ['e', 'f']);
      expect(paging.allItems, ['a', 'b', 'c', 'd', 'e', 'f']);
    });

    test('prependItems in correct order', () {
      const page1 = PageData<int, String>(data: ['a', 'b']);
      const page2 = PageData<int, String>(data: ['c', 'd']);

      final paging = CenterPaging<int, String>(
        state: const LoadStateLoaded(),
        prependPages: const [page1, page2], // page1 is newer, page2 is older
        centerPages: const [],
        appendPages: const [],
      );

      expect(paging.prependItems, ['a', 'b', 'c', 'd']);
    });
  });

  group('CenterPaging equality', () {
    test('equals works correctly', () {
      const page1 = PageData<int, String>(data: ['a']);
      final paging1 = CenterPaging<int, String>(
        state: const LoadStateLoaded(),
        prependPages: const [],
        centerPages: const [page1],
        appendPages: const [],
      );
      final paging2 = CenterPaging<int, String>(
        state: const LoadStateLoaded(),
        prependPages: const [],
        centerPages: const [page1],
        appendPages: const [],
      );
      final paging3 = CenterPaging<int, String>(
        state: const LoadStateInit(),
        prependPages: const [],
        centerPages: const [page1],
        appendPages: const [],
      );

      expect(paging1, equals(paging2));
      expect(paging1, isNot(equals(paging3)));
      expect(paging1.hashCode, equals(paging2.hashCode));
    });

    test('toString returns expected format', () {
      final paging = CenterPaging<int, String>(
        state: const LoadStateLoaded(),
        prependPages: const [],
        centerPages: const [],
        appendPages: const [],
      );
      expect(paging.toString(), contains('CenterPaging'));
    });
  });

  group('CenterWarning equality', () {
    test('equals works correctly', () {
      const warning1 = CenterWarning<int, String>(
        error: 'error',
        stackTrace: null,
      );
      const warning2 = CenterWarning<int, String>(
        error: 'error',
        stackTrace: null,
      );
      const warning3 = CenterWarning<int, String>(
        error: 'different',
        stackTrace: null,
      );

      expect(warning1, equals(warning2));
      expect(warning1, isNot(equals(warning3)));
      expect(warning1.hashCode, equals(warning2.hashCode));
    });

    test('toString returns expected format', () {
      const warning = CenterWarning<int, String>(
        error: 'error',
        stackTrace: null,
      );
      expect(warning.toString(), contains('CenterWarning'));
    });
  });
}

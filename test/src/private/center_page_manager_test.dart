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
        expect(manager.value, isA<CenterWarning>());
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
        expect(manager.value, isA<CenterWarning>());
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
        expect(manager.value, isA<CenterWarning>());
      });
    });
  });

  group('CenterPageManagerState extension', () {
    test('isLoading returns correct values', () {
      const init = CenterPaging<int, String>(
        state: LoadStateInit(),
        prependPages: [],
        centerPages: [],
        appendPages: [],
      );
      const loaded = CenterPaging<int, String>(
        state: LoadStateLoaded(),
        prependPages: [],
        centerPages: [],
        appendPages: [],
      );
      const loading = CenterPaging<int, String>(
        state: LoadStateLoading(state: LoadType.append),
        prependPages: [],
        centerPages: [],
        appendPages: [],
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
      const withPrepend = CenterPaging<int, String>(
        state: LoadStateLoaded(),
        prependPages: [page2],
        centerPages: [page1],
        appendPages: [],
      );
      expect(withPrepend.prependPageKey, 0);

      // From centerPages if no prependPages
      const withoutPrepend = CenterPaging<int, String>(
        state: LoadStateLoaded(),
        prependPages: [],
        centerPages: [page1],
        appendPages: [],
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
      const withAppend = CenterPaging<int, String>(
        state: LoadStateLoaded(),
        prependPages: [],
        centerPages: [page1],
        appendPages: [page2],
      );
      expect(withAppend.appendPageKey, 3);

      // From centerPages if no appendPages
      const withoutAppend = CenterPaging<int, String>(
        state: LoadStateLoaded(),
        prependPages: [],
        centerPages: [page1],
        appendPages: [],
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

      const paging = CenterPaging<int, String>(
        state: LoadStateLoaded(),
        prependPages: [page1],
        centerPages: [page2],
        appendPages: [page3],
      );

      expect(paging.prependItems, ['a', 'b']);
      expect(paging.centerItems, ['c', 'd']);
      expect(paging.appendItems, ['e', 'f']);
      expect(paging.allItems, ['a', 'b', 'c', 'd', 'e', 'f']);
    });

    test('prependItems in correct order', () {
      const page1 = PageData<int, String>(data: ['a', 'b']);
      const page2 = PageData<int, String>(data: ['c', 'd']);

      const paging = CenterPaging<int, String>(
        state: LoadStateLoaded(),
        prependPages: [page1, page2], // page1 is newer, page2 is older
        centerPages: [],
        appendPages: [],
      );

      expect(paging.prependItems, ['a', 'b', 'c', 'd']);
    });
  });

  group('CenterPaging equality', () {
    test('equals works correctly', () {
      const page1 = PageData<int, String>(data: ['a']);
      const paging1 = CenterPaging<int, String>(
        state: LoadStateLoaded(),
        prependPages: [],
        centerPages: [page1],
        appendPages: [],
      );
      const paging2 = CenterPaging<int, String>(
        state: LoadStateLoaded(),
        prependPages: [],
        centerPages: [page1],
        appendPages: [],
      );
      const paging3 = CenterPaging<int, String>(
        state: LoadStateInit(),
        prependPages: [],
        centerPages: [page1],
        appendPages: [],
      );

      expect(paging1, equals(paging2));
      expect(paging1, isNot(equals(paging3)));
      expect(paging1.hashCode, equals(paging2.hashCode));
    });

    test('toString returns expected format', () {
      const paging = CenterPaging<int, String>(
        state: LoadStateLoaded(),
        prependPages: [],
        centerPages: [],
        appendPages: [],
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

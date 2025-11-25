import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';

/// Manager class that manages [PageManagerState].
class PageManager<PageKey, Value>
    extends ValueNotifier<PageManagerState<PageKey, Value>> {
  /// Creates a [PageManager].
  PageManager() : super(Paging.init());

  bool get isLoading => value.isLoading;

  bool get isRefreshing => value.isRefreshing;

  bool get isPrepending => value.isPrepending;

  bool get isAppending => value.isAppending;

  PageKey? get prependPageKey => value.prependPageKey;

  PageKey? get appendPageKey => value.appendPageKey;

  List<Value> get values => value.items;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void changeState({required LoadType type}) {
    if (_disposed) {
      return;
    }

    value = Paging(
      state: LoadStateLoading(state: type),
      data: value.pages,
    );
  }

  void setError({required Object error, required StackTrace? stackTrace}) {
    if (_disposed) {
      return;
    }

    value = Warning(error: error, stackTrace: stackTrace);
  }

  void refresh({required PageData<PageKey, Value>? newPage}) {
    if (_disposed) {
      return;
    }

    if (newPage == null) {
      value = const Paging(state: LoadStateLoaded(), data: []);
      return;
    }

    value = Paging(state: const LoadStateLoaded(), data: [newPage]);
  }

  void prepend({required PageData<PageKey, Value>? newPage}) {
    if (_disposed) {
      return;
    }

    if (newPage == null) {
      value = Paging(state: const LoadStateLoaded(), data: value.pages);
      return;
    }

    value = Paging(
      state: const LoadStateLoaded(),
      data: [newPage, ...value.pages],
    );
  }

  void append({required PageData<PageKey, Value>? newPage}) {
    if (_disposed) {
      return;
    }

    if (newPage == null) {
      value = Paging(state: const LoadStateLoaded(), data: value.pages);
      return;
    }

    value = Paging(
      state: const LoadStateLoaded(),
      data: [...value.pages, newPage],
    );
  }

  void updateItem(int index, Value Function(Value item) update) {
    if (_disposed) {
      return;
    }

    final currentValue = value;
    if (currentValue is! Paging<PageKey, Value>) {
      return;
    }

    try {
      final items = currentValue.items;
      if (index < 0 || index >= items.length) {
        throw RangeError.index(index, items, 'index', null, items.length);
      }

      final itemToUpdate = items[index];
      final updatedItem = update(itemToUpdate);

      var itemIndexAcrossPages = 0;
      final updatedPages = <PageData<PageKey, Value>>[];

      for (final page in currentValue.pages) {
        final pageSize = page.data.length;
        final isTargetInThisPage =
            index >= itemIndexAcrossPages &&
            index < itemIndexAcrossPages + pageSize;

        if (isTargetInThisPage) {
          final indexInPage = index - itemIndexAcrossPages;
          final updatedPageData = List<Value>.from(page.data);
          updatedPageData[indexInPage] = updatedItem;

          updatedPages.add(
            PageData(
              data: updatedPageData,
              prependKey: page.prependKey,
              appendKey: page.appendKey,
            ),
          );
        } else {
          updatedPages.add(page);
        }

        itemIndexAcrossPages += pageSize;
      }

      value = Paging(state: currentValue.state, data: updatedPages);
    } catch (error, stackTrace) {
      setError(error: error, stackTrace: stackTrace);
    }
  }

  void updateItems(Value Function(int index, Value item) update) {
    if (_disposed) {
      return;
    }

    final currentValue = value;
    if (currentValue is! Paging<PageKey, Value>) {
      return;
    }

    try {
      var itemIndexAcrossPages = 0;
      final updatedPages = <PageData<PageKey, Value>>[];

      for (final page in currentValue.pages) {
        final updatedPageData = <Value>[];

        for (var i = 0; i < page.data.length; i++) {
          final globalIndex = itemIndexAcrossPages + i;
          final item = page.data[i];
          final updatedItem = update(globalIndex, item);
          updatedPageData.add(updatedItem);
        }

        // Only add page if it still has data
        if (updatedPageData.isNotEmpty) {
          updatedPages.add(
            PageData(
              data: updatedPageData,
              prependKey: page.prependKey,
              appendKey: page.appendKey,
            ),
          );
        }

        itemIndexAcrossPages += page.data.length;
      }

      value = Paging(state: currentValue.state, data: updatedPages);
    } catch (error, stackTrace) {
      setError(error: error, stackTrace: stackTrace);
    }
  }

  void removeItem(int index) {
    if (_disposed) {
      return;
    }

    final currentValue = value;
    if (currentValue is! Paging<PageKey, Value>) {
      return;
    }

    try {
      final items = currentValue.items;
      if (index < 0 || index >= items.length) {
        throw RangeError.index(index, items, 'index', null, items.length);
      }

      var itemIndexAcrossPages = 0;
      final updatedPages = <PageData<PageKey, Value>>[];

      for (final page in currentValue.pages) {
        final pageSize = page.data.length;
        final isTargetInThisPage =
            index >= itemIndexAcrossPages &&
            index < itemIndexAcrossPages + pageSize;

        if (isTargetInThisPage) {
          final indexInPage = index - itemIndexAcrossPages;
          final updatedPageData = List<Value>.from(page.data);
          updatedPageData.removeAt(indexInPage);

          // Only add page if it still has data
          if (updatedPageData.isNotEmpty) {
            updatedPages.add(
              PageData(
                data: updatedPageData,
                prependKey: page.prependKey,
                appendKey: page.appendKey,
              ),
            );
          }
        } else {
          updatedPages.add(page);
        }

        itemIndexAcrossPages += pageSize;
      }

      value = Paging(state: currentValue.state, data: updatedPages);
    } catch (error, stackTrace) {
      setError(error: error, stackTrace: stackTrace);
    }
  }

  void removeItems(bool Function(int index, Value item) test) {
    if (_disposed) {
      return;
    }

    final currentValue = value;
    if (currentValue is! Paging<PageKey, Value>) {
      return;
    }

    try {
      var itemIndexAcrossPages = 0;
      final updatedPages = <PageData<PageKey, Value>>[];

      for (final page in currentValue.pages) {
        final updatedPageData = <Value>[];

        for (var i = 0; i < page.data.length; i++) {
          final globalIndex = itemIndexAcrossPages + i;
          final item = page.data[i];
          final shouldRemove = test(globalIndex, item);

          if (!shouldRemove) {
            updatedPageData.add(item);
          }
        }

        // Only add page if it still has data
        if (updatedPageData.isNotEmpty) {
          updatedPages.add(
            PageData(
              data: updatedPageData,
              prependKey: page.prependKey,
              appendKey: page.appendKey,
            ),
          );
        }

        itemIndexAcrossPages += page.data.length;
      }

      value = Paging(state: currentValue.state, data: updatedPages);
    } catch (error, stackTrace) {
      setError(error: error, stackTrace: stackTrace);
    }
  }

  void insertItem(int index, Value item) {
    if (_disposed) {
      return;
    }

    final currentValue = value;
    if (currentValue is! Paging<PageKey, Value>) {
      return;
    }

    try {
      final items = currentValue.items;
      if (index < 0 || index > items.length) {
        throw RangeError.range(index, 0, items.length, 'index');
      }

      // Special case: insert at the end
      if (index == items.length) {
        if (currentValue.pages.isEmpty) {
          // Create a new page if there are no pages
          value = Paging(
            state: currentValue.state,
            data: [
              PageData(data: [item]),
            ],
          );
          return;
        }

        // Add to the last page
        final lastPage = currentValue.pages.last;
        final updatedPages = List<PageData<PageKey, Value>>.from(
          currentValue.pages.take(currentValue.pages.length - 1),
        );
        updatedPages.add(
          PageData(
            data: [...lastPage.data, item],
            prependKey: lastPage.prependKey,
            appendKey: lastPage.appendKey,
          ),
        );
        value = Paging(state: currentValue.state, data: updatedPages);
        return;
      }

      var itemIndexAcrossPages = 0;
      final updatedPages = <PageData<PageKey, Value>>[];

      for (final page in currentValue.pages) {
        final pageSize = page.data.length;
        final isTargetInThisPage =
            index >= itemIndexAcrossPages &&
            index < itemIndexAcrossPages + pageSize;

        if (isTargetInThisPage) {
          final indexInPage = index - itemIndexAcrossPages;
          final updatedPageData = List<Value>.from(page.data);
          updatedPageData.insert(indexInPage, item);

          updatedPages.add(
            PageData(
              data: updatedPageData,
              prependKey: page.prependKey,
              appendKey: page.appendKey,
            ),
          );
        } else {
          updatedPages.add(page);
        }

        itemIndexAcrossPages += pageSize;
      }

      value = Paging(state: currentValue.state, data: updatedPages);
    } catch (error, stackTrace) {
      setError(error: error, stackTrace: stackTrace);
    }
  }
}

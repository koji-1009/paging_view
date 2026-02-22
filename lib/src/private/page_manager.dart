import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';

/// A [ValueNotifier] that manages the `PageManagerState` of a paging view.
///
/// This class handles the state for data loading, page management, and item
/// manipulations (add, update, remove).
class PageManager<PageKey, Value>
    extends ValueNotifier<PageManagerState<PageKey, Value>> {
  /// Creates a [PageManager] with an initial empty state.
  PageManager() : super(Paging.init());

  /// Whether a data loading operation is currently in progress.
  bool get isLoading => value.isLoading;

  /// The key for prepending more data, if available.
  PageKey? get prependPageKey => value.prependPageKey;

  /// The key for appending more data, if available.
  PageKey? get appendPageKey => value.appendPageKey;

  /// A flattened list of all items from all loaded pages.
  List<Value> get values => value.items;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Transitions the manager to a loading state for the given `LoadType`.
  void changeState({required LoadType type}) {
    if (_disposed) {
      return;
    }

    value = Paging(
      state: LoadStateLoading(state: type),
      data: value.pages,
    );
  }

  /// Transitions the manager to a [Warning] state with the given [error].
  void setError({required Object error, required StackTrace? stackTrace}) {
    if (_disposed) {
      return;
    }

    value = Warning(error: error, stackTrace: stackTrace);
  }

  /// Reverts a loading state back to a loaded state without changing the data.
  ///
  /// This is used when an error policy is active to revert to the loaded state
  /// instead of showing an error.
  void revertLoad() {
    if (_disposed) {
      return;
    }

    final currentVal = value;
    if (currentVal is Paging<PageKey, Value> &&
        currentVal.state is LoadStateLoading) {
      value = Paging(state: const LoadStateLoaded(), data: currentVal.data);
    }
  }

  /// Replaces all existing pages with a new single [newPage].
  ///
  /// If [newPage] is null, all pages are cleared.
  void refresh({required PageData<PageKey, Value>? newPage}) {
    if (_disposed) {
      return;
    }

    if (newPage == null) {
      value = Paging(state: const LoadStateLoaded(), data: const []);
      return;
    }

    value = Paging(state: const LoadStateLoaded(), data: [newPage]);
  }

  /// Adds a [newPage] to the beginning of the list of pages.
  ///
  /// If [newPage] is null, the state remains unchanged.
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

  /// Adds a [newPage] to the end of the list of pages.
  ///
  /// If [newPage] is null, the state remains unchanged.
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

  /// Updates a single item at the specified [index].
  ///
  /// The `update` function provides the current item and should return the
  /// updated item.
  /// If [index] is out of bounds or an error occurs in `update`, the manager
  /// will transition to a [Warning] state.
  void updateItem(int index, Value Function(Value item) update) {
    if (_disposed) {
      return;
    }

    final currentValue = value;
    if (currentValue is! Paging<PageKey, Value>) {
      return;
    }

    try {
      final totalItems = _getTotalItemCount(currentValue);
      if (index < 0 || index >= totalItems) {
        throw RangeError.range(index, 0, totalItems - 1, 'index');
      }

      value = _updatePages(currentValue, (page, startIndex) {
        final pageSize = page.data.length;
        if (index >= startIndex && index < startIndex + pageSize) {
          final indexInPage = index - startIndex;
          final updatedPageData = List<Value>.from(page.data);
          updatedPageData[indexInPage] = update(page.data[indexInPage]);
          return updatedPageData;
        }
        return page.data;
      });
    } catch (error, stackTrace) {
      setError(error: error, stackTrace: stackTrace);
    }
  }

  /// Updates all items currently in the list.
  ///
  /// The `update` function provides the global index and the current item,
  /// and should return the updated item.
  /// If an error occurs in `update`, the manager transitions to a [Warning] state.
  void updateItems(Value Function(int index, Value item) update) {
    if (_disposed) {
      return;
    }

    final currentValue = value;
    if (currentValue is! Paging<PageKey, Value>) {
      return;
    }

    try {
      value = _updatePages(currentValue, (page, startIndex) {
        final updatedPageData = <Value>[];
        for (var i = 0; i < page.data.length; i++) {
          final globalIndex = startIndex + i;
          updatedPageData.add(update(globalIndex, page.data[i]));
        }
        return updatedPageData;
      });
    } catch (error, stackTrace) {
      setError(error: error, stackTrace: stackTrace);
    }
  }

  /// Removes the item at the specified [index].
  ///
  /// If a page becomes empty after removing the item, the page itself is
  /// also removed.
  /// If [index] is out of bounds, the manager transitions to a [Warning] state.
  void removeItem(int index) {
    if (_disposed) {
      return;
    }

    final currentValue = value;
    if (currentValue is! Paging<PageKey, Value>) {
      return;
    }

    try {
      final totalItems = _getTotalItemCount(currentValue);
      if (index < 0 || index >= totalItems) {
        throw RangeError.range(index, 0, totalItems - 1, 'index');
      }

      value = _updatePages(currentValue, (page, startIndex) {
        final pageSize = page.data.length;
        if (index >= startIndex && index < startIndex + pageSize) {
          final indexInPage = index - startIndex;
          final updatedPageData = List<Value>.from(page.data);
          updatedPageData.removeAt(indexInPage);
          return updatedPageData;
        }
        return page.data;
      });
    } catch (error, stackTrace) {
      setError(error: error, stackTrace: stackTrace);
    }
  }

  /// Removes all items that satisfy the given [test] predicate.
  ///
  /// The [test] function provides the global index and the item. If it returns
  /// `true`, the item is removed.
  /// If a page becomes empty after removing items, it is also removed.
  /// If an error occurs in [test], the manager transitions to a [Warning] state.
  void removeItems(bool Function(int index, Value item) test) {
    if (_disposed) {
      return;
    }

    final currentValue = value;
    if (currentValue is! Paging<PageKey, Value>) {
      return;
    }

    try {
      value = _updatePages(currentValue, (page, startIndex) {
        final updatedPageData = <Value>[];
        for (var i = 0; i < page.data.length; i++) {
          final globalIndex = startIndex + i;
          final item = page.data[i];
          if (!test(globalIndex, item)) {
            updatedPageData.add(item);
          }
        }
        return updatedPageData;
      });
    } catch (error, stackTrace) {
      setError(error: error, stackTrace: stackTrace);
    }
  }

  /// Inserts an [item] at the specified [index].
  ///
  /// This method correctly finds the page where the item should be inserted.
  /// If [index] is equal to the total number of items, the item is appended
  /// to the last page.
  /// If [index] is out of bounds, the manager transitions to a [Warning] state.
  void insertItem(int index, Value item) {
    if (_disposed) {
      return;
    }

    final currentValue = value;
    if (currentValue is! Paging<PageKey, Value>) {
      return;
    }

    try {
      final totalItems = _getTotalItemCount(currentValue);
      if (index < 0 || index > totalItems) {
        throw RangeError.range(index, 0, totalItems, 'index');
      }

      // Special case: insert at the end
      if (index == totalItems) {
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

      value = _updatePages(currentValue, (page, startIndex) {
        final pageSize = page.data.length;
        if (index >= startIndex && index < startIndex + pageSize) {
          final indexInPage = index - startIndex;
          final updatedPageData = List<Value>.from(page.data);
          updatedPageData.insert(indexInPage, item);
          return updatedPageData;
        }
        return page.data;
      });
    } catch (error, stackTrace) {
      setError(error: error, stackTrace: stackTrace);
    }
  }

  int _getTotalItemCount(Paging<PageKey, Value> paging) {
    int count = 0;
    for (final page in paging.data) {
      count += page.data.length;
    }
    return count;
  }

  /// Helper to iterate and update pages without mutating external variables
  Paging<PageKey, Value> _updatePages(
    Paging<PageKey, Value> currentVal,
    Iterable<Value> Function(PageData<PageKey, Value> page, int startIndex)
    processor,
  ) {
    var itemIndexAcrossPages = 0;
    final updatedPages = <PageData<PageKey, Value>>[];

    for (final page in currentVal.pages) {
      final newItems = processor(page, itemIndexAcrossPages).toList();
      if (newItems.isNotEmpty) {
        updatedPages.add(
          PageData(
            data: newItems,
            prependKey: page.prependKey,
            appendKey: page.appendKey,
          ),
        );
      }
      itemIndexAcrossPages += page.data.length;
    }

    return Paging(state: currentVal.state, data: updatedPages);
  }
}

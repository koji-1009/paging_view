import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';

/// Represents the state of a [CenterPageManager], managing three segments:
/// Prepend, Center, and Append.
sealed class CenterPageManagerState<PageKey, Value> {
  /// Creates a [CenterPageManagerState].
  const CenterPageManagerState();

  /// Pages loaded via prepend operations.
  List<PageData<PageKey, Value>> get prependPages;

  /// The initial/center pages loaded via refresh.
  List<PageData<PageKey, Value>> get centerPages;

  /// Pages loaded via append operations.
  List<PageData<PageKey, Value>> get appendPages;

  /// A flattened list of prepend items.
  List<Value> get prependItems;

  /// A flattened list of center items.
  List<Value> get centerItems;

  /// A flattened list of append items.
  List<Value> get appendItems;

  /// A flattened list of all items in display order.
  List<Value> get allItems;
}

/// A state representing successfully loaded pages of data for center paging.
@immutable
class CenterPaging<PageKey, Value>
    extends CenterPageManagerState<PageKey, Value> {
  /// Creates a [CenterPaging] state.
  CenterPaging({
    required this.state,
    required this.prependPages,
    required this.centerPages,
    required this.appendPages,
  });

  /// Creates an initial [CenterPaging] state with no data.
  factory CenterPaging.init() => CenterPaging(
    state: const LoadStateInit(),
    prependPages: const [],
    centerPages: const [],
    appendPages: const [],
  );

  /// The current loading state.
  final LoadState state;

  /// Pages loaded via prepend operations.
  /// These are displayed in reverse order (most recent prepend first).
  @override
  final List<PageData<PageKey, Value>> prependPages;

  /// The initial/center pages loaded via refresh.
  @override
  final List<PageData<PageKey, Value>> centerPages;

  /// Pages loaded via append operations.
  @override
  final List<PageData<PageKey, Value>> appendPages;

  /// A flattened list of prepend items.
  @override
  late final List<Value> prependItems = [
    for (final page in prependPages) ...page.data,
  ];

  /// A flattened list of center items.
  @override
  late final List<Value> centerItems = [
    for (final page in centerPages) ...page.data,
  ];

  /// A flattened list of append items.
  @override
  late final List<Value> appendItems = [
    for (final page in appendPages) ...page.data,
  ];

  /// A flattened list of all items in display order.
  @override
  late final List<Value> allItems = [
    ...prependItems,
    ...centerItems,
    ...appendItems,
  ];

  @override
  String toString() =>
      'CenterPaging(state: $state, prependPages: $prependPages, centerPages: $centerPages, appendPages: $appendPages)';

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (runtimeType == other.runtimeType &&
          other is CenterPaging<PageKey, Value> &&
          (identical(other.state, state) || other.state == state) &&
          const DeepCollectionEquality().equals(
            other.prependPages,
            prependPages,
          ) &&
          const DeepCollectionEquality().equals(
            other.centerPages,
            centerPages,
          ) &&
          const DeepCollectionEquality().equals(
            other.appendPages,
            appendPages,
          ));

  @override
  int get hashCode => Object.hash(
    runtimeType,
    state,
    const DeepCollectionEquality().hash(prependPages),
    const DeepCollectionEquality().hash(centerPages),
    const DeepCollectionEquality().hash(appendPages),
  );
}

/// A state representing an error that occurred during data processing.
@immutable
class CenterWarning<PageKey, Value>
    extends CenterPageManagerState<PageKey, Value> {
  /// Creates a [CenterWarning] state.
  const CenterWarning({required this.error, required this.stackTrace});

  /// The error that occurred.
  final Object error;

  /// The stack trace associated with the error, if available.
  final StackTrace? stackTrace;

  @override
  String toString() => 'CenterWarning(error: $error, stackTrace: $stackTrace)';

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (runtimeType == other.runtimeType &&
          other is CenterWarning<PageKey, Value> &&
          (identical(other.error, error) || other.error == error) &&
          (identical(other.stackTrace, stackTrace) ||
              other.stackTrace == stackTrace));

  @override
  int get hashCode => Object.hash(runtimeType, error, stackTrace);

  /// A flattened list of prepend items.
  @override
  List<Value> get prependItems => const [];

  /// A flattened list of center items.
  @override
  List<Value> get centerItems => const [];

  /// A flattened list of append items.
  @override
  List<Value> get appendItems => const [];

  /// A flattened list of all items in display order.
  @override
  List<Value> get allItems => const [];

  /// Pages loaded via prepend operations.
  @override
  List<PageData<PageKey, Value>> get prependPages => const [];

  /// The initial/center pages loaded via refresh.
  @override
  List<PageData<PageKey, Value>> get centerPages => const [];

  /// Pages loaded via append operations.
  @override
  List<PageData<PageKey, Value>> get appendPages => const [];
}

/// Provides convenient accessors for [CenterPageManagerState].
extension CenterPagingStateExt<PageKey, Value>
    on CenterPageManagerState<PageKey, Value> {
  /// Whether any loading operation is currently in progress.
  bool get isLoading => switch (this) {
    CenterPaging(:final state) =>
      state.isInitLoading ||
          state.isRefreshLoading ||
          state.isPrependLoading ||
          state.isAppendLoading,
    CenterWarning() => false,
  };

  /// The key for prepending more data, if available.
  ///
  /// This comes from the first prepend page, or if none exist,
  /// from the first center page.
  PageKey? get prependPageKey {
    switch (this) {
      case CenterPaging(:final prependPages, :final centerPages):
        if (prependPages.isNotEmpty) {
          return prependPages.first.prependKey;
        }
        return centerPages.firstOrNull?.prependKey;
      case CenterWarning():
        return null;
    }
  }

  /// The key for appending more data, if available.
  ///
  /// This comes from the last append page, or if none exist,
  /// from the last center page.
  PageKey? get appendPageKey {
    switch (this) {
      case CenterPaging(:final appendPages, :final centerPages):
        if (appendPages.isNotEmpty) {
          return appendPages.last.appendKey;
        }
        return centerPages.lastOrNull?.appendKey;
      case CenterWarning():
        return null;
    }
  }
}

/// A [ValueNotifier] that manages the [CenterPageManagerState] for center paging.
///
/// This class handles the state for data loading with three separate segments:
/// Prepend, Center, and Append.
class CenterPageManager<PageKey, Value>
    extends ValueNotifier<CenterPageManagerState<PageKey, Value>> {
  /// Creates a [CenterPageManager] with an initial empty state.
  CenterPageManager() : super(CenterPaging.init());

  /// Whether a data loading operation is currently in progress.
  bool get isLoading => value.isLoading;

  /// The key for prepending more data, if available.
  PageKey? get prependPageKey => value.prependPageKey;

  /// The key for appending more data, if available.
  PageKey? get appendPageKey => value.appendPageKey;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Transitions the manager to a loading state for the given [type].
  ///
  /// For `LoadType.prepend`, this also moves any existing `prependPages` to
  /// the beginning of `centerPages`. This leverages `CustomScrollView`'s
  /// center key behavior: by clearing prependPages at the start of loading,
  /// the centerKey sliver becomes the topmost content, and when the new
  /// prepend data arrives, it will appear above without causing scroll jumps.
  void changeState({required LoadType type}) {
    if (_disposed) {
      return;
    }

    final currentValue = value;
    if (currentValue is CenterPaging<PageKey, Value>) {
      // For prepend, move existing prependPages to centerPages
      value = switch (type) {
        LoadType.prepend => CenterPaging(
          state: LoadStateLoading(state: type),
          prependPages: const [],
          centerPages: [
            ...currentValue.prependPages,
            ...currentValue.centerPages,
          ],
          appendPages: currentValue.appendPages,
        ),
        LoadType.append => CenterPaging(
          state: LoadStateLoading(state: type),
          prependPages: currentValue.prependPages,
          centerPages: [
            ...currentValue.centerPages,
            ...currentValue.appendPages,
          ],
          appendPages: const [],
        ),
        _ => CenterPaging(
          state: LoadStateLoading(state: type),
          prependPages: currentValue.prependPages,
          centerPages: currentValue.centerPages,
          appendPages: currentValue.appendPages,
        ),
      };
    }
  }

  /// Transitions the manager to a [CenterWarning] state with the given [error].
  void setError({required Object error, required StackTrace? stackTrace}) {
    if (_disposed) {
      return;
    }

    value = CenterWarning(error: error, stackTrace: stackTrace);
  }

  /// Reverts a loading state back to a loaded state without changing the data.
  void revertLoad() {
    if (_disposed) {
      return;
    }

    final currentVal = value;
    if (currentVal is CenterPaging<PageKey, Value> &&
        currentVal.state is LoadStateLoading) {
      value = CenterPaging(
        state: const LoadStateLoaded(),
        prependPages: currentVal.prependPages,
        centerPages: currentVal.centerPages,
        appendPages: currentVal.appendPages,
      );
    }
  }

  /// Sets the center pages with a new single [newPage], clearing all segments.
  ///
  /// If [newPage] is null, all pages are cleared.
  void setCenter({required PageData<PageKey, Value>? newPage}) {
    if (_disposed) {
      return;
    }

    if (newPage == null) {
      value = CenterPaging(
        state: const LoadStateLoaded(),
        prependPages: const [],
        centerPages: const [],
        appendPages: const [],
      );
      return;
    }

    value = CenterPaging(
      state: const LoadStateLoaded(),
      prependPages: const [],
      centerPages: [newPage],
      appendPages: const [],
    );
  }

  /// Refreshes and sets the center pages, clearing prepend and append.
  void refresh({required PageData<PageKey, Value>? newPage}) {
    if (_disposed) {
      return;
    }

    if (newPage == null) {
      value = CenterPaging(
        state: const LoadStateLoaded(),
        prependPages: const [],
        centerPages: const [],
        appendPages: const [],
      );
      return;
    }

    value = CenterPaging(
      state: const LoadStateLoaded(),
      prependPages: const [],
      centerPages: [newPage],
      appendPages: const [],
    );
  }

  /// Adds a [newPage] to the prepend segment.
  ///
  /// This method is called after the prepend request completes. The existing
  /// `prependPages` were already moved to `centerPages` when `changeState`
  /// was called with `LoadType.prepend`.
  ///
  /// If [newPage] is null, the state remains unchanged but loading ends.
  void prepend({required PageData<PageKey, Value>? newPage}) {
    if (_disposed) {
      return;
    }

    final currentVal = value;
    if (currentVal is! CenterPaging<PageKey, Value>) {
      return;
    }

    if (newPage == null) {
      value = CenterPaging(
        state: const LoadStateLoaded(),
        prependPages: currentVal.prependPages,
        centerPages: currentVal.centerPages,
        appendPages: currentVal.appendPages,
      );
      return;
    }

    value = CenterPaging(
      state: const LoadStateLoaded(),
      prependPages: [newPage],
      centerPages: currentVal.centerPages,
      appendPages: currentVal.appendPages,
    );
  }

  /// Adds a [newPage] to the append segment.
  ///
  /// Appended pages are simply added to the end of `appendPages`.
  /// If [newPage] is null, the state remains unchanged but loading ends.
  void append({required PageData<PageKey, Value>? newPage}) {
    if (_disposed) {
      return;
    }

    final currentVal = value;
    if (currentVal is! CenterPaging<PageKey, Value>) {
      return;
    }

    if (newPage == null) {
      value = CenterPaging(
        state: const LoadStateLoaded(),
        prependPages: currentVal.prependPages,
        centerPages: currentVal.centerPages,
        appendPages: currentVal.appendPages,
      );
      return;
    }

    value = CenterPaging(
      state: const LoadStateLoaded(),
      prependPages: currentVal.prependPages,
      centerPages: [...currentVal.centerPages, ...currentVal.appendPages],
      appendPages: [newPage],
    );
  }

  /// Helper to safely recreate PageData with updated list of items.
  PageData<PageKey, Value> _createUpdatedPage(
    PageData<PageKey, Value> original,
    List<Value> updatedData,
  ) {
    return PageData(
      data: updatedData,
      prependKey: original.prependKey,
      appendKey: original.appendKey,
    );
  }

  /// Updates a single item at the specified [index] across all segments.
  void updateItem(int index, Value Function(Value item) update) {
    if (_disposed) {
      return;
    }

    final currentVal = value;
    if (currentVal is! CenterPaging<PageKey, Value>) {
      return;
    }

    try {
      final totalItems = _getTotalItemCount(currentVal);
      if (index < 0 || index >= totalItems) {
        throw RangeError.range(index, 0, totalItems - 1, 'index');
      }

      value = _updateSegments(currentVal, (page, startIndex) {
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

  /// Updates all items currently in the list across all segments.
  void updateItems(Value Function(int index, Value item) update) {
    if (_disposed) {
      return;
    }

    final currentVal = value;
    if (currentVal is! CenterPaging<PageKey, Value>) {
      return;
    }

    try {
      value = _updateSegments(currentVal, (page, startIndex) {
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

  /// Removes the item at the specified [index] across all segments.
  void removeItem(int index) {
    if (_disposed) {
      return;
    }

    final currentVal = value;
    if (currentVal is! CenterPaging<PageKey, Value>) {
      return;
    }

    try {
      final totalItems = _getTotalItemCount(currentVal);
      if (index < 0 || index >= totalItems) {
        throw RangeError.range(index, 0, totalItems - 1, 'index');
      }

      value = _updateSegments(currentVal, (page, startIndex) {
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
  void removeItems(bool Function(int index, Value item) test) {
    if (_disposed) {
      return;
    }

    final currentVal = value;
    if (currentVal is! CenterPaging<PageKey, Value>) {
      return;
    }

    try {
      value = _updateSegments(currentVal, (page, startIndex) {
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
  void insertItem(int index, Value item) {
    if (_disposed) {
      return;
    }

    final currentVal = value;
    if (currentVal is! CenterPaging<PageKey, Value>) {
      return;
    }

    try {
      final totalItems = _getTotalItemCount(currentVal);
      if (index < 0 || index > totalItems) {
        throw RangeError.range(index, 0, totalItems, 'index');
      }

      // Special case: insert into an empty list
      if (totalItems == 0) {
        value = CenterPaging(
          state: currentVal.state,
          prependPages: const [],
          centerPages: [
            PageData(data: [item]),
          ],
          appendPages: const [],
        );
        return;
      }

      // Identifies the last non-empty segment to append if inserting at the very end
      List<PageData<PageKey, Value>> getLastSegmentToAppend() {
        if (currentVal.appendPages.isNotEmpty) return currentVal.appendPages;
        if (currentVal.centerPages.isNotEmpty) return currentVal.centerPages;
        return currentVal.prependPages;
      }

      if (index == totalItems) {
        final targetSegment = getLastSegmentToAppend();
        final lastPage = targetSegment.last;

        final newLastPage = _createUpdatedPage(lastPage, [
          ...lastPage.data,
          item,
        ]);

        if (targetSegment == currentVal.appendPages) {
          value = CenterPaging(
            state: currentVal.state,
            prependPages: currentVal.prependPages,
            centerPages: currentVal.centerPages,
            appendPages: [
              ...currentVal.appendPages.take(currentVal.appendPages.length - 1),
              newLastPage,
            ],
          );
        } else if (targetSegment == currentVal.centerPages) {
          value = CenterPaging(
            state: currentVal.state,
            prependPages: currentVal.prependPages,
            centerPages: [
              ...currentVal.centerPages.take(currentVal.centerPages.length - 1),
              newLastPage,
            ],
            appendPages: currentVal.appendPages,
          );
        } else {
          value = CenterPaging(
            state: currentVal.state,
            prependPages: [
              ...currentVal.prependPages.take(
                currentVal.prependPages.length - 1,
              ),
              newLastPage,
            ],
            centerPages: currentVal.centerPages,
            appendPages: currentVal.appendPages,
          );
        }
        return;
      }

      value = _updateSegments(currentVal, (page, startIndex) {
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

  int _getTotalItemCount(CenterPaging<PageKey, Value> paging) {
    int count = 0;
    for (final page in paging.prependPages) {
      count += page.data.length;
    }
    for (final page in paging.centerPages) {
      count += page.data.length;
    }
    for (final page in paging.appendPages) {
      count += page.data.length;
    }
    return count;
  }

  /// Helper to iterate and update segments without mutating external variables
  CenterPaging<PageKey, Value> _updateSegments(
    CenterPaging<PageKey, Value> currentVal,
    Iterable<Value> Function(PageData<PageKey, Value> page, int startIndex)
    processor,
  ) {
    var itemIndexAcrossPages = 0;

    List<PageData<PageKey, Value>> processSegment(
      List<PageData<PageKey, Value>> segment,
    ) {
      final updatedSegment = <PageData<PageKey, Value>>[];
      for (final page in segment) {
        final newItems = processor(page, itemIndexAcrossPages).toList();
        if (newItems.isNotEmpty) {
          updatedSegment.add(_createUpdatedPage(page, newItems));
        }
        itemIndexAcrossPages += page.data.length;
      }
      return updatedSegment;
    }

    return CenterPaging(
      state: currentVal.state,
      prependPages: processSegment(currentVal.prependPages),
      centerPages: processSegment(currentVal.centerPages),
      appendPages: processSegment(currentVal.appendPages),
    );
  }
}

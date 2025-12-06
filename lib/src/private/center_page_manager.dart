import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';

/// Represents the state of a [CenterPageManager], managing three segments:
/// Prepend, Center, and Append.
sealed class CenterPageManagerState<PageKey, Value> {
  /// Creates a [CenterPageManagerState].
  const CenterPageManagerState();
}

/// A state representing successfully loaded pages of data for center paging.
class CenterPaging<PageKey, Value>
    extends CenterPageManagerState<PageKey, Value> {
  /// Creates a [CenterPaging] state.
  const CenterPaging({
    required this.state,
    required this.prependPages,
    required this.centerPages,
    required this.appendPages,
  });

  /// Creates an initial [CenterPaging] state with no data.
  factory CenterPaging.init() => const CenterPaging(
    state: LoadStateInit(),
    prependPages: [],
    centerPages: [],
    appendPages: [],
  );

  /// The current loading state.
  final LoadState state;

  /// Pages loaded via prepend operations.
  /// These are displayed in reverse order (most recent prepend first).
  final List<PageData<PageKey, Value>> prependPages;

  /// The initial/center pages loaded via refresh.
  final List<PageData<PageKey, Value>> centerPages;

  /// Pages loaded via append operations.
  final List<PageData<PageKey, Value>> appendPages;

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

  /// The prepend pages (displayed in reverse order in the UI).
  List<PageData<PageKey, Value>> get prependPages => switch (this) {
    CenterPaging(:final prependPages) => prependPages,
    CenterWarning() => const [],
  };

  /// The center pages (the initial anchor point).
  List<PageData<PageKey, Value>> get centerPages => switch (this) {
    CenterPaging(:final centerPages) => centerPages,
    CenterWarning() => const [],
  };

  /// The append pages.
  List<PageData<PageKey, Value>> get appendPages => switch (this) {
    CenterPaging(:final appendPages) => appendPages,
    CenterWarning() => const [],
  };

  /// A flattened list of prepend items.
  List<Value> get prependItems => [
    ...prependPages.map((e) => e.data).flattened,
  ];

  /// A flattened list of center items.
  List<Value> get centerItems => [...centerPages.map((e) => e.data).flattened];

  /// A flattened list of append items.
  List<Value> get appendItems => [...appendPages.map((e) => e.data).flattened];

  /// A flattened list of all items in display order.
  List<Value> get allItems => [...prependItems, ...centerItems, ...appendItems];
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
  /// For [LoadType.prepend], this also moves any existing [prependPages] to
  /// the beginning of [centerPages]. This leverages [CustomScrollView]'s
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
      value = const CenterPaging(
        state: LoadStateLoaded(),
        prependPages: [],
        centerPages: [],
        appendPages: [],
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
      value = const CenterPaging(
        state: LoadStateLoaded(),
        prependPages: [],
        centerPages: [],
        appendPages: [],
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
  /// [prependPages] were already moved to [centerPages] when [changeState]
  /// was called with [LoadType.prepend].
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
  /// Appended pages are simply added to the end of [appendPages].
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
}

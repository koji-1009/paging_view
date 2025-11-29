import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';
import 'package:paging_view/src/private/page_manager.dart';

/// Defines how the [DataSource] should recover from a non-critical error
/// during a `prepend` or `append` operation.
enum ErrorRecovery {
  /// Transitions the entire view into an error state, requiring a `refresh`
  /// to recover. This is the default behavior.
  forceRefresh,

  /// Reverts the loading state to allow for another attempt. The error is
  /// reported via the `onLoadFinished` callback, allowing the UI to show a
  /// "retry" button.
  allowRetry,
}

/// The core of the paging_view library, acting as the bridge between a data
/// source (like a network API or local database) and the UI.
///
/// [DataSource] is an abstract class responsible for fetching paginated data,
/// managing pagination state (keys, loading status), and notifying UI widgets
/// of changes.
///
/// To use it, you must extend this class and implement the [load] method,
/// which contains your specific data-fetching logic. The [DataSource] then
/// handles the state of your data (loading, success, error) and provides it
/// to `paging_view` widgets like `PagingList` or `PagingGrid`.
abstract class DataSource<PageKey, Value> {
  /// Creates a [DataSource].
  DataSource({
    this.errorRecovery = ErrorRecovery.forceRefresh,
    this.onLoadFinished,
  });

  /// The strategy for recovering from `prepend` or `append` errors.
  final ErrorRecovery errorRecovery;

  /// A callback invoked after every `load` operation completes, providing the
  /// [LoadResult]. Useful for analytics or showing temporary error messages.
  final void Function(
    LoadAction<PageKey> action,
    LoadResult<PageKey, Value> result,
  )?
  onLoadFinished;

  /// Loads a page of data based on the specified [LoadAction].
  ///
  /// This is the central method of the `DataSource` and **must be implemented**
  /// by your subclass. Your implementation should:
  ///
  /// 1.  Determine the type of load action (`Refresh`, `Prepend`, `Append`).
  /// 2.  Fetch data from your source (e.g., make an API call).
  /// 3.  Return a [LoadResult] to represent the outcome:
  ///     - [Success]: If data was fetched successfully, containing a [PageData].
  ///     - [Failure]: If an error occurred.
  ///     - [None]: If the load was skipped or no data was returned (e.g., end of list).
  @protected
  Future<LoadResult<PageKey, Value>> load(LoadAction<PageKey> action);

  final _manager = PageManager<PageKey, Value>();

  /// The underlying state manager for the data source.
  ///
  /// This `ChangeNotifier` holds the current list of items, pagination state,
  /// and loading status. It is primarily used internally by `paging_view`
  /// widgets to listen for updates and rebuild the UI.
  PageManager<PageKey, Value> get notifier => _manager;

  /// Releases the resources used by this [DataSource].
  ///
  /// This should be called when the `DataSource` is no longer needed (e.g., in
  /// a `StatefulWidget`'s `dispose` method) to prevent memory leaks by
  /// disposing of the underlying [ValueNotifier].
  @mustCallSuper
  void dispose() {
    _manager.dispose();
  }

  /// Registers a callback to be invoked when the data or loading state changes.
  void addListener(VoidCallback listener) {
    _manager.addListener(listener);
  }

  /// Removes a previously registered callback.
  void removeListener(VoidCallback listener) {
    _manager.removeListener(listener);
  }

  /// Updates a single item in the list at the specified [index].
  ///
  /// The [update] function receives the current item and should return the new,
  /// updated item. This method notifies listeners and is useful for localized
  /// state changes (e.g., toggling a "favorite" status) without a full refresh.
  ///
  /// If the [index] is out of range, an error will be set in the `PageManager`.
  void updateItem(int index, Value Function(Value item) update) {
    _manager.updateItem(index, update);
  }

  /// Updates all items currently in the list and notifies listeners.
  ///
  /// The [update] function is called for each item, providing its `index` and
  /// current `item`, and should return the new item.
  ///
  /// If the update function throws an error, it will be caught and set in the
  /// `PageManager`.
  void updateItems(Value Function(int index, Value item) update) {
    _manager.updateItems(update);
  }

  /// Removes a single item at the specified [index] and notifies listeners.
  ///
  /// If the [index] is out of range, an error will be set in the `PageManager`.
  void removeItem(int index) {
    _manager.removeItem(index);
  }

  /// Removes all items that satisfy the given [test] and notifies listeners.
  ///
  /// The [test] function receives the `index` and `item` of each element and
  /// should return `true` if the item should be removed. This is similar to
  /// [List.removeWhere].
  ///
  /// If the test function throws an error, it will be caught and set in the
  /// `PageManager`.
  void removeItems(bool Function(int index, Value item) test) {
    _manager.removeItems(test);
  }

  /// Inserts an [item] at the specified [index] and notifies listeners.
  ///
  /// If the [index] is out of range, an error will be set in the `PageManager`.
  void insertItem(int index, Value item) {
    _manager.insertItem(index, item);
  }

  /// Triggers a full refresh of the data, discarding the existing items.
  ///
  /// This calls the [load] method with a [Refresh] action. If a load is already
  /// in progress, this method does nothing.
  Future<void> refresh() async {
    try {
      await _refresh();
    } catch (error, stackTrace) {
      _manager.setError(error: error, stackTrace: stackTrace);
    }
  }

  /// Triggers a prepend operation to load data before the current items.
  ///
  /// This calls the [load] method with a [Prepend] action, using the current
  /// `prependPageKey`. If the key is `null` or a load is in progress, this
  /// method does nothing.
  Future<void> prepend() async {
    try {
      await _prepend();
    } catch (error, stackTrace) {
      _manager.setError(error: error, stackTrace: stackTrace);
    }
  }

  /// Triggers an append operation to load data after the current items.
  ///
  /// This calls the [load] method with an [Append] action, using the current
  /// `appendPageKey`. If the key is `null` or a load is in progress, this
  /// method does nothing.
  Future<void> append() async {
    try {
      await _append();
    } catch (error, stackTrace) {
      _manager.setError(error: error, stackTrace: stackTrace);
    }
  }

  /// Called by `paging_view` widgets to trigger a data load.
  ///
  /// This method is intended for internal use by the library. You should
  /// typically call [refresh] directly or rely on UI widgets to trigger
  /// `prepend` and `append` actions automatically.
  @internal
  Future<void> update(LoadType type) async {
    switch (type) {
      case LoadType.init:
        await _init();
      case LoadType.refresh:
        await _refresh();
      case LoadType.prepend:
        await _prepend();
      case LoadType.append:
        await _append();
    }
  }

  Future<void> _init() async {
    _manager.changeState(type: LoadType.init);

    try {
      final result = await load(const Refresh());
      onLoadFinished?.call(const Refresh(), result);
      switch (result) {
        case Success(:final page):
          _manager.append(newPage: page);
        case Failure(:final error, :final stackTrace):
          _manager.setError(error: error, stackTrace: stackTrace);
        case None():
          _manager.append(newPage: null);
      }
    } catch (error, stackTrace) {
      onLoadFinished?.call(
        const Refresh(),
        Failure(error: error, stackTrace: stackTrace),
      );
      _manager.setError(error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _refresh() async {
    if (_manager.isLoading) {
      return;
    }

    _manager.changeState(type: LoadType.refresh);
    try {
      final result = await load(const Refresh());
      onLoadFinished?.call(const Refresh(), result);
      switch (result) {
        case Success(:final page):
          _manager.refresh(newPage: page);
        case Failure(:final error, :final stackTrace):
          _manager.setError(error: error, stackTrace: stackTrace);
        case None():
          _manager.refresh(newPage: null);
      }
    } catch (error, stackTrace) {
      onLoadFinished?.call(
        const Refresh(),
        Failure(error: error, stackTrace: stackTrace),
      );
      _manager.setError(error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _prepend() async {
    if (_manager.isLoading) {
      return;
    }

    final key = _manager.prependPageKey;
    if (key == null) {
      return;
    }

    _manager.changeState(type: LoadType.prepend);
    try {
      final result = await load(Prepend(key: key));
      onLoadFinished?.call(Prepend(key: key), result);
      switch (result) {
        case Success(:final page):
          _manager.prepend(newPage: page);
        case Failure(:final error, :final stackTrace):
          switch (errorRecovery) {
            case ErrorRecovery.forceRefresh:
              _manager.setError(error: error, stackTrace: stackTrace);
            case ErrorRecovery.allowRetry:
              _manager.revertLoad();
          }
        case None():
          _manager.prepend(newPage: null);
      }
    } catch (error, stackTrace) {
      onLoadFinished?.call(
        Prepend(key: key),
        Failure(error: error, stackTrace: stackTrace),
      );
      switch (errorRecovery) {
        case ErrorRecovery.forceRefresh:
          _manager.setError(error: error, stackTrace: stackTrace);
        case ErrorRecovery.allowRetry:
          _manager.revertLoad();
      }
    }
  }

  Future<void> _append() async {
    if (_manager.isLoading) {
      return;
    }

    final key = _manager.appendPageKey;
    if (key == null) {
      return;
    }

    _manager.changeState(type: LoadType.append);
    try {
      final result = await load(Append(key: key));
      onLoadFinished?.call(Append(key: key), result);
      switch (result) {
        case Success(:final page):
          _manager.append(newPage: page);
        case Failure(:final error, :final stackTrace):
          switch (errorRecovery) {
            case ErrorRecovery.forceRefresh:
              _manager.setError(error: error, stackTrace: stackTrace);
            case ErrorRecovery.allowRetry:
              _manager.revertLoad();
          }
        case None():
          _manager.append(newPage: null);
      }
    } catch (error, stackTrace) {
      onLoadFinished?.call(
        Append(key: key),
        Failure(error: error, stackTrace: stackTrace),
      );
      switch (errorRecovery) {
        case ErrorRecovery.forceRefresh:
          _manager.setError(error: error, stackTrace: stackTrace);
        case ErrorRecovery.allowRetry:
          _manager.revertLoad();
      }
    }
  }
}

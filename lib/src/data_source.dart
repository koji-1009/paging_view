import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';
import 'package:paging_view/src/private/page_manager.dart';

/// The core of the paging_view library.
///
/// [DataSource] is an abstract class responsible for fetching paginated data
/// from a given source (e.g., a network API, a local database). It acts as the
/// bridge between your data layer and the UI widgets ([PagingList], [PagingGrid], etc.).
///
/// To use it, you must extend this class and implement the [load] method,
/// which contains your specific data-fetching logic. The [DataSource] will
/// then manage the state of your data (loading, success, error) and notify
/// the UI to update accordingly.
abstract class DataSource<PageKey, Value> {
  /// Loads a page of data based on the specified [LoadAction].
  ///
  /// This is the central method of the `DataSource` and **must be implemented**
  /// by your subclass. The implementation should:
  ///
  /// 1.  Determine the type of load action (`Refresh`, `Prepend`, `Append`).
  /// 2.  Fetch data from your source (e.g., make an API call).
  /// 3.  Return a [LoadResult]:
  ///     - [Success]: If the data was fetched successfully, containing a [PageData] object.
  ///     - [Failure]: If an error occurred during fetching.
  ///     - [None]: If no data needs to be loaded (e.g., end of list).
  @protected
  Future<LoadResult<PageKey, Value>> load(LoadAction<PageKey> action);

  final _manager = PageManager<PageKey, Value>();

  /// The underlying state manager for the data source.
  ///
  /// While you can use this to listen for changes, it's typically used
  /// internally by the `paging_view` widgets.
  PageManager<PageKey, Value> get notifier => _manager;

  /// Dispose the underlying [PageManager].
  ///
  /// You should call this when the `DataSource` is no longer needed to prevent
  /// memory leaks.
  @mustCallSuper
  void dispose() {
    _manager.dispose();
  }

  /// Add a listener to be notified of data changes.
  void addListener(VoidCallback listener) {
    _manager.addListener(listener);
  }

  /// Remove a previously registered listener.
  void removeListener(VoidCallback listener) {
    _manager.removeListener(listener);
  }

  /// Updates a single item at the specified [index] and notifies listeners.
  ///
  /// The [update] function receives the current item and should return the
  /// new, updated item.
  ///
  /// This is useful for performing localized state changes (e.g., toggling a
  /// "favorite" button) without a full refresh.
  ///
  /// If the index is out of range, an error will be set in the `PageManager`.
  void updateItem(int index, Value Function(Value item) update) {
    _manager.updateItem(index, update);
  }

  /// Updates all items in the list and notifies listeners.
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
  /// If the index is out of range, an error will be set in the `PageManager`.
  void removeItem(int index) {
    _manager.removeItem(index);
  }

  /// Removes all items that satisfy the given [test] and notifies listeners.
  ///
  /// The [test] function receives the `index` and `item` of each element and
  /// should return `true` if the item should be removed.
  ///
  /// This is similar to [List.removeWhere] but operates on the internal state
  /// of the data source.
  /// If the test function throws an error, it will be caught and set in the `PageManager`.
  void removeItems(bool Function(int index, Value item) test) {
    _manager.removeItems(test);
  }

  /// Inserts an [item] at the specified [index] and notifies listeners.
  ///
  /// If the index is out of range, an error will be set in the `PageManager`.
  void insertItem(int index, Value item) {
    _manager.insertItem(index, item);
  }

  /// Triggers a full refresh of the data, discarding the existing items.
  ///
  /// This calls the [load] method with a [Refresh] action.
  Future<void> refresh() async {
    try {
      await _refresh();
    } catch (error, stackTrace) {
      _manager.setError(error: error, stackTrace: stackTrace);
    }
  }

  /// Triggers a prepend operation to load data before the current items.
  ///
  /// This calls the [load] method with a [Prepend] action.
  Future<void> prepend() async {
    try {
      await _prepend();
    } catch (error, stackTrace) {
      _manager.setError(error: error, stackTrace: stackTrace);
    }
  }

  /// Triggers an append operation to load data after the current items.
  ///
  /// This calls the [load] method with an [Append] action.
  Future<void> append() async {
    try {
      await _append();
    } catch (error, stackTrace) {
      _manager.setError(error: error, stackTrace: stackTrace);
    }
  }

  /// Called by `paging_view` widgets to trigger a data load.
  ///
  /// This method is intended for internal use. You should typically call
  /// [refresh], or rely on the UI widgets to trigger `prepend` and `append`
  /// actions automatically.
  @internal
  Future<void> update(LoadType type) async {
    try {
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
    } catch (error, stackTrace) {
      _manager.setError(error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _init() async {
    _manager.changeState(type: LoadType.init);

    final result = await load(const Refresh());
    switch (result) {
      case Success(:final page):
        _manager.append(newPage: page);
      case Failure(:final error, :final stackTrace):
        _manager.setError(error: error, stackTrace: stackTrace);
      case None():
        _manager.append(newPage: null);
    }
  }

  /// Request a refresh via [_manager]
  Future<void> _refresh() async {
    if (_manager.isLoading) {
      // already loading
      return;
    }

    _manager.changeState(type: LoadType.refresh);
    final result = await load(const Refresh());
    switch (result) {
      case Success(:final page):
        _manager.refresh(newPage: page);
      case Failure(:final error, :final stackTrace):
        _manager.setError(error: error, stackTrace: stackTrace);
      case None():
        _manager.refresh(newPage: null);
    }
  }

  /// Request a prepend via [_manager]
  Future<void> _prepend() async {
    if (_manager.isLoading) {
      // already loading
      return;
    }

    final key = _manager.prependPageKey;
    if (key == null) {
      // no more prepend data
      return;
    }

    _manager.changeState(type: LoadType.prepend);
    final result = await load(Prepend(key: key));
    switch (result) {
      case Success(:final page):
        _manager.prepend(newPage: page);
      case Failure(:final error, :final stackTrace):
        _manager.setError(error: error, stackTrace: stackTrace);
      case None():
        _manager.prepend(newPage: null);
    }
  }

  /// Request an append via [_manager]
  Future<void> _append() async {
    if (_manager.isLoading) {
      // already loading
      return;
    }

    final key = _manager.appendPageKey;
    if (key == null) {
      // no more append data
      return;
    }

    _manager.changeState(type: LoadType.append);
    final result = await load(Append(key: key));

    switch (result) {
      case Success(:final page):
        _manager.append(newPage: page);
      case Failure(:final error, :final stackTrace):
        _manager.setError(error: error, stackTrace: stackTrace);
      case None():
        _manager.append(newPage: null);
    }
  }
}

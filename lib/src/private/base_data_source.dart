import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';
import 'package:paging_view/src/private/paging_manager.dart';

/// The load pipeline shared by `DataSource` and `CenterDataSource`.
///
/// Subclasses supply the concrete state manager through [notifier].
abstract class BaseDataSource<
  PageKey,
  Value,
  Manager extends PagingManager<PageKey, Value, Object?>
> {
  /// Creates a [BaseDataSource].
  BaseDataSource({this.errorPolicy = const {}});

  /// Defines the error handling policy for load operations.
  /// By default, all errors are shown in the UI.
  Set<LoadErrorPolicy> errorPolicy;

  /// A callback that is invoked just before a `load` operation begins. It
  /// provides the [LoadAction] that is about to be executed.
  void Function(LoadAction<PageKey> action)? onLoadStarted;

  /// A callback invoked after every `load` operation completes, providing the
  /// [LoadResult]. Useful for analytics or showing temporary error messages.
  void Function(LoadAction<PageKey> action, LoadResult<PageKey, Value> result)?
  onLoadFinished;

  /// The underlying state manager for the data source.
  ///
  /// This `ChangeNotifier` holds the current list of items, pagination state,
  /// and loading status. It is primarily used internally by `paging_view`
  /// widgets to listen for updates and rebuild the UI.
  Manager get notifier;

  /// Loads a page of data based on the specified [LoadAction].
  ///
  /// This is the central method of the data source and **must be implemented**
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

  /// Releases the resources used by this data source.
  ///
  /// This should be called when the data source is no longer needed (e.g., in
  /// a `StatefulWidget`'s `dispose` method) to prevent memory leaks by
  /// disposing of the underlying [ValueNotifier].
  @mustCallSuper
  void dispose() {
    onLoadStarted = null;
    onLoadFinished = null;
    notifier.dispose();
  }

  /// Registers a callback to be invoked when the data or loading state changes.
  void addListener(VoidCallback listener) {
    notifier.addListener(listener);
  }

  /// Removes a previously registered callback.
  void removeListener(VoidCallback listener) {
    notifier.removeListener(listener);
  }

  /// Updates a single item in the list at the specified [index].
  ///
  /// The `update` function receives the current item and should return the new,
  /// updated item. This method notifies listeners and is useful for localized
  /// state changes (e.g., toggling a "favorite" status) without a full refresh.
  ///
  /// If the [index] is out of range, an error will be set in the state manager.
  void updateItem(int index, Value Function(Value item) update) {
    notifier.updateItem(index, update);
  }

  /// Updates all items currently in the list and notifies listeners.
  ///
  /// The `update` function is called for each item, providing its `index` and
  /// current `item`, and should return the new item.
  ///
  /// If the update function throws an error, it will be caught and set in the
  /// state manager.
  void updateItems(Value Function(int index, Value item) update) {
    notifier.updateItems(update);
  }

  /// Removes a single item at the specified [index] and notifies listeners.
  ///
  /// If the [index] is out of range, an error will be set in the state manager.
  void removeItem(int index) {
    notifier.removeItem(index);
  }

  /// Removes all items that satisfy the given [test] and notifies listeners.
  ///
  /// The [test] function receives the `index` and `item` of each element and
  /// should return `true` if the item should be removed. This is similar to
  /// [List.removeWhere].
  ///
  /// If the test function throws an error, it will be caught and set in the
  /// state manager.
  void removeItems(bool Function(int index, Value item) test) {
    notifier.removeItems(test);
  }

  /// Inserts an [item] at the specified [index] and notifies listeners.
  ///
  /// If the [index] is out of range, an error will be set in the state manager.
  void insertItem(int index, Value item) {
    notifier.insertItem(index, item);
  }

  /// Triggers a full refresh of the data, discarding the existing items.
  ///
  /// This calls the [load] method with a [Refresh] action. If a load is already
  /// in progress, this method does nothing.
  Future<void> refresh() async {
    await _refresh();
  }

  /// Triggers a prepend operation to load data before the current items.
  ///
  /// This calls the [load] method with a [Prepend] action, using the current
  /// `prependPageKey`. If the key is `null` or a load is in progress, this
  /// method does nothing.
  Future<void> prepend() async {
    await _prepend();
  }

  /// Triggers an append operation to load data after the current items.
  ///
  /// This calls the [load] method with an [Append] action, using the current
  /// `appendPageKey`. If the key is `null` or a load is in progress, this
  /// method does nothing.
  Future<void> append() async {
    await _append();
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

  /// Whether to skip showing errors during refresh operations.
  bool get _skipRefreshWhenError =>
      errorPolicy.contains(LoadErrorPolicy.ignoreRefresh);

  /// Whether to skip showing errors during prepend operations.
  bool get _skipPrependWhenError =>
      errorPolicy.contains(LoadErrorPolicy.ignorePrepend);

  /// Whether to skip showing errors during append operations.
  bool get _skipAppendWhenError =>
      errorPolicy.contains(LoadErrorPolicy.ignoreAppend);

  Future<void> _init() async {
    if (notifier.isLoading) {
      return;
    }

    notifier.changeState(type: LoadType.init);
    onLoadStarted?.call(const Refresh());

    try {
      final result = await load(const Refresh());
      onLoadFinished?.call(const Refresh(), result);
      switch (result) {
        case Success(:final page):
          notifier.refresh(newPage: page);
        case Failure(:final error, :final stackTrace):
          notifier.setError(error: error, stackTrace: stackTrace);
        case None():
          notifier.refresh(newPage: null);
      }
    } catch (error, stackTrace) {
      onLoadFinished?.call(
        const Refresh(),
        Failure(error: error, stackTrace: stackTrace),
      );
      notifier.setError(error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _refresh() async {
    if (notifier.isLoading) {
      return;
    }

    notifier.changeState(type: LoadType.refresh);
    onLoadStarted?.call(const Refresh());
    try {
      final result = await load(const Refresh());
      onLoadFinished?.call(const Refresh(), result);
      switch (result) {
        case Success(:final page):
          notifier.refresh(newPage: page);
        case Failure(:final error, :final stackTrace):
          _handleFailure(_skipRefreshWhenError, error, stackTrace);
        case None():
          notifier.refresh(newPage: null);
      }
    } catch (error, stackTrace) {
      onLoadFinished?.call(
        const Refresh(),
        Failure(error: error, stackTrace: stackTrace),
      );
      _handleFailure(_skipRefreshWhenError, error, stackTrace);
    }
  }

  Future<void> _prepend() async {
    if (notifier.isLoading) {
      return;
    }

    final key = notifier.prependPageKey;
    if (key == null) {
      return;
    }

    notifier.changeState(type: LoadType.prepend);
    onLoadStarted?.call(Prepend(key: key));
    try {
      final result = await load(Prepend(key: key));
      onLoadFinished?.call(Prepend(key: key), result);
      switch (result) {
        case Success(:final page):
          notifier.prepend(newPage: page);
        case Failure(:final error, :final stackTrace):
          _handleFailure(_skipPrependWhenError, error, stackTrace);
        case None():
          notifier.prepend(newPage: null);
      }
    } catch (error, stackTrace) {
      onLoadFinished?.call(
        Prepend(key: key),
        Failure(error: error, stackTrace: stackTrace),
      );
      _handleFailure(_skipPrependWhenError, error, stackTrace);
    }
  }

  Future<void> _append() async {
    if (notifier.isLoading) {
      return;
    }

    final key = notifier.appendPageKey;
    if (key == null) {
      return;
    }

    notifier.changeState(type: LoadType.append);
    onLoadStarted?.call(Append(key: key));
    try {
      final result = await load(Append(key: key));
      onLoadFinished?.call(Append(key: key), result);
      switch (result) {
        case Success(:final page):
          notifier.append(newPage: page);
        case Failure(:final error, :final stackTrace):
          _handleFailure(_skipAppendWhenError, error, stackTrace);
        case None():
          notifier.append(newPage: null);
      }
    } catch (error, stackTrace) {
      onLoadFinished?.call(
        Append(key: key),
        Failure(error: error, stackTrace: stackTrace),
      );
      _handleFailure(_skipAppendWhenError, error, stackTrace);
    }
  }

  void _handleFailure(bool skip, Object error, StackTrace? stackTrace) {
    if (skip) {
      notifier.revertLoad();
    } else {
      notifier.setError(error: error, stackTrace: stackTrace);
    }
  }
}

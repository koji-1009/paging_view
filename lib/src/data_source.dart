import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';
import 'package:paging_view/src/private/page_manager.dart';

/// Class that manages data loading.
abstract class DataSource<PageKey, Value> {
  /// Load data according to [LoadAction].
  @protected
  Future<LoadResult<PageKey, Value>> load(LoadAction<PageKey> action);

  final _manager = PageManager<PageKey, Value>();

  /// The [PageManager] that manages the data.
  PageManager<PageKey, Value> get notifier => _manager;

  /// Dispose the [PageManager].
  @mustCallSuper
  void dispose() {
    _manager.dispose();
  }

  /// Add a listener to the [PageManager].
  void addListener(VoidCallback listener) {
    _manager.addListener(listener);
  }

  /// Remove a listener from the [PageManager].
  void removeListener(VoidCallback listener) {
    _manager.removeListener(listener);
  }

  /// Update an item at the specified [index] by applying the [update] function.
  ///
  /// The [update] function receives the current item and should return the updated item.
  /// If the index is out of range or if the update function throws an error,
  /// the error will be set via [PageManager.setError].
  void updateItem(int index, Value Function(Value item) update) {
    _manager.updateItem(index, update);
  }

  /// Reload and then replace the data.
  Future<void> refresh() async {
    try {
      await _refresh();
    } catch (error, stackTrace) {
      _manager.setError(error: error, stackTrace: stackTrace);
    }
  }

  /// Run the load function according to the [LoadType].
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
        await _manager.append(newPage: page);
      case Failure(:final error, :final stackTrace):
        _manager.setError(error: error, stackTrace: stackTrace);
      case None():
        await _manager.append(newPage: null);
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
        await _manager.prepend(newPage: page);
      case Failure(:final error, :final stackTrace):
        _manager.setError(error: error, stackTrace: stackTrace);
      case None():
        await _manager.prepend(newPage: null);
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
        await _manager.append(newPage: page);
      case Failure(:final error, :final stackTrace):
        _manager.setError(error: error, stackTrace: stackTrace);
      case None():
        await _manager.append(newPage: null);
    }
  }
}

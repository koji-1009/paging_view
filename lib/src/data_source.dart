import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';
import 'package:paging_view/src/private/page_manager.dart';

/// Class that manages data loading.
abstract base class DataSource<PageKey, Value> {
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

  /// Reload and then replace the data.
  Future<void> refresh() async {
    try {
      await _refresh();
    } on Exception catch (e) {
      _manager.setError(e);
    }
  }

  /// Same as [refresh], but does not change the state of the [PageManager].
  @Deprecated('Use refresh() instead of smoothRefresh()')
  Future<void> smoothRefresh() async {
    refresh();
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
    } on Exception catch (e) {
      _manager.setError(e);
    }
  }

  Future<void> _init() async {
    _manager.changeState(LoadType.init);

    final result = await load(const Refresh());
    switch (result) {
      case Success(page: final page):
        _manager.append(page);
      case Failure(e: final e):
        _manager.setError(e);
      case None():
        _manager.append(null);
    }
  }

  Future<void> _refresh() async {
    if (_manager.isLoading) {
      /// already loading
      return;
    }

    _manager.changeState(LoadType.refresh);
    final result = await load(const Refresh());
    switch (result) {
      case Success(page: final page):
        _manager.refresh(page);
      case Failure(e: final e):
        _manager.setError(e);
      case None():
        _manager.append(null);
    }
  }

  Future<void> _prepend() async {
    if (_manager.isLoading) {
      /// already loading
      return;
    }

    final key = _manager.prependPageKey;
    if (key == null) {
      /// no more prepend data
      return;
    }

    _manager.changeState(LoadType.prepend);
    final result = await load(
      Prepend(
        key: key,
      ),
    );
    switch (result) {
      case Success(page: final page):
        _manager.prepend(page);
      case Failure(e: final e):
        _manager.setError(e);
      case None():
        _manager.prepend(null);
    }
  }

  Future<void> _append() async {
    if (_manager.isLoading) {
      /// already loading
      return;
    }

    final key = _manager.appendPageKey;
    if (key == null) {
      /// no more append data
      return;
    }

    _manager.changeState(LoadType.append);
    final result = await load(
      Append(
        key: key,
      ),
    );

    switch (result) {
      case Success(page: final page):
        _manager.append(page);
      case Failure(e: final e):
        _manager.setError(e);
      case None():
        _manager.append(null);
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';
import 'package:paging_view/src/private/page_manager.dart';

/// Class that manages data loading.
abstract base class DataSource<PageKey, Value> {
  @protected
  Future<LoadResult<PageKey, Value>> load(LoadAction<PageKey> params);

  final _manager = PageManager<PageKey, Value>();

  PageManager<PageKey, Value> get notifier => _manager;

  @mustCallSuper
  void dispose() {
    _manager.dispose();
  }

  void refresh() {
    _manager.clear();
  }

  Future<void> update(LoadType type) async {
    try {
      switch (type) {
        case LoadType.refresh:
          await _refresh();
          break;
        case LoadType.prepend:
          await _prepend();
          break;
        case LoadType.append:
          await _append();
          break;
      }
    } on Exception catch (e) {
      _manager.setError(e);
    }
  }

  Future<void> _refresh() async {
    if (_manager.isLoading) {
      /// already loading
      return;
    }

    _manager.setLoading(LoadType.refresh);
    final result = await load(const Refresh());
    switch (result) {
      case Success(page: final page):
        _manager.append(page);
        break;
      case Failure(e: final e):
        _manager.setError(e);
        break;
      case None():
        _manager.append(null);
        break;
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

    _manager.setLoading(LoadType.prepend);
    final result = await load(
      Prepend(
        key: key,
      ),
    );
    switch (result) {
      case Success(page: final page):
        _manager.prepend(page);
        break;
      case Failure(e: final e):
        _manager.setError(e);
        break;
      case None():
        _manager.prepend(null);
        break;
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

    _manager.setLoading(LoadType.append);
    final result = await load(
      Append(
        key: key,
      ),
    );

    switch (result) {
      case Success(page: final page):
        _manager.append(page);
        break;
      case Failure(e: final e):
        _manager.setError(e);
        break;
      case None():
        _manager.append(null);
        break;
    }
  }
}

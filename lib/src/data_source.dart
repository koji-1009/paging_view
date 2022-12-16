import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';
import 'package:paging_view/src/private/page_manager.dart';

/// Class that manages data loading.
abstract class DataSource<PageKey, Value> {
  @protected
  Future<LoadResult<PageKey, Value>> load(LoadParams<PageKey> params);

  final PageManager<PageKey, Value> _manager = PageManager();

  PageManager<PageKey, Value> get notifier => _manager;

  @mustCallSuper
  void dispose() {
    _manager.dispose();
  }

  void refresh() {
    _manager.clear();
  }

  Future<void> update(LoadType type) async {
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
  }

  Future<void> _refresh() async {
    if (_manager.isLoading) {
      /// already loading
      return;
    }

    _manager.setLoading(LoadType.refresh);
    final result = await load(const LoadParams.refresh());
    result.when(
      success: (page) => _manager.append(page),
      failure: (e) => _manager.setError(e),
      none: () => _manager.append(null),
    );
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
      LoadParams.prepend(
        key: key,
      ),
    );
    result.when(
      success: (page) => _manager.prepend(page),
      failure: (e) => _manager.setError(e),
      none: () => _manager.prepend(null),
    );
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
      LoadParams.append(
        key: key,
      ),
    );
    result.when(
      success: (page) => _manager.append(page),
      failure: (e) => _manager.setError(e),
      none: () => _manager.append(null),
    );
  }
}

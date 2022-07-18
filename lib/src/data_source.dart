import 'package:flutter/foundation.dart';
import 'package:flutter_paging/src/entity.dart';
import 'package:flutter_paging/src/private/entity.dart';
import 'package:flutter_paging/src/private/page_manager.dart';

abstract class DataSource<Value, Key> {
  @protected
  Future<LoadResult<Value, Key>> load(LoadParams<Key> params);

  final PageManager<Value, Key> _manager = PageManager();

  PageManager<Value, Key> get notifier => _manager;

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

    _manager
      ..clear()
      ..setLoading(LoadType.refresh);

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

    final key = _manager.prependKey;
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

    final key = _manager.appendKey;
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

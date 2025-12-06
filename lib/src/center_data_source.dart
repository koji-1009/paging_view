import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:paging_view/src/data_source.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/center_page_manager.dart';
import 'package:paging_view/src/private/entity.dart';

/// A [DataSource] specifically designed for [CenterPagingList].
///
/// Unlike the standard [DataSource], this manages three separate segments
/// of data: Prepend, Center, and Append. This allows for seamless bi-directional
/// scrolling using [CustomScrollView]'s `center` key feature.
///
/// The Center segment is the initial anchor point of the list, and:
/// - Prepend segment items appear above the Center (in reverse scroll direction)
/// - Append segment items appear below the Center
abstract class CenterDataSource<PageKey, Value> {
  /// Creates a [CenterDataSource].
  /// Use [errorPolicy] to define which errors should be ignored visually.
  CenterDataSource({this.errorPolicy = const {}});

  /// Defines the error handling policy for load operations.
  /// By default, all errors are shown in the UI.
  Set<LoadErrorPolicy> errorPolicy;

  /// A callback invoked after every `load` operation completes, providing the
  /// [LoadResult]. Useful for analytics or showing temporary error messages.
  void Function(LoadAction<PageKey> action, LoadResult<PageKey, Value> result)?
  onLoadFinished;

  /// The key used to anchor the [CustomScrollView] at the Center segment.
  ///
  /// This key is assigned to the Center sliver, making it the origin point
  /// of the scroll view. Slivers before the center will be laid out in
  /// reverse order (growing upward).
  final GlobalKey centerKey = GlobalKey();

  /// Loads a page of data based on the specified [LoadAction].
  ///
  /// Your implementation should:
  /// 1. Determine the type of load action (`Refresh`, `Prepend`, `Append`).
  /// 2. Fetch data from your source (e.g., make an API call).
  /// 3. Return a [LoadResult] to represent the outcome.
  ///
  /// For `Refresh`, the returned data becomes the Center segment.
  /// For `Prepend`, the data is added to the Prepend segment.
  /// For `Append`, the data is added to the Append segment.
  @protected
  Future<LoadResult<PageKey, Value>> load(LoadAction<PageKey> action);

  final _manager = CenterPageManager<PageKey, Value>();

  /// The underlying state manager for the data source.
  CenterPageManager<PageKey, Value> get notifier => _manager;

  /// Releases the resources used by this [CenterDataSource].
  @mustCallSuper
  void dispose() {
    onLoadFinished = null;
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

  /// Triggers a full refresh of the data, discarding all segments.
  ///
  /// The result becomes the new Center segment.
  Future<void> refresh() async {
    await _refresh();
  }

  /// Triggers a prepend operation to load data before the current items.
  Future<void> prepend() async {
    await _prepend();
  }

  /// Triggers an append operation to load data after the current items.
  Future<void> append() async {
    await _append();
  }

  /// Called internally to trigger a data load.
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
    _manager.changeState(type: LoadType.init);

    try {
      final result = await load(const Refresh());
      onLoadFinished?.call(const Refresh(), result);
      switch (result) {
        case Success(:final page):
          _manager.setCenter(newPage: page);
        case Failure(:final error, :final stackTrace):
          _manager.setError(error: error, stackTrace: stackTrace);
        case None():
          _manager.setCenter(newPage: null);
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
          if (_skipRefreshWhenError) {
            _manager.revertLoad();
          } else {
            _manager.setError(error: error, stackTrace: stackTrace);
          }
        case None():
          _manager.refresh(newPage: null);
      }
    } catch (error, stackTrace) {
      onLoadFinished?.call(
        const Refresh(),
        Failure(error: error, stackTrace: stackTrace),
      );
      if (_skipRefreshWhenError) {
        _manager.revertLoad();
      } else {
        _manager.setError(error: error, stackTrace: stackTrace);
      }
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
          if (_skipPrependWhenError) {
            _manager.revertLoad();
          } else {
            _manager.setError(error: error, stackTrace: stackTrace);
          }
        case None():
          _manager.prepend(newPage: null);
      }
    } catch (error, stackTrace) {
      onLoadFinished?.call(
        Prepend(key: key),
        Failure(error: error, stackTrace: stackTrace),
      );
      if (_skipPrependWhenError) {
        _manager.revertLoad();
      } else {
        _manager.setError(error: error, stackTrace: stackTrace);
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
          if (_skipAppendWhenError) {
            _manager.revertLoad();
          } else {
            _manager.setError(error: error, stackTrace: stackTrace);
          }
        case None():
          _manager.append(newPage: null);
      }
    } catch (error, stackTrace) {
      onLoadFinished?.call(
        Append(key: key),
        Failure(error: error, stackTrace: stackTrace),
      );
      if (_skipAppendWhenError) {
        _manager.revertLoad();
      } else {
        _manager.setError(error: error, stackTrace: stackTrace);
      }
    }
  }
}

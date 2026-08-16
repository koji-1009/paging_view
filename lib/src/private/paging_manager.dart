import 'package:flutter/foundation.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/private/entity.dart';

/// The operations a `DataSource` needs from its underlying state manager.
///
/// Implemented by both `PageManager` and `CenterPageManager` so that the
/// load pipeline can be shared between `DataSource` and `CenterDataSource`.
abstract class PagingManager<PageKey, Value, State>
    extends ValueNotifier<State> {
  /// Creates a [PagingManager] with the given initial state.
  PagingManager(super.value);

  /// Whether a data loading operation is currently in progress.
  bool get isLoading;

  /// The key for prepending more data, if available.
  PageKey? get prependPageKey;

  /// The key for appending more data, if available.
  PageKey? get appendPageKey;

  /// Transitions the manager to a loading state for the given [type].
  void changeState({required LoadType type});

  /// Transitions the manager to an error state with the given [error].
  void setError({required Object error, required StackTrace? stackTrace});

  /// Reverts a loading state back to a loaded state without changing the data.
  void revertLoad();

  /// Replaces the loaded pages with [newPage], or clears them when null.
  void refresh({required PageData<PageKey, Value>? newPage});

  /// Adds [newPage] before the current pages.
  void prepend({required PageData<PageKey, Value>? newPage});

  /// Adds [newPage] after the current pages.
  void append({required PageData<PageKey, Value>? newPage});

  /// Updates a single item at the specified [index].
  void updateItem(int index, Value Function(Value item) update);

  /// Updates all items currently loaded.
  void updateItems(Value Function(int index, Value item) update);

  /// Removes the item at the specified [index].
  void removeItem(int index);

  /// Removes all items that satisfy the given [test] predicate.
  void removeItems(bool Function(int index, Value item) test);

  /// Inserts an [item] at the specified [index].
  void insertItem(int index, Value item);
}

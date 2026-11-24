import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/// Represents the type of data loading action to be performed.
///
/// This is a sealed class with three concrete implementations that define
/// the type of data fetch operation:
/// - [Refresh]: For a full refresh of the data, starting from the beginning.
/// - [Prepend]: To load more data at the beginning of the list.
/// - [Append]: To load more data at the end of the list.
sealed class LoadAction<PageKey> {
  const LoadAction._();
}

/// A [LoadAction] that signals a request to completely refresh the data.
///
/// This typically involves clearing the existing data and loading the first page.
class Refresh<PageKey> implements LoadAction<PageKey> {
  /// Creates a [Refresh] action.
  const Refresh(); // coverage:ignore-line

  @override
  String toString() => 'Refresh()';
}

/// A [LoadAction] that signals a request to load data to be inserted at the
/// beginning of the current list.
class Prepend<PageKey> implements LoadAction<PageKey> {
  /// Creates a [Prepend] action with the specified [key].
  const Prepend({required this.key});

  /// The key for the page to be prepended.
  final PageKey key;

  @override
  String toString() => 'Prepend(key: $key)';
}

/// A [LoadAction] that signals a request to load data to be added at the end
/// of the current list.
class Append<PageKey> implements LoadAction<PageKey> {
  /// Creates an [Append] action with the specified [key].
  const Append({required this.key});

  /// The key for the page to be appended.
  final PageKey key;

  @override
  String toString() => 'Append(key: $key)';
}

/// Represents the result of a data loading operation initiated by a [LoadAction].
///
/// This is a sealed class with three concrete implementations:
/// - [Success]: Indicates that the data was loaded successfully.
/// - [Failure]: Indicates that an error occurred during loading.
/// - [None]: Indicates that the load operation was skipped or resulted in no
///   data.
///
/// The end of the data is signaled by a `null` [PageData.appendKey] or
/// [PageData.prependKey] in a [Success], not by [None].
sealed class LoadResult<PageKey, Value> {
  const LoadResult._();
}

/// A [LoadResult] that indicates a successful data loading operation.
class Success<PageKey, Value> implements LoadResult<PageKey, Value> {
  /// Creates a [Success] result with the loaded [page].
  const Success({required this.page});

  /// The [PageData] containing the loaded data and new pagination keys.
  final PageData<PageKey, Value> page;

  @override
  String toString() => 'Success(page: $page)';
}

/// A [LoadResult] that indicates a failed data loading operation.
class Failure<PageKey, Value> implements LoadResult<PageKey, Value> {
  /// Creates a [Failure] result with the [error] and an optional [stackTrace].
  const Failure({required this.error, this.stackTrace});

  /// The error or exception that occurred.
  final Object error;

  /// The stack trace associated with the error, if available.
  final StackTrace? stackTrace;

  @override
  String toString() => 'Failure(error: $error, stackTrace: $stackTrace)';
}

/// A [LoadResult] that indicates no data was loaded.
///
/// For a [Prepend] or [Append], the current items and page keys are kept, so
/// the same key can be requested again later. To mark the end of the data,
/// return a [Success] whose [PageData.prependKey] or [PageData.appendKey] is
/// `null` instead.
///
/// For a [Refresh], all items are cleared and the empty state is shown.
class None<PageKey, Value> implements LoadResult<PageKey, Value> {
  /// Creates a [None] result.
  const None(); // coverage:ignore-line

  @override
  String toString() => 'None()';
}

/// A container for a single "page" of data loaded by a data source.
///
/// It holds the list of items for the current page and, optionally, keys
/// that a data source can use to fetch the previous or next pages.
@immutable
class PageData<PageKey, Value> {
  /// Creates a page of data.
  const PageData({this.data = const [], this.prependKey, this.appendKey});

  /// The list of items in this page. Defaults to an empty list.
  final List<Value> data;

  /// The key to be used to fetch the page displayed before this one, passed
  /// to [Prepend].
  ///
  /// If `null`, it signifies that there is no previous page to load, effectively
  /// marking the beginning of the dataset.
  final PageKey? prependKey;

  /// The key to be used to fetch the page displayed after this one, passed
  /// to [Append].
  ///
  /// If `null`, it signifies that there is no next page to load, effectively
  /// marking the end of the dataset.
  final PageKey? appendKey;

  @override
  String toString() =>
      'PageData(data: $data, prependKey: $prependKey, appendKey: $appendKey)';

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (runtimeType == other.runtimeType &&
          other is PageData<PageKey, Value> &&
          (const DeepCollectionEquality().equals(other.data, data)) &&
          (identical(other.prependKey, prependKey) ||
              other.prependKey == prependKey) &&
          (identical(other.appendKey, appendKey) ||
              other.appendKey == appendKey));

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(data),
    prependKey,
    appendKey,
  );
}

/// Defines the policy when a data load fails.
///
/// By default, a failed load puts the data source into the error state, and
/// paging widgets show their `errorBuilder`. Adding these values allows you to
/// ignore errors for specific actions, reverting to the previous valid state
/// instead of showing an error.
enum LoadErrorPolicy {
  /// Ignores errors during a refresh operation. The list retains its current
  /// items.
  ///
  /// This applies to `refresh()` only. A failure of the initial load always
  /// puts the data source into the error state.
  ignoreRefresh,

  /// Ignores errors when prepending items.
  ignorePrepend,

  /// Ignores errors when appending items.
  ignoreAppend,
}

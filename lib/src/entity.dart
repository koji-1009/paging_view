/// Represents the type of data loading action to be performed by the [DataSource].
///
/// This is a sealed class, with three concrete implementations:
/// - [Refresh]: For a full refresh of the data.
/// - [Prepend]: To load more data at the beginning of the list (e.g., older messages in a chat).
/// - [Append]: To load more data at the end of the list (e.g., in an infinite scroll feed).
sealed class LoadAction<PageKey> {
  const LoadAction._();
}

/// Action to refresh data.
class Refresh<PageKey> implements LoadAction<PageKey> {
  const Refresh();
}

/// Action to add data at top of the list.
class Prepend<PageKey> implements LoadAction<PageKey> {
  const Prepend({required this.key});

  final PageKey key;
}

/// Action to add data at bottom of the list.
class Append<PageKey> implements LoadAction<PageKey> {
  const Append({required this.key});

  final PageKey key;
}

/// Result of load action.
sealed class LoadResult<PageKey, Value> {
  const LoadResult._();
}

/// Action is success.
class Success<PageKey, Value> implements LoadResult<PageKey, Value> {
  const Success({required this.page});

  final PageData<PageKey, Value> page;
}

/// Action is failure.
class Failure<PageKey, Value> implements LoadResult<PageKey, Value> {
  const Failure({required this.error, this.stackTrace});

  final Object error;
  final StackTrace? stackTrace;
}

/// Action is not necessary.
class None<PageKey, Value> implements LoadResult<PageKey, Value> {
  const None();
}

/// A container for a single "page" of data loaded by a [DataSource].
///
/// It holds the list of items for the current page and, optionally, keys
/// to fetch the previous or next pages.
class PageData<PageKey, Value> {
  /// Creates a page of data.
  const PageData({this.data = const [], this.prependKey, this.appendKey});

  /// The list of items in this page.
  final List<Value> data;

  /// The key to be used to fetch the *previous* page of data.
  ///
  /// If `null`, it indicates that there is no previous page to load.
  final PageKey? prependKey;

  /// The key to be used to fetch the *next* page of data.
  ///
  /// If `null`, it indicates that there is no next page to load.
  final PageKey? appendKey;

  @override
  String toString() =>
      'PageData(data: $data, prependKey: $prependKey, appendKey: $appendKey)';

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (runtimeType == other.runtimeType &&
          other is PageData<PageKey, Value> &&
          (identical(other.data, data) || other.data == data) &&
          (identical(other.prependKey, prependKey) ||
              other.prependKey == prependKey) &&
          (identical(other.appendKey, appendKey) ||
              other.appendKey == appendKey));

  @override
  int get hashCode => Object.hash(runtimeType, data, prependKey, appendKey);
}

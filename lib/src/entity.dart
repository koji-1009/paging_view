import 'package:equatable/equatable.dart';

/// Required action to load necessary data.
sealed class LoadAction<PageKey> {
  const LoadAction._();
}

/// Action to refresh data.
class Refresh<PageKey> implements LoadAction<PageKey> {
  const Refresh();
}

/// Action to add data at top of the list.
class Prepend<PageKey> implements LoadAction<PageKey> {
  const Prepend({
    required this.key,
  });

  final PageKey key;
}

/// Action to add data at bottom of the list.
class Append<PageKey> implements LoadAction<PageKey> {
  const Append({
    required this.key,
  });

  final PageKey key;
}

/// Result of load action.
sealed class LoadResult<PageKey, Value> {
  const LoadResult._();
}

/// Action is success.
class Success<PageKey, Value> implements LoadResult<PageKey, Value> {
  const Success({
    required this.page,
  });

  final PageData<PageKey, Value> page;
}

/// Action is failure.
class Failure<PageKey, Value> implements LoadResult<PageKey, Value> {
  const Failure({
    required this.e,
  });

  final Exception e;
}

/// Action is not necessary.
class None<PageKey, Value> implements LoadResult<PageKey, Value> {
  const None();
}

/// Data structure of page.
class PageData<PageKey, Value> extends Equatable {
  const PageData({
    this.data = const [],
    this.prependKey,
    this.appendKey,
  });

  final List<Value> data;
  final PageKey? prependKey;
  final PageKey? appendKey;

  @override
  List<Object?> get props => [data, prependKey, appendKey];
}

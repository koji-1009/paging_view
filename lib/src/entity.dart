import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity.freezed.dart';

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
@freezed
class PageData<PageKey, Value> with _$PageData<PageKey, Value> {
  const factory PageData({
    @Default([]) List<Value> data,
    PageKey? prependKey,
    PageKey? appendKey,
  }) = _PageData;
}

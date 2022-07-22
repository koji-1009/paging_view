import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity.freezed.dart';

/// The entity representing the type of Page to be newly loaded.
@freezed
class LoadParams<PageKey> with _$LoadParams<PageKey> {
  /// Refresh data
  const factory LoadParams.refresh() = _LoadParamsRefresh;

  /// Data to be added to the top of the list
  const factory LoadParams.prepend({
    required PageKey key,
  }) = _LoadParamsPrepend;

  /// Data to be added to the bottom of the list
  const factory LoadParams.append({
    required PageKey key,
  }) = _LoadParamsAppend;
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

/// Result of load.
@freezed
class LoadResult<PageKey, Value> with _$LoadResult<PageKey, Value> {
  const factory LoadResult.success({
    required PageData<PageKey, Value> page,
  }) = _LoadResultSuccess;

  const factory LoadResult.failure({
    required Exception? e,
  }) = _LoadResultFailure;

  const factory LoadResult.none() = _LoadResultNone;
}

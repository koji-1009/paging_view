import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity.freezed.dart';

@freezed
class LoadParams<PageKey> with _$LoadParams<PageKey> {
  const factory LoadParams.refresh() = _LoadParamsRefresh;

  const factory LoadParams.prepend({
    required PageKey key,
  }) = _LoadParamsPrepend;

  const factory LoadParams.append({
    required PageKey key,
  }) = _LoadParamsAppend;
}

@freezed
class PageData<PageKey, Value> with _$PageData<PageKey, Value> {
  const factory PageData({
    @Default([]) List<Value> data,
    PageKey? prependKey,
    PageKey? appendKey,
  }) = _PageData;
}

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

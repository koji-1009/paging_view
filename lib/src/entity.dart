import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity.freezed.dart';

@freezed
class LoadParams<Key> with _$LoadParams<Key> {
  const factory LoadParams.refresh() = _LoadParamsRefresh;

  const factory LoadParams.prepend({
    required Key key,
  }) = _LoadParamsPrepend;

  const factory LoadParams.append({
    required Key key,
  }) = _LoadParamsAppend;
}

@freezed
class PageData<Value, Key> with _$PageData<Value, Key> {
  const factory PageData({
    @Default([]) List<Value> data,
    Key? prependKey,
    Key? appendKey,
  }) = _PageData;
}

@freezed
class LoadResult<Value, Key> with _$LoadResult<Value, Key> {
  const factory LoadResult.success({
    required PageData<Value, Key> page,
  }) = _LoadResultSuccess;

  const factory LoadResult.failure({
    required Exception? e,
  }) = _LoadResultFailure;

  const factory LoadResult.none() = _LoadResultNone;
}

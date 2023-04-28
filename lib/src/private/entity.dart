import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paging_view/src/entity.dart';

part 'entity.freezed.dart';

enum NotifierLoadingState {
  init,
  loaded,
  initLoading,
  prependLoading,
  appendLoading,
}

@freezed
class NotifierState<PageKey, Value> with _$NotifierState<PageKey, Value> {
  const factory NotifierState({
    required NotifierLoadingState state,
    @Default([]) List<PageData<PageKey, Value>> data,
  }) = _NotifierState;

  const factory NotifierState.error({
    required Exception e,
  }) = _NotifierStateError;

  factory NotifierState.init() => const NotifierState(
        state: NotifierLoadingState.init,
      );
}

extension NotifierStateExt<PageKey, Value> on NotifierState<PageKey, Value> {
  bool get isLoading => when(
        (state, _) =>
            state == NotifierLoadingState.initLoading ||
            state == NotifierLoadingState.prependLoading ||
            state == NotifierLoadingState.appendLoading,
        error: (_) => false,
      );

  PageKey? get prependPageKey => pages.firstOrNull?.prependKey;

  PageKey? get appendPageKey => pages.lastOrNull?.appendKey;

  List<PageData<PageKey, Value>> get pages => when(
        (state, data) => data,
        error: (_) => const [],
      );

  List<Value> get items => [...pages.map((e) => e.data).flattened];
}

enum LoadType {
  refresh,
  prepend,
  append,
}

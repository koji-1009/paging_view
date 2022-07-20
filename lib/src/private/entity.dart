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
class NotifierState<Value, PageKey> with _$NotifierState<Value, PageKey> {
  const factory NotifierState({
    required NotifierLoadingState state,
    @Default([]) List<PageData<Value, PageKey>> data,
  }) = _NotifierState;

  const factory NotifierState.error({
    required Exception? e,
  }) = _NotifierStateError;

  factory NotifierState.init() => const NotifierState(
        state: NotifierLoadingState.init,
      );
}

extension NotifierStateExt<Value, PageKey> on NotifierState<Value, PageKey> {
  bool get isLoading => when(
        (state, _) =>
            state == NotifierLoadingState.initLoading ||
            state == NotifierLoadingState.prependLoading ||
            state == NotifierLoadingState.appendLoading,
        error: (_) => false,
      );

  PageKey? get prependPageKey => pages.firstOrNull?.prependKey;

  PageKey? get appendPageKey => pages.lastOrNull?.appendKey;

  List<PageData<Value, PageKey>> get pages => when(
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

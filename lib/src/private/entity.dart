import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_paging/src/entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity.freezed.dart';

enum NotifierLoadingState {
  init,
  loaded,
  initLoading,
  prependLoading,
  appendLoading,
}

@freezed
class NotifierState<Value, Key> with _$NotifierState<Value, Key> {
  const factory NotifierState({
    required NotifierLoadingState state,
    @Default([]) List<PageData<Value, Key>> data,
  }) = _NotifierState;

  const factory NotifierState.error({
    required Exception? e,
  }) = _NotifierStateError;

  factory NotifierState.init() => const NotifierState(
        state: NotifierLoadingState.init,
      );
}

extension NotifierStateExt<Value, Key> on NotifierState<Value, Key> {
  bool get isLoading => when(
        (state, _) =>
            state == NotifierLoadingState.initLoading ||
            state == NotifierLoadingState.prependLoading ||
            state == NotifierLoadingState.appendLoading,
        error: (_) => false,
      );

  Key? get prependKey => pages.firstOrNull?.prependKey;

  Key? get appendKey => pages.lastOrNull?.appendKey;

  List<PageData<Value, Key>> get pages => when(
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

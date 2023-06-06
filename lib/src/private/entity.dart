import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:paging_view/src/entity.dart';

enum LoadState {
  init,
  loaded,
  initLoading,
  prependLoading,
  appendLoading,
}

sealed class NotifierState<PageKey, Value> {
  const NotifierState._();
}

class Paging<PageKey, Value> extends Equatable
    implements NotifierState<PageKey, Value> {
  const Paging({
    required this.state,
    this.data = const [],
  });

  factory Paging.init() => const Paging(
        state: LoadState.init,
      );

  final LoadState state;
  final List<PageData<PageKey, Value>> data;

  @override
  List<Object?> get props => [state, data];
}

class Warning<PageKey, Value> extends Equatable
    implements NotifierState<PageKey, Value> {
  const Warning({
    required this.e,
  });

  final Exception e;

  @override
  List<Object?> get props => [e];
}

extension PagingStateExt<PageKey, Value> on NotifierState<PageKey, Value> {
  bool get isLoading => switch (this) {
        Paging(state: final state, data: _) =>
          state == LoadState.initLoading ||
              state == LoadState.prependLoading ||
              state == LoadState.appendLoading,
        Warning(e: _) => false,
      };

  PageKey? get prependPageKey => pages.firstOrNull?.prependKey;

  PageKey? get appendPageKey => pages.lastOrNull?.appendKey;

  List<PageData<PageKey, Value>> get pages => switch (this) {
        Paging(state: _, data: final data) => data,
        Warning(e: _) => const [],
      };

  List<Value> get items => [...pages.map((e) => e.data).flattened];
}

enum LoadType {
  refresh,
  prepend,
  append,
}

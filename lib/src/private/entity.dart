import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:paging_view/src/entity.dart';

sealed class LoadState {
  const LoadState();
}

class LoadStateInit extends LoadState {
  const LoadStateInit();
}

class LoadStateLoaded extends LoadState {
  const LoadStateLoaded();
}

class LoadStateLoading extends LoadState {
  const LoadStateLoading({
    required this.state,
  });

  final LoadType state;

  bool get isInit => state == LoadType.init;

  bool get isRefresh => state == LoadType.refresh;

  bool get isPrepend => state == LoadType.prepend;

  bool get isAppend => state == LoadType.append;
}

sealed class PageManagerState<PageKey, Value> with EquatableMixin {
  const PageManagerState();
}

class Paging<PageKey, Value> extends PageManagerState<PageKey, Value> {
  const Paging({
    required this.state,
    required this.data,
  });

  factory Paging.init() => const Paging(
        state: LoadStateInit(),
        data: [],
      );

  final LoadState state;
  final List<PageData<PageKey, Value>> data;

  @override
  List<Object?> get props => [state, data];
}

class Warning<PageKey, Value> extends PageManagerState<PageKey, Value> {
  const Warning({
    required this.exception,
  });

  final Exception exception;

  @override
  List<Object?> get props => [exception];
}

extension PagingStateExt<PageKey, Value> on PageManagerState<PageKey, Value> {
  bool get isLoading => switch (this) {
        Paging(state: final state, data: _) => state is LoadStateLoading,
        Warning(exception: _) => false,
      };

  PageKey? get prependPageKey => pages.firstOrNull?.prependKey;

  PageKey? get appendPageKey => pages.lastOrNull?.appendKey;

  List<PageData<PageKey, Value>> get pages => switch (this) {
        Paging(state: _, data: final data) => data,
        Warning(exception: _) => const [],
      };

  List<Value> get items => [...pages.map((e) => e.data).flattened];
}

enum LoadType {
  init,
  refresh,
  prepend,
  append,
}

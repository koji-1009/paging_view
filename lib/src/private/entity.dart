import 'package:collection/collection.dart';
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

sealed class PageManagerState<PageKey, Value> {
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
  String toString() => 'Paging(state: $state, data: $data)';

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (runtimeType == other.runtimeType &&
          other is Paging<PageKey, Value> &&
          (identical(other.state, state) || other.state == state) &&
          const DeepCollectionEquality().equals(other.data, data));

  @override
  int get hashCode => Object.hash(
        runtimeType,
        state,
        const DeepCollectionEquality().hash(data),
      );
}

class Warning<PageKey, Value> extends PageManagerState<PageKey, Value> {
  const Warning({
    required this.exception,
  });

  final Exception exception;

  @override
  String toString() => 'Warning(exception: $exception)';

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (runtimeType == other.runtimeType &&
          other is Warning<PageKey, Value> &&
          (identical(other.exception, exception) ||
              other.exception == exception));

  @override
  int get hashCode => Object.hash(
        runtimeType,
        exception,
      );
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

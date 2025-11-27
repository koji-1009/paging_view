import 'package:collection/collection.dart';
import 'package:paging_view/src/entity.dart';

sealed class LoadState {
  const LoadState();

  bool get isInit;
  bool get isLoaded;
  bool get isInitLoading;
  bool get isRefreshLoading;
  bool get isPrependLoading;
  bool get isAppendLoading;
}

class LoadStateInit extends LoadState {
  const LoadStateInit();

  @override
  bool get isInit => true;

  @override
  bool get isLoaded => false;

  @override
  bool get isInitLoading => false;

  @override
  bool get isRefreshLoading => false;

  @override
  bool get isPrependLoading => false;

  @override
  bool get isAppendLoading => false;
}

class LoadStateLoaded extends LoadState {
  const LoadStateLoaded();

  @override
  bool get isInit => false;

  @override
  bool get isLoaded => true;

  @override
  bool get isInitLoading => false;

  @override
  bool get isRefreshLoading => false;

  @override
  bool get isPrependLoading => false;

  @override
  bool get isAppendLoading => false;
}

class LoadStateLoading extends LoadState {
  const LoadStateLoading({required this.state});

  final LoadType state;

  @override
  bool get isInit => false;

  @override
  bool get isLoaded => false;

  @override
  bool get isInitLoading => state == LoadType.init;

  @override
  bool get isRefreshLoading => state == LoadType.refresh;

  @override
  bool get isPrependLoading => state == LoadType.prepend;

  @override
  bool get isAppendLoading => state == LoadType.append;
}

sealed class PageManagerState<PageKey, Value> {
  const PageManagerState();
}

class Paging<PageKey, Value> extends PageManagerState<PageKey, Value> {
  const Paging({required this.state, required this.data});

  factory Paging.init() => const Paging(state: LoadStateInit(), data: []);

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
  const Warning({required this.error, required this.stackTrace});

  final Object error;
  final StackTrace? stackTrace;

  @override
  String toString() => 'Warning(error: $error, stackTrace: $stackTrace)';

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (runtimeType == other.runtimeType &&
          other is Warning<PageKey, Value> &&
          (identical(other.error, error) || other.error == error) &&
          (identical(other.stackTrace, stackTrace) ||
              other.stackTrace == stackTrace));

  @override
  int get hashCode => Object.hash(runtimeType, error, stackTrace);
}

extension PagingStateExt<PageKey, Value> on PageManagerState<PageKey, Value> {
  bool get isLoading => switch (this) {
    Paging(:final state) => state is LoadStateLoading,
    Warning() => false,
  };

  PageKey? get prependPageKey => pages.firstOrNull?.prependKey;

  PageKey? get appendPageKey => pages.lastOrNull?.appendKey;

  List<PageData<PageKey, Value>> get pages => switch (this) {
    Paging(data: final data) => data,
    Warning() => const [],
  };

  List<Value> get items => [...pages.map((e) => e.data).flattened];
}

enum LoadType { init, refresh, prepend, append }

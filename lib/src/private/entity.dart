import 'package:collection/collection.dart';
import 'package:paging_view/src/entity.dart';

/// Represents the current data loading status.
sealed class LoadState {
  /// Creates a [LoadState].
  const LoadState();

  /// Whether the data is in its initial, uninitialized state.
  bool get isInit;

  /// Whether the data has been successfully loaded at least once.
  bool get isLoaded;

  /// Whether the initial data load is in progress.
  bool get isInitLoading;

  /// Whether a data refresh is in progress.
  bool get isRefreshLoading;

  /// Whether a prepend operation is in progress.
  bool get isPrependLoading;

  /// Whether an append operation is in progress.
  bool get isAppendLoading;
}

/// The initial state before any data has been loaded.
class LoadStateInit extends LoadState {
  /// Creates a [LoadStateInit].
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

  @override
  String toString() => 'LoadStateInit()';
}

/// The state when data has been successfully loaded.
class LoadStateLoaded extends LoadState {
  /// Creates a [LoadStateLoaded].
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

  @override
  String toString() => 'LoadStateLoaded()';
}

/// The state when a data loading operation is in progress.
class LoadStateLoading extends LoadState {
  /// Creates a [LoadStateLoading].
  const LoadStateLoading({required this.state});

  /// The specific type of loading operation.
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

  @override
  String toString() => 'LoadStateLoading(state: $state)';
}

/// Represents the overall state of the paged data, including the data itself
/// and any errors.
sealed class PageManagerState<PageKey, Value> {
  /// Creates a [PageManagerState].
  const PageManagerState();
}

/// A state representing successfully loaded pages of data.
class Paging<PageKey, Value> extends PageManagerState<PageKey, Value> {
  /// Creates a [Paging] state.
  const Paging({required this.state, required this.data});

  /// Creates an initial [Paging] state with no data.
  factory Paging.init() => const Paging(state: LoadStateInit(), data: []);

  /// The current loading state of the data.
  final LoadState state;

  /// The list of loaded pages.
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

/// A state representing an error that occurred during data processing or
/// manipulation.
class Warning<PageKey, Value> extends PageManagerState<PageKey, Value> {
  /// Creates a [Warning] state.
  const Warning({required this.error, required this.stackTrace});

  /// The error that occurred.
  final Object error;

  /// The stack trace associated with the error, if available.
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

/// Provides convenient accessors for [PageManagerState].
extension PagingStateExt<PageKey, Value> on PageManagerState<PageKey, Value> {
  /// Whether any loading operation is currently in progress.
  bool get isLoading => switch (this) {
    Paging(:final state) =>
      state.isInitLoading ||
          state.isRefreshLoading ||
          state.isPrependLoading ||
          state.isAppendLoading,
    Warning() => false,
  };

  /// The key for prepending more data, if available.
  ///
  /// This is the `prependKey` of the first page.
  PageKey? get prependPageKey => pages.firstOrNull?.prependKey;

  /// The key for appending more data, if available.
  ///
  /// This is the `appendKey` of the last page.
  PageKey? get appendPageKey => pages.lastOrNull?.appendKey;

  /// The list of loaded pages.
  ///
  /// Returns an empty list if the state is [Warning].
  List<PageData<PageKey, Value>> get pages => switch (this) {
    Paging(:final data) => data,
    Warning() => const [],
  };

  /// A flattened list of all items from all loaded pages.
  List<Value> get items => [...pages.map((e) => e.data).flattened];
}

/// Defines the type of data loading operation.
enum LoadType {
  /// Initial data load.
  init,

  /// A full refresh of the data.
  refresh,

  /// Loading data at the beginning of the list.
  prepend,

  /// Loading data at the end of the list.
  append,
}

import 'package:flutter/widgets.dart';
import 'package:paging_view/paging_view.dart';
import 'package:paging_view/src/private/entity.dart';

/// A widget that builds a custom UI at the start of the list (prepend)
/// based on the [DataSource]'s loading state.
///
/// It provides [hasMore] and [isLoading] states to the builder, allowing you to:
/// * Show a button only when [hasMore] is true.
/// * Disable the button when [isLoading] is true.
///
/// Example:
/// ```dart
/// PrependLoadStateBuilder(
///   dataSource: dataSource,
///   builder: (context, hasMore, isLoading) {
///     // If there is no more data, show nothing.
///     if (!hasMore) {
///       return const SizedBox.shrink();
///     }
///
///     // Show a manual trigger button.
///     // Disable it while loading to prevent double-tapping.
///     return FilledButton(
///       onPressed: isLoading ? null : () => dataSource.prepend(),
///       child: const Text('Load Previous'),
///     );
///   },
/// )
/// ```
class PrependLoadStateBuilder<PageKey, Value> extends StatelessWidget {
  /// Creates a [PrependLoadStateBuilder].
  const PrependLoadStateBuilder({
    super.key,
    required this.dataSource,
    required this.builder,
  });

  /// The [DataSource] to listen to for paging state changes.
  final DataSource<PageKey, Value> dataSource;

  /// A builder function that constructs the widget based on the current state.
  ///
  /// - [context]: The build context.
  /// - [hasMore]: True if a [PageKey] for prepending is available (not null).
  ///   Use this to decide whether to show the trigger button.
  /// - [isLoading]: True if a prepend operation is currently in progress.
  ///   Use this to disable the button interaction (visual loading is handled by [SliverPagingList]).
  final Widget Function(BuildContext context, bool hasMore, bool isLoading)
  builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dataSource.notifier,
      builder: (context, state, child) => switch (state) {
        Paging() => builder(
          context,
          state.prependPageKey != null,
          state.state.isPrependLoading,
        ),
        Warning() => const SizedBox.shrink(),
      },
    );
  }
}

/// A widget that builds a custom UI at the end of the list (append)
/// based on the [DataSource]'s loading state.
///
/// It provides [hasMore] and [isLoading] states to the builder, allowing you to:
/// * Show a button only when [hasMore] is true.
/// * Disable the button when [isLoading] is true.
///
/// Example:
/// ```dart
/// AppendLoadStateBuilder(
///   dataSource: dataSource,
///   builder: (context, hasMore, isLoading) {
///     // If there is no more data, show a message.
///     if (!hasMore) {
///       return const Padding(
///         padding: EdgeInsets.all(16.0),
///         child: Text('No more items'),
///       );
///     }
///
///     // Show a manual trigger button.
///     return TextButton(
///       onPressed: isLoading ? null : () => dataSource.append(),
///       child: const Text('Load More'),
///     );
///   },
/// )
/// ```
class AppendLoadStateBuilder<PageKey, Value> extends StatelessWidget {
  /// Creates an [AppendLoadStateBuilder].
  const AppendLoadStateBuilder({
    super.key,
    required this.dataSource,
    required this.builder,
  });

  /// The [DataSource] to listen to for paging state changes.
  final DataSource<PageKey, Value> dataSource;

  /// A builder function that constructs the widget based on the current state.
  ///
  /// - [context]: The build context.
  /// - [hasMore]: True if a [PageKey] for appending is available (not null).
  ///   Use this to decide whether to show the trigger button.
  /// - [isLoading]: True if an append operation is currently in progress.
  ///   Use this to disable the button interaction (visual loading is handled by [SliverPagingList]).
  final Widget Function(BuildContext context, bool hasMore, bool isLoading)
  builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dataSource.notifier,
      builder: (context, state, child) => switch (state) {
        Paging() => builder(
          context,
          state.appendPageKey != null,
          state.state.isAppendLoading,
        ),
        Warning() => const SizedBox.shrink(),
      },
    );
  }
}

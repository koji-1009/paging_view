import 'package:flutter/widgets.dart';
import 'package:paging_view/src/data_source.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/function.dart';
import 'package:paging_view/src/private/entity.dart';
import 'package:paging_view/src/widget/sliver_bounds_detector.dart';

/// A sliver that displays a paginated, linear list of items.
///
/// This widget automatically handles loading more data when the user scrolls
/// near the boundaries of the list, using a [DataSource]. It can display
/// initial loading indicators, prepend/append loading indicators, empty states,
/// and error messages.
///
/// For a non-sliver version that wraps this in a [CustomScrollView], see [PagingList].
class SliverPagingList<PageKey, Value> extends StatelessWidget {
  /// Creates a scrollable, linear array of widgets that are created on demand.
  const SliverPagingList({
    super.key,
    required this.dataSource,
    required this.builder,
    this.errorBuilder,
    this.initialLoadingWidget,
    this.prependLoadingWidget,
    this.appendLoadingWidget,
    this.emptyWidget,
    this.fillRemainErrorWidget = true,
    this.fillRemainEmptyWidget = true,
    this.padding = EdgeInsets.zero,
    this.autoLoadAppend = true,
    this.autoLoadPrepend = true,
  }) : _separatorBuilder = null;

  /// Creates a scrollable linear array of list "items" separated
  /// by list item "separators".
  const SliverPagingList.separated({
    super.key,
    required this.dataSource,
    required this.builder,
    this.errorBuilder,
    this.initialLoadingWidget,
    this.prependLoadingWidget,
    this.appendLoadingWidget,
    this.emptyWidget,
    this.fillRemainErrorWidget = true,
    this.fillRemainEmptyWidget = true,
    this.padding = EdgeInsets.zero,
    required IndexedWidgetBuilder separatorBuilder,
    this.autoLoadAppend = true,
    this.autoLoadPrepend = true,
  }) : _separatorBuilder = separatorBuilder;

  /// The [DataSource] that provides the paginated data.
  final DataSource<PageKey, Value> dataSource;

  /// The builder that builds a widget for the given item and index.
  final TypedWidgetBuilder<Value> builder;

  /// The builder that builds a widget for the given exception.
  final ExceptionWidgetBuilder? errorBuilder;

  /// The widget that is shown when the data is loading for the first time.
  final Widget? initialLoadingWidget;

  /// The widget that is shown when the data is loading at the beginning of the list.
  final Widget? prependLoadingWidget;

  /// The widget that is shown when the data is loading at the end of the list.
  final Widget? appendLoadingWidget;

  /// The widget that is shown when the data is empty.
  final Widget? emptyWidget;

  /// If true, the error widget will fill the remaining space of the viewport.
  final bool fillRemainErrorWidget;

  /// If true, the empty widget will fill the remaining space of the viewport.
  final bool fillRemainEmptyWidget;

  /// The separator builder for `separated` constructor.
  final IndexedWidgetBuilder? _separatorBuilder;

  /// The padding around the list.
  final EdgeInsets padding;

  /// Automatically load more data at the beginning of the list
  /// when reaching the boundary.
  final bool autoLoadPrepend;

  /// Automatically load more data at the end of the list
  /// when reaching the boundary.
  final bool autoLoadAppend;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PageManagerState<PageKey, Value>>(
      valueListenable: dataSource.notifier,
      builder: (context, value, child) => switch (value) {
        Paging(:final state, :final data) =>
          _separatorBuilder != null
              ? _List<PageKey, Value>.separated(
                  state: state,
                  pages: data,
                  dataSource: dataSource,
                  builder: builder,
                  initialLoadingWidget: initialLoadingWidget,
                  prependLoadingWidget: prependLoadingWidget,
                  appendLoadingWidget: appendLoadingWidget,
                  emptyWidget: emptyWidget,
                  fillRemainEmptyWidget: fillRemainEmptyWidget,
                  padding: padding,
                  autoLoadPrepend: autoLoadPrepend,
                  autoLoadAppend: autoLoadAppend,
                  separatorBuilder: _separatorBuilder,
                )
              : _List<PageKey, Value>(
                  state: state,
                  pages: data,
                  dataSource: dataSource,
                  builder: builder,
                  initialLoadingWidget: initialLoadingWidget,
                  prependLoadingWidget: prependLoadingWidget,
                  appendLoadingWidget: appendLoadingWidget,
                  emptyWidget: emptyWidget,
                  fillRemainEmptyWidget: fillRemainEmptyWidget,
                  padding: padding,
                  autoLoadPrepend: autoLoadPrepend,
                  autoLoadAppend: autoLoadAppend,
                ),
        Warning(:final error, :final stackTrace) => SliverPadding(
          padding: padding,
          sliver: fillRemainErrorWidget
              ? SliverFillRemaining(
                  child: errorBuilder?.call(context, error, stackTrace),
                )
              : SliverToBoxAdapter(
                  child: errorBuilder?.call(context, error, stackTrace),
                ),
        ),
      },
    );
  }
}

/// Internal widget for [SliverPagingList] that handles the actual sliver layout.
class _List<PageKey, Value> extends StatelessWidget {
  const _List({
    required this.state,
    required this.pages,
    required this.dataSource,
    required this.builder,
    required this.initialLoadingWidget,
    required this.prependLoadingWidget,
    required this.appendLoadingWidget,
    required this.emptyWidget,
    required this.fillRemainEmptyWidget,
    required this.padding,
    required this.autoLoadPrepend,
    required this.autoLoadAppend,
  }) : _separatorBuilder = null;

  const _List.separated({
    required this.state,
    required this.pages,
    required this.dataSource,
    required this.builder,
    required this.initialLoadingWidget,
    required this.prependLoadingWidget,
    required this.appendLoadingWidget,
    required this.emptyWidget,
    required this.fillRemainEmptyWidget,
    required this.padding,
    required this.autoLoadPrepend,
    required this.autoLoadAppend,
    required IndexedWidgetBuilder separatorBuilder,
  }) : _separatorBuilder = separatorBuilder;

  final LoadState state;
  final List<PageData<PageKey, Value>> pages;
  final DataSource<PageKey, Value> dataSource;
  final TypedWidgetBuilder<Value> builder;
  final Widget? initialLoadingWidget;
  final Widget? prependLoadingWidget;
  final Widget? appendLoadingWidget;
  final Widget? emptyWidget;
  final bool fillRemainEmptyWidget;
  final IndexedWidgetBuilder? _separatorBuilder;
  final EdgeInsets padding;
  final bool autoLoadPrepend;
  final bool autoLoadAppend;

  EdgeInsets get _horizontalPadding =>
      EdgeInsets.only(left: padding.left, right: padding.right);

  @override
  Widget build(BuildContext context) {
    final state = this.state;
    if (state.isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await dataSource.update(LoadType.init);
      });

      return SliverPadding(
        padding: padding,
        sliver: SliverFillRemaining(child: initialLoadingWidget),
      );
    } else if (state.isInitLoading) {
      return SliverPadding(
        padding: padding,
        sliver: SliverFillRemaining(child: initialLoadingWidget),
      );
    }

    final items = dataSource.notifier.values;
    if (state.isLoaded && items.isEmpty) {
      if (fillRemainEmptyWidget) {
        return SliverPadding(
          padding: padding,
          sliver: SliverFillRemaining(child: emptyWidget),
        );
      }

      return SliverPadding(
        padding: padding,
        sliver: SliverToBoxAdapter(child: emptyWidget),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: padding.top)),
        if (state.isPrependLoading)
          SliverPadding(
            padding: _horizontalPadding,
            sliver: SliverToBoxAdapter(child: prependLoadingWidget),
          ),
        if (autoLoadPrepend)
          SliverBoundsDetector(
            onVisibilityChanged: (isVisible) async {
              if (isVisible) {
                await dataSource.update(LoadType.prepend);
              }
            },
          ),
        SliverPadding(
          padding: _horizontalPadding,
          sliver: _separatorBuilder != null
              ? SliverList.separated(
                  itemBuilder: (context, index) =>
                      builder(context, items[index], index),
                  itemCount: items.length,
                  separatorBuilder: _separatorBuilder,
                )
              : SliverList.builder(
                  itemBuilder: (context, index) =>
                      builder(context, items[index], index),
                  itemCount: items.length,
                ),
        ),
        if (autoLoadAppend)
          SliverBoundsDetector(
            onVisibilityChanged: (isVisible) async {
              if (isVisible) {
                await dataSource.update(LoadType.append);
              }
            },
          ),
        if (state.isAppendLoading)
          SliverPadding(
            padding: _horizontalPadding,
            sliver: SliverToBoxAdapter(child: appendLoadingWidget),
          ),
        SliverToBoxAdapter(child: SizedBox(height: padding.bottom)),
      ],
    );
  }
}

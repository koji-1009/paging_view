import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:paging_view/src/data_source.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/function.dart';
import 'package:paging_view/src/private/entity.dart';

/// A sliver that manages pages and scroll position to read more data.
/// Display a single-column list.
class SliverPagingList<PageKey, Value> extends StatelessWidget {
  /// Creates a scrollable, linear array of widgets that are created on demand.
  const SliverPagingList({
    super.key,
    required this.dataSource,
    required this.builder,
    required this.errorBuilder,
    required this.initialLoadingWidget,
    this.prependLoadingWidget = const SizedBox.shrink(),
    this.appendLoadingWidget = const SizedBox.shrink(),
    this.emptyWidget = const SizedBox.shrink(),
    this.fillRemainErrorWidget = true,
    this.fillRemainEmptyWidget = true,
    this.padding = EdgeInsets.zero,
  }) : _separatorBuilder = null;

  /// Creates a scrollable linear array of list "items" separated
  /// by list item "separators".
  const SliverPagingList.separated({
    super.key,
    required this.dataSource,
    required this.builder,
    required this.errorBuilder,
    required this.initialLoadingWidget,
    this.prependLoadingWidget = const SizedBox.shrink(),
    this.appendLoadingWidget = const SizedBox.shrink(),
    this.emptyWidget = const SizedBox.shrink(),
    this.fillRemainErrorWidget = true,
    this.fillRemainEmptyWidget = true,
    this.padding = EdgeInsets.zero,
    required IndexedWidgetBuilder separatorBuilder,
  }) : _separatorBuilder = separatorBuilder;

  /// The data source that provides pages from loader.
  final DataSource<PageKey, Value> dataSource;

  /// The builder that builds a widget for the given item and index.
  final TypedWidgetBuilder<Value> builder;

  /// The builder that builds a widget for the given exception.
  final ExceptionWidgetBuilder errorBuilder;

  /// The widget that is shown when the data is loading for the first time.
  final Widget initialLoadingWidget;

  /// The widget that is shown when the data is loading at the beginning of the list.
  final Widget prependLoadingWidget;

  /// The widget that is shown when the data is loading at the end of the list.
  final Widget appendLoadingWidget;

  /// The widget that is shown when the data is empty.
  final Widget emptyWidget;

  /// If true, the error widget will fill the remaining space.
  final bool fillRemainErrorWidget;

  /// If true, the empty widget will fill the remaining space.
  final bool fillRemainEmptyWidget;

  /// Separated builder, if null, separated builder will not be used.
  final IndexedWidgetBuilder? _separatorBuilder;

  /// The padding around the list.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PageManagerState<PageKey, Value>>(
      valueListenable: dataSource.notifier,
      builder: (context, value, child) => switch (value) {
        Paging(:final state, :final data) => _separatorBuilder != null
            ? _List<PageKey, Value>.separated(
                state: state,
                pages: data,
                separatorBuilder: _separatorBuilder!,
                dataSource: dataSource,
                builder: builder,
                errorBuilder: errorBuilder,
                initialLoadingWidget: initialLoadingWidget,
                prependLoadingWidget: prependLoadingWidget,
                appendLoadingWidget: appendLoadingWidget,
                emptyWidget: emptyWidget,
                fillRemainEmptyWidget: fillRemainEmptyWidget,
                padding: padding,
              )
            : _List<PageKey, Value>(
                state: state,
                pages: data,
                dataSource: dataSource,
                builder: builder,
                errorBuilder: errorBuilder,
                initialLoadingWidget: initialLoadingWidget,
                prependLoadingWidget: prependLoadingWidget,
                appendLoadingWidget: appendLoadingWidget,
                emptyWidget: emptyWidget,
                fillRemainEmptyWidget: fillRemainEmptyWidget,
                padding: padding,
              ),
        Warning(:final error, :final stackTrace) => SliverPadding(
            padding: padding,
            sliver: fillRemainErrorWidget
                ? SliverFillRemaining(
                    child: errorBuilder(context, error, stackTrace),
                  )
                : SliverToBoxAdapter(
                    child: errorBuilder(context, error, stackTrace),
                  ),
          ),
      },
    );
  }
}

/// Internal widget for [SliverPagingList].
class _List<PageKey, Value> extends StatelessWidget {
  const _List({
    required this.state,
    required this.pages,
    required this.dataSource,
    required this.builder,
    required this.errorBuilder,
    required this.initialLoadingWidget,
    required this.prependLoadingWidget,
    required this.appendLoadingWidget,
    required this.emptyWidget,
    required this.fillRemainEmptyWidget,
    required this.padding,
  }) : _separatorBuilder = null;

  /// Creates a scrollable linear array of list "items" separated
  /// by list item "separators".
  const _List.separated({
    required this.state,
    required this.pages,
    required this.dataSource,
    required this.builder,
    required this.errorBuilder,
    required this.initialLoadingWidget,
    required this.prependLoadingWidget,
    required this.appendLoadingWidget,
    required this.emptyWidget,
    required this.fillRemainEmptyWidget,
    required this.padding,
    required IndexedWidgetBuilder separatorBuilder,
  }) : _separatorBuilder = separatorBuilder;

  final LoadState state;
  final List<PageData<PageKey, Value>> pages;
  final DataSource<PageKey, Value> dataSource;
  final TypedWidgetBuilder<Value> builder;
  final ExceptionWidgetBuilder errorBuilder;
  final Widget initialLoadingWidget;
  final Widget prependLoadingWidget;
  final Widget appendLoadingWidget;
  final Widget emptyWidget;
  final bool fillRemainEmptyWidget;
  final IndexedWidgetBuilder? _separatorBuilder;
  final EdgeInsets padding;

  EdgeInsets get _horizontalPadding => EdgeInsets.only(
        left: padding.left,
        right: padding.right,
      );

  @override
  Widget build(BuildContext context) {
    final state = this.state;
    if (state is LoadStateInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await dataSource.update(LoadType.init);
      });

      return SliverPadding(
        padding: padding,
        sliver: SliverFillRemaining(
          child: initialLoadingWidget,
        ),
      );
    } else if (state is LoadStateLoading && state.isInit) {
      return SliverPadding(
        padding: padding,
        sliver: SliverFillRemaining(
          child: initialLoadingWidget,
        ),
      );
    }

    final items = [...pages.map((e) => e.data).flattened];
    if (state is LoadStateLoaded && items.isEmpty) {
      if (fillRemainEmptyWidget) {
        return SliverPadding(
          padding: padding,
          sliver: SliverFillRemaining(
            child: emptyWidget,
          ),
        );
      }

      return SliverPadding(
        padding: padding,
        sliver: SliverToBoxAdapter(
          child: emptyWidget,
        ),
      );
    }

    Widget? itemBuilder(BuildContext context, int index) {
      if (index == 0) {
        // prepend
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await dataSource.update(LoadType.prepend);
        });
      } else if (index == items.length - 1) {
        // append
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await dataSource.update(LoadType.append);
        });
      }

      return builder(context, items[index], index);
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: padding.top,
          ),
        ),
        if (state is LoadStateLoading && state.isPrepend)
          SliverPadding(
            padding: _horizontalPadding,
            sliver: SliverToBoxAdapter(
              child: prependLoadingWidget,
            ),
          ),
        SliverPadding(
          padding: _horizontalPadding,
          sliver: _separatorBuilder != null
              ? SliverList.separated(
                  itemBuilder: itemBuilder,
                  separatorBuilder: _separatorBuilder!,
                  itemCount: items.length,
                )
              : SliverList.builder(
                  itemBuilder: itemBuilder,
                  itemCount: items.length,
                ),
        ),
        if (state is LoadStateLoading && state.isAppend)
          SliverPadding(
            padding: _horizontalPadding,
            sliver: SliverToBoxAdapter(
              child: appendLoadingWidget,
            ),
          ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: padding.bottom,
          ),
        ),
      ],
    );
  }
}

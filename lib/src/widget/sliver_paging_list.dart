import 'dart:math';

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
    this.padding = EdgeInsets.zero,
    required IndexedWidgetBuilder separatorBuilder,
  }) : _separatorBuilder = separatorBuilder;

  /// region Paging
  final DataSource<PageKey, Value> dataSource;
  final TypedWidgetBuilder<Value> builder;
  final ExceptionWidgetBuilder errorBuilder;
  final Widget initialLoadingWidget;
  final Widget prependLoadingWidget;
  final Widget appendLoadingWidget;
  final Widget emptyWidget;

  final IndexedWidgetBuilder? _separatorBuilder;

  /// endregion

  /// region customize
  final EdgeInsets padding;

  /// endregion

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<NotifierState<PageKey, Value>>(
      valueListenable: dataSource.notifier,
      builder: (context, value, child) => switch (value) {
        Paging(state: final state, data: final pages) =>
          _separatorBuilder != null
              ? _List<PageKey, Value>.separated(
                  state: state,
                  pages: pages,
                  separatorBuilder: _separatorBuilder!,
                  dataSource: dataSource,
                  builder: builder,
                  errorBuilder: errorBuilder,
                  initialLoadingWidget: initialLoadingWidget,
                  prependLoadingWidget: prependLoadingWidget,
                  appendLoadingWidget: appendLoadingWidget,
                  emptyWidget: emptyWidget,
                  padding: padding,
                )
              : _List<PageKey, Value>(
                  state: state,
                  pages: pages,
                  dataSource: dataSource,
                  builder: builder,
                  errorBuilder: errorBuilder,
                  initialLoadingWidget: initialLoadingWidget,
                  prependLoadingWidget: prependLoadingWidget,
                  appendLoadingWidget: appendLoadingWidget,
                  emptyWidget: emptyWidget,
                  padding: padding,
                ),
        Warning(e: final e) => SliverPadding(
            padding: padding,
            sliver: SliverFillRemaining(
              child: errorBuilder(context, e),
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
    required this.padding,
    required IndexedWidgetBuilder separatorBuilder,
  }) : _separatorBuilder = separatorBuilder;

  final LoadState state;
  final List<PageData<PageKey, Value>> pages;

  /// region Paging
  final DataSource<PageKey, Value> dataSource;
  final TypedWidgetBuilder<Value> builder;
  final ExceptionWidgetBuilder errorBuilder;
  final Widget initialLoadingWidget;
  final Widget prependLoadingWidget;
  final Widget appendLoadingWidget;
  final Widget emptyWidget;

  final IndexedWidgetBuilder? _separatorBuilder;

  /// endregion

  /// region customize
  final EdgeInsets padding;

  EdgeInsets get _horizontalPadding => EdgeInsets.only(
        left: padding.left,
        right: padding.right,
      );

  /// endregion

  @override
  Widget build(BuildContext context) {
    if (state == LoadState.init) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        dataSource.update(LoadType.refresh);
      });

      return SliverPadding(
        padding: padding,
        sliver: SliverFillRemaining(
          child: initialLoadingWidget,
        ),
      );
    } else if (state == LoadState.initLoading) {
      return SliverPadding(
        padding: padding,
        sliver: SliverFillRemaining(
          child: initialLoadingWidget,
        ),
      );
    }

    final List<Value> items = [...pages.map((e) => e.data).flattened];
    if (state == LoadState.loaded && items.isEmpty) {
      return SliverPadding(
        padding: padding,
        sliver: SliverFillRemaining(
          child: emptyWidget,
        ),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: padding.top,
          ),
        ),
        if (state == LoadState.prependLoading)
          SliverPadding(
            padding: _horizontalPadding,
            sliver: SliverToBoxAdapter(
              child: prependLoadingWidget,
            ),
          ),
        SliverPadding(
          padding: _horizontalPadding,
          sliver: SliverList(
            delegate: _createDelegate(items),
          ),
        ),
        if (state == LoadState.appendLoading)
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

  SliverChildBuilderDelegate _createDelegate(List<Value> items) {
    if (_separatorBuilder != null) {
      final count = _computeActualChildCount(items.length);
      return SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            // prepend
            WidgetsBinding.instance.addPostFrameCallback((_) {
              dataSource.update(LoadType.prepend);
            });
          } else if (index == count - 1) {
            // append
            WidgetsBinding.instance.addPostFrameCallback((_) {
              dataSource.update(LoadType.append);
            });
          }

          final int itemIndex = index ~/ 2;
          final Widget widget;
          if (index.isEven) {
            final element = items[itemIndex];
            widget = builder(context, element, itemIndex);
          } else {
            widget = _separatorBuilder!(context, itemIndex);
          }

          return widget;
        },
        childCount: count,
      );
    } else {
      return SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            // prepend
            WidgetsBinding.instance.addPostFrameCallback((_) {
              dataSource.update(LoadType.prepend);
            });
          } else if (index == items.length - 1) {
            // append
            WidgetsBinding.instance.addPostFrameCallback((_) {
              dataSource.update(LoadType.append);
            });
          }

          final element = items[index];
          return builder(context, element, index);
        },
        childCount: items.length,
      );
    }
  }

  /// Helper method to compute the actual child count for the separated constructor.
  static int _computeActualChildCount(int itemCount) =>
      max(0, itemCount * 2 - 1);
}

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:paging_view/src/data_source.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/function.dart';
import 'package:paging_view/src/private/entity.dart';

/// A sliver that manages pages and scroll position to read more data.
/// Display a grid list.
class SliverPagingGrid<PageKey, Value> extends StatelessWidget {
  const SliverPagingGrid({
    super.key,
    required this.gridDelegate,
    required this.dataSource,
    required this.builder,
    required this.errorBuilder,
    required this.initialLoadingWidget,
    this.prependLoadingWidget = const SizedBox.shrink(),
    this.appendLoadingWidget = const SizedBox.shrink(),
    this.emptyWidget = const SizedBox.shrink(),
    this.padding = EdgeInsets.zero,
  });

  /// region Paging
  final DataSource<PageKey, Value> dataSource;
  final TypedWidgetBuilder<Value> builder;
  final ExceptionWidgetBuilder errorBuilder;
  final Widget initialLoadingWidget;
  final Widget prependLoadingWidget;
  final Widget appendLoadingWidget;
  final Widget emptyWidget;

  /// endregion

  /// region customize
  final EdgeInsets padding;

  final SliverGridDelegate gridDelegate;

  /// endregion

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PageManagerState<PageKey, Value>>(
      valueListenable: dataSource.notifier,
      builder: (context, value, child) => switch (value) {
        Paging(state: final state, data: final pages) => _Grid<PageKey, Value>(
            state: state,
            pages: pages,
            gridDelegate: gridDelegate,
            dataSource: dataSource,
            builder: builder,
            errorBuilder: errorBuilder,
            initialLoadingWidget: initialLoadingWidget,
            prependLoadingWidget: prependLoadingWidget,
            appendLoadingWidget: appendLoadingWidget,
            emptyWidget: emptyWidget,
            padding: padding,
          ),
        Warning(exception: final exception) => SliverPadding(
            padding: padding,
            sliver: SliverFillRemaining(
              child: errorBuilder(context, exception),
            ),
          ),
      },
    );
  }
}

/// Internal widget for [SliverPagingGrid].
class _Grid<PageKey, Value> extends StatelessWidget {
  const _Grid({
    required this.state,
    required this.pages,
    required this.gridDelegate,
    required this.dataSource,
    required this.builder,
    required this.errorBuilder,
    required this.initialLoadingWidget,
    required this.prependLoadingWidget,
    required this.appendLoadingWidget,
    required this.emptyWidget,
    required this.padding,
  });

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

  /// endregion

  /// region customize
  final EdgeInsets padding;

  EdgeInsets get _horizontalPadding => EdgeInsets.only(
        left: padding.left,
        right: padding.right,
      );

  final SliverGridDelegate gridDelegate;

  /// endregion

  @override
  Widget build(BuildContext context) {
    final state = this.state;
    if (state is LoadStateInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        dataSource.update(LoadType.init);
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
        if (state is LoadStateLoading && state.isPrepend)
          SliverPadding(
            padding: _horizontalPadding,
            sliver: SliverToBoxAdapter(
              child: prependLoadingWidget,
            ),
          ),
        SliverPadding(
          padding: _horizontalPadding,
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
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
            ),
            gridDelegate: gridDelegate,
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

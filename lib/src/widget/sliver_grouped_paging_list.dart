import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:paging_view/src/function.dart';
import 'package:paging_view/src/grouped_data_source.dart';
import 'package:paging_view/src/grouped_entity.dart';
import 'package:paging_view/src/private/entity.dart';
import 'package:paging_view/src/private/sliver_bounds_detector.dart';

/// A sliver that displays items grouped by a parent element.
class SliverGroupedPagingList<PageKey, Parent, Value> extends StatelessWidget {
  /// Creates a sliver with grouped items.
  const SliverGroupedPagingList({
    super.key,
    required this.dataSource,
    required this.headerBuilder,
    required this.itemBuilder,
    required this.errorBuilder,
    required this.initialLoadingWidget,
    this.prependLoadingWidget = const SizedBox.shrink(),
    this.appendLoadingWidget = const SizedBox.shrink(),
    this.emptyWidget = const SizedBox.shrink(),
    this.fillRemainErrorWidget = true,
    this.fillRemainEmptyWidget = true,
    this.padding = EdgeInsets.zero,
    this.stickyHeader = false,
    this.stickyHeaderMinExtentPrototype,
    this.stickyHeaderMaxExtentPrototype,
  }) : _separatorBuilder = null;

  /// Creates a sliver with grouped items and separators.
  const SliverGroupedPagingList.separated({
    super.key,
    required this.dataSource,
    required this.headerBuilder,
    required this.itemBuilder,
    required this.errorBuilder,
    required this.initialLoadingWidget,
    this.prependLoadingWidget = const SizedBox.shrink(),
    this.appendLoadingWidget = const SizedBox.shrink(),
    this.emptyWidget = const SizedBox.shrink(),
    this.fillRemainErrorWidget = true,
    this.fillRemainEmptyWidget = true,
    this.padding = EdgeInsets.zero,
    this.stickyHeader = false,
    this.stickyHeaderMinExtentPrototype,
    this.stickyHeaderMaxExtentPrototype,
    required IndexedWidgetBuilder separatorBuilder,
  }) : _separatorBuilder = separatorBuilder;

  /// The grouped data source that provides grouped pages.
  final GroupedDataSource<PageKey, Parent, Value> dataSource;

  /// The builder for group headers.
  final TypedWidgetBuilder<Parent> headerBuilder;

  /// The builder for individual items within a group.
  final GroupedTypedWidgetBuilder<Value> itemBuilder;

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

  /// The padding around the list.
  final EdgeInsets padding;

  /// If true, group headers will be sticky.
  final bool stickyHeader;

  /// The prototype widget for the minimum extent of sticky headers.
  /// see [SliverResizingHeader.minExtentPrototype]
  final Widget? stickyHeaderMinExtentPrototype;

  /// The prototype widget for the maximum extent of sticky headers.
  /// see [SliverResizingHeader.maxExtentPrototype]
  final Widget? stickyHeaderMaxExtentPrototype;

  /// The separator builder between items.
  final IndexedWidgetBuilder? _separatorBuilder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PageManagerState<PageKey, Value>>(
      valueListenable: dataSource.notifier,
      builder: (context, value, child) => switch (value) {
        Paging(:final state) => _GroupedList<PageKey, Parent, Value>(
          state: state,
          groupedData: dataSource.groupedValues,
          dataSource: dataSource,
          headerBuilder: headerBuilder,
          valueBuilder: itemBuilder,
          errorBuilder: errorBuilder,
          initialLoadingWidget: initialLoadingWidget,
          prependLoadingWidget: prependLoadingWidget,
          appendLoadingWidget: appendLoadingWidget,
          emptyWidget: emptyWidget,
          fillRemainEmptyWidget: fillRemainEmptyWidget,
          padding: padding,
          stickyHeader: stickyHeader,
          stickyHeaderMinExtentPrototype: stickyHeaderMinExtentPrototype,
          stickyHeaderMaxExtentPrototype: stickyHeaderMaxExtentPrototype,
          separatorBuilder: _separatorBuilder,
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

/// Internal widget for [SliverGroupedPagingList].
class _GroupedList<PageKey, Parent, Value> extends StatelessWidget {
  const _GroupedList({
    required this.state,
    required this.groupedData,
    required this.dataSource,
    required this.headerBuilder,
    required this.valueBuilder,
    required this.errorBuilder,
    required this.initialLoadingWidget,
    required this.prependLoadingWidget,
    required this.appendLoadingWidget,
    required this.emptyWidget,
    required this.fillRemainEmptyWidget,
    required this.padding,
    required this.stickyHeader,
    required this.stickyHeaderMinExtentPrototype,
    required this.stickyHeaderMaxExtentPrototype,
    required this.separatorBuilder,
  });

  final LoadState state;
  final List<GroupedPageData<Parent, Value>> groupedData;
  final GroupedDataSource<PageKey, Parent, Value> dataSource;
  final TypedWidgetBuilder<Parent> headerBuilder;
  final GroupedTypedWidgetBuilder<Value> valueBuilder;
  final ExceptionWidgetBuilder errorBuilder;
  final Widget initialLoadingWidget;
  final Widget prependLoadingWidget;
  final Widget appendLoadingWidget;
  final Widget emptyWidget;
  final bool fillRemainEmptyWidget;
  final EdgeInsets padding;
  final bool stickyHeader;
  final Widget? stickyHeaderMinExtentPrototype;
  final Widget? stickyHeaderMaxExtentPrototype;
  final IndexedWidgetBuilder? separatorBuilder;

  EdgeInsets get _horizontalPadding =>
      EdgeInsets.only(left: padding.left, right: padding.right);

  @override
  Widget build(BuildContext context) {
    final state = this.state;
    if (state is LoadStateInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await dataSource.update(LoadType.init);
      });

      return SliverPadding(
        padding: padding,
        sliver: SliverFillRemaining(child: initialLoadingWidget),
      );
    } else if (state is LoadStateLoading && state.isInit) {
      return SliverPadding(
        padding: padding,
        sliver: SliverFillRemaining(child: initialLoadingWidget),
      );
    }

    if (state is LoadStateLoaded && groupedData.isEmpty) {
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
        if (state is LoadStateLoading && state.isPrepend)
          SliverPadding(
            padding: _horizontalPadding,
            sliver: SliverToBoxAdapter(child: prependLoadingWidget),
          ),
        SliverBoundsDetector(
          onVisibilityChanged: (isVisible) {
            if (isVisible) {
              dataSource.update(LoadType.prepend);
            }
          },
        ),
        ...groupedData.mapIndexed(
          (groupIndex, group) => SliverPadding(
            padding: _horizontalPadding,
            sliver: SliverMainAxisGroup(
              slivers: [
                stickyHeader
                    ? SliverResizingHeader(
                        minExtentPrototype: stickyHeaderMinExtentPrototype,
                        maxExtentPrototype: stickyHeaderMaxExtentPrototype,
                        child: headerBuilder(context, group.parent, groupIndex),
                      )
                    : SliverToBoxAdapter(
                        child: headerBuilder(context, group.parent, groupIndex),
                      ),
                if (separatorBuilder == null)
                  SliverList.builder(
                    itemCount: group.children.length,
                    itemBuilder: (context, index) => valueBuilder(
                      context,
                      group.children[index].value,
                      group.children[index].index,
                      index,
                    ),
                  )
                else
                  SliverList.separated(
                    itemCount: group.children.length,
                    itemBuilder: (context, index) => valueBuilder(
                      context,
                      group.children[index].value,
                      group.children[index].index,
                      index,
                    ),
                    separatorBuilder: separatorBuilder!,
                  ),
              ],
            ),
          ),
        ),
        SliverBoundsDetector(
          onVisibilityChanged: (isVisible) {
            if (isVisible) {
              dataSource.update(LoadType.append);
            }
          },
        ),
        if (state is LoadStateLoading && state.isAppend)
          SliverPadding(
            padding: _horizontalPadding,
            sliver: SliverToBoxAdapter(child: appendLoadingWidget),
          ),
        SliverToBoxAdapter(child: SizedBox(height: padding.bottom)),
      ],
    );
  }
}

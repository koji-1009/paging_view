import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:paging_view/src/function.dart';
import 'package:paging_view/src/grouped_data_source.dart';
import 'package:paging_view/src/widget/sliver_grouped_paging_list.dart';

/// A scrollable list that displays grouped items.
class GroupedPagingList<PageKey, Parent, Value> extends StatelessWidget {
  /// Creates a scrollable list with grouped items.
  const GroupedPagingList({
    super.key,
    required this.dataSource,
    required this.headerBuilder,
    required this.itemBuilder,
    required this.errorBuilder,
    required this.initialLoadingWidget,
    this.prependLoadingWidget = const SizedBox.shrink(),
    this.appendLoadingWidget = const SizedBox.shrink(),
    this.emptyWidget = const SizedBox.shrink(),
    this.padding = EdgeInsets.zero,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.scrollBehavior,
    this.center,
    this.anchor = 0.0,
    this.shrinkWrap = false,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.clipBehavior = Clip.hardEdge,
  }) : _itemSeparatorBuilder = null;

  /// Creates a scrollable list with grouped items, with separators.
  const GroupedPagingList.separated({
    super.key,
    required this.dataSource,
    required this.headerBuilder,
    required this.itemBuilder,
    required this.errorBuilder,
    required this.initialLoadingWidget,
    this.prependLoadingWidget = const SizedBox.shrink(),
    this.appendLoadingWidget = const SizedBox.shrink(),
    this.emptyWidget = const SizedBox.shrink(),
    this.padding = EdgeInsets.zero,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.scrollBehavior,
    this.center,
    this.anchor = 0.0,
    this.shrinkWrap = false,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.clipBehavior = Clip.hardEdge,
    required IndexedWidgetBuilder itemSeparatorBuilder,
  }) : _itemSeparatorBuilder = itemSeparatorBuilder;

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

  /// The padding around the list.
  final EdgeInsets padding;

  /// see [CustomScrollView.scrollDirection]
  final Axis scrollDirection;

  /// see [CustomScrollView.reverse]
  final bool reverse;

  /// see [CustomScrollView.controller]
  final ScrollController? controller;

  /// see [CustomScrollView.primary]
  final bool? primary;

  /// see [CustomScrollView.physics]
  final ScrollPhysics? physics;

  /// see [CustomScrollView.scrollBehavior]
  final ScrollBehavior? scrollBehavior;

  /// see [CustomScrollView.center]
  final Key? center;

  /// see [CustomScrollView.anchor]
  final double anchor;

  /// see [CustomScrollView.shrinkWrap]
  final bool shrinkWrap;

  /// see [CustomScrollView.cacheExtent]
  final double? cacheExtent;

  /// see [CustomScrollView.dragStartBehavior]
  final DragStartBehavior dragStartBehavior;

  /// see [CustomScrollView.keyboardDismissBehavior]
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// see [CustomScrollView.clipBehavior]
  final Clip clipBehavior;

  final IndexedWidgetBuilder? _itemSeparatorBuilder;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: key,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      scrollBehavior: scrollBehavior,
      center: center,
      anchor: anchor,
      shrinkWrap: shrinkWrap,
      cacheExtent: cacheExtent,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      clipBehavior: clipBehavior,
      slivers: [
        _itemSeparatorBuilder != null
            ? SliverGroupedPagingList<PageKey, Parent, Value>.separated(
                key: key,
                dataSource: dataSource,
                headerBuilder: headerBuilder,
                itemBuilder: itemBuilder,
                errorBuilder: errorBuilder,
                initialLoadingWidget: initialLoadingWidget,
                prependLoadingWidget: prependLoadingWidget,
                appendLoadingWidget: appendLoadingWidget,
                emptyWidget: emptyWidget,
                padding: padding,
                itemSeparatorBuilder: _itemSeparatorBuilder,
              )
            : SliverGroupedPagingList<PageKey, Parent, Value>(
                key: key,
                dataSource: dataSource,
                headerBuilder: headerBuilder,
                itemBuilder: itemBuilder,
                errorBuilder: errorBuilder,
                initialLoadingWidget: initialLoadingWidget,
                prependLoadingWidget: prependLoadingWidget,
                appendLoadingWidget: appendLoadingWidget,
                emptyWidget: emptyWidget,
                padding: padding,
              ),
      ],
    );
  }
}

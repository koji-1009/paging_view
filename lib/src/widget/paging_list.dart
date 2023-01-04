import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:paging_view/src/data_source.dart';
import 'package:paging_view/src/function.dart';
import 'package:paging_view/src/widget/sliver_paging_list.dart';

/// A single-column list that manages pages and scroll position
/// to read more data.
class PagingList<PageKey, Value> extends StatelessWidget {
  /// Creates a scrollable, linear array of widgets that are created on demand.
  const PagingList({
    super.key,
    required this.dataSource,
    required this.builder,
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
  }) : _separatorBuilder = null;

  /// Creates a scrollable linear array of list "items" separated
  /// by list item "separators".
  const PagingList.separated({
    super.key,
    required this.dataSource,
    required this.builder,
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

  /// endregion

  /// region customize
  final EdgeInsets padding;

  /// endregion

  /// region CustomScrollView
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final ScrollBehavior? scrollBehavior;
  final bool shrinkWrap;
  final Key? center;
  final double anchor;
  final double? cacheExtent;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final Clip clipBehavior;

  final IndexedWidgetBuilder? _separatorBuilder;

  /// endregion

  @override
  Widget build(BuildContext context) => CustomScrollView(
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
          _separatorBuilder != null
              ? SliverPagingList<PageKey, Value>.separated(
                  key: key,
                  dataSource: dataSource,
                  builder: builder,
                  errorBuilder: errorBuilder,
                  initialLoadingWidget: initialLoadingWidget,
                  prependLoadingWidget: prependLoadingWidget,
                  appendLoadingWidget: appendLoadingWidget,
                  emptyWidget: emptyWidget,
                  padding: padding,
                  separatorBuilder: _separatorBuilder!,
                )
              : SliverPagingList<PageKey, Value>(
                  key: key,
                  dataSource: dataSource,
                  builder: builder,
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

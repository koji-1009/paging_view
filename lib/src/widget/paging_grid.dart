import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:paging_view/src/data_source.dart';
import 'package:paging_view/src/function.dart';
import 'package:paging_view/src/widget/sliver_paging_grid.dart';

/// A grid list that manages pages and scroll position
/// to read more data.
class PagingGrid<PageKey, Value> extends StatelessWidget {
  /// Creates a scrollable, 2D array of widgets that are created on demand.
  const PagingGrid({
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
  });

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

  /// The padding around the grid.
  final EdgeInsets padding;

  /// The delegate that controls the layout of the children within the grid.
  final SliverGridDelegate gridDelegate;

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

  /// see [CustomScrollView.shrinkWrap]
  final bool shrinkWrap;

  /// see [CustomScrollView.center]
  final Key? center;

  /// see [CustomScrollView.anchor]
  final double anchor;

  /// see [CustomScrollView.cacheExtent]
  final double? cacheExtent;

  /// see [CustomScrollView.dragStartBehavior]
  final DragStartBehavior dragStartBehavior;

  /// see [CustomScrollView.keyboardDismissBehavior]
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// see [CustomScrollView.clipBehavior]
  final Clip clipBehavior;

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
        SliverPagingGrid<PageKey, Value>(
          key: key,
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
      ],
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:paging_view/src/data_source.dart';
import 'package:paging_view/src/function.dart';
import 'package:paging_view/src/widget/sliver_paging_grid.dart';

class PagingGrid<Value, PageKey> extends StatelessWidget {
  const PagingGrid({
    super.key,
    required this.gridDelegate,
    required this.dataSource,
    required this.builder,
    required this.errorBuilder,
    required this.initialLoadingWidget,
    this.prependLoadingWidget,
    this.appendLoadingWidget,
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

  /// region Paging
  final DataSource<Value, PageKey> dataSource;
  final TypedWidgetBuilder<Value> builder;
  final ExceptionWidgetBuilder errorBuilder;
  final Widget initialLoadingWidget;
  final Widget? prependLoadingWidget;
  final Widget? appendLoadingWidget;

  /// endregion

  /// region customize
  final EdgeInsets padding;
  final SliverGridDelegate gridDelegate;

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
          SliverPagingGrid<Value, PageKey>(
            key: key,
            gridDelegate: gridDelegate,
            dataSource: dataSource,
            builder: builder,
            errorBuilder: errorBuilder,
            initialLoadingWidget: initialLoadingWidget,
            prependLoadingWidget: prependLoadingWidget,
            appendLoadingWidget: appendLoadingWidget,
            padding: padding,
          ),
        ],
      );
}

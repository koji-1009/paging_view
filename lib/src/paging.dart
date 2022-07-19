import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_paging/src/data_source.dart';
import 'package:flutter_paging/src/function.dart';
import 'package:flutter_paging/src/sliver_paging.dart';

class Paging<Value, Key> extends StatelessWidget {
  const Paging({
    super.key,
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
    this.shrinkWrap = false,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.clipBehavior = Clip.hardEdge,
  });

  /// region Paging
  final DataSource<Value, Key> dataSource;
  final TypedWidgetBuilder<Value> builder;
  final ExceptionWidgetBuilder errorBuilder;
  final Widget initialLoadingWidget;
  final Widget? prependLoadingWidget;
  final Widget? appendLoadingWidget;

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
        shrinkWrap: shrinkWrap,
        cacheExtent: cacheExtent,
        dragStartBehavior: dragStartBehavior,
        keyboardDismissBehavior: keyboardDismissBehavior,
        clipBehavior: clipBehavior,
        slivers: [
          SliverPaging<Value, Key>(
            key: key,
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

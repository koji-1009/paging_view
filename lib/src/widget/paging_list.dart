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

  final IndexedWidgetBuilder? _separatorBuilder;

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
                separatorBuilder: _separatorBuilder,
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
}

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:paging_view/src/data_source.dart';
import 'package:paging_view/src/function.dart';
import 'package:paging_view/src/widget/sliver_paging_list.dart';

/// A high-level widget that displays a scrollable, paginated list of items.
///
/// [PagingList] is a convenient wrapper around [SliverPagingList] that
/// handles creating the [CustomScrollView] for you. It's the easiest way to
/// get started with displaying a simple, paginated list.
///
/// For more complex layouts, such as those with a `SliverAppBar` or multiple
/// slivers, consider using [SliverPagingList] directly inside a
/// [CustomScrollView].
class PagingList<PageKey, Value> extends StatelessWidget {
  /// Creates a scrollable, linear array of widgets that are created on demand.
  const PagingList({
    super.key,
    required this.dataSource,
    required this.builder,
    this.errorBuilder,
    this.initialLoadingWidget,
    this.prependLoadingWidget,
    this.appendLoadingWidget,
    this.emptyWidget,
    this.padding = EdgeInsets.zero,
    this.autoLoadPrepend = true,
    this.autoLoadAppend = true,
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
    this.errorBuilder,
    this.initialLoadingWidget,
    this.prependLoadingWidget,
    this.appendLoadingWidget,
    this.emptyWidget,
    this.padding = EdgeInsets.zero,
    this.autoLoadPrepend = true,
    this.autoLoadAppend = true,
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

  /// The [DataSource] that provides the paginated data.
  final DataSource<PageKey, Value> dataSource;

  /// A builder that creates a widget for each item in the list.
  final TypedWidgetBuilder<Value> builder;

  /// A builder that creates a widget to display when an error occurs.
  final ExceptionWidgetBuilder? errorBuilder;

  /// The widget to display while the first page is being loaded.
  final Widget? initialLoadingWidget;

  /// The widget to display at the top of the list when a `prepend` operation
  /// is in progress.
  final Widget? prependLoadingWidget;

  /// The widget to display at the bottom of the list when an `append` operation
  /// is in progress.
  final Widget? appendLoadingWidget;

  /// The widget to display when the list is empty.
  final Widget? emptyWidget;

  /// The amount of space by which to inset the children.
  final EdgeInsets padding;

  /// The separator builder between items.
  final IndexedWidgetBuilder? _separatorBuilder;

  /// Automatically load more data at the beginning of the list
  /// when reaching the boundary.
  final bool autoLoadPrepend;

  /// Automatically load more data at the end of the list
  /// when reaching the boundary.
  final bool autoLoadAppend;

  /// The axis along which the scroll view scrolls.
  ///
  /// See [ScrollView.scrollDirection].
  final Axis scrollDirection;

  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// See [ScrollView.reverse].
  final bool reverse;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// See [ScrollView.controller].
  final ScrollController? controller;

  /// Whether this is the primary scroll view associated with the parent
  /// [PrimaryScrollController].
  ///
  /// See [ScrollView.primary].
  final bool? primary;

  /// How the scroll view should respond to user input.
  ///
  /// See [ScrollView.physics].
  final ScrollPhysics? physics;

  /// A [ScrollBehavior] that will be applied to this widget individually.
  ///
  /// See [ScrollView.scrollBehavior].
  final ScrollBehavior? scrollBehavior;

  /// Whether to wrap the entire scrollable contents in a [Center] widget.
  ///
  /// This is useful when the content might not be tall enough to fill the
  /// viewport.
  final bool shrinkWrap;

  /// The key of the sliver that should be centered in the viewport.
  ///
  /// See [CustomScrollView.center].
  final Key? center;

  /// The relative position of the center sliver.
  ///
  /// See [ScrollView.anchor].
  final double anchor;

  /// The cache extent of the scroll view.
  ///
  /// See [ScrollView.cacheExtent].
  final double? cacheExtent;

  /// Determines the way that drag start behavior is handled.
  ///
  /// See [ScrollView.dragStartBehavior].
  final DragStartBehavior dragStartBehavior;

  /// [ScrollViewKeyboardDismissBehavior] the defines how this [ScrollView] will
  /// dismiss the keyboard automatically.
  ///
  /// See [ScrollView.keyboardDismissBehavior].
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// The content will be clipped (or not) according to this option.
  ///
  /// See [ScrollView.clipBehavior].
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
                autoLoadPrepend: autoLoadPrepend,
                autoLoadAppend: autoLoadAppend,
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
                autoLoadPrepend: autoLoadPrepend,
                autoLoadAppend: autoLoadAppend,
              ),
      ],
    );
  }
}

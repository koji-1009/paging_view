import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:paging_view/src/function.dart';
import 'package:paging_view/src/grouped_data_source.dart';
import 'package:paging_view/src/widget/sliver_grouped_paging_grid.dart';

/// A high-level widget that displays a scrollable, paginated grid with grouped items.
///
/// [GroupedPagingGrid] is a convenient wrapper around [SliverGroupedPagingGrid]
/// that handles creating the [CustomScrollView] for you. It's the easiest way
/// to display a grid with sections and headers.
///
/// It requires a [GroupedDataSource] to provide the data and grouping logic.
///
/// For more complex layouts, such as those with a `SliverAppBar` or multiple
/// slivers, consider using [SliverGroupedPagingGrid] directly inside a
/// [CustomScrollView].
class GroupedPagingGrid<PageKey, Parent, Value> extends StatelessWidget {
  /// Creates a scrollable, 2D array of widgets that are created on demand.
  const GroupedPagingGrid({
    super.key,
    required this.gridDelegate,
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
    this.stickyHeader = false,
    this.stickyHeaderMinExtentPrototype,
    this.stickyHeaderMaxExtentPrototype,
  });

  /// A delegate that controls the layout of the children within the grid.
  ///
  /// See [GridView.gridDelegate].
  final SliverGridDelegate gridDelegate;

  /// The [GroupedDataSource] that provides the paginated and grouped data.
  final GroupedDataSource<PageKey, Parent, Value> dataSource;

  /// A builder that creates a widget for each group header.
  ///
  /// The `parent` argument is the value returned by the `groupBy` method
  /// in your [GroupedDataSource].
  final TypedWidgetBuilder<Parent> headerBuilder;

  /// A builder that creates a widget for each item within a group.
  final GroupedTypedWidgetBuilder<Value> itemBuilder;

  /// A builder that creates a widget to display when an error occurs.
  final ExceptionWidgetBuilder errorBuilder;

  /// The widget to display while the first page is being loaded.
  final Widget initialLoadingWidget;

  /// The widget to display at the top of the grid when a `prepend` operation
  /// is in progress.
  final Widget prependLoadingWidget;

  /// The widget to display at the bottom of the grid when an `append` operation
  /// is in progress.
  final Widget appendLoadingWidget;

  /// The widget to display when the grid is empty.
  final Widget emptyWidget;

  /// Whether the `errorBuilder` should be constrained to fill the viewport.
  final bool fillRemainErrorWidget;

  /// Whether the `emptyWidget` should be constrained to fill the viewport.
  final bool fillRemainEmptyWidget;

  /// The amount of space by which to inset the children.
  final EdgeInsets padding;

  /// If `true`, group headers will remain visible at the top of the screen
  /// as the user scrolls down through the items in that group.
  final bool stickyHeader;

  /// A prototype widget for calculating the minimum extent of a sticky header.
  ///
  /// See [SliverResizingHeader.minExtentPrototype].
  final Widget? stickyHeaderMinExtentPrototype;

  /// A prototype widget for calculating the maximum extent of a sticky header.
  ///
  /// See [SliverResizingHeader.maxExtentPrototype].
  final Widget? stickyHeaderMaxExtentPrototype;

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
  /// See [GridView.shrinkWrap].
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
        SliverGroupedPagingGrid<PageKey, Parent, Value>(
          key: key,
          gridDelegate: gridDelegate,
          dataSource: dataSource,
          headerBuilder: headerBuilder,
          itemBuilder: itemBuilder,
          errorBuilder: errorBuilder,
          initialLoadingWidget: initialLoadingWidget,
          prependLoadingWidget: prependLoadingWidget,
          appendLoadingWidget: appendLoadingWidget,
          emptyWidget: emptyWidget,
          fillRemainErrorWidget: fillRemainErrorWidget,
          fillRemainEmptyWidget: fillRemainEmptyWidget,
          padding: padding,
          stickyHeader: stickyHeader,
          stickyHeaderMinExtentPrototype: stickyHeaderMinExtentPrototype,
          stickyHeaderMaxExtentPrototype: stickyHeaderMaxExtentPrototype,
        ),
      ],
    );
  }
}

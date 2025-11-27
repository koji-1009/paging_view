import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:paging_view/src/function.dart';
import 'package:paging_view/src/grouped_data_source.dart';
import 'package:paging_view/src/widget/sliver_grouped_paging_list.dart';

/// A high-level widget that displays a scrollable, paginated list with grouped items.
///
/// [GroupedPagingList] is a convenient wrapper around [SliverGroupedPagingList]
/// that handles creating the [CustomScrollView] for you. It's the easiest way
/// to display a list with sections and headers (e.g., a contact list grouped
/// by the first letter of the name).
///
/// It requires a [GroupedDataSource] to provide the data and grouping logic.
///
/// For more complex layouts, such as those with a `SliverAppBar` or multiple
/// slivers, consider using [SliverGroupedPagingList] directly inside a
/// [CustomScrollView].
class GroupedPagingList<PageKey, Parent, Value> extends StatelessWidget {
  /// Creates a scrollable list with grouped items.
  const GroupedPagingList({
    super.key,
    required this.dataSource,
    required this.headerBuilder,
    required this.itemBuilder,
    this.errorBuilder,
    this.initialLoadingWidget,
    this.prependLoadingWidget,
    this.appendLoadingWidget,
    this.emptyWidget,
    this.fillRemainErrorWidget = true,
    this.fillRemainEmptyWidget = true,
    this.padding = EdgeInsets.zero,
    this.stickyHeader = false,
    this.stickyHeaderMinExtentPrototype,
    this.stickyHeaderMaxExtentPrototype,
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

  /// Creates a scrollable list with grouped items and separators between items.
  const GroupedPagingList.separated({
    super.key,
    required this.dataSource,
    required this.headerBuilder,
    required this.itemBuilder,
    this.errorBuilder,
    this.initialLoadingWidget,
    this.prependLoadingWidget,
    this.appendLoadingWidget,
    this.emptyWidget,
    this.fillRemainErrorWidget = true,
    this.fillRemainEmptyWidget = true,
    this.padding = EdgeInsets.zero,
    this.stickyHeader = false,
    this.stickyHeaderMinExtentPrototype,
    this.stickyHeaderMaxExtentPrototype,
    this.autoLoadPrepend = true,
    this.autoLoadAppend = true,
    required IndexedWidgetBuilder separatorBuilder,
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
  }) : _separatorBuilder = separatorBuilder;

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

  /// A builder for creating separators between items.
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

  /// The key of the sliver that should be centered in the viewport.
  ///
  /// See [CustomScrollView.center].
  final Key? center;

  /// The relative position of the center sliver.
  ///
  /// See [ScrollView.anchor].
  final double anchor;

  /// Whether to wrap the entire scrollable contents in a [Center] widget.
  ///
  /// See [ListView.shrinkWrap].
  final bool shrinkWrap;

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
                stickyHeader: stickyHeader,
                stickyHeaderMinExtentPrototype: stickyHeaderMinExtentPrototype,
                stickyHeaderMaxExtentPrototype: stickyHeaderMaxExtentPrototype,
                autoLoadAppend: autoLoadAppend,
                autoLoadPrepend: autoLoadPrepend,
                separatorBuilder: _separatorBuilder,
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
                stickyHeader: stickyHeader,
                stickyHeaderMinExtentPrototype: stickyHeaderMinExtentPrototype,
                stickyHeaderMaxExtentPrototype: stickyHeaderMaxExtentPrototype,
                autoLoadAppend: autoLoadAppend,
                autoLoadPrepend: autoLoadPrepend,
              ),
      ],
    );
  }
}

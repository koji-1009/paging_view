import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:paging_view/src/center_data_source.dart';
import 'package:paging_view/src/function.dart';
import 'package:paging_view/src/private/center_page_manager.dart';
import 'package:paging_view/src/private/entity.dart';
import 'package:paging_view/src/private/sliver_bounds_detector.dart';

/// A widget that displays a paginated list with a center anchor point.
///
/// Unlike [PagingList], this widget uses [CustomScrollView]'s `center` key
/// feature to anchor the initial content at a specific position. This allows
/// for seamless bi-directional infinite scrolling:
///
/// - Prepend items appear above the center (scrolling up reveals them)
/// - Append items appear below the center (scrolling down reveals them)
///
/// This is particularly useful for scenarios like:
/// - Chat interfaces where new messages appear at the bottom
/// - Timeline views where you want to start at a specific point
/// - Any list where bi-directional loading from a center point is desired
class CenterPagingList<PageKey, Value> extends StatelessWidget {
  /// Creates a [CenterPagingList].
  const CenterPagingList({
    super.key,
    required this.dataSource,
    required this.builder,
    this.errorBuilder,
    this.initialLoadingWidget,
    this.emptyWidget,
    required this.prependLoadStateBuilder,
    required this.appendLoadStateBuilder,
    this.padding = EdgeInsets.zero,
    this.autoLoadPrepend = true,
    this.autoLoadAppend = true,
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
  }) : _separatorBuilder = null;

  /// Creates a [CenterPagingList] with separators between items.
  const CenterPagingList.separated({
    super.key,
    required this.dataSource,
    required this.builder,
    this.errorBuilder,
    this.initialLoadingWidget,
    this.emptyWidget,
    required this.prependLoadStateBuilder,
    required this.appendLoadStateBuilder,
    this.padding = EdgeInsets.zero,
    this.autoLoadPrepend = true,
    this.autoLoadAppend = true,
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
    required IndexedWidgetBuilder separatorBuilder,
  }) : _separatorBuilder = separatorBuilder;

  /// The [CenterDataSource] that provides the paginated data.
  final CenterDataSource<PageKey, Value> dataSource;

  /// A builder that creates a widget for each item in the list.
  final TypedWidgetBuilder<Value> builder;

  /// A builder that creates a widget to display when an error occurs.
  final ExceptionWidgetBuilder? errorBuilder;

  /// The widget to display while the first page is being loaded.
  final Widget? initialLoadingWidget;

  /// The widget to display when the list is empty.
  final Widget? emptyWidget;

  /// A builder for the prepend loading state widget.
  ///
  /// - [hasMore]: True if there are more items to prepend.
  /// - [isLoading]: True if a prepend operation is in progress.
  final Widget Function(BuildContext context, bool hasMore, bool isLoading)
  prependLoadStateBuilder;

  /// A builder for the append loading state widget.
  ///
  /// - [hasMore]: True if there are more items to append.
  /// - [isLoading]: True if an append operation is in progress.
  final Widget Function(BuildContext context, bool hasMore, bool isLoading)
  appendLoadStateBuilder;

  /// The separator builder between items.
  final IndexedWidgetBuilder? _separatorBuilder;

  /// The amount of space by which to inset the children.
  final EdgeInsets padding;

  /// Automatically load more data at the beginning of the list
  /// when reaching the boundary.
  final bool autoLoadPrepend;

  /// Automatically load more data at the end of the list
  /// when reaching the boundary.
  final bool autoLoadAppend;

  /// The axis along which the scroll view scrolls.
  final Axis scrollDirection;

  /// Whether the scroll view scrolls in the reading direction.
  final bool reverse;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  final ScrollController? controller;

  /// Whether this is the primary scroll view associated with the parent
  /// [PrimaryScrollController].
  final bool? primary;

  /// How the scroll view should respond to user input.
  final ScrollPhysics? physics;

  /// A [ScrollBehavior] that will be applied to this widget individually.
  final ScrollBehavior? scrollBehavior;

  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  final bool shrinkWrap;

  /// The viewport has an area before and after the visible area to cache items
  /// that are about to become visible when the user scrolls.
  final double? cacheExtent;

  /// Determines the way that drag start behavior is handled.
  final DragStartBehavior dragStartBehavior;

  /// Defines how this [ScrollView] will dismiss the keyboard automatically.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// The content will be clipped (or not) according to this option.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CenterPageManagerState<PageKey, Value>>(
      valueListenable: dataSource.notifier,
      builder: (context, value, child) => switch (value) {
        CenterPaging(:final state) => _CenterList<PageKey, Value>(
          state: state,
          dataSource: dataSource,
          builder: builder,
          initialLoadingWidget: initialLoadingWidget,
          emptyWidget: emptyWidget,
          prependLoadStateBuilder: prependLoadStateBuilder,
          appendLoadStateBuilder: appendLoadStateBuilder,
          separatorBuilder: _separatorBuilder,
          padding: padding,
          autoLoadPrepend: autoLoadPrepend,
          autoLoadAppend: autoLoadAppend,
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
          prependItems: value.prependItems,
          centerItems: value.centerItems,
          appendItems: value.appendItems,
          hasPrependMore: value.prependPageKey != null,
          hasAppendMore: value.appendPageKey != null,
        ),
        CenterWarning(:final error, :final stackTrace) => CustomScrollView(
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
            SliverPadding(
              padding: padding,
              sliver: SliverFillRemaining(
                child: errorBuilder?.call(context, error, stackTrace),
              ),
            ),
          ],
        ),
      },
    );
  }
}

/// Internal widget for [CenterPagingList] that handles the actual sliver layout.
class _CenterList<PageKey, Value> extends StatelessWidget {
  const _CenterList({
    required this.state,
    required this.dataSource,
    required this.builder,
    required this.initialLoadingWidget,
    required this.emptyWidget,
    required this.prependLoadStateBuilder,
    required this.appendLoadStateBuilder,
    required this.separatorBuilder,
    required this.padding,
    required this.autoLoadPrepend,
    required this.autoLoadAppend,
    required this.scrollDirection,
    required this.reverse,
    required this.controller,
    required this.primary,
    required this.physics,
    required this.scrollBehavior,
    required this.shrinkWrap,
    required this.cacheExtent,
    required this.dragStartBehavior,
    required this.keyboardDismissBehavior,
    required this.clipBehavior,
    required this.prependItems,
    required this.centerItems,
    required this.appendItems,
    required this.hasPrependMore,
    required this.hasAppendMore,
  });

  final LoadState state;
  final CenterDataSource<PageKey, Value> dataSource;
  final TypedWidgetBuilder<Value> builder;
  final Widget? initialLoadingWidget;
  final Widget? emptyWidget;
  final Widget Function(BuildContext context, bool hasMore, bool isLoading)
  prependLoadStateBuilder;
  final Widget Function(BuildContext context, bool hasMore, bool isLoading)
  appendLoadStateBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final EdgeInsets padding;
  final bool autoLoadPrepend;
  final bool autoLoadAppend;
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
  final List<Value> prependItems;
  final List<Value> centerItems;
  final List<Value> appendItems;
  final bool hasPrependMore;
  final bool hasAppendMore;

  EdgeInsets get _horizontalPadding =>
      EdgeInsets.only(left: padding.left, right: padding.right);

  @override
  Widget build(BuildContext context) {
    // Handle initial state - trigger first load
    if (state.isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await dataSource.update(LoadType.init);
      });

      return CustomScrollView(
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
          SliverPadding(
            padding: padding,
            sliver: SliverFillRemaining(child: initialLoadingWidget),
          ),
        ],
      );
    }

    // Handle initial loading state
    if (state.isInitLoading) {
      return CustomScrollView(
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
          SliverPadding(
            padding: padding,
            sliver: SliverFillRemaining(child: initialLoadingWidget),
          ),
        ],
      );
    }

    // Handle empty state
    final isEmpty =
        prependItems.isEmpty && centerItems.isEmpty && appendItems.isEmpty;
    if (state.isLoaded && isEmpty) {
      return CustomScrollView(
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
          SliverPadding(
            padding: padding,
            sliver: SliverFillRemaining(child: emptyWidget),
          ),
        ],
      );
    }

    // Calculate global index offset for items
    final prependOffset = 0;
    final centerOffset = prependItems.length;
    final appendOffset = prependItems.length + centerItems.length;

    return CustomScrollView(
      center: dataSource.centerKey,
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
        // === Prepend section (above center, laid out in reverse) ===
        SliverToBoxAdapter(child: SizedBox(height: padding.top)),

        // Prepend load state widget
        SliverPadding(
          padding: _horizontalPadding,
          sliver: SliverToBoxAdapter(
            child: prependLoadStateBuilder(
              context,
              hasPrependMore,
              state.isPrependLoading,
            ),
          ),
        ),

        // Auto-load trigger for prepend
        if (autoLoadPrepend)
          SliverBoundsDetector(
            onVisibilityChanged: (isVisible) async {
              if (isVisible) {
                await dataSource.update(LoadType.prepend);
              }
            },
          ),

        // Prepend items list (reversed for proper display order)
        if (prependItems.isNotEmpty)
          SliverPadding(
            padding: _horizontalPadding,
            sliver: separatorBuilder != null
                ? SliverList.separated(
                    itemBuilder: (context, index) {
                      final reversedIndex = prependItems.length - 1 - index;
                      final globalIndex = prependOffset + reversedIndex;
                      return builder(
                        context,
                        prependItems[reversedIndex],
                        globalIndex,
                      );
                    },
                    itemCount: prependItems.length,
                    separatorBuilder: (context, index) {
                      final reversedIndex = prependItems.length - 1 - index - 1;
                      final globalIndex = prependOffset + reversedIndex;
                      return separatorBuilder!(context, globalIndex);
                    },
                  )
                : SliverList.builder(
                    itemBuilder: (context, index) {
                      final reversedIndex = prependItems.length - 1 - index;
                      final globalIndex = prependOffset + reversedIndex;
                      return builder(
                        context,
                        prependItems[reversedIndex],
                        globalIndex,
                      );
                    },
                    itemCount: prependItems.length,
                  ),
          ),

        // Separator between prepend and center sections
        if (separatorBuilder != null && prependItems.isNotEmpty)
          SliverPadding(
            padding: _horizontalPadding,
            sliver: SliverToBoxAdapter(
              child: separatorBuilder!(context, prependItems.length - 1),
            ),
          ),

        // === Center section (the anchor point) ===
        SliverPadding(
          key: dataSource.centerKey,
          padding: _horizontalPadding,
          sliver: separatorBuilder != null
              ? SliverList.separated(
                  itemBuilder: (context, index) {
                    final globalIndex = centerOffset + index;
                    return builder(context, centerItems[index], globalIndex);
                  },
                  itemCount: centerItems.length,
                  separatorBuilder: (context, index) =>
                      separatorBuilder!(context, centerOffset + index),
                )
              : SliverList.builder(
                  itemBuilder: (context, index) {
                    final globalIndex = centerOffset + index;
                    return builder(context, centerItems[index], globalIndex);
                  },
                  itemCount: centerItems.length,
                ),
        ),

        // Separator between center and append sections
        if (separatorBuilder != null &&
            centerItems.isNotEmpty &&
            appendItems.isNotEmpty)
          SliverPadding(
            padding: _horizontalPadding,
            sliver: SliverToBoxAdapter(
              child: separatorBuilder!(
                context,
                centerOffset + centerItems.length - 1,
              ),
            ),
          ),

        // === Append section (below center) ===
        if (appendItems.isNotEmpty)
          SliverPadding(
            padding: _horizontalPadding,
            sliver: separatorBuilder != null
                ? SliverList.separated(
                    itemBuilder: (context, index) {
                      final globalIndex = appendOffset + index;
                      return builder(context, appendItems[index], globalIndex);
                    },
                    itemCount: appendItems.length,
                    separatorBuilder: (context, index) =>
                        separatorBuilder!(context, appendOffset + index),
                  )
                : SliverList.builder(
                    itemBuilder: (context, index) {
                      final globalIndex = appendOffset + index;
                      return builder(context, appendItems[index], globalIndex);
                    },
                    itemCount: appendItems.length,
                  ),
          ),

        // Auto-load trigger for append
        if (autoLoadAppend)
          SliverBoundsDetector(
            onVisibilityChanged: (isVisible) async {
              if (isVisible) {
                await dataSource.update(LoadType.append);
              }
            },
          ),

        // Append load state widget
        SliverPadding(
          padding: _horizontalPadding,
          sliver: SliverToBoxAdapter(
            child: appendLoadStateBuilder(
              context,
              hasAppendMore,
              state.isAppendLoading,
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: padding.bottom)),
      ],
    );
  }
}

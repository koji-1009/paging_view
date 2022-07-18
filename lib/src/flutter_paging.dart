import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_paging/src/data_source.dart';
import 'package:flutter_paging/src/function.dart';
import 'package:flutter_paging/src/private/entity.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

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
  Widget build(BuildContext context) =>
      StateNotifierBuilder<NotifierState<Value, Key>>(
        stateNotifier: dataSource.notifier,
        builder: (context, value, child) => value.when(
          (state, pages) {
            if (state == NotifierLoadingState.init) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                dataSource.update(LoadType.refresh);
              });

              return initialLoadingWidget;
            } else if (state == NotifierLoadingState.initLoading) {
              return initialLoadingWidget;
            }

            final showPrependLoading = prependLoadingWidget != null &&
                state == NotifierLoadingState.prependLoading;
            final showAppendLoading = appendLoadingWidget != null &&
                state == NotifierLoadingState.appendLoading;

            final items = value.items;
            final length = items.length;
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
                if (showPrependLoading)
                  SliverPadding(
                    padding: padding,
                    sliver: SliverToBoxAdapter(
                      child: prependLoadingWidget,
                    ),
                  ),
                SliverPadding(
                  padding: padding,
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == 0) {
                          // prepend
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            dataSource.update(LoadType.prepend);
                          });
                        } else if (index == length - 1) {
                          // append
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            dataSource.update(LoadType.append);
                          });
                        }

                        final element = items[index];
                        return builder(context, element, index);
                      },
                      childCount: length,
                    ),
                  ),
                ),
                if (showAppendLoading)
                  SliverPadding(
                    padding: padding,
                    sliver: SliverToBoxAdapter(
                      child: appendLoadingWidget,
                    ),
                  ),
              ],
            );
          },
          error: (e) => errorBuilder(context, e),
        ),
      );
}

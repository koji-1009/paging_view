import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:paging_view/src/data_source.dart';
import 'package:paging_view/src/function.dart';
import 'package:paging_view/src/private/entity.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// A sliver that manages pages and scroll position to read more data.
/// Display a single-column list.
class SliverPagingList<PageKey, Value> extends StatelessWidget {
  const SliverPagingList({
    super.key,
    required this.dataSource,
    required this.builder,
    required this.errorBuilder,
    required this.initialLoadingWidget,
    this.prependLoadingWidget = const SizedBox.shrink(),
    this.appendLoadingWidget = const SizedBox.shrink(),
    this.emptyWidget = const SizedBox.shrink(),
    this.padding = EdgeInsets.zero,
  });

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

  EdgeInsets get _horizontalPadding => EdgeInsets.only(
        left: padding.left,
        right: padding.right,
      );

  /// endregion

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<NotifierState<PageKey, Value>>(
        valueListenable: dataSource.notifier,
        builder: (context, value, child) => value.when(
          (state, pages) {
            if (state == NotifierLoadingState.init) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                dataSource.update(LoadType.refresh);
              });

              return SliverPadding(
                padding: padding,
                sliver: SliverFillRemaining(
                  child: initialLoadingWidget,
                ),
              );
            } else if (state == NotifierLoadingState.initLoading) {
              return SliverPadding(
                padding: padding,
                sliver: SliverFillRemaining(
                  child: initialLoadingWidget,
                ),
              );
            }

            final items = [...pages.map((e) => e.data).flattened];
            if (state == NotifierLoadingState.loaded && items.isEmpty) {
              return SliverPadding(
                padding: padding,
                sliver: SliverFillRemaining(
                  child: emptyWidget,
                ),
              );
            }

            return MultiSliver(
              children: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: padding.top,
                  ),
                ),
                if (state == NotifierLoadingState.prependLoading)
                  SliverPadding(
                    padding: _horizontalPadding,
                    sliver: SliverToBoxAdapter(
                      child: prependLoadingWidget,
                    ),
                  ),
                SliverPadding(
                  padding: _horizontalPadding,
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == 0) {
                          // prepend
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            dataSource.update(LoadType.prepend);
                          });
                        } else if (index == items.length - 1) {
                          // append
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            dataSource.update(LoadType.append);
                          });
                        }

                        final element = items[index];
                        return builder(context, element, index);
                      },
                      childCount: items.length,
                    ),
                  ),
                ),
                if (state == NotifierLoadingState.appendLoading)
                  SliverPadding(
                    padding: _horizontalPadding,
                    sliver: SliverToBoxAdapter(
                      child: appendLoadingWidget,
                    ),
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: padding.bottom,
                  ),
                ),
              ],
            );
          },
          error: (e) => errorBuilder(context, e),
        ),
      );
}

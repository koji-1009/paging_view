import 'package:flutter/widgets.dart';
import 'package:flutter_paging/src/data_source.dart';
import 'package:flutter_paging/src/private/entity.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

typedef TypedWidgetBuilder<Value> = Widget Function(
  BuildContext context,
  Value element,
  int index,
);

typedef ErrorWidgetBuilder = Widget Function(
  BuildContext context,
  Exception? e,
);

class Paging<Value, Key> extends StatelessWidget {
  const Paging({
    super.key,
    required this.dataSource,
    required this.typedBuilder,
    this.errorWidgetBuilder,
    this.prependWidget,
    this.appendWidget,
  });

  final DataSource<Value, Key> dataSource;
  final TypedWidgetBuilder<Value> typedBuilder;
  final ErrorWidgetBuilder? errorWidgetBuilder;
  final Widget? prependWidget;
  final Widget? appendWidget;

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
            }

            final items = value.items;
            final length = items.length;
            return CustomScrollView(
              slivers: [
                if (prependWidget != null)
                  SliverToBoxAdapter(
                    child: prependWidget,
                  ),
                SliverList(
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
                      return typedBuilder(context, element, index);
                    },
                    childCount: length,
                  ),
                ),
                if (appendWidget != null)
                  SliverToBoxAdapter(
                    child: appendWidget,
                  ),
              ],
            );
          },
          error: (e) =>
              errorWidgetBuilder?.call(context, e) ?? const SizedBox.shrink(),
        ),
      );
}

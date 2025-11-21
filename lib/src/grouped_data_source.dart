import 'package:flutter/foundation.dart';
import 'package:paging_view/src/data_source.dart';
import 'package:paging_view/src/grouped_entity.dart';

/// Class that manages data loading with grouping functionality.
abstract class GroupedDataSource<PageKey, Parent, Value>
    extends DataSource<PageKey, Value> {
  GroupedDataSource() {
    notifier.addListener(_invalidateCache);
  }

  @override
  void dispose() {
    notifier.removeListener(_invalidateCache);
    super.dispose();
  }

  List<GroupedPageData<Parent, Value>>? _cachedGroupedValues;

  void _invalidateCache() {
    _cachedGroupedValues = null;
  }

  List<GroupedPageData<Parent, Value>> _computeGroupedValues() {
    final items = notifier.values;
    if (items.isEmpty) {
      return const [];
    }

    final groups = <Parent, List<ValueWithIndex<Value>>>{};
    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      final parent = groupBy(item);
      groups
          .putIfAbsent(parent, () => [])
          .add(ValueWithIndex(value: item, index: index));
    }

    return groups.entries
        .map((e) => GroupedPageData(parent: e.key, children: e.value))
        .toList();
  }

  /// Extract the parent element from a child value.
  @protected
  Parent groupBy(Value value);

  /// Get the grouped data as a list of parent-child relationships.
  List<GroupedPageData<Parent, Value>> get groupedValues =>
      _cachedGroupedValues ??= _computeGroupedValues();
}

import 'package:flutter/foundation.dart';
import 'package:paging_view/src/data_source.dart';
import 'package:paging_view/src/grouped_entity.dart';

/// An extension of [DataSource] that groups items into sections.
///
/// Use this class to power `GroupedPagingList` or `GroupedPagingGrid`. It
/// requires you to implement the [groupBy] method, which defines how items
/// are categorized.
///
/// The [GroupedDataSource] automatically handles the logic of grouping the
/// flat list of items from the [DataSource.load] method into a structured
/// format that can be consumed by the grouped UI widgets.
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

  /// Extracts the group identifier (the "parent") from a given item.
  ///
  /// This method is called for each `Value` in the data source to determine
  /// which group it belongs to. The returned `Parent` object is used as the
  /// [_computeGroupedValues] key for the group.
  /// For example, you could return a `DateTime` to group items by day,
  /// or the first letter of a string to group them alphabetically.
  @protected
  Parent groupBy(Value value);

  /// Returns the cached, grouped list of data.
  ///
  /// This is automatically computed from the flat list of items managed by the
  /// base `DataSource`. The result is what the `GroupedPagingList` or
  /// `GroupedPagingGrid` uses to render the sectioned UI.
  List<GroupedPageData<Parent, Value>> get groupedValues =>
      _cachedGroupedValues ??= _computeGroupedValues();
}

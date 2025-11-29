import 'package:flutter/foundation.dart';
import 'package:paging_view/src/data_source.dart';
import 'package:paging_view/src/grouped_entity.dart';

/// An extension of [DataSource] that automatically groups its items into
/// sections based on a developer-defined condition.
///
/// Use this class to power `GroupedPagingList` or `GroupedPagingGrid`. To use it,
/// you must extend it and implement the [groupBy] method, which defines how
/// items are categorized into groups.
///
/// The [GroupedDataSource] listens for changes to the underlying flat list of
/// items from [DataSource] and re-computes the grouped structure on demand,
/// caching the result for efficiency.
///
/// Example:
/// ```dart
/// class ContactDataSource extends GroupedDataSource<int, String, Contact> {
///   @override
///   String groupBy(Contact value) {
///     // Group contacts by the first letter of their name.
///     return value.name.substring(0, 1).toUpperCase();
///   }
///
///   @override
///   Future<LoadResult<int, Contact>> load(LoadAction<int> action) {
///     // Your data loading logic here...
///   }
/// }
/// ```
abstract class GroupedDataSource<PageKey, Parent, Value>
    extends DataSource<PageKey, Value> {
  /// Creates a [GroupedDataSource] and sets up a listener to invalidate the
  /// group cache when the underlying data changes.
  GroupedDataSource() {
    notifier.addListener(_invalidateCache);
  }

  @override
  @mustCallSuper
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
    final groupOrder = <Parent>[];

    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      final parent = groupBy(item);
      final groupItems = groups.putIfAbsent(parent, () {
        groupOrder.add(parent);
        return [];
      });
      groupItems.add(ValueWithIndex(value: item, index: index));
    }

    return groupOrder
        .map(
          (parent) => GroupedPageData(parent: parent, children: groups[parent]!),
        )
        .toList();
  }

  /// Extracts the group identifier (the "parent") from a given item.
  ///
  /// This method is called for each `Value` in the data source to determine
  /// which group it belongs to. The returned `Parent` object is used as a key
  /// to group items together.
  ///
  /// The order of the groups is determined by the order in which the first
  /// item of a group appears in the source list.
  ///
  /// For example, you could return a `DateTime` to group items by day,
  /// or the first letter of a string to group them alphabetically.
  @protected
  Parent groupBy(Value value);

  /// Returns a cached, grouped list of data suitable for sectioned UI.
  ///
  /// This getter computes the grouped structure from the flat list of items
  /// managed by the base `DataSource`. The result is cached for performance
  /// and automatically invalidated and recomputed whenever the underlying data
  /// changes (e.g., after a refresh, append, or item manipulation).
  ///
  /// The list is what `GroupedPagingList` or `GroupedPagingGrid` uses to
  /// render the UI with its sections and items.
  List<GroupedPageData<Parent, Value>> get groupedValues =>
      _cachedGroupedValues ??= _computeGroupedValues();
}

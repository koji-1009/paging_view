import 'package:collection/collection.dart';

/// Represents a single group in a sectioned list, composed of a parent
/// and its associated child items.
///
/// This data structure holds the `parent` (e.g., a category header)
/// and a list of its `children` (the items within that group), where each child
/// is wrapped in a [ValueWithIndex] to preserve its original index from the
/// flat list.
class GroupedPageData<Parent, Value> {
  /// Creates a [GroupedPageData] instance.
  const GroupedPageData({required this.parent, required this.children});

  /// The parent element, often used as the group's header or title.
  final Parent parent;

  /// The list of child items belonging to this group. Each item is a
  /// [ValueWithIndex] that pairs the value with its global index.
  final List<ValueWithIndex<Value>> children;

  @override
  String toString() => 'GroupedPageData(parent: $parent, children: $children)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupedPageData<Parent, Value> &&
          parent == other.parent &&
          const DeepCollectionEquality().equals(children, other.children));

  @override
  int get hashCode => Object.hash(
        parent,
        const DeepCollectionEquality().hash(children),
      );
}

/// A data structure that wraps a `value` with its original `index` from a
/// larger, flat list.
///
/// This is useful in grouped lists to maintain a reference to the item's
/// position in the complete, ungrouped dataset, enabling operations like
/// updating or removing the item from the original source.
class ValueWithIndex<Value> {
  /// Creates a [ValueWithIndex] instance.
  const ValueWithIndex({required this.value, required this.index});

  /// The underlying item value.
  final Value value;

  /// The index of the value in the overall flat list.
  final int index;

  @override
  String toString() => 'ValueWithIndex(value: $value, index: $index)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ValueWithIndex<Value> &&
          value == other.value &&
          index == other.index);

  @override
  int get hashCode => Object.hash(value, index);
}

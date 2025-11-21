/// Data structure for grouped items.
class GroupedPageData<Parent, Value> {
  /// Creates a [GroupedPageData].
  const GroupedPageData({required this.parent, required this.children});

  /// The parent element.
  final Parent parent;

  /// The child elements.
  final List<ValueWithIndex<Value>> children;

  @override
  String toString() => 'GroupedPageData(parent: $parent, children: $children)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupedPageData<Parent, Value> &&
          parent == other.parent &&
          children == other.children);

  @override
  int get hashCode => Object.hash(parent, children);
}

/// Data structure that holds a value along with its index.
class ValueWithIndex<Value> {
  /// Creates a [ValueWithIndex].
  const ValueWithIndex({required this.value, required this.index});

  /// The value.
  final Value value;

  /// The index of the value in the overall list.
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

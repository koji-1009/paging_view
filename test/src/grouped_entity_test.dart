import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/grouped_entity.dart';

void main() {
  group('GroupedPageData', () {
    test('creates with parent and children', () {
      const group = GroupedPageData<String, int>(
        parent: 'Group A',
        children: [
          ValueWithIndex(value: 1, index: 1),
          ValueWithIndex(value: 2, index: 2),
          ValueWithIndex(value: 3, index: 3),
        ],
      );

      expect(group.parent, 'Group A');
      expect(group.children, [
        const ValueWithIndex(value: 1, index: 1),
        const ValueWithIndex(value: 2, index: 2),
        const ValueWithIndex(value: 3, index: 3),
      ]);
    });

    test('toString returns formatted string', () {
      const group = GroupedPageData<String, int>(
        parent: 'Group A',
        children: [
          ValueWithIndex(value: 1, index: 1),
          ValueWithIndex(value: 2, index: 2),
          ValueWithIndex(value: 3, index: 3),
        ],
      );

      expect(
        group.toString(),
        'GroupedPageData(parent: Group A, children: [ValueWithIndex(value: 1, index: 1), ValueWithIndex(value: 2, index: 2), ValueWithIndex(value: 3, index: 3)])',
      );
    });

    test('equality works correctly', () {
      const group1 = GroupedPageData<String, int>(
        parent: 'Group A',
        children: [
          ValueWithIndex(value: 1, index: 1),
          ValueWithIndex(value: 2, index: 2),
          ValueWithIndex(value: 3, index: 3),
        ],
      );
      const group2 = GroupedPageData<String, int>(
        parent: 'Group A',
        children: [
          ValueWithIndex(value: 1, index: 1),
          ValueWithIndex(value: 2, index: 2),
          ValueWithIndex(value: 3, index: 3),
        ],
      );
      const group3 = GroupedPageData<String, int>(
        parent: 'Group B',
        children: [
          ValueWithIndex(value: 1, index: 1),
          ValueWithIndex(value: 2, index: 2),
          ValueWithIndex(value: 3, index: 3),
        ],
      );

      expect(group1, group2);
      expect(group1 == group3, false);
    });

    test('hashCode works correctly', () {
      const group1 = GroupedPageData<String, int>(
        parent: 'Group A',
        children: [
          ValueWithIndex(value: 1, index: 1),
          ValueWithIndex(value: 2, index: 2),
          ValueWithIndex(value: 3, index: 3),
        ],
      );
      const group2 = GroupedPageData<String, int>(
        parent: 'Group A',
        children: [
          ValueWithIndex(value: 1, index: 1),
          ValueWithIndex(value: 2, index: 2),
          ValueWithIndex(value: 3, index: 3),
        ],
      );

      expect(group1.hashCode, group2.hashCode);
    });
  });
}

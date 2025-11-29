import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/grouped_entity.dart';

void main() {
  group('ValueWithIndex', () {
    test('should hold the provided value and index', () {
      const item = ValueWithIndex<String>(value: 'hello', index: 5);
      expect(item.value, 'hello');
      expect(item.index, 5);
    });

    test('== operator should compare value equality', () {
      const item1 = ValueWithIndex<String>(value: 'a', index: 1);
      const item2 = ValueWithIndex<String>(value: 'a', index: 1);
      const item3 = ValueWithIndex<String>(value: 'b', index: 1);
      const item4 = ValueWithIndex<String>(value: 'a', index: 2);

      expect(item1 == item2, isTrue);
      expect(item1 == item3, isFalse);
      expect(item1 == item4, isFalse);
    });

    test('hashCode should be consistent with == operator', () {
      const item1 = ValueWithIndex<String>(value: 'a', index: 1);
      const item2 = ValueWithIndex<String>(value: 'a', index: 1);
      const item3 = ValueWithIndex<String>(value: 'b', index: 1);

      expect(item1.hashCode, item2.hashCode);
      expect(item1.hashCode, isNot(item3.hashCode));
    });

    test('toString should return a readable string representation', () {
      const item = ValueWithIndex<String>(value: 'test', index: 99);
      expect(item.toString(), 'ValueWithIndex(value: test, index: 99)');
    });
  });

  group('GroupedPageData', () {
    const children1 = [
      ValueWithIndex<int>(value: 10, index: 0),
      ValueWithIndex<int>(value: 20, index: 1),
    ];
    const children2 = [
      ValueWithIndex<int>(value: 10, index: 0),
      ValueWithIndex<int>(value: 20, index: 1),
    ];
    const children3 = [
      ValueWithIndex<int>(value: 30, index: 2),
      ValueWithIndex<int>(value: 40, index: 3),
    ];

    test('should hold the provided parent and children', () {
      const group = GroupedPageData<String, int>(
        parent: 'Group A',
        children: children1,
      );
      expect(group.parent, 'Group A');
      expect(group.children, children1);
    });

    test('== operator should compare value equality', () {
      const group1 =
          GroupedPageData<String, int>(parent: 'Group', children: children1);
      const group2 =
          GroupedPageData<String, int>(parent: 'Group', children: children2);
      const group3 =
          GroupedPageData<String, int>(parent: 'Different', children: children1);
      const group4 =
          GroupedPageData<String, int>(parent: 'Group', children: children3);

      // Note: This relies on the implementation of == for List<ValueWithIndex>
      // The implementation in the source file needs deep equality for this to be robust.
      expect(group1 == group2, isTrue);
      expect(group1 == group3, isFalse);
      expect(group1 == group4, isFalse);
    });

    test('hashCode should be consistent with == operator', () {
      const group1 =
          GroupedPageData<String, int>(parent: 'Group', children: children1);
      const group2 =
          GroupedPageData<String, int>(parent: 'Group', children: children2);
      const group3 =
          GroupedPageData<String, int>(parent: 'Group', children: children3);

      expect(group1.hashCode, group2.hashCode);
      expect(group1.hashCode, isNot(group3.hashCode));
    });

    test('toString should return a readable string representation', () {
      const group =
          GroupedPageData<String, int>(parent: 'MyGroup', children: children1);
      expect(
        group.toString(),
        'GroupedPageData(parent: MyGroup, children: [ValueWithIndex(value: 10, index: 0), ValueWithIndex(value: 20, index: 1)])',
      );
    });
  });
}
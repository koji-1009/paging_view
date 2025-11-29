import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/grouped_data_source.dart';

class TestItem {
  const TestItem(this.id, this.category);
  final int id;
  final String category;

  @override
  bool operator ==(Object other) =>
      other is TestItem && id == other.id && category == other.category;
  @override
  int get hashCode => Object.hash(id, category);
  @override
  String toString() => 'TestItem(id: $id, category: $category)';
}

class TestGroupedDataSource extends GroupedDataSource<int, String, TestItem> {
  TestGroupedDataSource(this._items);

  final List<TestItem> _items;
  var loadCount = 0;

  @override
  String groupBy(TestItem value) => value.category;

  @override
  Future<LoadResult<int, TestItem>> load(LoadAction<int> action) async {
    loadCount++;
    return switch (action) {
      Refresh() => Success(page: PageData(data: _items, appendKey: 1)),
      Append() => const Success(page: PageData(data: [])),
      Prepend() => const Success(page: PageData(data: [])),
    };
  }
}

void main() {
  const items = [
    TestItem(1, 'A'),
    TestItem(2, 'B'),
    TestItem(3, 'A'),
    TestItem(4, 'C'),
    TestItem(5, 'B'),
  ];
  late TestGroupedDataSource dataSource;

  setUp(() async {
    dataSource = TestGroupedDataSource(items);
    await dataSource.refresh();
  });

  tearDown(() {
    dataSource.dispose();
  });

  group('GroupedDataSource Grouping Logic', () {
    test('groupedValues should group items correctly', () {
      final grouped = dataSource.groupedValues;
      expect(grouped.length, 3);
      expect(grouped.map((g) => g.parent), ['A', 'B', 'C']);
    });

    test('items within groups should be ordered by appearance', () {
      final grouped = dataSource.groupedValues;

      final groupA = grouped.firstWhere((g) => g.parent == 'A');
      expect(groupA.children.map((c) => c.value.id), [1, 3]);

      final groupB = grouped.firstWhere((g) => g.parent == 'B');
      expect(groupB.children.map((c) => c.value.id), [2, 5]);

      final groupC = grouped.firstWhere((g) => g.parent == 'C');
      expect(groupC.children.map((c) => c.value.id), [4]);
    });

    test('group order should be determined by first appearance', () async {
      final mixedOrderItems = [
        TestItem(1, 'C'),
        TestItem(2, 'A'),
        TestItem(3, 'B'),
        TestItem(4, 'A'),
      ];
      final mixedDataSource = TestGroupedDataSource(mixedOrderItems);
      await mixedDataSource.refresh();

      expect(mixedDataSource.groupedValues.map((g) => g.parent), [
        'C',
        'A',
        'B',
      ]);
      mixedDataSource.dispose();
    });

    test('groupedValues should be empty for empty source', () async {
      final emptyDataSource = TestGroupedDataSource([]);
      await emptyDataSource.refresh();
      expect(emptyDataSource.groupedValues, isEmpty);
      emptyDataSource.dispose();
    });
  });

  group('GroupedDataSource Cache Invalidation', () {
    test('groupedValues should be recomputed after item manipulation', () {
      // First access
      final grouped1 = dataSource.groupedValues;
      expect(grouped1.firstWhere((g) => g.parent == 'A').children.length, 2);

      // Manipulate data
      dataSource.removeItem(0); // Removes TestItem(1, 'A')

      // Second access, should be recomputed
      final grouped2 = dataSource.groupedValues;
      expect(grouped2.firstWhere((g) => g.parent == 'A').children.length, 1);
      expect(
        grouped2.firstWhere((g) => g.parent == 'A').children[0].value.id,
        3,
      );
    });

    test('groupedValues should be recomputed after refresh', () async {
      // First access
      final grouped1 = dataSource.groupedValues;
      expect(grouped1.length, 3);

      // Refresh with different data
      final newDataSource = TestGroupedDataSource([const TestItem(10, 'Z')]);
      await newDataSource.refresh();

      // Access again
      final grouped2 = newDataSource.groupedValues;
      expect(grouped2.length, 1);
      expect(grouped2[0].parent, 'Z');
      newDataSource.dispose();
    });
  });

  group('GroupedDataSource Index Consistency', () {
    test('ValueWithIndex should hold the correct global index', () {
      final grouped = dataSource.groupedValues;

      // Item 1: 'A', id 1, global index 0
      expect(grouped[0].children[0].value.id, 1);
      expect(grouped[0].children[0].index, 0);

      // Item 2: 'B', id 2, global index 1
      expect(grouped[1].children[0].value.id, 2);
      expect(grouped[1].children[0].index, 1);

      // Item 3: 'A', id 3, global index 2
      expect(grouped[0].children[1].value.id, 3);
      expect(grouped[0].children[1].index, 2);

      // Item 4: 'C', id 4, global index 3
      expect(grouped[2].children[0].value.id, 4);
      expect(grouped[2].children[0].index, 3);

      // Item 5: 'B', id 5, global index 4
      expect(grouped[1].children[1].value.id, 5);
      expect(grouped[1].children[1].index, 4);
    });

    test('removeItem should use global index correctly', () {
      // Remove item with global index 2 (TestItem(3, 'A'))
      dataSource.removeItem(2);

      final grouped = dataSource.groupedValues;
      final groupA = grouped.firstWhere((g) => g.parent == 'A');
      expect(groupA.children.length, 1);
      expect(groupA.children.first.value.id, 1);
      expect(groupA.children.first.index, 0); // New global index is 0

      final groupB = grouped.firstWhere((g) => g.parent == 'B');
      expect(groupB.children[0].index, 1); // New global index is 1
      expect(groupB.children[1].index, 3); // New global index is 3
    });

    test('insertItem should use global index correctly', () {
      // Insert new item at global index 1
      const newItem = TestItem(99, 'A');
      dataSource.insertItem(1, newItem);

      final grouped = dataSource.groupedValues;
      final groupA = grouped.firstWhere((g) => g.parent == 'A');
      expect(groupA.children.length, 3);
      expect(groupA.children.map((c) => c.value.id), [1, 99, 3]);

      // Check new indices
      expect(groupA.children[0].index, 0); // old item 1
      expect(groupA.children[1].index, 1); // new item 99
      expect(groupA.children[2].index, 3); // old item 3, now at global index 3
    });

    test('updateItem should use global index correctly', () {
      // Update item with global index 4 (TestItem(5, 'B'))
      dataSource.updateItem(
        4,
        (item) => TestItem(item.id + 100, item.category),
      );

      final grouped = dataSource.groupedValues;
      final groupB = grouped.firstWhere((g) => g.parent == 'B');

      expect(groupB.children.length, 2);
      expect(groupB.children.map((c) => c.value.id), [2, 105]);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/grouped_data_source.dart';
import 'package:paging_view/src/private/entity.dart';

class TestGroupedDataSource extends GroupedDataSource<int, String, TestItem> {
  TestGroupedDataSource({required this.items, this.onLoad});

  final List<TestItem> items;
  final LoadResult<int, TestItem> Function(LoadAction<int> action)? onLoad;

  @override
  String groupBy(TestItem item) => item.category;

  @override
  Future<LoadResult<int, TestItem>> load(LoadAction<int> action) async {
    if (onLoad != null) {
      return onLoad!(action);
    }

    // Default implementation
    return Success(page: PageData(data: items, appendKey: 2));
  }
}

class TestItem {
  const TestItem({
    required this.id,
    required this.category,
    required this.name,
  });

  final int id;
  final String category;
  final String name;

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      (other is TestItem &&
          id == other.id &&
          category == other.category &&
          name == other.name);

  @override
  int get hashCode => Object.hash(id, category, name);
}

void main() {
  group('GroupedDataSource', () {
    const items = [
      TestItem(id: 1, category: 'A', name: 'Item 1'),
      TestItem(id: 2, category: 'A', name: 'Item 2'),
      TestItem(id: 3, category: 'B', name: 'Item 3'),
      TestItem(id: 4, category: 'B', name: 'Item 4'),
      TestItem(id: 5, category: 'C', name: 'Item 5'),
    ];

    test('groupedValues returns empty list when no data', () {
      final dataSource = TestGroupedDataSource(items: items);

      expect(dataSource.groupedValues, isEmpty);
      dataSource.dispose();
    });

    test('groupedValues groups items by category', () async {
      final dataSource = TestGroupedDataSource(items: items);
      await dataSource.update(LoadType.init);

      final grouped = dataSource.groupedValues;

      expect(grouped.length, 3);
      expect(grouped[0].parent, 'A');
      expect(grouped[0].children.length, 2);
      expect(grouped[1].parent, 'B');
      expect(grouped[1].children.length, 2);
      expect(grouped[2].parent, 'C');
      expect(grouped[2].children.length, 1);

      dataSource.dispose();
    });

    test('groupedValues maintains order of items', () async {
      final dataSource = TestGroupedDataSource(items: items);
      await dataSource.update(LoadType.init);

      final grouped = dataSource.groupedValues;

      expect(grouped[0].children[0].value.id, 1);
      expect(grouped[0].children[1].value.id, 2);
      expect(grouped[1].children[0].value.id, 3);
      expect(grouped[1].children[1].value.id, 4);
      expect(grouped[2].children[0].value.id, 5);

      dataSource.dispose();
    });

    test('groupedValues preserves group order by first appearance', () async {
      final dataSource = TestGroupedDataSource(
        items: items,
        onLoad: (action) => const Success(
          page: PageData(
            data: [
              TestItem(id: 1, category: 'B', name: 'Item 1'),
              TestItem(id: 2, category: 'A', name: 'Item 2'),
              TestItem(id: 3, category: 'B', name: 'Item 3'),
              TestItem(id: 4, category: 'C', name: 'Item 4'),
              TestItem(id: 5, category: 'A', name: 'Item 5'),
            ],
          ),
        ),
      );
      await dataSource.update(LoadType.init);

      final grouped = dataSource.groupedValues;

      // Order should be B, A, C (order of first appearance)
      expect(grouped[0].parent, 'B');
      expect(grouped[1].parent, 'A');
      expect(grouped[2].parent, 'C');

      dataSource.dispose();
    });

    test('groupedValues works with single group', () async {
      final dataSource = TestGroupedDataSource(
        items: items,
        onLoad: (action) => const Success(
          page: PageData(
            data: [
              TestItem(id: 1, category: 'A', name: 'Item 1'),
              TestItem(id: 2, category: 'A', name: 'Item 2'),
              TestItem(id: 3, category: 'A', name: 'Item 3'),
            ],
          ),
        ),
      );
      await dataSource.update(LoadType.init);

      final grouped = dataSource.groupedValues;

      expect(grouped.length, 1);
      expect(grouped[0].parent, 'A');
      expect(grouped[0].children.length, 3);

      dataSource.dispose();
    });

    test('groupedValues updates after data changes', () async {
      final dataSource = TestGroupedDataSource(items: items);
      await dataSource.update(LoadType.init);

      var grouped = dataSource.groupedValues;
      expect(grouped.length, 3);

      // Remove items from category B
      dataSource.removeItems((index, item) => item.category == 'B');

      grouped = dataSource.groupedValues;
      expect(grouped.length, 2);
      expect(grouped[0].parent, 'A');
      expect(grouped[1].parent, 'C');

      dataSource.dispose();
    });
  });

  group('GroupedDataSource index consistency', () {
    test('updateItem uses correct global index', () async {
      final items = [
        const TestItem(id: 0, category: 'A', name: 'Item 0'),
        const TestItem(id: 1, category: 'A', name: 'Item 1'),
        const TestItem(id: 2, category: 'A', name: 'Item 2'),
        const TestItem(id: 5, category: 'B', name: 'Item 5'),
        const TestItem(id: 6, category: 'B', name: 'Item 6'),
        const TestItem(id: 7, category: 'B', name: 'Item 7'),
        const TestItem(id: 10, category: 'C', name: 'Item 10'),
        const TestItem(id: 11, category: 'C', name: 'Item 11'),
      ];

      final dataSource = TestGroupedDataSource(items: items);
      await dataSource.update(LoadType.init);

      // Verify grouped structure
      final grouped = dataSource.groupedValues;
      expect(grouped.length, 3);
      expect(grouped[0].parent, 'A');
      expect(grouped[0].children.length, 3);
      expect(grouped[1].parent, 'B');
      expect(grouped[1].children.length, 3);
      expect(grouped[2].parent, 'C');
      expect(grouped[2].children.length, 2);

      // Update item at global index 3 (first item in group B)
      dataSource.updateItem(
        3,
        (item) => TestItem(
          id: item.id + 100,
          category: item.category,
          name: '${item.name} Updated',
        ),
      );

      // Verify the update
      final values = dataSource.notifier.values;
      expect(values[3].id, 105);
      expect(values[3].name, 'Item 5 Updated');

      // Verify other items unchanged
      expect(values[0].id, 0);
      expect(values[2].id, 2);
      expect(values[4].id, 6);

      dataSource.dispose();
    });

    test('removeItem uses correct global index', () async {
      final items = [
        const TestItem(id: 0, category: 'A', name: 'Item 0'),
        const TestItem(id: 1, category: 'A', name: 'Item 1'),
        const TestItem(id: 2, category: 'A', name: 'Item 2'),
        const TestItem(id: 5, category: 'B', name: 'Item 5'),
        const TestItem(id: 6, category: 'B', name: 'Item 6'),
        const TestItem(id: 7, category: 'B', name: 'Item 7'),
        const TestItem(id: 10, category: 'C', name: 'Item 10'),
        const TestItem(id: 11, category: 'C', name: 'Item 11'),
      ];

      final dataSource = TestGroupedDataSource(items: items);
      await dataSource.update(LoadType.init);

      // Remove item at global index 3 (first item in group B)
      dataSource.removeItem(3);

      final values = dataSource.notifier.values;
      expect(values.length, 7);
      expect(values[3].id, 6); // Next item in group B

      // Verify grouped structure updated
      final grouped = dataSource.groupedValues;
      expect(grouped[1].parent, 'B');
      expect(grouped[1].children.length, 2);

      dataSource.dispose();
    });

    test('insertItem uses correct global index', () async {
      final items = [
        const TestItem(id: 0, category: 'A', name: 'Item 0'),
        const TestItem(id: 1, category: 'A', name: 'Item 1'),
        const TestItem(id: 2, category: 'A', name: 'Item 2'),
        const TestItem(id: 5, category: 'B', name: 'Item 5'),
        const TestItem(id: 6, category: 'B', name: 'Item 6'),
      ];

      final dataSource = TestGroupedDataSource(items: items);
      await dataSource.update(LoadType.init);

      // Insert at global index 3 (between group A and B)
      dataSource.insertItem(
        3,
        const TestItem(id: 99, category: 'B', name: 'Item 99'),
      );

      final values = dataSource.notifier.values;
      expect(values.length, 6);
      expect(values[3].id, 99);
      expect(values[4].id, 5);

      // Verify grouped structure
      final grouped = dataSource.groupedValues;
      expect(grouped[1].parent, 'B');
      expect(grouped[1].children.length, 3);
      expect(grouped[1].children[0].value.id, 99);

      dataSource.dispose();
    });

    test('global index mapping is consistent across operations', () async {
      final items = [
        const TestItem(id: 0, category: 'A', name: 'Item 0'),
        const TestItem(id: 1, category: 'A', name: 'Item 1'),
        const TestItem(id: 5, category: 'B', name: 'Item 5'),
        const TestItem(id: 6, category: 'B', name: 'Item 6'),
      ];

      final dataSource = TestGroupedDataSource(items: items);
      await dataSource.update(LoadType.init);

      // Simulate what itemBuilder would receive
      final grouped = dataSource.groupedValues;
      var globalIndex = 0;
      final indexMapping = <int, TestItem>{};

      for (final group in grouped) {
        for (final item in group.children) {
          indexMapping[globalIndex] = item.value;
          globalIndex++;
        }
      }

      // Verify mapping matches notifier.values
      expect(indexMapping[0], dataSource.notifier.values[0]);
      expect(indexMapping[1], dataSource.notifier.values[1]);
      expect(indexMapping[2], dataSource.notifier.values[2]);
      expect(indexMapping[3], dataSource.notifier.values[3]);

      dataSource.dispose();
    });
  });
}

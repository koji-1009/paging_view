import 'package:flutter_test/flutter_test.dart';
import 'package:paging_view/src/entity.dart';
import 'package:paging_view/src/grouped_data_source.dart';
import 'package:paging_view/src/private/entity.dart';

class TestGroupedDataSource extends GroupedDataSource<int, String, TestItem> {
  TestGroupedDataSource({this.onLoad});

  final Future<LoadResult<int, TestItem>> Function(LoadAction<int> action)?
  onLoad;

  @override
  String groupBy(TestItem item) => item.category;

  @override
  Future<LoadResult<int, TestItem>> load(LoadAction<int> action) async {
    if (onLoad != null) {
      return onLoad!(action);
    }

    // Default implementation
    return const Success(
      page: PageData(
        data: [
          TestItem(id: 1, category: 'A', name: 'Item 1'),
          TestItem(id: 2, category: 'A', name: 'Item 2'),
          TestItem(id: 3, category: 'B', name: 'Item 3'),
          TestItem(id: 4, category: 'B', name: 'Item 4'),
          TestItem(id: 5, category: 'C', name: 'Item 5'),
        ],
        appendKey: 2,
      ),
    );
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
    test('groupedValues returns empty list when no data', () {
      final dataSource = TestGroupedDataSource();

      expect(dataSource.groupedValues, isEmpty);
      dataSource.dispose();
    });

    test('groupedValues groups items by category', () async {
      final dataSource = TestGroupedDataSource();
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
      final dataSource = TestGroupedDataSource();
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
        onLoad: (action) async => const Success(
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
        onLoad: (action) async => const Success(
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
      final dataSource = TestGroupedDataSource();
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
}

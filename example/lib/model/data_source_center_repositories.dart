import 'package:example/model/demo_entity.dart';
import 'package:paging_view/paging_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_source_center_repositories.g.dart';

@riverpod
ExampleCenterDataSource centerDataSource(Ref ref) {
  final dataSource = ExampleCenterDataSource();

  ref.onDispose(() {
    dataSource.dispose();
  });

  return dataSource;
}

/// An example [CenterDataSource] that demonstrates bi-directional pagination.
///
/// This data source starts at the middle of the data set and allows
/// scrolling both up (prepend) and down (append).
class ExampleCenterDataSource extends CenterDataSource<int, DemoEntity> {
  static const int pageSize = 10;

  /// Start from the middle of the list
  static int get initialOffset => allItems.length ~/ 2;

  @override
  Future<LoadResult<int, DemoEntity>> load(LoadAction<int> action) async =>
      switch (action) {
        Refresh() => await _fetchInitial(),
        Prepend(:final key) => await _fetchPrepend(key),
        Append(:final key) => await _fetchAppend(key),
      };

  /// Fetch the initial (center) page, starting from the middle of the data.
  Future<LoadResult<int, DemoEntity>> _fetchInitial() async {
    await Future.delayed(const Duration(seconds: 1));

    final start = initialOffset;
    final items = allItems.skip(start).take(pageSize).toList();

    // prependKey: the index before this page (for loading older items)
    // appendKey: the index after this page (for loading newer items)
    final prependKey = start > 0 ? start : null;
    final appendKey = start + pageSize < allItems.length
        ? start + pageSize
        : null;

    return Success(
      page: PageData(data: items, prependKey: prependKey, appendKey: appendKey),
    );
  }

  /// Fetch items before the current list (prepend/older items).
  Future<LoadResult<int, DemoEntity>> _fetchPrepend(int key) async {
    await Future.delayed(const Duration(seconds: 3));

    // key is the start index of the current first page
    // We want to load items before it
    final end = key;
    final start = (end - pageSize).clamp(0, end);

    if (start >= end) {
      return const None();
    }

    final items = allItems.sublist(start, end);
    final prependKey = start > 0 ? start : null;

    return Success(
      page: PageData(
        data: items,
        prependKey: prependKey,
        appendKey: null, // Not used for prepend pages
      ),
    );
  }

  /// Fetch items after the current list (append/newer items).
  Future<LoadResult<int, DemoEntity>> _fetchAppend(int key) async {
    await Future.delayed(const Duration(seconds: 3));

    final start = key;
    final items = allItems.skip(start).take(pageSize).toList();

    if (items.isEmpty) {
      return const None();
    }

    final appendKey = start + pageSize < allItems.length
        ? start + pageSize
        : null;

    return Success(
      page: PageData(
        data: items,
        prependKey: null, // Not used for append pages
        appendKey: appendKey,
      ),
    );
  }
}

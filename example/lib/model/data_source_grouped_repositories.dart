import 'package:example/model/demo_entity.dart';
import 'package:paging_view/paging_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_source_grouped_repositories.g.dart';

@riverpod
ExampleGroupedDataSource groupedDataSource(Ref ref) {
  final dataSource = ExampleGroupedDataSource();

  ref.onDispose(() {
    dataSource.dispose();
  });

  return dataSource;
}

class ExampleGroupedDataSource
    extends GroupedDataSource<int, String, DemoEntity> {
  static const int pageSize = 20;

  @override
  Future<LoadResult<int, DemoEntity>> load(LoadAction<int> action) async =>
      switch (action) {
        Refresh() => await fetch(null),
        Prepend() => const None(),
        Append(:final key) => await fetch(key),
      };

  Future<LoadResult<int, DemoEntity>> fetch(int? key) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final int start = key ?? 0;
    final items = allItems.skip(start).take(pageSize).toList();
    final nextKey = start + pageSize < allItems.length
        ? start + pageSize
        : null;
    return Success(
      page: PageData(data: items, appendKey: nextKey),
    );
  }

  @override
  String groupBy(DemoEntity value) => value.category;
}

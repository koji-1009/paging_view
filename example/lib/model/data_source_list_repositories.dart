import 'package:example/model/demo_entity.dart';
import 'package:paging_view/paging_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_source_list_repositories.g.dart';

@riverpod
ExampleDataSource dataSource(Ref ref) {
  final dataSource = ExampleDataSource();

  ref.onDispose(() {
    dataSource.dispose();
  });

  return dataSource;
}

class ExampleDataSource extends DataSource<int, DemoEntity> {
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

    final start = key ?? 0;
    final items = allItems.skip(start).take(pageSize).toList();
    final nextKey = start + pageSize < allItems.length
        ? start + pageSize
        : null;
    return Success(
      page: PageData(data: items, appendKey: nextKey),
    );
  }
}

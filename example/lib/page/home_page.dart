import 'package:example/model/data_source_public_repositories.dart';
import 'package:example/model/entity/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paging_view/paging_view.dart';

enum BottomBarType {
  list,
  grid,
  listH,
  gridH;
}

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(dataSourcePublicRepositoriesProvider);

    final index = useState(BottomBarType.list);
    final Widget body;
    switch (index.value) {
      case BottomBarType.list:
        body = PagingList<int, Repository>(
          dataSource: dataSource,
          builder: (context, repository, index) => Card(
            child: ListTile(
              title: Text(repository.fullName),
              subtitle: Text(repository.description),
            ),
          ),
          errorBuilder: (context, e) => Center(
            child: Text('$e'),
          ),
          initialLoadingWidget: const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
          appendLoadingWidget: const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
          emptyWidget: const Center(
            child: Text('No Item'),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
        );
        break;
      case BottomBarType.grid:
        body = PagingGrid<int, Repository>(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          dataSource: dataSource,
          builder: (context, repository, index) => Card(
            child: ListTile(
              title: Text(repository.fullName),
              subtitle: Text(
                repository.description,
                maxLines: 3,
              ),
            ),
          ),
          errorBuilder: (context, e) => Center(
            child: Text('$e'),
          ),
          initialLoadingWidget: const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
          appendLoadingWidget: const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
          emptyWidget: const Center(
            child: Text('No Item'),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
        );
        break;
      case BottomBarType.listH:
        body = PagingList<int, Repository>(
          scrollDirection: Axis.horizontal,
          dataSource: dataSource,
          builder: (context, repository, index) => SizedBox(
            width: 200,
            child: Card(
              child: ListTile(
                title: Text(repository.fullName),
                subtitle: Text(repository.description),
              ),
            ),
          ),
          errorBuilder: (context, e) => Center(
            child: Text('$e'),
          ),
          initialLoadingWidget: const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
          appendLoadingWidget: const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
          emptyWidget: const Center(
            child: Text('No Item'),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
        );

        break;
      case BottomBarType.gridH:
        body = PagingGrid<int, Repository>(
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          dataSource: dataSource,
          builder: (context, repository, index) => Card(
            child: ListTile(
              title: Text(repository.fullName),
              subtitle: Text(
                repository.description,
                maxLines: 3,
              ),
            ),
          ),
          errorBuilder: (context, e) => Center(
            child: Text('$e'),
          ),
          initialLoadingWidget: const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
          appendLoadingWidget: const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
          emptyWidget: const Center(
            child: Text('No Item'),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
        );
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub public repositories'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => dataSource.refresh(),
        child: body,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_3x3),
            label: 'Grid',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'List H',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_goldenratio),
            label: 'Grid H',
          ),
        ],
        onTap: (value) {
          index.value = BottomBarType.values[value];
        },
        currentIndex: index.value.index,
      ),
    );
  }
}

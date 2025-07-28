import 'package:example/model/data_source_public_repositories.dart';
import 'package:example/model/entity/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paging_view/paging_view.dart';

enum BottomBarType {
  list,
  grid,
  listH,
  gridH,
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  BottomBarType _index = BottomBarType.list;

  @override
  Widget build(BuildContext context) {
    final dataSource = ref.watch(dataSourcePublicRepositoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub public repositories'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await dataSource.refresh();
        },
        child: switch (_index) {
          BottomBarType.list => PagingList<int, Repository>(
              dataSource: dataSource,
              builder: (context, repository, index) => Card(
                child: ListTile(
                  title: Text(repository.fullName),
                  subtitle: Text(repository.description),
                ),
              ),
              errorBuilder: (context, error, stackTrace) => Center(
                child: Text('$error'),
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
            ),
          BottomBarType.grid => PagingGrid<int, Repository>(
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
              errorBuilder: (context, error, stackTrace) => Center(
                child: Text('$error'),
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
            ),
          BottomBarType.listH => PagingList<int, Repository>(
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
              errorBuilder: (context, error, stackTrace) => Center(
                child: Text('$error'),
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
            ),
          BottomBarType.gridH => PagingGrid<int, Repository>(
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
              errorBuilder: (context, error, stackTrace) => Center(
                child: Text('$error'),
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
            )
        },
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_3x3),
            label: 'Grid',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'List H',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_goldenratio),
            label: 'Grid H',
          ),
        ],
        onDestinationSelected: (value) {
          setState(() {
            _index = BottomBarType.values[value];
          });
        },
        selectedIndex: _index.index,
      ),
    );
  }
}

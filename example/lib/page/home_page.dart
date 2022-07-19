import 'package:example/model/data_source_public_repositories.dart';
import 'package:example/model/entity/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_paging/flutter_paging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(dataSourcePublicRepositoriesProvider);
    final index = useState(0);
    final body = index.value == 0
        ? PagingList<Repository, int>(
            dataSource: dataSource,
            builder: (context, repository, index) {
              return Card(
                child: ListTile(
                  title: Text(repository.fullName),
                  subtitle: Text(repository.description),
                ),
              );
            },
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          )
        : PagingGrid<Repository, int>(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            dataSource: dataSource,
            builder: (context, repository, index) {
              return Card(
                child: ListTile(
                  title: Text(repository.fullName),
                  subtitle: Text(
                    repository.description,
                    maxLines: 3,
                  ),
                ),
              );
            },
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub public repositories'),
      ),
      body: body,
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
        ],
        onTap: (value) {
          index.value = value;
        },
        currentIndex: index.value,
      ),
    );
  }
}

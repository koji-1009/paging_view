import 'package:example/model/data_source_center_repositories.dart';
import 'package:example/model/data_source_grouped_repositories.dart';
import 'package:example/model/data_source_list_repositories.dart';
import 'package:example/model/demo_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paging_view/paging_view.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'paging_view Demo App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const DemoPage(),
    );
  }
}

enum DemoType { list, grid, groupedList, manual, centeredList }

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  DemoType _selected = DemoType.list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('paging_view')),
      body: switch (_selected) {
        .list => const PagingListDemo(),
        .grid => const PagingGridDemo(),
        .groupedList => const GroupedPagingListDemo(),
        .manual => const ManualListDemo(),
        .centeredList => const CenteredPagingListDemo(),
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selected.index,
        onDestinationSelected: (i) {
          setState(() => _selected = DemoType.values[i]);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'List',
            tooltip: 'Paging List',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            label: 'Grid',
            tooltip: 'Grid Paging List',
          ),
          NavigationDestination(
            icon: Icon(Icons.group),
            label: 'Grouped',
            tooltip: 'Grouped Paging List',
          ),
          NavigationDestination(
            icon: Icon(Icons.handshake),
            label: 'Manual',
            tooltip: 'Manual Paging List',
          ),
          NavigationDestination(
            icon: Icon(Icons.center_focus_strong),
            label: 'Centered',
            tooltip: 'Centered Paging List',
          ),
        ],
      ),
    );
  }
}

class PagingListDemo extends ConsumerWidget {
  const PagingListDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(dataSourceProvider);

    return RefreshIndicator(
      onRefresh: () async => dataSource.refresh(),
      child: PagingList(
        dataSource: dataSource,
        builder: (context, entity, index) => Card(
          child: ListTile(
            title: Text(entity.word),
            subtitle: Text(entity.description),
          ),
        ),
        errorBuilder: (context, error, stackTrace) =>
            Center(child: Text('$error')),
        initialLoadingWidget: const Center(
          child: Padding(
            padding: .all(16),
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
        appendLoadingWidget: const Center(
          child: Padding(
            padding: .all(16),
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
        emptyWidget: const Center(child: Text('No Item')),
        padding: const .symmetric(horizontal: 16),
      ),
    );
  }
}

class PagingGridDemo extends ConsumerWidget {
  const PagingGridDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(dataSourceProvider);

    return RefreshIndicator(
      onRefresh: () async => dataSource.refresh(),
      child: PagingGrid(
        dataSource: dataSource,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        builder: (context, entity, index) => Card(
          child: ListTile(
            title: Text(entity.word),
            subtitle: Text(entity.description),
          ),
        ),
        errorBuilder: (context, error, stackTrace) =>
            Center(child: Text('$error')),
        initialLoadingWidget: const Center(
          child: Padding(
            padding: .all(16),
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
        appendLoadingWidget: const Center(
          child: Padding(
            padding: .all(16),
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
        emptyWidget: const Center(child: Text('No Item')),
        padding: const .all(16),
      ),
    );
  }
}

class GroupedPagingListDemo extends ConsumerWidget {
  const GroupedPagingListDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(groupedDataSourceProvider);

    return RefreshIndicator(
      onRefresh: () async => dataSource.refresh(),
      child: CustomScrollView(
        slivers: [
          SliverGroupedPagingList(
            dataSource: dataSource,
            headerBuilder: (context, parent, groupIndex) => Padding(
              padding: const .symmetric(vertical: 8),
              child: Material(
                color: Theme.of(context).colorScheme.primaryContainer,
                clipBehavior: .antiAlias,
                borderRadius: .circular(8),
                child: Center(
                  child: Text(
                    'category: $parent, index: $groupIndex',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
            itemBuilder: (context, entity, globalIndex, localIndex) => Card(
              child: ListTile(
                title: Text(entity.word),
                subtitle: Text(entity.description),
              ),
            ),
            errorBuilder: (context, error, stackTrace) =>
                Center(child: Text('$error')),
            initialLoadingWidget: const Center(
              child: Padding(
                padding: .all(16),
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
            appendLoadingWidget: const Center(
              child: Padding(
                padding: .all(16),
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
            emptyWidget: const Center(child: Text('No Item')),
            padding: const .symmetric(horizontal: 16),
            stickyHeader: true,
            stickyHeaderMinExtentPrototype: const SizedBox(height: 40),
          ),
        ],
      ),
    );
  }
}

class ManualListDemo extends ConsumerWidget {
  const ManualListDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(dataSourceProvider);
    dataSource.onLoadFinished = (action, LoadResult<int, DemoEntity> result) {
      // You can handle load results here for logging or error handling.
      debugPrint('Load action: $action, result: $result');
    };

    return RefreshIndicator(
      onRefresh: () async => dataSource.refresh(),
      child: CustomScrollView(
        slivers: [
          SliverPagingList(
            dataSource: dataSource,
            builder: (context, entity, index) => Card(
              child: ListTile(
                title: Text(entity.word),
                subtitle: Text(entity.description),
              ),
            ),
            errorBuilder: (context, error, stackTrace) =>
                Center(child: Text('$error')),
            initialLoadingWidget: const Center(
              child: Padding(
                padding: .all(16),
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
            emptyWidget: const Center(child: Text('No Item')),
            padding: const .symmetric(horizontal: 16),
            autoLoadPrepend: false,
            autoLoadAppend: false,
          ),
          AppendLoadStateBuilder(
            dataSource: dataSource,
            builder: (context, hasMore, isLoading) => SliverToBoxAdapter(
              child: SizedBox(
                height: 64,
                child: isLoading
                    ? const Center(
                        child: Padding(
                          padding: .all(16),
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      )
                    : hasMore
                    ? Padding(
                        padding: const .all(16),
                        child: FilledButton(
                          onPressed: () => dataSource.append(),
                          child: const Text('Load More'),
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CenteredPagingListDemo extends ConsumerWidget {
  const CenteredPagingListDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(centerDataSourceProvider);

    return CenterPagingList(
      dataSource: dataSource,
      autoLoadPrepend: false,
      autoLoadAppend: false,
      builder: (context, entity, index) => Card(
        child: ListTile(
          leading: CircleAvatar(child: Text('$index')),
          title: Text(entity.word),
          subtitle: Text(entity.description),
        ),
      ),
      errorBuilder: (context, error, stackTrace) =>
          Center(child: Text('$error')),
      initialLoadingWidget: const Center(
        child: Padding(
          padding: .all(16),
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
      emptyWidget: const Center(child: Text('No Item')),
      prependLoadStateBuilder: (context, hasMore, isLoading) {
        if (isLoading) {
          return SizedBox(
            height: 64,
            child: const Center(
              child: Padding(
                padding: .all(16),
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          );
        }
        if (!hasMore) {
          return SizedBox(
            height: 64,
            child: const Padding(
              padding: .all(16),
              child: Center(child: Text('--- Beginning of list ---')),
            ),
          );
        }
        return SizedBox(
          height: 64,
          child: Padding(
            padding: const .all(16),
            child: FilledButton(
              onPressed: () => dataSource.prepend(),
              child: const Text('Load Previous'),
            ),
          ),
        );
      },
      appendLoadStateBuilder: (context, hasMore, isLoading) {
        if (isLoading) {
          return SizedBox(
            height: 64,
            child: const Center(
              child: Padding(
                padding: .all(16),
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          );
        }
        if (!hasMore) {
          return SizedBox(
            height: 64,
            child: const Padding(
              padding: .all(16),
              child: Center(child: Text('--- End of list ---')),
            ),
          );
        }
        return SizedBox(
          height: 64,
          child: Padding(
            padding: const .all(16),
            child: FilledButton(
              onPressed: () => dataSource.append(),
              child: const Text('Load More'),
            ),
          ),
        );
      },
      padding: const .symmetric(horizontal: 16),
    );
  }
}

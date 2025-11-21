import 'package:example/model/data_source_grouped_repositories.dart';
import 'package:example/model/data_source_public_repositories.dart';
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
      title: 'PagingView Example',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const DemoSelectorPage(),
    );
  }
}

enum DemoType { paging, grouped }

class DemoSelectorPage extends StatefulWidget {
  const DemoSelectorPage({super.key});

  @override
  State<DemoSelectorPage> createState() => _DemoSelectorPageState();
}

class _DemoSelectorPageState extends State<DemoSelectorPage> {
  DemoType _selected = DemoType.paging;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PagingView Example')),
      body: switch (_selected) {
        DemoType.paging => const PagingListDemo(),
        DemoType.grouped => const GroupedPagingListDemo(),
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selected.index,
        onDestinationSelected: (i) {
          setState(() => _selected = DemoType.values[i]);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'PagingList',
            tooltip: 'Paging List',
          ),
          NavigationDestination(
            icon: Icon(Icons.group),
            label: 'GroupedPagingList',
            tooltip: 'Grouped Paging List',
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
    final dataSource = ref.watch(dataSourcePublicRepositoriesProvider);

    return RefreshIndicator(
      onRefresh: () async => dataSource.refresh(),
      child: PagingList(
        dataSource: dataSource,
        builder: (context, repository, index) => Card(
          child: ListTile(
            title: Text(repository.fullName),
            subtitle: Text(repository.description),
          ),
        ),
        errorBuilder: (context, error, stackTrace) =>
            Center(child: Text('$error')),
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
        emptyWidget: const Center(child: Text('No Item')),
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
      child: GroupedPagingList(
        dataSource: dataSource,
        headerBuilder: (context, parent, groupIndex) => Text(
          '$groupIndex: $parent',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        itemBuilder: (context, value, globalIndex, localIndex) => Card(
          child: ListTile(
            title: Text(value.fullName),
            subtitle: Text(value.description),
          ),
        ),
        errorBuilder: (context, error, stackTrace) =>
            Center(child: Text('$error')),
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
        emptyWidget: const Center(child: Text('No Item')),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}

import 'package:example/model/data_source_public_repositories.dart';
import 'package:example/model/entity/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paging/flutter_paging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(dataSourcePublicRepositoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub public repositories'),
      ),
      body: Paging<Repository, int>(
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
      ),
    );
  }
}

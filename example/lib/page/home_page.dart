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
        appendLoadingWidget: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        builder: (context, repository, index) {
          return Card(
            child: ListTile(
              title: Text(repository.fullName),
              subtitle: Text(repository.description),
            ),
          );
        },
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
      ),
    );
  }
}

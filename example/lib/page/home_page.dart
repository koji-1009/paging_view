import 'package:example/model/data_source_top.dart';
import 'package:example/model/entity/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paging/flutter_paging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datasource = ref.watch(dataSourceTopProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Paging<Repository, int>(
        dataSource: datasource,
        appendWidget: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        typedBuilder: (context, repository, index) {
          return Card(
            child: ListTile(
              title: Text(repository.fullName),
              subtitle: Text(repository.description),
            ),
          );
        },
      ),
    );
  }
}

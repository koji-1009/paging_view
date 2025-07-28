import 'dart:convert';

import 'package:example/model/entity/repository.dart';
import 'package:github/github.dart' as github;
import 'package:http/http.dart' as http;
import 'package:paging_view/paging_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'github_repository.g.dart';

@riverpod
GitHubRepository gitHubRepository(GitHubRepositoryRef ref) =>
    GitHubRepository(client: http.Client());

const _endpoint = 'https://api.github.com';

class GitHubRepository {
  GitHubRepository({required this.client});

  final http.Client client;

  Future<PageData<int, Repository>> repositories({int? since}) async {
    final response = await client.get(
      '$_endpoint/repositories${since != null ? '?since=$since' : ''}'.uri,
      headers: {'Accept': 'application/vnd.github+json'},
    );

    final int? appendKey;
    final link = response.headers['link'];
    if (link != null) {
      final map = github.parseLinkHeader(link);
      final nextUrl = map['next'] ?? '';
      appendKey = int.tryParse(nextUrl.uri.queryParameters['since'] ?? '');
    } else {
      appendKey = null;
    }

    final rawList = jsonDecode(response.body) as List<dynamic>;
    final list = rawList
        .map((e) => Map<String, dynamic>.from(e as Map))
        .map((e) => Repository.fromJson(e))
        .toList();

    return PageData(data: list, appendKey: appendKey);
  }
}

extension on String {
  Uri get uri => Uri.parse(this);
}

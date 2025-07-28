import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository.freezed.dart';
part 'repository.g.dart';

@freezed
abstract class Repository with _$Repository {
  const factory Repository({
    required String name,
    required int id,
    required String fullName,
    @Default('') String description,
  }) = _Repository;

  factory Repository.fromJson(Map<String, dynamic> json) =>
      _$RepositoryFromJson(json);
}

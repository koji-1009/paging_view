// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Repository _$RepositoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Repository', json, ($checkedConvert) {
      final val = _Repository(
        name: $checkedConvert('name', (v) => v as String),
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        fullName: $checkedConvert('full_name', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String? ?? ''),
        since: $checkedConvert('since', (v) => v as String? ?? ''),
      );
      return val;
    }, fieldKeyMap: const {'fullName': 'full_name'});

Map<String, dynamic> _$RepositoryToJson(_Repository instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'full_name': instance.fullName,
      'description': instance.description,
      'since': instance.since,
    };

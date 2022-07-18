// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Repository _$$_RepositoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$_Repository',
      json,
      ($checkedConvert) {
        final val = _$_Repository(
          name: $checkedConvert('name', (v) => v as String),
          id: $checkedConvert('id', (v) => v as int),
          fullName: $checkedConvert('full_name', (v) => v as String),
          description:
              $checkedConvert('description', (v) => v as String? ?? ''),
        );
        return val;
      },
      fieldKeyMap: const {'fullName': 'full_name'},
    );

Map<String, dynamic> _$$_RepositoryToJson(_$_Repository instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'full_name': instance.fullName,
      'description': instance.description,
    };

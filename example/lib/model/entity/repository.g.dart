// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RepositoryImpl _$$RepositoryImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$RepositoryImpl',
      json,
      ($checkedConvert) {
        final val = _$RepositoryImpl(
          name: $checkedConvert('name', (v) => v as String),
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          fullName: $checkedConvert('full_name', (v) => v as String),
          description:
              $checkedConvert('description', (v) => v as String? ?? ''),
        );
        return val;
      },
      fieldKeyMap: const {'fullName': 'full_name'},
    );

Map<String, dynamic> _$$RepositoryImplToJson(_$RepositoryImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'full_name': instance.fullName,
      'description': instance.description,
    };

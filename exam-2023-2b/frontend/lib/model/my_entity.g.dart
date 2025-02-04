// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyEntity _$MyEntityFromJson(Map<String, dynamic> json) => MyEntity(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      date: json['date'] as String?,
      time: (json['time'] as num?)?.toInt(),
      intensity: json['intensity'] as String?,
    );

Map<String, dynamic> _$MyEntityToJson(MyEntity instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'date': instance.date,
      'time': instance.time,
      'intensity': instance.intensity,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyEntity _$MyEntityFromJson(Map<String, dynamic> json) => MyEntity(
      id: (json['id'] as num?)?.toInt(),
      date: json['date'] as String?,
      title: json['title'] as String?,
      ingredients: json['ingredients'] as String?,
      category: json['category'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MyEntityToJson(MyEntity instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'title': instance.title,
      'ingredients': instance.ingredients,
      'category': instance.category,
      'rating': instance.rating,
    };

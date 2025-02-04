import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_entity.g.dart';

@entity
@JsonSerializable()
class MyEntity {
  @JsonKey(name: "id")
  @PrimaryKey()
  int? id;
  String? date;
  String? title;
  String? ingredients;
  String? category;
  double? rating;

  MyEntity({
    this.id,
    required this.date,
    required this.title,
    required this.ingredients,
    required this.category,
    required this.rating
  });

  factory MyEntity.fromJson(Map<String, dynamic> json) =>
    _$MyEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MyEntityToJson(this);
}
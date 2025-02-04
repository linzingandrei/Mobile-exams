import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_entity.g.dart';

@entity
@JsonSerializable()
class MyEntity {
  @JsonKey(name: "id")
  @PrimaryKey()
  int? id;
  String? name;
  String? description;
  String? category;
  String? date;
  int? time;
  String? intensity;

  MyEntity({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.intensity
  });

  factory MyEntity.fromJson(Map<String, dynamic> json) =>
    _$MyEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MyEntityToJson(this);
}
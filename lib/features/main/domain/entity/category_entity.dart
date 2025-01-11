import 'package:json_annotation/json_annotation.dart';

part 'category_entity.g.dart';

@JsonSerializable()
class CategoryEntity {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String description;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toJson() => _$CategoryEntityToJson(this);
  factory CategoryEntity.fromJson(Map<String, dynamic> json) =>
      _$CategoryEntityFromJson(json);
}

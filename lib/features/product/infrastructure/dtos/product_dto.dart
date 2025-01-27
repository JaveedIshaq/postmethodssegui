import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';

part 'product_dto.g.dart';

@JsonSerializable()
class ProductDto extends Equatable {
  @JsonKey(name: "id")
  final String? id;

  @JsonKey(name: "name")
  final String? name;

  @JsonKey(name: "createdAt")
  final String? createdAt;

  const ProductDto({
    this.id,
    this.name,
    this.createdAt,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);

  ProductEntity toEntity() =>
      ProductEntity(id: id ?? "", name: name ?? "", createdAt: createdAt ?? "");

  @override
  List<Object?> get props => [
        id,
        name,
        createdAt,
      ];
}

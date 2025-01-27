import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/weather/domain/entities/location_entity.dart';

part 'location_dto.g.dart';

@JsonSerializable()
class LocationDto extends Equatable {
  final int? id;
  final String? name;
  final double? latitude;
  final double? longitude;

  const LocationDto({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) =>
      _$LocationDtoFromJson(json);

  @override
  List<Object?> get props => [
        id,
        name,
        latitude,
        longitude,
      ];

  LocationEntity toEntity() => LocationEntity(
        id: id ?? 0,
        name: name ?? "",
        latitude: latitude ?? 0.0,
        longitude: longitude ?? 0.0,
      );
}

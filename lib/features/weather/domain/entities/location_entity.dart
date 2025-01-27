import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final int id;
  final String name;
  final double latitude;
  final double longitude;

  const LocationEntity({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props {
    return [
      id,
      name,
      latitude,
      longitude,
    ];
  }

  const LocationEntity.empty()
      : id = 0,
        name = '',
        latitude = 0.0,
        longitude = 0.0;

  LocationEntity copyWith(
      {int? id, String? name, double? latitude, double? longitude}) {
    return LocationEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

import 'package:equatable/equatable.dart';
import '/place_repository_library.dart';

// ignore: must_be_immutable
class Place extends Equatable {
  final String id;
  final String googleId;
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  String? image;
  DateTime? arrival;
  DateTime? departure;
  List<Place>? attractions;
  List<Place>? accommodations;
  String? currency;
  String? language;
  double? cost;

  Place({
    required this.id,
    required this.googleId,
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.image,
    this.arrival,
    this.departure,
    this.attractions,
    this.accommodations,
    this.currency,
    this.language,
    this.cost,
  });

  static final empty = Place(googleId: '', id: '', name: '', country: '', latitude: 0.0, longitude: 0.0);

  void addAccommodation(Place accommodation) {
    accommodations ??= [];
    accommodations!.add(accommodation);
  }

  PlaceEntity toEntity() {
    return PlaceEntity(
      id: id,
      googleId: googleId,
      name: name,
      country: country,
      latitude: latitude,
      longitude: longitude,
      image: image,
      arrival: arrival,
      departure: departure,
      attractions: attractions,
      accommodations: accommodations,
      currency: currency,
      language: language,
      cost: cost,
    );
  }

  static fromEntity(PlaceEntity entity) {
    return Place(
      id: entity.id!,
      googleId: entity.googleId!,
      name: entity.name!,
      country: entity.country!,
      latitude: entity.latitude!,
      longitude: entity.longitude!,
      image: entity.image,
      arrival: entity.arrival,
      departure: entity.departure,
      attractions: entity.attractions,
      accommodations: entity.accommodations,
      currency: entity.currency,
      language: entity.language,
      cost: entity.cost,
    );
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      googleId: json['googleId'],
      name: json['name'],
      country: json['country'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      image: json['image'],
      arrival: json['arrival'] != null ? DateTime.parse(json['arrival']) : null,
      departure: json['departure'] != null ? DateTime.parse(json['departure']) : null,
      attractions: json['attractions'] != null
          ? (json['attractions'] as List).map((placeJson) => Place.fromJson(placeJson)).toList()
          : null,
      accommodations: json['accommodations'] != null
          ? (json['accommodations'] as List).map((placeJson) => Place.fromJson(placeJson)).toList()
          : null,
      currency: json['currency'],
      language: json['language'],
      cost: json['cost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'googleId': googleId,
      'name': name,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'image': image,
      'arrival': arrival?.toIso8601String(),
      'departure': departure?.toIso8601String(),
      'attractions': attractions?.map((place) => place.toJson()).toList(),
      'accommodations': accommodations?.map((place) => place.toJson()).toList(),
      'currency': currency,
      'language': language,
      'cost': cost,
    };
  }

  @override
  List<Object?> get props => [
        id,
        googleId,
        name,
        country,
        latitude,
        longitude,
        image,
        arrival,
        departure,
        attractions,
        accommodations,
        currency,
        language,
        cost
      ];
}

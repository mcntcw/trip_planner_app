import 'package:equatable/equatable.dart';
import '/place_repository_library.dart';

class PlaceEntity extends Equatable {
  final String? id;
  final String? googleId;
  final String? name;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? image;
  final DateTime? arrival;
  final DateTime? departure;
  final List<Place>? attractions;
  final List<Place>? accommodations;
  final String? currency;
  final String? language;
  final double? cost;

  const PlaceEntity({
    this.id,
    this.googleId,
    this.name,
    this.country,
    this.latitude,
    this.longitude,
    this.image,
    this.arrival,
    this.departure,
    this.attractions,
    this.accommodations,
    this.currency,
    this.language,
    this.cost,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'googleId': googleId,
      'name': name,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'image': image,
      'arrival': arrival,
      'departure': departure,
      'attractions': attractions,
      'accommodations': accommodations,
      'currency': currency,
      'language': language,
      'cost': cost,
    };
  }

  static PlaceEntity fromDocument(Map<String, dynamic> document) {
    return PlaceEntity(
      id: document['id'],
      googleId: document['googleId'],
      name: document['name'],
      country: document['country'],
      latitude: document['latitude']?.toDouble(),
      longitude: document['longitude']?.toDouble(),
      image: document['image'],
      arrival: (document['arrival'] != null) ? DateTime.parse(document['arrival']) : null,
      departure: (document['departure'] != null) ? DateTime.parse(document['departure']) : null,
      attractions: (document['attractions'] != null)
          ? List<Place>.from((document['attractions'] as List<dynamic>)
              .map((item) => Place.fromEntity(PlaceEntity.fromDocument(item))))
          : null,
      accommodations: (document['accommodations'] != null)
          ? List<Place>.from((document['accommodations'] as List<dynamic>)
              .map((item) => Place.fromEntity(PlaceEntity.fromDocument(item))))
          : null,
      currency: document['currency'],
      language: document['language'],
      cost: document['cost']?.toDouble(),
    );
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

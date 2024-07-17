import 'package:equatable/equatable.dart';
import 'package:place_repository/place_repository_library.dart';

// ignore: must_be_immutable
class TripEntity extends Equatable {
  final String? id;
  final String? name;

  final DateTime? startDate;
  final List<Place>? stops;

  const TripEntity({
    this.id,
    this.name,
    this.startDate,
    this.stops,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate,
      'stops': stops,
    };
  }

  static TripEntity fromDocument(Map<String, dynamic> document) {
    return TripEntity(
      id: document['id'],
      name: document['name'],
      startDate: document['startDate'],
      stops: (document['stops'] != null)
          ? List<Place>.from(
              (document['stops'] as List<dynamic>).map(
                (item) => Place.fromEntity(
                  PlaceEntity.fromDocument(item),
                ),
              ),
            )
          : null,
    );
  }

  @override
  List<Object?> get props => [id, name, stops];
}

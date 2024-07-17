import 'package:equatable/equatable.dart';
import 'package:place_repository/place_repository_library.dart';
import 'package:trip_repository/trip_repository_library.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class Trip extends Equatable {
  final String id;
  String name;
  DateTime startDate;
  List<Place> stops;

  Trip({
    required this.id,
    required this.name,
    required this.startDate,
    required this.stops,
  });

  double get totalCost {
    double cost = 0;
    for (var stop in stops) {
      cost += (stop.attractions?.map((attraction) => attraction.cost ?? 0).reduce((a, b) => a + b) ?? 0);
      cost += (stop.accommodations?.map((accommodation) => accommodation.cost ?? 0).reduce((a, b) => a + b) ?? 0);
    }
    return cost;
  }

  DateTime get endDate {
    for (int i = stops.length - 1; i >= 0; i--) {
      if (stops[i].departure != null) {
        return stops[i].departure!;
      } else if (stops[i].arrival != null) {
        return stops[i].arrival!;
      }
    }
    return startDate;
  }

  List<String?> get currencies => stops.map((stop) => stop.currency).toSet().toList();

  List<String?> get languages => stops.map((stop) => stop.language).toSet().toList();

  static final empty = Trip(id: '', name: '', startDate: DateTime(0), stops: const []);

  static Trip newTrip({
    required String name,
    required Place beginning,
    required DateTime startDate,
  }) {
    Trip trip = Trip(id: const Uuid().v4(), name: name, startDate: startDate, stops: [beginning]);
    return trip;
  }

  TripEntity toEntity() {
    return TripEntity(
      id: id,
      name: name,
      startDate: startDate,
      stops: stops,
    );
  }

  static fromEntity(TripEntity entity) {
    return Trip(
      id: entity.id!,
      name: entity.name!,
      startDate: entity.startDate!,
      stops: entity.stops!,
    );
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      stops: (json['stops'] as List<dynamic>).map((placeJson) => Place.fromJson(placeJson)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'stops': stops.map((place) => place.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        startDate,
        stops,
      ];
}

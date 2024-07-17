import 'package:trip_repository/src/models/models.dart';

abstract class TripRepository {
  Future<List<Trip>> getUserTrips(String userId);
}

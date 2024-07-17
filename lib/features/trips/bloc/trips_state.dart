part of 'trips_bloc.dart';

@immutable
sealed class TripsState extends Equatable {
  final List<Trip> trips;

  const TripsState({required this.trips});
  @override
  List<Object> get props => [trips];
}

final class TripsInitial extends TripsState {
  const TripsInitial() : super(trips: const []);
}

final class TripsProcess extends TripsState {
  const TripsProcess() : super(trips: const []);
}

final class TripsSuccess extends TripsState {
  const TripsSuccess({
    required super.trips,
  });
}

final class TripsFailure extends TripsState {
  const TripsFailure() : super(trips: const []);
}

//ADD NEW TRIP

final class TripAddProcess extends TripsState {
  const TripAddProcess({
    required super.trips,
  });
}

final class TripAddSuccess extends TripsState {
  const TripAddSuccess() : super(trips: const []);
}

final class TripAddFailure extends TripsState {
  final String errorMessage;
  const TripAddFailure({required this.errorMessage}) : super(trips: const []);
}

//UPDATE TRIP

final class TripUpdateProcess extends TripsState {
  const TripUpdateProcess({
    required super.trips,
  });
}

final class TripUpdateSuccess extends TripsState {
  const TripUpdateSuccess() : super(trips: const []);
}

final class TripUpdateFailure extends TripsState {
  final String errorMessage;
  const TripUpdateFailure({required this.errorMessage}) : super(trips: const []);
}

//DELETE TRIP

final class TripDeleteProcess extends TripsState {
  const TripDeleteProcess({
    required super.trips,
  });
}

final class TripDeleteSuccess extends TripsState {
  const TripDeleteSuccess() : super(trips: const []);
}

final class TripDeleteFailure extends TripsState {
  final String errorMessage;
  const TripDeleteFailure({required this.errorMessage}) : super(trips: const []);
}

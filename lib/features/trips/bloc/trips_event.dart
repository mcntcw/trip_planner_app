part of 'trips_bloc.dart';

sealed class TripsEvent extends Equatable {
  const TripsEvent();

  @override
  List<Object> get props => [];
}

class GetTrips extends TripsEvent {
  const GetTrips();
}

class AddTrip extends TripsEvent {
  final Trip trip;

  const AddTrip({required this.trip});

  @override
  List<Object> get props => [trip];
}

class UpdateTrip extends TripsEvent {
  final Trip trip;

  const UpdateTrip({required this.trip});

  @override
  List<Object> get props => [trip];
}

class DeleteTrip extends TripsEvent {
  final Trip trip;

  const DeleteTrip({required this.trip});

  @override
  List<Object> get props => [trip];
}

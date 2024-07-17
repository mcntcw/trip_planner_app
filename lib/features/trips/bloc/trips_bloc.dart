import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:place_repository/place_repository_library.dart';
import 'package:trip_repository/trip_repository_library.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripsBloc extends HydratedBloc<TripsEvent, TripsState> {
  // ignore: unused_field
  final GooglePlacesRepository _googlePlacesRepository;
  TripsBloc({required GooglePlacesRepository googlePlacesRepository})
      : _googlePlacesRepository = googlePlacesRepository,
        super(const TripsInitial()) {
    on<GetTrips>((event, emit) {
      emit(const TripsProcess());
      try {
        final trips = List.of(state.trips);
        emit(TripsSuccess(trips: trips));
      } catch (e) {
        emit(const TripsFailure());
      }
    });

    on<AddTrip>((event, emit) {
      emit(TripAddProcess(trips: state.trips));
      try {
        final trips = List.of(state.trips)..add(event.trip);
        emit(const TripAddSuccess());
        emit(TripsSuccess(trips: trips));
      } catch (e) {
        String errorMessage = e.toString();
        if (errorMessage.startsWith("Exception: ")) {
          errorMessage = errorMessage.substring("Exception: ".length);
        }
        final trips = state.trips;
        emit(TripAddFailure(errorMessage: errorMessage));
        emit(const TripsFailure());
      }
    });

    on<UpdateTrip>((event, emit) {
      emit(TripUpdateProcess(trips: state.trips));
      try {
        final newTrips = state.trips.map((trip) {
          if (trip.id == event.trip.id) {
            return event.trip;
          } else {
            return trip;
          }
        }).toList();
        emit(const TripUpdateSuccess());
        emit(TripsSuccess(trips: newTrips));
      } catch (e) {
        String errorMessage = e.toString();
        if (errorMessage.startsWith("Exception: ")) {
          errorMessage = errorMessage.substring("Exception: ".length);
        }
        final trips = state.trips;
        emit(TripUpdateFailure(errorMessage: errorMessage));
        emit(const TripsFailure());
      }
    });

    on<DeleteTrip>((event, emit) {
      emit(TripDeleteProcess(trips: state.trips));
      try {
        final newTrips = state.trips.where((trip) => trip.id != event.trip.id).toList();
        emit(const TripDeleteSuccess());
        emit(TripsSuccess(trips: newTrips));
      } catch (e) {
        String errorMessage = e.toString();
        if (errorMessage.startsWith("Exception: ")) {
          errorMessage = errorMessage.substring("Exception: ".length);
        }
        final trips = state.trips;
        emit(TripDeleteFailure(errorMessage: errorMessage));
        emit(const TripsFailure());
      }
    });
  }

  @override
  TripsState? fromJson(Map<String, dynamic> json) {
    try {
      final trips = (json['trips'] as List).map<Trip>((trip) => Trip.fromJson(trip as Map<String, dynamic>)).toList();

      return TripsSuccess(trips: trips);
    } catch (e) {
      return const TripsFailure();
    }
  }

  @override
  Map<String, dynamic>? toJson(TripsState state) {
    if (state is TripsSuccess) {
      try {
        return {
          'trips': state.trips.map((trip) => trip.toJson()).toList(),
        };
      } catch (e) {
        return {'trips': []};
      }
    }
    return {'trips': []};
  }
}

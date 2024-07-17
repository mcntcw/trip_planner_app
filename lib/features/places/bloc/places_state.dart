part of 'places_bloc.dart';

@immutable
sealed class PlacesState extends Equatable {
  const PlacesState();

  @override
  List<Object> get props => [];
}

final class PlacesInitial extends PlacesState {}

final class GetPlaceProcess extends PlacesState {
  const GetPlaceProcess();
}

final class GetPlaceSuccess extends PlacesState {
  final Place place;

  const GetPlaceSuccess({required this.place});
}

final class GetPlaceFailure extends PlacesState {
  const GetPlaceFailure();
}

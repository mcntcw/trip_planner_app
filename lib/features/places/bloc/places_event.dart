part of 'places_bloc.dart';

@immutable
sealed class PlacesEvent extends Equatable {
  const PlacesEvent();

  @override
  List<Object> get props => [];
}

class GetPlace extends PlacesEvent {
  final String id;
  const GetPlace({required this.id});
}

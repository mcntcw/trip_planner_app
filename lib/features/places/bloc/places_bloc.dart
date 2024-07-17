import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:place_repository/place_repository_library.dart';

part 'places_event.dart';
part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  // ignore: unused_field
  final GooglePlacesRepository _googlePlacesRepository;
  PlacesBloc({required GooglePlacesRepository googlePlacesRepository})
      : _googlePlacesRepository = googlePlacesRepository,
        super(PlacesInitial()) {
    on<GetPlace>((event, emit) async {
      emit(const GetPlaceProcess());
      try {
        final place = await _googlePlacesRepository.getPlace(event.id);
        emit(GetPlaceSuccess(place: place));
      } catch (e) {
        emit(const GetPlaceFailure());
      }
    });
  }
}

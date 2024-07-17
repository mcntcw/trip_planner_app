import '/place_repository_library.dart';

abstract class PlaceRepository {
  Future<List<PlaceSearch>> getAutocomplete(String search);
  Future<Place> getPlace(String googleId);
}

import 'dart:io';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sealed_languages/sealed_languages.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import '/place_repository_library.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class GooglePlacesRepository implements PlaceRepository {
  final key = 'AIzaSyCcxtOdEZZsiBwVNEhn7UghgFZZdoboNRw';

  @override
  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    if (search.length < 2) {
      return [];
    }

    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&key=$key');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      var jsonResults = json['predictions'] as List;
      List<PlaceSearch> autocomplete = jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
      return autocomplete;
    } else {
      throw Exception('Failed to autocomplete places');
    }
  }

  @override
  Future<Place> getPlace(String placeId) async {
    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      var result = json['result'];

      String id = const Uuid().v4();

      var addressComponents = result['address_components'] as List<dynamic>;

      String country = '';
      String countryCode = '';
      for (var component in addressComponents) {
        var types = component['types'] as List<dynamic>;

        if (types.contains('country')) {
          country = component['long_name'];
          countryCode = component['short_name'];
        }
      }

      String currency = _getCurrency(countryCode);
      String language = _getLanguage(countryCode);

      String? photoReference;
      if (result['photos'] != null && result['photos'].isNotEmpty) {
        photoReference = result['photos'][0]['photo_reference'];
      }

      String? photoUrl;
      if (photoReference != null) {
        photoUrl =
            'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$key';
      }

      String? localImagePath;
      if (photoUrl != null) {
        localImagePath = await _downloadAndSaveImage(photoUrl, id);
      }

      Place place = Place(
        id: id,
        googleId: result['place_id'],
        name: result['name'],
        country: country,
        latitude: result['geometry']?['location']?['lat'].toDouble(),
        longitude: result['geometry']?['location']?['lng'].toDouble(),
        image: localImagePath,
        language: language,
        currency: currency,
      );
      return place;
    } else {
      throw Exception('Failed to load place details');
    }
  }

  Future<String?> _downloadAndSaveImage(String photoUrl, String id) async {
    try {
      final photoResponse = await http.get(Uri.parse(photoUrl));
      if (photoResponse.statusCode == 200) {
        final imageBytes = photoResponse.bodyBytes;
        final directory = await getApplicationDocumentsDirectory();
        final filePath = path.join(directory.path, '$id.jpg');
        final file = File(filePath);
        await file.writeAsBytes(imageBytes);
        return filePath;
      } else {
        throw Exception('Failed to download image');
      }
    } catch (e) {
      throw Exception('Error downloading image: $e');
    }
  }

  String _getCurrency(String countryCode) {
    try {
      Locale locale = Locale(countryCode);
      var format = NumberFormat.simpleCurrency(locale: locale.toString());
      return format.currencySymbol;
    } catch (e) {
      return '$countryCode currency';
    }
  }

  String _getLanguage(String countryCode) {
    try {
      final language = NaturalLanguage.fromCodeShort(countryCode).toString();
      final RegExp regExp = RegExp(r'Language\(name:\s*"(.+)"\)');
      final match = regExp.firstMatch(language);

      if (match != null && match.groupCount == 1) {
        return match.group(1)!;
      } else {
        throw Exception('Unexpected format: $language');
      }
    } catch (e) {
      return countryCode;
    }
  }
}

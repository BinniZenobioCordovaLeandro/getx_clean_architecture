import "package:google_maps_webservice/places.dart";
import 'package:pickpointer/src/core/env/config_env.dart';

class PlacesProvider {
  static PlacesProvider? _instance;
  GoogleMapsPlaces? googleMapsPlaces;

  static PlacesProvider? getInstance() {
    _instance ??= PlacesProvider();
    _instance!.googleMapsPlaces ??= GoogleMapsPlaces(
      apiKey: ConfigEnv.apiKeyPlaces,
    );
    return _instance!;
  }

  Future<List<Prediction>> getPredictions(String input) {
    Future<List<Prediction>> futureListPrediction = googleMapsPlaces!
        .autocomplete(input)
        .then((PlacesAutocompleteResponse placesAutocompleteResponse) {
      if (placesAutocompleteResponse.errorMessage != null) {
        throw Exception(placesAutocompleteResponse.errorMessage);
      }
      return placesAutocompleteResponse.predictions;
    });
    return futureListPrediction;
  }

  Future<PlacesDetailsResponse> getPlaceDetails(String placeId) {
    Future<PlacesDetailsResponse> futurePlaceDetails = googleMapsPlaces!
        .getDetailsByPlaceId(placeId)
        .then((PlacesDetailsResponse placesDetailsResponse) {
      if (placesDetailsResponse.errorMessage != null) {
        throw Exception(placesDetailsResponse.errorMessage);
      }
      return placesDetailsResponse;
    });
    return futurePlaceDetails;
  }
}

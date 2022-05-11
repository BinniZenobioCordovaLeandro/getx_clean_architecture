import 'dart:convert';
import "package:google_maps_webservice/places.dart";
import 'package:pickpointer/src/core/env/config_env.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

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

  Future<List<Prediction>> getPredictions(
    String placeName, {
    LatLng? currentPosition,
  }) async {
    try {
      final String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=${ConfigEnv.apiKeyPlaces}&components=country:pe&location=${currentPosition?.latitude ?? 0},${currentPosition?.longitude ?? 0}&rankby=distance";
      http.Response response =
          await http.get(Uri.parse(autoCompleteUrl), headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
      });
      final List<dynamic> predictions =
          const JsonDecoder().convert(response.body)["predictions"];
      List<Prediction> listPrediction =
          predictions.map((e) => Prediction.fromJson(e)).toList();
      return listPrediction;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<PlacesDetailsResponse> getPlaceDetails(String placeId) async {
    String placeAddressDetailUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${ConfigEnv.apiKeyPlaces}";
    http.Response response =
        await http.get(Uri.parse(placeAddressDetailUrl), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
    });
    PlacesDetailsResponse placesDetailsResponse =
        PlacesDetailsResponse.fromJson(
      const JsonDecoder().convert(response.body),
    );
    return placesDetailsResponse;
  }
}

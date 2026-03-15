import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/models/place_prediction.dart';
import 'package:uuid/uuid.dart';

class SuggestionController extends GetxController {
  var predictions = <PlacePrediction>[].obs;
  Rxn<PlacePrediction> selected = Rxn();
  var query = ''.obs;
  var isLoading = false.obs;

  String? _sessionToken;
  final String _apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
  final String mapUrl = "https://maps.googleapis.com/maps/api";
  final int cacheDays = 3;
  late final Future<SharedPreferences> _prefsFuture =
      SharedPreferences.getInstance();

  // Count
  int hit = 0;
  int miss = 0;

  @override
  void onInit() {
    super.onInit();
    _sessionToken = const Uuid().v4();

    debounce(
      query,
      (val) => _handleCachedSuggestions(val),
      time: Duration(milliseconds: 100),
    );
  }

  /////////////////////////////////
  // HANDLE LOCATION SUGGESTION  //
  /////////////////////////////////

  // 1. Update the query signal (called from UI)
  void onSearchChanged(String val) {
    query.value = val;
    if (val.isEmpty) {
      predictions.clear();
      isLoading.value = false;
    }
  }

  // 3. Selection Logic
  void selectPrediction(
    PlacePrediction prediction,
    TextEditingController textController, {
    void Function(double, double)? callback,
  }) {
    getPlacePosition(prediction.placeId).then((newPosition) {
      if (callback != null) {
        callback(newPosition?['lat'], newPosition?['lng']);
      }
    });
    selected.value = prediction;
    textController.text = prediction.description;
    predictions.clear();
    query.value = "";
    _sessionToken = const Uuid().v4(); // Reset session for Google billing
  }

  /////////////////////////////
  // Convert Positional Data //
  /////////////////////////////

  Future<Map<String, dynamic>?> getPlacePosition(String? placeId) async {
    if (placeId == null) return null;

    final String url =
        '$mapUrl/place/details/json?place_id=$placeId&key=$_apiKey&sessiontoken=$_sessionToken';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final location = data['result']['geometry']['location'];
          return {"lat": location['lat'], "lng": location['lng']};
        }
      }
    } catch (e) {
      debugPrint("Error fetching place position: $e");
    }
    return null;
  }

  Future<String?> getAddressFromLatLng(double lat, double lng) async {
    final String url = '$mapUrl/geocode/json?latlng=$lat,$lng&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address'];
        }
      }
    } catch (e) {
      debugPrint("Error reverse geocoding: $e");
    }
    return null;
  }

  /////////////////////////////
  // HANDLE CACHED RESPONSES //
  /////////////////////////////

  // Check cache first, then fetch from API if expired or missing
  Future<void> _handleCachedSuggestions(String input) async {
    if (input.isEmpty) {
      predictions.clear();
      isLoading.value = false;
      return;
    }

    final prefs = await _prefsFuture;
    final String cacheKey = _cacheKey(input);
    final String timeKey = _cacheTimeKey(input);

    final cached = prefs.getString(cacheKey);
    final cachedTime = prefs.getInt(timeKey);

    if (cached != null && cachedTime != null) {
      final bool valid = _isCacheValid(cachedTime);
      if (valid) return _useCachedPredictions(cached);
    }

    // Cache expired → fetch new data
    await _fetchAndCacheSuggestions(input, cacheKey, timeKey);
  }

  // Fetch from API and update cache
  Future<void> _fetchAndCacheSuggestions(
    String input,
    String cacheKey,
    String timeKey,
  ) async {
    isLoading.value = true;
    _incrementMiss();
    final String request =
        '$mapUrl/place/autocomplete/json?input=$input&key=$_apiKey&sessiontoken=$_sessionToken';

    try {
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        if (result['status'] == 'OK') {
          predictions.value = _parsePredictions(result['predictions'] as List);

          final prefs = await _prefsFuture;
          await prefs.setString(cacheKey, json.encode(result['predictions']));
          await prefs.setInt(timeKey, DateTime.now().millisecondsSinceEpoch);
        }
      }
    } catch (e) {
      debugPrint("Error fetching places: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String _cacheKey(String input) => "place_cache_$input";
  String _cacheTimeKey(String input) => "place_cache_time_$input";

  bool _isCacheValid(int cachedTime) {
    final saved = DateTime.fromMillisecondsSinceEpoch(cachedTime);
    return DateTime.now().difference(saved).inDays < cacheDays;
  }

  void _useCachedPredictions(String cachedJson) {
    _incrementHit();
    predictions.value = _parsePredictions(json.decode(cachedJson) as List);
    update();
    isLoading.value = false;
  }

  List<PlacePrediction> _parsePredictions(List raw) =>
      raw.map((p) => PlacePrediction.fromJson(p)).toList();

  void _incrementHit() => debugPrint("Hit Count: ${hit++}");
  void _incrementMiss() => debugPrint("Miss Count: ${miss++}");
}

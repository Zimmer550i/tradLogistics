import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapsController extends GetxController {
  // ─── Public state ─────────────────────────────────────────────────────────
  final isLoading = false.obs;
  final Rxn<LatLng> currentPosition = Rxn<LatLng>();
  final locationPermissionGranted = false.obs;
  final Rxn<LatLng> pickupLocation = Rxn<LatLng>();
  final Rxn<LatLng> dropoffLocation = Rxn<LatLng>();
  final RxnString pickupAddress = RxnString();
  final RxnString dropoffAddress = RxnString();
  final selectingPickup = true.obs;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final RxBool isNavigating = RxBool(false);

  // ─── Config ───────────────────────────────────────────────────────────────
  final String mapUrl = 'https://maps.googleapis.com/maps/api';
  final String _apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
  static const double _earthRadiusMeters = 6371000.0;

  // ─── Private ──────────────────────────────────────────────────────────────
  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionSub;

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onClose() {
    _positionSub?.cancel();
    _mapController?.dispose();
    super.onClose();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Public API
  // ══════════════════════════════════════════════════════════════════════════

  // ─── Map controller ───────────────────────────────────────────────────────

  void setMapController(GoogleMapController controller) {
    if (_mapController != controller) {
      _mapController?.dispose();
      _mapController = controller;
    }
    if (currentPosition.value != null) {
      _animateTo(currentPosition.value!);
    }
  }

  void clearMapController() {
    _mapController?.dispose();
    _mapController = null;
  }

  // ─── Location ─────────────────────────────────────────────────────────────

  /// Initialises location with standard accuracy and begins passive updates.
  Future<void> initLocation() async {
    if (!await _requestPermission()) return;
    locationPermissionGranted.value = true;
    await _fetchCurrentPosition();
    await _startPositionStream(
      accuracy: LocationAccuracy.best,
      distanceFilter: 5,
    );
  }

  /// Starts high-accuracy navigation updates.
  Future<void> startNavigation() async {
    if (_positionSub != null) return;
    isLoading.value = true;

    if (!await _requestPermission()) {
      isLoading.value = false;
      return;
    }

    locationPermissionGranted.value = true;
    await _fetchCurrentPosition();

    if (isClosed) {
      isLoading.value = false;
      return;
    }

    await _startPositionStream(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1,
    );

    isLoading.value = false;
  }

  /// Stops navigation and releases the location stream.
  Future<void> cancelNavigation() async {
    await stopLocationUpdates();
    isLoading.value = false;
  }

  /// Cancels the active position stream subscription.
  Future<void> stopLocationUpdates() async {
    await _positionSub?.cancel();
    _positionSub = null;
  }

  // ─── Selection mode ───────────────────────────────────────────────────────

  void setSelectionMode({required bool pickup}) {
    selectingPickup.value = pickup;
  }

  void onMapTap(LatLng position) {
    selectingPickup.value
        ? setPickupLocation(position)
        : setDropoffLocation(position);
  }

  // ─── Pickup / dropoff ─────────────────────────────────────────────────────
  
  Future<void> setCurrentLocationAsPickup() async {
    final pos = currentPosition.value;
    if (pos == null) return;
    setPickupLocation(pos, address: 'Current Location');
  }

  void setPickupLocation(LatLng? position, {String? address}) {
    position ??= currentPosition.value;
    pickupLocation.value = position;
    if (address != null) pickupAddress.value = address;
    _onLocationsChanged();
  }

  void setDropoffLocation(LatLng? position, {String? address}) {
    position ??= currentPosition.value;
    dropoffLocation.value = position;
    if (address != null) dropoffAddress.value = address;
    _onLocationsChanged();
  }

  void clearPickupDropoff() {
    pickupLocation.value = null;
    dropoffLocation.value = null;
    pickupAddress.value = null;
    dropoffAddress.value = null;
    markers.clear();
    polylines.clear();
  }

  // ─── Distance ─────────────────────────────────────────────────────────────

  /// Great-circle distance in metres between two coordinates (Haversine).
  double getDistance(LatLng from, LatLng to) {
    final dLat = _toRad(to.latitude - from.latitude);
    final dLng = _toRad(to.longitude - from.longitude);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(from.latitude)) *
            cos(_toRad(to.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    return _earthRadiusMeters * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  /// Distance in metres between pickup and dropoff. Returns 0 if either unset.
  double getPickupDropoffDistance() {
    final p = pickupLocation.value;
    final d = dropoffLocation.value;
    return (p != null && d != null) ? getDistance(p, d).toPrecision(2) : 0.0;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Private – location helpers
  // ══════════════════════════════════════════════════════════════════════════

  Future<bool> _requestPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever;
  }

  Future<void> _fetchCurrentPosition() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      );
      if (isClosed) return;
      currentPosition.value = LatLng(pos.latitude, pos.longitude);
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentPosition.value!, 15),
      );
    } catch (e) {
      debugPrint('[MapsController] _fetchCurrentPosition error: $e');
    }
  }

  Future<void> _startPositionStream({
    required LocationAccuracy accuracy,
    required int distanceFilter,
  }) async {
    await _positionSub?.cancel();
    _positionSub =
        Geolocator.getPositionStream(
          locationSettings: LocationSettings(
            accuracy: accuracy,
            distanceFilter: distanceFilter,
          ),
        ).listen((pos) {
          if (isClosed) return;
          currentPosition.value = LatLng(pos.latitude, pos.longitude);
          _animateTo(currentPosition.value!);
        });
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Private – map layer helpers
  // ══════════════════════════════════════════════════════════════════════════

  void _onLocationsChanged() {
    _updateMarkers();
    _updateRoute(); // async – intentional fire-and-forget
    _fitCamera();
  }

  void _updateMarkers() {
    final updated = <Marker>{};

    if (pickupLocation.value != null) {
      updated.add(
        _buildMarker(
          id: 'pickup',
          position: pickupLocation.value!,
          title: 'Pickup',
          snippet: pickupAddress.value,
          hue: BitmapDescriptor.hueBlue,
        ),
      );
    }

    if (dropoffLocation.value != null) {
      updated.add(
        _buildMarker(
          id: 'dropoff',
          position: dropoffLocation.value!,
          title: 'Dropoff',
          snippet: dropoffAddress.value,
          hue: BitmapDescriptor.hueAzure,
        ),
      );
    }

    markers
      ..clear()
      ..addAll(updated);
  }

  Marker _buildMarker({
    required String id,
    required LatLng position,
    required String title,
    String? snippet,
    required double hue,
  }) {
    return Marker(
      markerId: MarkerId(id),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      infoWindow: InfoWindow(title: title, snippet: snippet),
    );
  }

  Future<void> _updateRoute() async {
    final pickup = pickupLocation.value;
    final dropoff = dropoffLocation.value;

    if (pickup == null || dropoff == null) {
      polylines.clear();
      return;
    }

    final routePoints = await _fetchRoutePoints(pickup, dropoff);

    if (isClosed) return;

    final isFallback = routePoints.length == 2;

    polylines
      ..clear()
      ..add(
        Polyline(
          polylineId: const PolylineId('route'),
          color: isFallback ? Colors.blueGrey : Colors.blue,
          width: 5,
          points: routePoints,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
          // Dashed pattern signals a straight-line fallback to the user.
          patterns: isFallback
              ? [PatternItem.dash(20), PatternItem.gap(10)]
              : [],
        ),
      );
  }

  /// Calls the Directions API and returns decoded route points.
  /// Falls back to a two-point straight line on any failure.
  Future<List<LatLng>> _fetchRoutePoints(LatLng origin, LatLng dest) async {
    try {
      final uri = Uri.parse('$mapUrl/directions/json').replace(
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${dest.latitude},${dest.longitude}',
          'mode': 'driving',
          'key': _apiKey,
        },
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        debugPrint(
          '[MapsController] Directions API HTTP ${response.statusCode}',
        );
        return [origin, dest];
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (body['status'] != 'OK') {
        debugPrint('[MapsController] Directions API status: ${body['status']}');
        return [origin, dest];
      }

      final encoded =
          body['routes']?[0]?['overview_polyline']?['points'] as String?;

      if (encoded == null || encoded.isEmpty) {
        debugPrint('[MapsController] Directions API: empty polyline');
        return [origin, dest];
      }

      return _decodePolyline(encoded);
    } catch (e) {
      debugPrint('[MapsController] _fetchRoutePoints error: $e');
      return [origin, dest];
    }
  }

  /// Decodes a Google encoded polyline string into a list of [LatLng].
  /// Spec: https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int delta = 0;
      int shift = 0;
      int byte;

      // Decode one variable-length integer (latitude or longitude delta).
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        delta |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lat += (delta & 1) != 0 ? ~(delta >> 1) : (delta >> 1);

      delta = 0;
      shift = 0;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        delta |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lng += (delta & 1) != 0 ? ~(delta >> 1) : (delta >> 1);

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }

  void _fitCamera() {
    if (_mapController == null) return;

    final pickup = pickupLocation.value;
    final dropoff = dropoffLocation.value;

    if (pickup != null && dropoff != null) {
      final bounds = LatLngBounds(
        southwest: LatLng(
          min(pickup.latitude, dropoff.latitude),
          min(pickup.longitude, dropoff.longitude),
        ),
        northeast: LatLng(
          max(pickup.latitude, dropoff.latitude),
          max(pickup.longitude, dropoff.longitude),
        ),
      );
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 64));
      return;
    }

    final single = pickup ?? dropoff;
    if (single != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(single, 15));
    }
  }

  void _animateTo(LatLng position) {
    _mapController?.animateCamera(CameraUpdate.newLatLng(position));
  }

  double _toRad(double degrees) => degrees * (pi / 180.0);
}

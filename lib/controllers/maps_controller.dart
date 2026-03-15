import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsController extends GetxController {
  var isLoading = false.obs;
  final Rxn<LatLng> currentPosition = Rxn<LatLng>();
  final RxBool locationPermissionGranted = false.obs;
  final Rxn<LatLng> pickupLocation = Rxn<LatLng>();
  final Rxn<LatLng> dropoffLocation = Rxn<LatLng>();
  final RxnString pickupAddress = RxnString();
  final RxnString dropoffAddress = RxnString();
  final RxBool selectingPickup = true.obs;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  final String mapUrl = "https://maps.googleapis.com/maps/api";
  final int cacheDays = 3;
  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionSub;
  static const double _earthRadiusMeters = 6371000.0;


  @override
  void onClose() {
    _positionSub?.cancel();
    _mapController?.dispose();
    super.onClose();
  }

  void setMapController(GoogleMapController controller) {
    if (_mapController != controller) {
      _mapController?.dispose();
      _mapController = controller;
    }
    final position = currentPosition.value;
    if (position != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLng(position));
    }
  }

  void clearMapController() {
    _mapController?.dispose();
    _mapController = null;
  }

  /// Starts high-accuracy location updates intended for navigation.
  /// Returns immediately if updates are already running or permission is denied.
  Future<void> startNavigation() async {
    if (_positionSub != null) return;
    isLoading.value = true;

    final hasPermission = await _checkPermission();
    if (!hasPermission || isClosed) {
      isLoading.value = false;
      return;
    }

    locationPermissionGranted.value = true;
    await _getCurrentLocation();

    if (isClosed) {
      isLoading.value = false;
      return;
    }

    _positionSub =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 1,
          ),
        ).listen((position) {
          currentPosition.value = LatLng(position.latitude, position.longitude);
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(currentPosition.value!),
          );
          if (pickupLocation.value != null && dropoffLocation.value == null) {
            _refreshRoute();
          }
        });

    isLoading.value = false;
  }

  /// Stops navigation updates and releases the underlying location stream.
  Future<void> cancelNavigation() async {
    await stopLocationUpdates();
    isLoading.value = false;
  }

  /// Returns the great-circle distance in meters between two coordinates.
  double getDistance(LatLng from, LatLng to) {
    final double dLat = _degToRad(to.latitude - from.latitude);
    final double dLng = _degToRad(to.longitude - from.longitude);
    final double lat1 = _degToRad(from.latitude);
    final double lat2 = _degToRad(to.latitude);

    final double sinDLat = sin(dLat / 2);
    final double sinDLng = sin(dLng / 2);
    final double a = sinDLat * sinDLat +
        sinDLng * sinDLng * cos(lat1) * cos(lat2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return _earthRadiusMeters * c;
  }

  /// Returns the distance in meters between pickup and dropoff locations.
  /// If either location is missing, returns 0.
  double getPickupDropoffDistance() {
    final pickup = pickupLocation.value;
    final dropoff = dropoffLocation.value;
    if (pickup == null || dropoff == null) return 0.0;
    return getDistance(pickup, dropoff);
  }

  void setSelectionMode({required bool pickup}) {
    selectingPickup.value = pickup;
  }

  void onMapTap(LatLng position) {
    if (selectingPickup.value) {
      setPickupLocation(position);
    } else {
      setDropoffLocation(position);
    }
  }

  void setPickupLocation(LatLng position, {String? address}) {
    pickupLocation.value = position;
    if (address != null) pickupAddress.value = address;
    _refreshMapLayers();
  }

  void setDropoffLocation(LatLng position, {String? address}) {
    dropoffLocation.value = position;
    if (address != null) dropoffAddress.value = address;
    _refreshMapLayers();
  }

  void clearPickupDropoff() {
    pickupLocation.value = null;
    dropoffLocation.value = null;
    pickupAddress.value = null;
    dropoffAddress.value = null;
    markers.clear();
    polylines.clear();
  }

  void _refreshMapLayers() {
    _refreshMarkers();
    _refreshRoute();
    _fitCameraToMarkers();
  }

  void _refreshMarkers() {
    final newMarkers = <Marker>{};
    final pickup = pickupLocation.value;
    final dropoff = dropoffLocation.value;

    if (pickup != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickup,
          infoWindow: InfoWindow(
            title: 'Pickup',
            snippet: pickupAddress.value,
          ),
        ),
      );
    }

    if (dropoff != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('dropoff'),
          position: dropoff,
          infoWindow: InfoWindow(
            title: 'Dropoff',
            snippet: dropoffAddress.value,
          ),
        ),
      );
    }

    markers
      ..clear()
      ..addAll(newMarkers);
  }

  void _refreshRoute() {
    final pickup = pickupLocation.value;
    final dropoff = dropoffLocation.value;

    if (pickup == null) {
      polylines.clear();
      return;
    }

    final start = dropoff != null ? pickup : currentPosition.value;
    final end = dropoff ?? pickup;

    if (start != null) {
      polylines
        ..clear()
        ..add(
          Polyline(
            polylineId: const PolylineId('pickup_dropoff'),
            color: Colors.blue,
            width: 4,
            points: [start, end],
          ),
        );
      return;
    }

    polylines.clear();
  }

  void _fitCameraToMarkers() {
    final pickup = pickupLocation.value;
    final dropoff = dropoffLocation.value;
    if (_mapController == null) return;

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
      _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
      return;
    }

    final single = pickup ?? dropoff;
    if (single != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLng(single));
    }
  }

  Future<void> initLocation() async {
    final hasPermission = await _checkPermission();
    if (!hasPermission || isClosed) return;

    locationPermissionGranted.value = true;

    await _getCurrentLocation();

    await _positionSub?.cancel();
    _positionSub =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 5,
          ),
        ).listen((position) {
          currentPosition.value = LatLng(position.latitude, position.longitude);
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(currentPosition.value!),
          );
          if (pickupLocation.value != null && dropoffLocation.value == null) {
            _refreshRoute();
          }
        });
  }

  Future<void> stopLocationUpdates() async {
    await _positionSub?.cancel();
    _positionSub = null;
  }

  Future<bool> _checkPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    return permission != LocationPermission.deniedForever;
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      );

      currentPosition.value = LatLng(position.latitude, position.longitude);
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentPosition.value!, 15),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  double _degToRad(double degrees) => degrees * (pi / 180.0);
}

import 'dart:developer';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/network/google_map_helper/google_maps_consumer.dart';
import 'package:meka/features/loader/domain/entities/decoded_polyline.dart';
import 'package:meka/main.dart';
import 'package:meka/service_locator/service_locator.dart';
import 'loader_state.dart';
import 'package:location/location.dart' as location;

class LoaderBloc extends Cubit<LoaderState> {
  LoaderBloc() : super(LoaderState()) {
    getCurrentLocation();
  }

  void resetState() {
    emit(state.copyWith(distance: '0', polylines: {}, coordinate: null));
  }

  void clearPolylines() {
    emit(state.copyWith(polylines: {}));
  }

  final location.Location _location = location.Location();

  Future<void> getCurrentLocation() async {
    emit(state.copyWith(status: LoaderStatus.loading));

    try {
      // Check if location service is enabled
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          emit(state.copyWith(
            status: LoaderStatus.failure,
            errorMessage: 'Location services are disabled.',
          ));
          return;
        }
      }

      // Check for location permissions
      location.PermissionStatus permissionGranted =
          await _location.hasPermission();
      if (permissionGranted == location.PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != location.PermissionStatus.granted) {
          emit(state.copyWith(
            status: LoaderStatus.failure,
            errorMessage: 'Location permission denied.',
          ));
          return;
        }
      }

      // Fetch current location
      final locationData = await _location.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        emit(state.copyWith(
          status: LoaderStatus.failure,
          errorMessage: 'Failed to fetch location.',
        ));
        return;
      }

      final currentPosition =
          LatLng(locationData.latitude!, locationData.longitude!);

      emit(state.copyWith(
        currentPosition: currentPosition,
        status: LoaderStatus.success,
      ));

      log('Current location: ${currentPosition.latitude}, ${currentPosition.longitude}');
    } catch (e) {
      emit(state.copyWith(
        status: LoaderStatus.failure,
        errorMessage: 'Error getting location: $e',
      ));
      log('Error getting location: $e');
    }
  }

  Future<void> getDirection(String origin, String destination) async {
    emit(state.copyWith(
      status: LoaderStatus.loading,
      polylines: {},
    ));
    final result =
        await sl<GoogleMapsConsumer>().getDirections(origin, destination);
    result.fold((left) {
      emit(state.copyWith(
        status: LoaderStatus.failure,
        errorMessage: left.message,
        polylines: {},
      ));
      log('Failure: ${left.message}');
    }, (r) {
      final routes = r['routes'] as List;
      if (routes.isEmpty) {
        log('No routes found');
        emit(state.copyWith(
          polylines: {},
          status: LoaderStatus.failure,
          errorMessage: 'No routes available',
        ));
        navigatorKey.currentContext!.pop();
        navigatorKey.currentContext!.showErrorMessage('No routes available');
        return;
      }

      final polylinePoints = routes[0]['overview_polyline']?['points'];
      if (polylinePoints == null || polylinePoints.isEmpty) {
        log('Overview polyline points are missing or empty');
        emit(state.copyWith(
          polylines: {},
          status: LoaderStatus.failure,
          errorMessage: 'Invalid polyline data',
        ));
        return;
      }

      final decodedPoints = decodePolyline(polylinePoints);
      if (decodedPoints.isEmpty) {
        log('Failed to decode polyline points');
        emit(state.copyWith(
          status: LoaderStatus.failure,
          polylines: {},
          errorMessage: 'Polyline decoding failed',
        ));
        return;
      }

      final polylineCoordinates = decodedPoints
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      final polyline = Polyline(
        polylineId: const PolylineId('route'),
        points: polylineCoordinates,
        color: state.polylineColor ?? const Color(0xFF2196F3),
        width: 5,
      );

      emit(state.copyWith(
        status: LoaderStatus.success,
        polylines: {polyline},
      ));

      log('Polyline added with ${polylineCoordinates.length} points');
    });
  }

  Future<void> getCoordinates(String destination) async {
    emit(state.copyWith(
      status: LoaderStatus.loading,
      polylines: {},
    ));
    final result = await sl<GoogleMapsConsumer>().getCoordinates(destination);
    result.fold((left) {
      emit(state.copyWith(
          status: LoaderStatus.failure,
          errorMessage: left.message,
          polylines: {}));
      log('Failure');
    }, (r) async {
      if (r['results'].isEmpty) {
        emit(state.copyWith(
            errorMessage: 'اكتب عنوانا اخر',
            status: LoaderStatus.failure,
            polylines: {}));
        return;
      }
      final location = r['results'][0]['geometry']['location'];
      final latLng = LatLng(location['lat'], location['lng']);
      // Future.delayed(Duration(seconds: ))
      log('from cubit ${latLng.latitude},${latLng.longitude}');
      emit(state.copyWith(coordinate: latLng, status: LoaderStatus.ploylined));
      log('Success');
    });
  }

  Future<void> getDistance(
      double lat1, double lon1, double lat2, double lon2) async {
    final result = await sl<GoogleMapsConsumer>()
        .calculateDistance(lat1, lon1, lat2, lon2);
    emit(result.fold(
        (left) => state.copyWith(
            status: LoaderStatus.failure,
            distance: '0',
            polylines: {},
            errorMessage: left.message),
        (right) => state.copyWith(distance: right)));
  }
}

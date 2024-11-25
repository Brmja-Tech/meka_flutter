import 'dart:developer';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meka/core/network/google_map_helper/google_maps_helper.dart';
import 'package:meka/features/loader/domain/entities/decoded_polyline.dart';
import 'package:meka/service_locator/service_locator.dart';
import 'loader_state.dart';

class LoaderCubit extends Cubit<LoaderState> {
  LoaderCubit() : super(LoaderState());

  void resetState() {
    emit(state.copyWith(status: LoaderStatus.initial));
  }

  void getDirection(String origin, String destination) async {
    emit(state.copyWith(status: LoaderStatus.loading));
    final result =
        await sl<GoogleMapsHelper>().getDirections(origin, destination);
    result.fold((left) {
      emit(state.copyWith(
        status: LoaderStatus.failure,
        errorMessage: left.message,
      ));
      log('Failure: ${left.message}');
    }, (r) {
      final routes = r['routes'] as List;
      if (routes.isEmpty) {
        log('No routes found');
        emit(state.copyWith(
          status: LoaderStatus.failure,
          errorMessage: 'No routes available',
        ));
        return;
      }

      final polylinePoints = routes[0]['overview_polyline']?['points'];
      if (polylinePoints == null || polylinePoints.isEmpty) {
        log('Overview polyline points are missing or empty');
        emit(state.copyWith(
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
        polylines: {...state.polylines, polyline},
      ));

      log('Polyline added with ${polylineCoordinates.length} points');
    });

  }

  Future<void> getCoordinates(String destination) async {
    emit(state.copyWith(status: LoaderStatus.loading));
    final result = await sl<GoogleMapsHelper>().getCoordinates(destination);
    result.fold((left) {
      emit(state.copyWith(
          status: LoaderStatus.failure, errorMessage: left.message));
      log('Failure');
    }, (r) async {
      final location = r['results'][0]['geometry']['location'];
      final latLng = LatLng(location['lat'], location['lng']);
      // Future.delayed(Duration(seconds: ))
      log('from cubit ${latLng.latitude},${latLng.longitude}');
      emit(state.copyWith(status: LoaderStatus.ploylined, coordinate: latLng));
      log('Success');
    });
  }
}

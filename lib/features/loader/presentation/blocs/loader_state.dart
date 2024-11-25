import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';

enum LoaderStatus { initial, loading, success, failure,ploylined }

extension LoaderStatusX on LoaderState {
  bool get isInitial => status == LoaderStatus.initial;

  bool get isLoading => status == LoaderStatus.loading;

  bool get isSuccess => status == LoaderStatus.success;

  bool get isError => status == LoaderStatus.failure;
  bool get isBolyline => status == LoaderStatus.ploylined;
}


class LoaderState {
  final LoaderStatus status;
  final LatLng? coordinate;
  final Set<Polyline> polylines;
  final Color? polylineColor;
  final String? errorMessage;

  LoaderState({
    this.status = LoaderStatus.initial,
    this.coordinate,
    this.polylines = const {},
    this.polylineColor,
    this.errorMessage,
  });

  LoaderState copyWith({
    LoaderStatus? status,
    LatLng? coordinate,
    Set<Polyline>? polylines,
    Color? polylineColor,
    String? errorMessage,
  }) {
    return LoaderState(
      status: status ?? this.status,
      coordinate: coordinate ?? this.coordinate,
      polylines: polylines ?? this.polylines,
      polylineColor: polylineColor ?? this.polylineColor,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

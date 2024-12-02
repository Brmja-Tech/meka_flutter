import 'dart:math';

import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/network/http/either.dart';

abstract class GoogleMapsConsumer {
  Future<Either<Failure, Map<String, dynamic>>> getDirections(
      String origin, String destination);

  Future<Either<Failure, Map<String, dynamic>>> getCoordinates(String address);
  String calculateDistance(double lat1, double lon1, double lat2, double lon2);
}

class GoogleMapsConsumerImpl implements GoogleMapsConsumer {
  final ApiConsumer _apiConsumer;

  GoogleMapsConsumerImpl(this._apiConsumer);

  final String _apiKey = 'AIzaSyCcsdaGkuueZUcHIij1LTTX5IRuzXV90Bc';

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDirections(
      String origin, String destination) async {
    return await _apiConsumer.get(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$_apiKey');
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCoordinates(
      String address) async {
    return await _apiConsumer.get(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$_apiKey');
  }

  // Haversine formula to calculate distance between two coordinates
  @override
  String calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double radius = 6371000; // Earth radius in meters

    // Convert degrees to radians
    double lat1Rad = _degToRad(lat1);
    double lon1Rad = _degToRad(lon1);
    double lat2Rad = _degToRad(lat2);
    double lon2Rad = _degToRad(lon2);

    // Difference in coordinates
    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;
    // Haversine formula
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = radius * c/1000;
    return distance.toStringAsFixed(2);
  }

  double _degToRad(double degree) {
    return degree * (pi / 180);
  }
}

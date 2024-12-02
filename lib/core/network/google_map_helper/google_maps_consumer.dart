import 'dart:math';

import 'package:geocoding/geocoding.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/main.dart';

abstract class GoogleMapsConsumer {
  Future<Either<Failure, Map<String, dynamic>>> getDirections(
      String origin, String destination);

  Future<Either<Failure, Map<String, dynamic>>> getCoordinates(String address);

  Future<Either<Failure, String>> calculateDistance(
      double lat1, double lon1, double lat2, double lon2);
}

class GoogleMapsConsumerImpl implements GoogleMapsConsumer {
  final ApiConsumer _apiConsumer;

  GoogleMapsConsumerImpl(this._apiConsumer);

  final String _apiKey = 'AIzaSyCcsdaGkuueZUcHIij1LTTX5IRuzXV90Bc';

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDirections(
      String origin, String destination) async {
    try {
      final originCoords = origin.split(',');
      final destinationCoords = destination.split(',');
      final originLat = double.parse(originCoords[0]);
      final originLng = double.parse(originCoords[1]);
      final destinationLat = double.parse(destinationCoords[0]);
      final destinationLng = double.parse(destinationCoords[1]);
      final isValidOrigin = await _isLocationInEgypt(originLat, originLng);
      final isValidDestination =
          await _isLocationInEgypt(destinationLat, destinationLng);
      if (!isValidOrigin || !isValidDestination) {
        _showSnackBar(
            'Destination is outside Egypt. Please search within Egypt.');
        return Left(GoogleMapFailure(message: 'Invalid destination'));
      }
      return await _apiConsumer.get(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$_apiKey',
      );
    } catch (e) {
      return Left(GoogleMapFailure(
          message: 'Error parsing coordinates or validating location: $e'));
    }
  }

  Future<bool> _isLocationInEgypt(double latitude, double longitude) async {
    try {
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return placemarks.first.country == 'Egypt';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void _showSnackBar(String message) {
    // Assuming you have a global context (like a navigator key) or pass context
    final context = navigatorKey.currentContext!;
    context.showErrorMessage(message);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCoordinates(
      String address) async {
    return await _apiConsumer.get(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$_apiKey');
  }

  // Haversine formula to calculate distance between two coordinates
  @override
  Future<Either<Failure, String>> calculateDistance(
      double lat1, double lon1, double lat2, double lon2) async {
    try {
      if (!await _isLocationInEgypt(lat2, lat2)) {
        return Left(GoogleMapFailure(
            message: 'Distance cannot be calculated outside of Egypt'));
      }
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

      double distance = radius * c / 1000;
      return Right(distance.toStringAsFixed(2));
    } catch (e) {
      return Left(GoogleMapFailure(message: 'Error occurred on $e'));
    }
  }

  double _degToRad(double degree) {
    return degree * (pi / 180);
  }
}

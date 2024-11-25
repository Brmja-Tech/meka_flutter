import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/network/http/either.dart';

class GoogleMapsHelper {
  final ApiConsumer _apiConsumer;

  GoogleMapsHelper(this._apiConsumer);

  final String YOUR_API_KEY = 'AIzaSyCcsdaGkuueZUcHIij1LTTX5IRuzXV90Bc';

  Future<Either<Failure, Map<String,dynamic>>> getDirections(
      String origin, String destination) async {
    return await _apiConsumer.get(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$YOUR_API_KEY');
  }
  Future<Either<Failure, Map<String,dynamic>>> getCoordinates(String address) async {
    return  await _apiConsumer.get(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$YOUR_API_KEY',
      );}
}

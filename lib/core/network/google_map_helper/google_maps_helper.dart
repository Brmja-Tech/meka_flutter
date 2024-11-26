import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/network/http/either.dart';


abstract class GoogleMapsConsumer {
  Future<Either<Failure, Map<String, dynamic>>> getDirections(
      String origin, String destination);

  Future<Either<Failure, Map<String, dynamic>>> getCoordinates(String address);
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
  Future<Either<Failure, Map<String, dynamic>>> getCoordinates(String address) async {
    return await _apiConsumer.get(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$_apiKey');
  }
}

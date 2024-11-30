import 'package:meka/core/network/http/endpoints.dart';

sealed class PusherConsts{
  static const String PUSHER_APP_KEY = '95855f2765558883a556';
  static const String CLUSTER = 'mt1';
  static const String AUTH_URL = '${EndPoints.baseUrl}${EndPoints.login}';
}
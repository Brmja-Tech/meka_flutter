import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:meka/core/network/google_map_helper/google_maps_helper.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/network/http/endpoints.dart';
import 'package:meka/core/network/socket/pusher_consumer.dart';
import 'package:meka/service_locator/auth_service_locator.dart';
import 'package:meka/service_locator/loader_service_locator.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final sl = GetIt.instance;

class DI {
  static Future<void> init() async {
    sl.registerLazySingleton<ApiConsumer>(
      () => BaseApiConsumer(
        dio: sl(),
      ),
    );
    sl.registerLazySingleton(() => GoogleMapsConsumerImpl(sl()));
    sl.registerLazySingleton(() => PusherConsumerImpl(appKey: '95855f2765558883a556',cluster:'mt1'));
    // dio
    sl.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: EndPoints.baseUrl,
          connectTimeout: const Duration(seconds: 60),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      )..interceptors.addAll([
          if (kDebugMode)
            PrettyDioLogger(
              requestHeader: true,
              requestBody: true,
              responseBody: true,
              responseHeader: false,
              error: true,
              compact: true,
              maxWidth: 90,
            )
        ]),
    );

    await AuthServiceLocator.execute(sl: sl);
    await LoaderServiceLocator.execute(sl: sl);
  }
}

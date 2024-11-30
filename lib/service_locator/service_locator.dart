import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/network/cache_helper/cache_manager.dart';
import 'package:meka/core/network/google_map_helper/google_maps_helper.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/core/network/http/endpoints.dart';
import 'package:meka/core/network/socket/pusher_consts.dart';
import 'package:meka/core/network/socket/pusher_consumer.dart';
import 'package:meka/main.dart';
import 'package:meka/service_locator/auth_service_locator.dart';
import 'package:meka/service_locator/chat_service_loactor.dart';
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
    sl.registerLazySingleton<GoogleMapsConsumer>(
        () => GoogleMapsConsumerImpl(sl()));
    sl.registerFactory<PusherConsumer>(() =>
        PusherConsumerImpl(appKey: PusherConsts.PUSHER_APP_KEY, cluster: PusherConsts.CLUSTER));
    // dio
    final String token = await CacheManager.getAccessToken() ?? '';

    sl.registerLazySingleton<Dio>(
      ()  {
        return Dio(
          BaseOptions(
            baseUrl: EndPoints.baseUrl,
            connectTimeout: const Duration(seconds: 60),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Cache-Control': 'no-cache',
              'Pragma': 'no-cache',
              'Accept-Language':navigatorKey.currentContext!.isArabic?'ar':'en',
              'Authorization': 'Bearer $token',
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
          ]);
      },
    );

    await AuthServiceLocator.execute(sl: sl);
    await LoaderServiceLocator.execute(sl: sl);
    await ChatServiceLocator.execute(sl: sl);
  }
}

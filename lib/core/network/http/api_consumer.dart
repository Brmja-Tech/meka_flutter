import 'dart:convert';

import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/helper/functions.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:dio/dio.dart';
import 'package:meka/main.dart';

abstract final class ApiConsumer {
  Future<Either<Failure, Map<String, dynamic>>> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  });

  Future<Either<Failure, Map<String, dynamic>>> post(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Either<Failure, Map<String, dynamic>>> patch(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Either<Failure, Map<String, dynamic>>> put(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  Future<Either<Failure, Map<String, dynamic>>> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, Map<String, dynamic>>> downloadFile(
    String url,
    String savePath,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  );

  Future<Either<Failure, Map<String, dynamic>>> uploadFile(
    String url,
    FormData formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  );

  void addInterceptor(Interceptor interceptor);

  void removeAllInterceptors();

  void updateHeader(Map<String, dynamic> headers);
}

final class BaseApiConsumer implements ApiConsumer {
  final Dio _dio;

  BaseApiConsumer({required Dio dio}) : _dio = dio;

  @override
  Future<Either<Failure, Map<String, dynamic>>> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      loggerError(e.toString());
      final failure = _handleDioError(e);
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(
          message: 'An unexpected error occurred${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> patch(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response response = await _dio.patch(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      loggerError(e.toString());
      final failure = _handleDioError(e);
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(
          message: 'An unexpected error occurred${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> post(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response response = await _dio.post(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      loggerError(e.toString());
      final failure = _handleDioError(e);
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(
          message: 'An unexpected error occurred${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> put(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response response = await _dio.put(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      loggerError(e.toString());
      final failure = _handleDioError(e);
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(
          message: 'An unexpected error occurred${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response response = await _dio.delete(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );

      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      loggerError(e.toString());
      final failure = _handleDioError(e);
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure(
          message: 'An unexpected error occurred${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> downloadFile(
      String url,
      String savePath,
      ProgressCallback? onReceiveProgress,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken) async {
    try {
      Response response = await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      loggerError(e.toString());
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(
          message: 'An unexpected error occurred${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> uploadFile(
      String url,
      FormData formData,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress) async {
    try {
      Response response = await _dio.post(
        url,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      loggerError(e.toString());
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(
          message: 'An unexpected error occurred${e.toString()}'));
    }
  }

  @override
  void removeAllInterceptors() {
    _dio.options.headers.clear();
  }

  @override
  void updateHeader(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  @override
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        navigatorKey.currentContext!.showErrorMessage('تم الغاء الطلب ');
        return ServerFailure(message: 'تم إلغاء الطلب  ');
      case DioExceptionType.connectionTimeout:
        navigatorKey.currentContext!.showErrorMessage('انتهت مهلة الاتصال ');
        return ServerFailure(message: 'انتهت مهلة الاتصال ');
      case DioExceptionType.receiveTimeout:
        navigatorKey.currentContext!.showErrorMessage('انتهت مهلة الاتصال ');
        return ServerFailure(message: 'انتهت مهلة الاستقبال في الاتصال ');
      case DioExceptionType.sendTimeout:
        navigatorKey.currentContext!.showErrorMessage('انتهت مهلة الاتصال ');
        return ServerFailure(message: 'انتهت مهلة الإرسال في الاتصال ');
      case DioExceptionType.badResponse:
        if (error.response?.data != null) {
          try {
            final data = error.response!.data;
            final Map<String, dynamic> decoded =
                data is String ? json.decode(data) : data;

            if (decoded.containsKey('message')) {
              String message = decoded['message'];
              List<String> errors = decoded['errors'] != null
                  ? List<String>.from(decoded['errors'])
                  : [];
              loggerError(message);
              if (errors.isNotEmpty) {
                navigatorKey.currentContext!.showErrorMessage(errors[0]);

                return ValidationFailure(
                  message: message,
                  errors: errors,
                );
              }
              return ServerFailure(message: message);
            }
          } catch (e) {
            navigatorKey.currentContext!.showErrorMessage(e.toString());

            return ServerFailure(
                message:
                    'Received invalid status code: ${error.response?.statusCode}');
          }
        }
        navigatorKey.currentContext!.showErrorMessage(error.message!);

        return ServerFailure(
            message:
                'Received invalid status code: ${error.response?.statusCode}');
      case DioExceptionType.badCertificate:
        return ServerFailure(message: 'تعذر الاتصال ');
      case DioExceptionType.connectionError:
        navigatorKey.currentContext!.showErrorMessage('تعذر الاتصال ');

        return NetworkFailure(message: 'تعذر الاتصال ');
      case DioExceptionType.unknown:
      default:
        return UnknownFailure(message: 'Unexpected error: ${error.message}');
    }
  }
}
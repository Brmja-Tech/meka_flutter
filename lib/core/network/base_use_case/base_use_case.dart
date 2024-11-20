import 'package:equatable/equatable.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';

abstract class BaseUseCase<Type, Params> {
  const BaseUseCase();

  Future<Either<Failure, Type>> call(Params params);
}

abstract class NormalUseCase<Type, Params> {
  Type call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

class PaginationParams extends Equatable {
  final int page;
  final int limit;

  PaginationParams({this.limit = 30, required this.page}) {
    if (page < 1 || limit < 1) {
      throw Exception(
          'Invalid pagination params: page and limit must be greater than 0');
    }
  }

  Map<String, dynamic> toJson() => {
        'limit': limit,
        'page': page,
      };

  @override
  List<Object?> get props => [page, limit];
}

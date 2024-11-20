import 'package:get_it/get_it.dart';
import 'package:meka/features/auth/data/datasources/auth_data_source.dart';
import 'package:meka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:meka/features/auth/domain/repositories/auth_repository.dart';
import 'package:meka/features/auth/domain/usecases/login_use_case.dart';
import 'package:meka/features/auth/domain/usecases/logout_use_case.dart';
import 'package:meka/features/auth/domain/usecases/register_use_case.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_cubit.dart';

class AuthServiceLocator {
  Future<void> execute({required GetIt sl}) async {
    sl.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(sl()));
    sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
    sl.registerFactory(()=>RegisterUseCase(sl()));
    sl.registerFactory(()=>LoginUseCase(sl()));
    sl.registerFactory(()=>LogoutUseCase(sl()));
    sl.registerFactory(()=>AuthCubit(sl(),sl(),sl()));
  }
}

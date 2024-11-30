import 'package:get_it/get_it.dart';
import 'package:meka/features/auth/data/datasources/auth_data_source.dart';
import 'package:meka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:meka/features/auth/domain/repositories/auth_repository.dart';
import 'package:meka/features/auth/domain/usecases/apple_sign_in_use_case.dart';
import 'package:meka/features/auth/domain/usecases/facebook_sign_in_use_case.dart';
import 'package:meka/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:meka/features/auth/domain/usecases/get_user_profile_use_case.dart';
import 'package:meka/features/auth/domain/usecases/google_sign_in_use_case.dart';
import 'package:meka/features/auth/domain/usecases/login_use_case.dart';
import 'package:meka/features/auth/domain/usecases/logout_use_case.dart';
import 'package:meka/features/auth/domain/usecases/otp_verify_use_case.dart';
import 'package:meka/features/auth/domain/usecases/register_use_case.dart';
import 'package:meka/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:meka/features/auth/domain/usecases/send_otp_use_case.dart';
import 'package:meka/features/auth/domain/usecases/update_profile_use_case.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_cubit.dart';
import 'package:meka/features/auth/presentation/blocs/user/user_cubit.dart';

class AuthServiceLocator {
  static Future<void> execute({required GetIt sl}) async {
    // sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    // sl.registerLazySingleton(() => BaseFirebaseApiConsumer());
    sl.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(sl()));
    sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
    sl.registerFactory(() => RegisterUseCase(sl()));
    sl.registerFactory(() => LoginUseCase(sl()));
    sl.registerFactory(() => LogoutUseCase(sl()));
    sl.registerFactory(() => GoogleSignInUseCase(sl()));
    sl.registerFactory(() => FacebookSignInUseCase(sl()));
    sl.registerFactory(() => OtpVerifyUseCase(sl()));
    sl.registerFactory(() => ResetPasswordUseCase(sl()));
    sl.registerFactory(() => ForgotPasswordUseCase(sl()));
    sl.registerFactory(() => AppleSignInUseCase(sl()));
    sl.registerFactory(() => SendOTPUseCase(sl()));
    sl.registerFactory(() => GetProfileUseCase(sl()));
    sl.registerFactory(() => UpdateProfileUseCase(sl()));
    sl.registerFactory(() =>
        AuthBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
    sl.registerLazySingleton<UserBloc>(() => UserBloc(sl(), sl()));
  }
}

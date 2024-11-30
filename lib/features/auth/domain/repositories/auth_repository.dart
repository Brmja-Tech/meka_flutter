import 'package:meka/core/network/base_use_case/base_use_case.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';
import 'package:meka/features/auth/data/datasources/auth_data_source.dart';
import 'package:meka/features/auth/data/models/user_model.dart';
import 'package:meka/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> register(RegisterParams params);

  Future<Either<Failure, void>> oTPVerify(OTPVerifyParams params);

  Future<Either<Failure, void>> sendOTP(SendOTPParams params);

  Future<Either<Failure, UserModel>> login(LoginParams params);

  Future<Either<Failure, void>> googleLogin(SocialAuthParams params);

  Future<Either<Failure, void>> facebookLogin(SocialAuthParams params);

  Future<Either<Failure, void>> appleLogin(SocialAuthParams params);

  Future<Either<Failure, void>> forgetPassword(ForgetPasswordParams params);

  Future<Either<Failure, void>> resetPassword(ResetPasswordParams params);

  Future<Either<Failure, UserEntity>> getUserProfile(NoParams params);

  Future<Either<Failure, UserEntity>> updateProfile(RegisterParams params);

  Future<Either<Failure, void>> logout(NoParams params);
}

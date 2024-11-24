import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';

abstract final class FirebaseApiConsumer {
  Future<Either<Failure, User>> loginWithGoogle();

  Future<Either<Failure, User>> loginWithFacebook();

  Future<Either<Failure, User>> loginWithApple();
}

final class BaseFirebaseApiConsumer implements FirebaseApiConsumer {
  BaseFirebaseApiConsumer();

  @override
  Future<Either<Failure, User>> loginWithApple() {
    // TODO: implement loginWithApple
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> loginWithFacebook() async {

    log('llllllllllllllllllllllllllllllllllllllllllllll');
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    log('token is ${loginResult.accessToken!.tokenString}');
    log('message is ${loginResult.accessToken!.tokenString}');
    if (userCredential.user == null) {
      return Left(AuthFailure(message: 'Failed to sign in with Facebook'));
    } else {
      return Right(userCredential.user!);
    }
  }

  @override
  Future<Either<Failure, User>> loginWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Check if the user is null (i.e., the user canceled the sign-in)
      if (googleUser == null) {
        return Left(
            AuthFailure(message: 'Google sign-in was canceled by the user.'));
      }

      // Obtain the authentication details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase using the credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Return the signed-in user's credentials
      return Right(userCredential.user!);
    } catch (e) {
      return Left(AuthFailure(message: 'Failed to sign in with Google: $e'));
    }
  }
}

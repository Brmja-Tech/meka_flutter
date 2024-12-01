import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meka/core/network/failure/failure.dart';
import 'package:meka/core/network/http/either.dart';

abstract final class FirebaseApiConsumer {
  Future<Either<Failure, UserCredential>> loginWithGoogle();

  Future<Either<Failure, void>> googleSignOut();

  Future<Either<Failure, UserCredential>> loginWithFacebook();

  Future<Either<Failure, void>> facebookSignOut();

  Future<Either<Failure, UserCredential>> loginWithApple();

  Future<Either<Failure, void>> appleSignOut();
}

final class BaseFirebaseApiConsumer implements FirebaseApiConsumer {
  BaseFirebaseApiConsumer();

  @override
  Future<Either<Failure, UserCredential>> loginWithApple() {
    // TODO: implement loginWithApple
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserCredential>> loginWithFacebook() async {
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
      return Right(userCredential);
    }
  }

  @override
  Future<Either<Failure, UserCredential>> loginWithGoogle() async {
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
      return Right(userCredential);
    } catch (e) {
      return Left(AuthFailure(message: 'Failed to sign in with Google: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> appleSignOut() async {
    try {
      await GoogleSignIn().signOut();
      return Right(null);
    } catch (e) {
      return Left(AuthFailure(message: 'Failed to sign out with Google: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> facebookSignOut() async {
    try {
      await FacebookAuth.instance.logOut();
      return Right(null);
    } catch (e) {
      return Left(AuthFailure(message: 'Failed to sign out with Facebook: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> googleSignOut() async {
    try {
      await GoogleSignIn().signOut();
      return Right(null);
    } catch (e) {
      return Left(AuthFailure(message: 'Failed to sign out with Google: $e'));
    }
  }
}

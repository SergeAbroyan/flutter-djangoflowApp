import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:speakly/middleware/typedef/typedef.dart';

class FirebaseAuthRepositoryImplement {
  FirebaseAuthRepositoryImplement();

  static Future<UserCredential> signUp(
    String emailVal,
    String password,
  ) async {
    final result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: emailVal, password: password);

    return result;
  }

  static Future<UserCredential> signIn(
    String emailVal,
    String password,
  ) async {
    final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailVal,
      password: password,
    );

    return result;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> delete(
      {required AsyncCallbackList onEmailReauth,
      required ValueChanged<FirebaseAuthException> onException}) async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        final deleteSucceed = await _reauthenticateAndDelete(
            onEmailReauth: onEmailReauth, onException: onException);
        return deleteSucceed;
      }
      return false;
    }
  }

  Future<bool> _reauthenticateAndDelete(
      {required AsyncCallbackList onEmailReauth,
      required ValueChanged<FirebaseAuthException> onException}) async {
    final providerData = FirebaseAuth.instance.currentUser?.providerData.first;
    UserCredential? userCredential;
    try {
      if (providerData == null) {
        return false;
      }
      if (providerData.providerId == 'password') {
        final userInfo = await onEmailReauth.call();
        if (userInfo == null) {
          return false;
        }
        final email = userInfo[0]['email'];
        final password = userInfo[1]['password'];
        if (email != null && password != null) {
          final credential =
              EmailAuthProvider.credential(email: email, password: password);
          userCredential = await FirebaseAuth.instance.currentUser!
              .reauthenticateWithCredential(credential);
        }
      }
      if (AppleAuthProvider().providerId == providerData.providerId) {
        userCredential = await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      }
      if (GoogleAuthProvider().providerId == providerData.providerId) {
        userCredential = await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }
      if (userCredential != null) {
        await FirebaseAuth.instance.currentUser?.delete();
        return true;
      }
      return false;
    } on FirebaseAuthException catch (exception) {
      onException.call(exception);
      return false;
    }
  }

  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    final email = user?.email;
    if (email != null) {
      final credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      final userCredential =
          await user?.reauthenticateWithCredential(credential);
      if (userCredential != null) {
        await user?.updatePassword(newPassword);
      }
    }
  }

  static Future<UserCredential?> googleAuth() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return result;
    }
    return null;
  }

  static Future<UserCredential?> appleAuth() async {
    final appleProvider = AppleAuthProvider();

    final result =
        await FirebaseAuth.instance.signInWithProvider(appleProvider);

    return result;
  }

  static Future<UserCredential> anonymousAuth() async {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    return userCredential;
  }

  static Future<UserCredential?> linkGoogleAuth() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final linkedCredential =
            await _linkAccountWithAuthCredential(currentUser, credential);

        return linkedCredential;
      }
    }
    return null;
  }

  static Future<UserCredential?> linkAppleAuth() async {
    final appleProvider = AppleAuthProvider();

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final linkedCredential =
          await _linkAccountWithAuthProvider(currentUser, appleProvider);
      return linkedCredential;
    }
    return null;
  }

  static Future<UserCredential?> linkEmailAuth(
      String emailVal, String password) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final linkedCredential = await _linkAccountWithAuthCredential(currentUser,
          EmailAuthProvider.credential(email: emailVal, password: password));

      return linkedCredential;
    }
    return null;
  }

  Future<void> resetPasswordWithEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<UserCredential> _linkAccountWithAuthCredential(
      User currentUser, AuthCredential authCredential) async {
    final userCredential = await currentUser.linkWithCredential(authCredential);

    return userCredential;
  }

  static Future<UserCredential> _linkAccountWithAuthProvider(
      User currentUser, AuthProvider authProvider) async {
    final userCredential = await currentUser.linkWithProvider(authProvider);

    return userCredential;
  }
}

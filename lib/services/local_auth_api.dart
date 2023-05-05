import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/types/auth_messages_android.dart';
import 'package:local_auth_ios/types/auth_messages_ios.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate() async {
    // final isAvailable = await hasBiometrics();
    // if (!isAvailable) {
    //   return false;
    // }

    try {
      if (!await _canAuthenticate()) return false;

      return await _auth.authenticate(
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Sign In',
            cancelButton: 'No thanks',
          ),
          IOSAuthMessages(
            cancelButton: 'No thanks',
          )
        ],
        localizedReason: 'Use face id to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }
}

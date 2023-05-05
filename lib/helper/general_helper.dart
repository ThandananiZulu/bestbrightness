import '../services/local_auth_api.dart';

class GeneralHelper {
  static Future<bool> biometricAuth() {
    final authenticate = LocalAuth.authenticate();
    return authenticate;
  }
}

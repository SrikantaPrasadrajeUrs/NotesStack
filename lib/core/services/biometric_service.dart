import 'package:local_auth/local_auth.dart';

class BiometricService{
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    final isAvailable = await _auth.canCheckBiometrics;
    final isDeviceSupported = await _auth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  Future<bool> authenticateUser()async{
    if(await isBiometricAvailable()){
      return await _auth.authenticate(
          options: const AuthenticationOptions(
              biometricOnly: true,
              stickyAuth: true
          ),
          localizedReason: "Please authenticate to continue"
      );
    }
    return false;
  }
}
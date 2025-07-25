import 'package:demo/firebase_options.dart';
import 'package:demo/screens/home_screen.dart';
import 'package:demo/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseAuth.instance.useAuthEmulator("localhost", 9090);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Future<bool> isBiometricAvailable() async {
    final LocalAuthentication _auth = LocalAuthentication();
    final isAvailable = await _auth.canCheckBiometrics;
    final isDeviceSupported = await _auth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }
  print(await isBiometricAvailable());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: LoginScreen(),
    );
  }
}
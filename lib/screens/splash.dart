import 'package:demo/screens/home_screen.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_)=>Splash());
    super.initState();
  }

  void navigateToHome(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container());
  }
}

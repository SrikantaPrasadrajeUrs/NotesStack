import 'package:demo/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_)=>Future.delayed(const Duration(seconds: 3),()=>navigateToHome()));
    super.initState();
  }

  void navigateToHome(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
        backgroundColor: Color.fromRGBO(173, 155, 242, 1),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Notes Stack", style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.bold)),
            ClipRRect(
                borderRadius: BorderRadius.circular(height/6),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset("assets/images/notes.jpeg", fit: BoxFit.fill, height: height/2, width: width),
                )),
          ],
        ));
  }
}

import 'package:demo/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: Image.asset("assets/images/notes.jpeg", fit: BoxFit.fill, height: 360)),
              ),
              SizedBox(height: 20),
              Text("Notes Stack", style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text("Take notes anytime, stay organized everywhere. Your thoughts, saved and synced seamlessly.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ptSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)
              ),
              Spacer(
                flex: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  CustomButton(width: 170,onPressed: (){}, text: "Register", textStyle: GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), buttonBackgroundColor: Colors.indigoAccent),
                  CustomButton(width: 170,onPressed: (){}, text: "Sign in", textStyle: GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), buttonBackgroundColor: Colors.white, border: Border.all(color: Colors.indigoAccent, width: 1.5),)
                ],
              ),
              Spacer(),
            ],
          ),
        ));
  }
}

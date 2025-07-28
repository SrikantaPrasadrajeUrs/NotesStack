import 'package:demo/screens/login_screen.dart';
import 'package:demo/screens/register.dart';
import 'package:demo/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../repository/auth_repo.dart';

class Splash extends StatelessWidget {
  final AuthRepo authRepo;
  const Splash({super.key, required this.authRepo});

  void navigateToRegister(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Register(authRepo: authRepo)));
  }
  void navigateToLogin(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen(authRepo: authRepo)));
  }

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
                  CustomButton(width: 170,onPressed: ()=>navigateToRegister(context), text: "Register", textStyle: GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), buttonBackgroundColor: Colors.indigoAccent),
                  CustomButton(width: 170,onPressed: ()=>navigateToLogin(context), text: "Sign in", textStyle: GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), buttonBackgroundColor: Colors.white, border: Border.all(color: Colors.indigoAccent, width: 1.5),)
                ],
              ),
              Spacer(),
            ],
          ),
        ));
  }
}

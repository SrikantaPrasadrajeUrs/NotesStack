import 'package:demo/core/services/biometric_service.dart';
import 'package:demo/models/user_model.dart';
import 'package:demo/repository/auth_repo.dart';
import 'package:demo/screens/home_screen.dart';
import 'package:demo/screens/register.dart';
import 'package:demo/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  final String? email;
  final String? password;
  final AuthRepo authRepo;

  const LoginScreen({
    super.key,
    required this.authRepo,
    this.email,
    this.password,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool turns = false;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> formKey;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController(text: widget.password);
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void navigateToRegister()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Register(authRepo: widget.authRepo)));

  toggleEye() => setState(() => turns = !turns);

  String? validate(String? value, {String type = "password"}) {
    if(value==null||value.isEmpty) return "This field is required";
    if(type=="email"&&!value.contains("@")&&!value.contains(".")){
      return "Invalid email";
    }else if(type=="password"&&value.length<6){
      return "Password must be at least 6 characters";
    }
    return null;
  }

  void navigateToHome(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
  }

  void loginUser() async {
    if (!formKey.currentState!.validate()) return;
    UserModel? userData;

    if (userData != null) {
      if (!userData.isBioMetricEnabled) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Enable Biometric Authentication"),
              content: Text(
                "Would you like to enable biometric authentication for faster, more secure logins in the future?",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("No, Thanks"),
                ),
                TextButton(
                  onPressed: () async {
                    final isValid = await BiometricService().authenticateUser();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isValid
                              ? "Successfully authenticated"
                              : "Authentication failed",
                        ),
                      ),
                    );
                    if (isValid) {
                      navigateToHome();
                    }
                  },
                  child: Text("Enable"),
                ),
              ],
            );
          },
        ).whenComplete(()=>navigateToHome());
      } else {
        navigateToHome();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                "Log in",
                style: GoogleFonts.quicksand(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have a account?",
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: navigateToRegister,
                    child: Text(
                      "Sign up",
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigoAccent,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 70),
              TextFormField(
                controller: _emailController,
                validator: (value) => validate(value, type: "email"),
                decoration: InputDecoration(hintText: "Email address"),
                onFieldSubmitted: (_) => focusNode.requestFocus(),
              ),
              SizedBox(height: 20),
              TextFormField(
                focusNode: focusNode,
                controller: _passwordController,
                validator: (value) => validate(value, type: "password"),
                obscureText: turns,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: IconButton(
                    onPressed: toggleEye,
                    icon:
                        turns
                            ? Icon(Icons.visibility_off_outlined)
                            : Icon(Icons.visibility_outlined),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Recovery password",
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
              SizedBox(height: 30),
              CustomButton(
                width: MediaQuery.of(context).size.width,
                onPressed: loginUser,
                text: "Continue",
                textStyle: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                buttonBackgroundColor: Colors.yellow,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Divider()),
                  Text(
                    " Or continue with ",
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialButton(imagePath: "assets/images/google.png", onPressed: (){}),
                  SocialButton(imagePath: "assets/images/apple.png", onPressed: (){}),
                  SocialButton(imagePath: "assets/images/facebook.png", onPressed: (){})
                ],
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

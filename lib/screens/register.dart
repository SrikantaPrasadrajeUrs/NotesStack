import 'package:demo/repository/auth_repo.dart';
import 'package:demo/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  final AuthRepo authRepo;
  const Register({super.key, required this.authRepo});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool turns = false;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  toggleEye()=>setState(()=>turns=!turns);

  String? validate(String? value, {String type = "password"}) {
    if (value == null || value.isEmpty) {
      return 'Field is required';
    }
    if(type == "password" && value.length < 6){
      return "Password must be at least 6 characters";
    }
    if(type == "email" && !value.contains("@")){
      return "Invalid email";
    }
    return null;
  }

  void createAccount()async{
    if(!formKey.currentState!.validate()) return;
    await widget.authRepo.createUser(_emailController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:16.0),
        child: Form(
          key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Text("Create an account", style: GoogleFonts.quicksand(fontSize: 30, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style: GoogleFonts.quicksand(fontSize: 14, fontWeight: FontWeight.bold),),
                    TextButton(onPressed: (){}, child: Text("Sign in", style: GoogleFonts.quicksand(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.indigoAccent)))
                  ],
                ),
                SizedBox(height: 70,),
                TextFormField(
                  controller: _emailController,
                  validator: (value)=>validate(value, type: "email"),
                  decoration: InputDecoration(
                      hintText: "Email address",
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  validator: (value)=>validate(value, type: "password"),
                  obscureText: turns,
                  decoration: InputDecoration(
                      hintText: "Password",
                    suffixIcon: IconButton(onPressed: toggleEye, icon: turns?Icon(Icons.visibility_off_outlined):Icon(Icons.visibility_outlined))
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text("Recovery password", style: GoogleFonts.quicksand(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.end)],
                ),
                SizedBox(height: 30),
                CustomButton(width: MediaQuery.of(context).size.width, onPressed: createAccount, text: "Continue", textStyle: GoogleFonts.quicksand(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), buttonBackgroundColor: Colors.indigoAccent),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                      ),
                    ),
                    Text(" Or continue with ", style: GoogleFonts.quicksand(fontSize: 14, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Divider(
                      ),
                    )
                  ],
                ),
                Spacer(),
              ],
            )
        ),
      ),
    );
  }
}
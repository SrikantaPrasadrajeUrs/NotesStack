import 'dart:math';
import 'package:NotesStack/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/services/biometric_service.dart';
import '../core/services/secure_storage_service.dart';
import '../repository/auth_repo.dart';
import '../repository/user_repo.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final AuthRepo authRepo;
  const WelcomeScreen({super.key, required this.authRepo});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  final SecureStorageService _secureStorageService = SecureStorageService();
  final UserRepo _userRepo = UserRepo();
  final BiometricService _biometricService = BiometricService();
  late AnimationController _animationController,
      _buttonAnimationController,
      _opacityAnimationController;
  late Animation<Offset> _imageSlideAnimation;
  late Animation<Offset> _buttonSlideAnimation;
  final double finalAngle = 3.115575554029089;

  void navigateToHome() => _secureStorageService.getUserId().then(
    (id) => Future.delayed(Duration(seconds: 2), () async {
      // print(id);
      if (id != null) {
        final userData = await _userRepo.getUserData(uid: id);
        // print(userData);
        if(userData.isBioMetricEnabled) {
         await _biometricService.authenticateUser().then((isValid) {
            if (isValid) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(userData: userData),
                ),
              );
            }
          });
        }else{
          navigateToLogin(context);
        }
      }
    }),
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _imageSlideAnimation = Tween<Offset>(
      begin: Offset(1.5, 0),
      end: Offset(0, 0),
    ).animate(_animationController);
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _opacityAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _buttonSlideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(2.5, 0),
    ).animate(_buttonAnimationController);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward().then(
        (_) =>
            _opacityAnimationController.forward().then((_) => navigateToHome()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _buttonAnimationController.dispose();
    _opacityAnimationController.dispose();
    super.dispose();
  }

  void navigateToRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => Register(
              authRepo: widget.authRepo,
              secureStorageService: _secureStorageService,
              biometricService: _biometricService,
            ),
      ),
    );
  }

  void navigateToLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => LoginScreen(
              authRepo: widget.authRepo,
              secureStorageService: _secureStorageService,
              biometricService: _biometricService,
            ),
      ),
    );
  }

  void forwardOrReverseArrow() {
    if (_buttonAnimationController.isCompleted) {
      _buttonAnimationController.reverse();
    } else {
      _buttonAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return SlideTransition(
                    position: _imageSlideAnimation,
                    child: Transform.rotate(
                      angle: _animationController.value * -pi,
                      child: Transform.rotate(
                        angle: finalAngle,
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(180),
                              border: Border.all(
                                color: Colors.yellow.shade300,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.yellow.shade100,
                                  blurRadius: 9,
                                  spreadRadius: 6,
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 9,
                                  spreadRadius: 6,
                                  offset: Offset(3, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(180),
                              child: Image.asset(
                                "assets/images/welcome_image.jpg",
                                fit: BoxFit.fill,
                                height: 300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: _opacityAnimationController,
                  builder: (context, _) {
                    return AnimatedOpacity(
                      opacity: _opacityAnimationController.value,
                      duration: const Duration(seconds: 1),
                      child: Column(
                        children: [
                          Spacer(),
                          Text(
                            "Everything you need to say just to yourself..",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.arima(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "People can be clever as high as sky, but as long as they don't write, they will be lost in society and from history",
                              style: GoogleFonts.arima(
                                color: Colors.grey.shade600,
                                letterSpacing: 1,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Spacer(flex: 3),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _buttonAnimationController,
                                builder: (context, _) {
                                  return AnimatedOpacity(
                                    duration: const Duration(milliseconds: 500),
                                    opacity: _buttonAnimationController.value,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      spacing: 20,
                                      children: [
                                        CustomButton(
                                          width: 170,
                                          onPressed:
                                              () => navigateToRegister(context),
                                          text: "Register",
                                          textStyle: GoogleFonts.arima(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                          buttonBackgroundColor: Colors.yellow,
                                        ),
                                        CustomButton(
                                          width: 170,
                                          onPressed:
                                              () => navigateToLogin(context),
                                          text: "Sign in",
                                          textStyle: GoogleFonts.arima(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                          buttonBackgroundColor: Colors.white,
                                          border: Border.all(
                                            color: Colors.yellow,
                                            width: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Center(
                                child: SlideTransition(
                                  position: _buttonSlideAnimation,
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.yellow,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.1,
                                          ),
                                          blurRadius: 3,
                                          spreadRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      onPressed: forwardOrReverseArrow,
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

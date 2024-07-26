import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/views/auth/login_screen.dart';
import 'package:mender/views/auth/verify_email_screen.dart';
import 'package:mender/views/splash/splash_screen.dart';

class SplashService extends StatefulWidget {
  const SplashService({super.key});

  @override
  State<SplashService> createState() => _SplashServiceState();
}

class _SplashServiceState extends State<SplashService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themewhitecolor,
      // body: FirebaseAuth.instance.currentUser == null
      //             ? const LoginScreen()
      //             : const SplashScreen(),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const VerifyEmailScreen();
            } else {
              return FirebaseAuth.instance.currentUser == null
                  ? const LoginScreen()
                  : const SplashScreen();
            }
          },
        ),
      ),
    );
  }
}

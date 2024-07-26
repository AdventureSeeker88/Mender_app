import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mender/route/go_router.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/utils/path.dart';
import 'package:mender/views/splash/splash_screen.dart';
import 'package:mender/widgets/toast.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification().then((value) {
        customToast("Email resent successfulyy", context);
      });
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Catch Exception: $e");
      }
    }
  }

  int emailSendCount = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return isEmailVerified
        ? const SplashScreen()
        : WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              backgroundColor: themelightgreencolor,
              body: SafeArea(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/png/mender-screen-background.png"),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: Palette.themecolor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Verify Email",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: themewhitecolor,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  FirebaseAuth.instance.signOut();
                                  context.pushNamed(
                                    Routes.splash,
                                  );
                                },
                                child: const Icon(
                                  Icons.logout,
                                  color: themewhitecolor,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Divider(color: Palette.themecolor,),
                      const Spacer(),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "A Verification email has been sent to your email.",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Palette.themecolor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: themewhitecolor,
                                      minimumSize: const Size.fromHeight(40),
                                      elevation: 5),
                                  onPressed: () {
                                    if (emailSendCount < 3) {
                                      sendVerificationEmail();
                                      setState(() {
                                        emailSendCount += 1;
                                      });
                                    } else {
                                      customToast(
                                          "Unable to send, you've reached the resent limit",
                                          context);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.email,
                                    size: 28,
                                    color: themegreencolor,
                                  ),
                                  label: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Resent Email".toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: themegreencolor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                           emailSendCount >= 3?   const Text(
                                "You have exeed your daily limit to receive Verification email, please try again after 24 hours.",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Palette.themecolor,
                                ),
                                textAlign: TextAlign.center,
                              ): SizedBox(),

                           
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

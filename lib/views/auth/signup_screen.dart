import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mender/provider/auth_pro.dart';
import 'package:mender/route/go_router.dart';
import 'package:mender/route/navigator.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/widgets/custom_icon_button.dart';
import 'package:mender/widgets/custom_simple_rounded_button.dart';
import 'package:mender/widgets/toast.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool visiblePass = true;
  bool visibleConfirmPass = true;
  bool value = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameC = TextEditingController();
  final TextEditingController aboutMeC = TextEditingController();
  final TextEditingController bioC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController confirmPasswordC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // background
            Image.asset(
              "assets/images/png/mender-screen-background.png",
              fit: BoxFit.cover,
              width: size.width,
            ),
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/png/mender-logo.png",
                        // height: 100,
                        // width: 100,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 32,
                          color: Palette.themecolor,
                          fontWeight: FontWeight.bold,
                          fontFamily: "dripping",
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 30,
                          left: 30,
                          right: 30,
                          bottom: 5,
                        ),
                        child: Text(
                          "You are just one step away from being part of this family",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themegreytextcolor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Text(
                        "Love conquers all",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themegreytextcolor,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 40,
                          horizontal: 25,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // user name
                              TextFormField(
                                controller: userNameC,
                                decoration: InputDecoration(
                                  hintText: "User Name",
                                  hintStyle: const TextStyle(
                                    color: themegreytextcolor,
                                  ),
                                  // filled: true,
                                  // fillColor: themegreycolor.withOpacity(0.4),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: themegreytextcolor,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: themegreytextcolor,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Username is empty";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              // user name
                              TextFormField(
                                controller: bioC,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  hintText: "Your Bio",
                                  hintStyle: const TextStyle(
                                    color: themegreytextcolor,
                                  ),
                                  // filled: true,
                                  // fillColor: themegreycolor.withOpacity(0.4)
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: themegreytextcolor,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: themegreytextcolor,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Bio is empty";
                                  }
                                  return null;
                                },
                              ),
                               const SizedBox(
                                height: 25,
                              ),
                              // user name
                              TextFormField(
                                controller: aboutMeC,
                                keyboardType: TextInputType.name,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: "Details About yourself",
                                  hintStyle: const TextStyle(
                                    color: themegreytextcolor,
                                  ),
                                
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: themegreytextcolor,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: themegreytextcolor,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Doctor details is empty";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              // your email
                              TextFormField(
                                controller: emailC,
                                decoration: InputDecoration(
                                  hintText: "Your Email",
                                  hintStyle: const TextStyle(
                                    color: themegreytextcolor,
                                  ),
                                  // filled: true,
                                  // fillColor: themegreycolor.withOpacity(0.4),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: themegreytextcolor,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: themegreytextcolor,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Email is empty";
                                  }
                                  if (!RegExp(
                                          "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                      .hasMatch(value)) {
                                    return ("Please Enter a valid email");
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              // password
                              TextFormField(
                                controller: passwordC,
                                obscureText: visiblePass,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: const TextStyle(
                                    color: themegreytextcolor,
                                  ),
                                  // filled: true,
                                  // fillColor: themegreycolor.withOpacity(0.4),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: themegreytextcolor,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: themegreytextcolor,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  suffixIcon: CustomIconButton(
                                    onTap: () {
                                      if (visiblePass == true) {
                                        setState(() {
                                          visiblePass = false;
                                        });
                                      } else if (visiblePass == false) {
                                        setState(() {
                                          visiblePass = true;
                                        });
                                      }
                                    },
                                    child: Icon(
                                      visiblePass == false
                                          ? Icons.remove_red_eye
                                          : Icons.remove_red_eye_outlined,
                                      color: themegreytextcolor,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Password is empty";
                                  } else if (value.length < 6) {
                                    return "Enter At Least 6 Characters";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              // confirm password
                              TextFormField(
                                controller: confirmPasswordC,
                                obscureText: visibleConfirmPass,
                                decoration: InputDecoration(
                                  hintText: "Confirm Password",
                                  hintStyle: const TextStyle(
                                    color: themegreytextcolor,
                                  ),
                                  // filled: true,
                                  // fillColor: themegreycolor.withOpacity(0.4),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: themegreytextcolor,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: themegreytextcolor,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  suffixIcon: CustomIconButton(
                                    onTap: () {
                                      if (visibleConfirmPass == true) {
                                        setState(() {
                                          visibleConfirmPass = false;
                                        });
                                      } else if (visibleConfirmPass == false) {
                                        setState(() {
                                          visibleConfirmPass = true;
                                        });
                                      }
                                    },
                                    child: Icon(
                                      visibleConfirmPass == false
                                          ? Icons.remove_red_eye
                                          : Icons.remove_red_eye_outlined,
                                      color: themegreytextcolor,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Password is empty";
                                  } else if (value.length < 6) {
                                    return "Enter At Least 6 Characters";
                                  } else if (value != passwordC.text) {
                                    return "Confirm password doesn't match";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              CheckboxListTile(
                                value: value,
                                contentPadding: EdgeInsets.zero,
                                activeColor: Palette.themecolor,
                                title: const Text(
                                  "I accept the terms and privacy policy",
                                  style: TextStyle(
                                    color: themegreytextcolor,
                                    fontSize: 18,
                                  ),
                                ),
                                checkboxShape: const CircleBorder(),
                                side: const BorderSide(
                                  color: themegreytextcolor,
                                  width: 2,
                                ),
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    value = newValue!;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: themewhitecolor,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: themegreycolor,
                                      blurRadius: 10,
                                      offset: Offset(5, 10),
                                    ),
                                  ],
                                ),
                                child: CustomSimpleRoundedButton(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (value != true) {
                                        customToast(
                                            "Please Select Privacy policy to continue!",
                                            context);
                                      } else {
                                        final post = Provider.of<AuthPro>(
                                            context,
                                            listen: false);

                                        post.signupFun(
                                            userNameC.text,
                                            aboutMeC.text,
                                            emailC.text,
                                            passwordC.text,
                                            bioC.text,
                                            context);
                                      }
                                    }
                                  },
                                  height: 60,
                                  width: size.width,
                                  buttoncolor: Palette.themecolor,
                                  borderRadius: BorderRadius.circular(30),
                                  child: const Text(
                                    "Create Account",
                                    style: TextStyle(
                                      color: themewhitecolor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Text.rich(
                                TextSpan(
                                  text: "Already have an account? ",
                                  style: const TextStyle(
                                    color: themegreytextcolor,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Go.named(
                                            context,
                                            Routes.login,
                                          );
                                        },
                                      text: "Login",
                                      style: const TextStyle(
                                        color: Palette.themecolor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

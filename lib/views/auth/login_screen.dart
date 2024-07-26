import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mender/provider/auth_pro.dart';
import 'package:mender/route/go_router.dart';
import 'package:mender/route/navigator.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/widgets/custom_simple_rounded_button.dart';
import 'package:mender/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  List<String> suggestons = [
    "USA",
    "UK",
    "Uganda",
    "Uruguay",
    "United Arab Emirates"
  ];
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
              // height: size.height,
            ),
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/png/mender-logo.png",
                        // height: 100,
                        // width: 100,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        "assets/images/png/welcome-menders.png",
                        // height: 100,
                        // width: 100,
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
                              // email
                              TextFormField(
                                controller: emailC,
                                decoration: InputDecoration(
                                  hintText: "Email",
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
                                obscureText: true,
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
                                height: 15,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: CustomTextButton(
                                  buttonText: "Forgot Password?",
                                  onTap: () {
                                       Go.named(context, Routes.forgotPassword);
                                  },
                                  textstyle: const TextStyle(
                                    color: themegreytextcolor,
                                  ),
                                ),
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
                                      Provider.of<AuthPro>(context,
                                              listen: false)
                                          .loginFun(emailC.text, passwordC.text,
                                              context);
                                    }
                                  },
                                  height: 60,
                                  width: size.width,
                                  buttoncolor: Palette.themecolor,
                                  borderRadius: BorderRadius.circular(30),
                                  child: const Text(
                                    "Login",
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width / 100 * 28,
                                    child: const Divider(
                                      color: Palette.themecolor,
                                    ),
                                  ),
                                  const Text(
                                    "or sign up with",
                                    style: TextStyle(
                                      color: themegreytextcolor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width / 100 * 28,
                                    child: const Divider(
                                      color: Palette.themecolor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 35,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(
                                  3,
                                  (index) => GestureDetector(
                                    onTap: (){

                                      
                                      if(index == 0){
                                      Provider.of<AuthPro>(context,
                                      listen: false).signinWithGoogle(context);
                                      }
                                    },
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: themewhitecolor,
                                      child: SvgPicture.asset(
                                        index == 0
                                            ? "assets/images/svg/google.svg"
                                            : index == 1
                                                ? "assets/images/svg/facebook.svg"
                                                : "assets/images/svg/apple.svg",
                                        height: index == 1
                                            ? 30
                                            : index == 2
                                                ? 30
                                                : 25,
                                        width: 30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Text.rich(
                                TextSpan(
                                  text: "Not registered yet? ",
                                  style: const TextStyle(
                                    color: themegreytextcolor,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                         

                                         Go.named(context, Routes.signup);
                                        },
                                      text: "Create Account",
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

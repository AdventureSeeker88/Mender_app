import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mender/provider/auth_pro.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/widgets/custom_icon_button.dart';
import 'package:mender/widgets/custom_simple_rounded_button.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();
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
                    padding: const EdgeInsets.only(
                      top: 30,
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: CustomIconButton(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.close,
                                color: themewhitecolor,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          "Forgot Password",
                          style: TextStyle(
                            fontSize: 40,
                            color: themewhitecolor,
                            fontWeight: FontWeight.bold,
                            fontFamily: "dripping",
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 30,
                            right: 30,
                            bottom: 5,
                          ),
                          child: Text(
                            "Oops, It happens to the best of us, Input your address to fix the issue",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: themegreycolor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
                                // email
                                TextFormField(
                                  controller: emailC,
                                 decoration: InputDecoration(
                                  hintText: "Email",
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
                    final authProvider =
                        Provider.of<AuthPro>(context, listen: false);

                    authProvider.forgotPassword(emailC.text, context);
                  }
                                  },
                                  height: 60,
                                  width: size.width,
                                  buttoncolor: Palette.themecolor,
                                  borderRadius: BorderRadius.circular(30),
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(
                                      color: themewhitecolor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
          )),
    );
  }
}

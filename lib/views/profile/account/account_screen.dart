import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mender/helper/pick_image.dart';
import 'package:mender/model/auth_model.dart';
import 'package:mender/provider/auth_pro.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/widgets/custom_icon_button.dart';
import 'package:mender/widgets/custom_simple_rounded_button.dart';
import 'package:mender/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool changePass = true;
  bool confirmChangePass = true;


  Uint8List? selectImageV;
  Future selectImage() async {
    try {
      Uint8List file;
      file = await pickImage(ImageSource.gallery);

      selectImageV = file;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameC = TextEditingController();
  final TextEditingController aboutMeC = TextEditingController();
  final TextEditingController bioC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _model_auth = Provider.of<AuthPro>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: themelightgreencolor,
      // bottomNavigationBar: Padding(
      //     padding: const EdgeInsets.all(12.0),
          // child: Consumer<AuthPro>(builder: ((context, value, child) {
          //   return CustomSimpleRoundedButton(
          //     onTap: () {
          //       if (_formKey.currentState!.validate()) {
          //         final authProvider =
          //             Provider.of<AuthPro>(context, listen: false);
          //         authProvider.profileUpdateFunc(
          //             usernameC.text,
          //             bioC.text,
          //             aboutMeC.text,
          //             selectImageV,
          //             FirebaseAuth.instance.currentUser!.uid,
          //             context);
          //       }
          //     },
          //     height: 50,
          //     width: size.width,
          //     buttoncolor: Palette.themecolor,
          //     borderRadius: BorderRadius.circular(30),
          //     child: const Text(
          //       "Done",
          //       style: TextStyle(
          //         color: themewhitecolor,
          //         fontSize: 16,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   );
          // }))),
      body: SafeArea(
        child: 
        StreamBuilder<AuthM>(
            stream: filter_user_detail(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong! ${snapshot.error}');
              } else if (snapshot.hasData) {
                final userData = snapshot.data!;
                usernameC.text = userData.name;
                bioC.text = userData.bio;
                aboutMeC.text = userData.aboutDoctor;
                return userData.email.isEmpty
                    ? Expanded(
                        child: Center(
                            child: Image.asset(
                          "assets/images/png/mender-circular-logo.png",
                        )),
                      )
                    : Column(
                        children: [
                          //top change password
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: CustomIconButton(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(
                                      Icons.arrow_back_ios,
                                      color: themewhitecolor,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Account",
                                    style: TextStyle(
                                      color: themewhitecolor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              
                              ],
                            ),
                          ),

                          //body
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      selectImageV == null
                                          ? (userData.image == "")
                                              ? const CircleAvatar(
                                                  radius: 50,
                                                  backgroundColor:
                                                      themeyellowcolor,
                                                  backgroundImage: NetworkImage(
                                                    "https://img.freepik.com/free-vector/cute-rabbit-holding-carrot-cartoon-vector-icon-illustration-animal-nature-icon-isolated-flat_138676-7315.jpg?w=2000",
                                                  ))
                                              : CircleAvatar(
                                                  radius: 50,
                                                  backgroundColor:
                                                      themeyellowcolor,
                                                  backgroundImage: NetworkImage(
                                                    userData.image,
                                                  ))
                                          : CircleAvatar(
                                              radius: 50,
                                              backgroundColor: themeyellowcolor,
                                              backgroundImage:
                                                  MemoryImage(selectImageV!)),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        userData.name,
                                        style: TextStyle(
                                          color: themewhitecolor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextButton(
                                        buttonText: "Edit",
                                        onTap: () {
                                          selectImage();
                                        },
                                        textstyle: const TextStyle(
                                          color: themewhitecolor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      TextFormField(
                                        controller: usernameC,
                                        style: const TextStyle(
                                          color: themewhitecolor,
                                        ),
                                        decoration: InputDecoration(
                                                                          hintText: "User Name",

                                          hintStyle: const TextStyle(
                                            color: themegreycolor,
                                          ),
                                          filled: true,
                                          fillColor:
                                              themegreycolor.withOpacity(0.4),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: themewhitecolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: themewhitecolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(12),
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
                                      TextFormField(
                                        controller: bioC,
                                        keyboardType: TextInputType.name,
                                         style: const TextStyle(
                                          color: themewhitecolor,
                                        ),
                                        decoration: InputDecoration(
                                         hintText: "Your Bio",
                                          hintStyle: const TextStyle(
                                            color: themegreycolor,
                                          ),
                                          filled: true,
                                          fillColor:
                                              themegreycolor.withOpacity(0.4),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: themewhitecolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: themewhitecolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(12),
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
                                      TextFormField(
                                        controller: aboutMeC,
                                        keyboardType: TextInputType.name,
                                        maxLines: 3,
                                       style: const TextStyle(
                                          color: themewhitecolor,
                                        ),
                                        decoration: InputDecoration(
                                           hintText: "Details About yourself",
                                          hintStyle: const TextStyle(
                                            color: themegreycolor,
                                          ),
                                          filled: true,
                                          fillColor:
                                              themegreycolor.withOpacity(0.4),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: themewhitecolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: themewhitecolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(12),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Doctor details is empty";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
              } else {
                return Container();
              }
            }),
     
     
      ),
    );
  }

  //doctor detail filer stream
  Stream<AuthM> filter_user_detail(String user_id) {
    return FirebaseFirestore.instance
        .collection('auth')
        .doc(user_id)
        .snapshots()
        .map((snapshot) => AuthM.fromJson(snapshot.data() ?? {}));
  }
}

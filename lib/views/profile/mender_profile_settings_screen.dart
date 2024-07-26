import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mender/model/auth_model.dart';
import 'package:mender/provider/auth_pro.dart';
import 'package:mender/route/go_router.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/widgets/custom_icon_button.dart';
import 'package:mender/widgets/custom_simple_rounded_button.dart';
import 'package:mender/widgets/custom_text_button.dart';
import 'package:mender/widgets/dailog.dart';
import 'package:provider/provider.dart';

import '../../helper/pick_image.dart';

class MenderProfileSettingScreen extends StatefulWidget {
  const MenderProfileSettingScreen({Key? key}) : super(key: key);

  @override
  State<MenderProfileSettingScreen> createState() =>
      _MenderProfileSettingScreenState();
}

class _MenderProfileSettingScreenState
    extends State<MenderProfileSettingScreen> {
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

  //license
  Uint8List? selectLicense;
  Future pickLicense() async {
    try {
      Uint8List file;
      file = await pickImage(ImageSource.gallery);

      selectLicense = file;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameC = TextEditingController();
  final TextEditingController aboutMeC = TextEditingController();
  final TextEditingController bioC = TextEditingController();

  //password
  final passwordFormKey = GlobalKey<FormState>();

  final TextEditingController oldPasswordC = TextEditingController();
  final TextEditingController newPasswordC = TextEditingController();
  final TextEditingController confirmPasswordC = TextEditingController();
  bool oldPass = true;
  bool changePass = true;
  bool confirmChangePass = true;
  @override
  Widget build(BuildContext context) {
    final _model_auth = Provider.of<AuthPro>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: themewhitecolor,
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Consumer<AuthPro>(builder: ((context, value, child) {
            return CustomSimpleRoundedButton(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  final authProvider =
                      Provider.of<AuthPro>(context, listen: false);
                  authProvider.profileUpdateFunc(
                      usernameC.text,
                      bioC.text,
                      aboutMeC.text,
                      selectImageV,
                      selectLicense,
                      FirebaseAuth.instance.currentUser!.uid,
                      context);
                }
              },
              height: 50,
              width: size.width,
              buttoncolor: Palette.themecolor,
              borderRadius: BorderRadius.circular(30),
              child: const Text(
                "Done",
                style: TextStyle(
                  color: themewhitecolor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }))),
      body: SafeArea(
        child: StreamBuilder<AuthM>(
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
                                      color: themegreytextcolor,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Account",
                                    style: TextStyle(
                                      color: themegreytextcolor,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            selectImageV == null
                                                ? (userData.image == "")
                                                    ? const CircleAvatar(
                                                        radius: 50,
                                                        backgroundColor:
                                                            themeyellowcolor,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          "https://img.freepik.com/free-vector/cute-rabbit-holding-carrot-cartoon-vector-icon-illustration-animal-nature-icon-isolated-flat_138676-7315.jpg?w=2000",
                                                        ))
                                                    : CircleAvatar(
                                                        radius: 50,
                                                        backgroundColor:
                                                            themeyellowcolor,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          userData.image,
                                                        ))
                                                : CircleAvatar(
                                                    radius: 50,
                                                    backgroundColor:
                                                        themeyellowcolor,
                                                    backgroundImage:
                                                        MemoryImage(
                                                            selectImageV!)),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              userData.name,
                                              style: TextStyle(
                                                color: themegreytextcolor,
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
                                                color: themegreytextcolor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, bottom: 5),
                                        child: Text(
                                          "Username",
                                          style: TextStyle(
                                              color: themegreytextcolor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: usernameC,
                                        decoration: InputDecoration(
                                          hintText: "User Name",
                                          hintStyle: const TextStyle(
                                            color: themegreycolor,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: themegreytextcolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: themegreytextcolor,
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
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, bottom: 5),
                                        child: Text(
                                          "Bio",
                                          style: TextStyle(
                                              color: themegreytextcolor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: bioC,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          hintText: "Your Bio",
                                          hintStyle: const TextStyle(
                                            color: themegreycolor,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: themegreytextcolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: themegreytextcolor,
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
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, bottom: 5),
                                        child: Text(
                                          "About Me",
                                          style: TextStyle(
                                              color: themegreytextcolor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: aboutMeC,
                                        keyboardType: TextInputType.name,
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                          hintText: "Details About yourself",
                                          hintStyle: const TextStyle(
                                            color: themegreycolor,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: themegreytextcolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: themegreytextcolor,
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
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, bottom: 5),
                                        child: Text(
                                          "Password",
                                          style: TextStyle(
                                              color: themegreytextcolor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      TextFormField(
                                        autofocus: false,
                                        keyboardType: TextInputType.none,
                                        textInputAction: TextInputAction.next,
                                        readOnly: true,
                                        onTap: () {
                                          changePasswordDialog(context, size);
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          hintStyle: const TextStyle(
                                            color: themegreytextcolor,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: themegreytextcolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: themegreytextcolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          suffixIcon: Icon(
                                            Icons.edit,
                                            color: themegreytextcolor,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(12),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, bottom: 5),
                                        child: Text(
                                          "Upload License",
                                          style: TextStyle(
                                              color: themegreytextcolor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      TextFormField(
                                        autofocus: false,
                                        keyboardType: TextInputType.none,
                                        textInputAction: TextInputAction.next,
                                        readOnly: true,
                                        onTap: () {
                                          pickLicense();
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.upload_file_outlined,
                                            color: Palette.themecolor,
                                          ),
                                          hintText: selectLicense == null
                                              ? (userData.license == "")
                                                  ? "Drag and Drop Here"
                                                  : "Update License"
                                              : "Upload License",
                                          hintStyle: const TextStyle(
                                              color: Palette.themecolor,
                                              fontWeight: FontWeight.bold),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: themegreytextcolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: themegreytextcolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(12),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text(
                                          "Supported formates: JPEG, PNG, GIF",
                                          style: TextStyle(
                                            color: themegreytextcolor,
                                            fontSize: 14,
                                          ),
                                        ),
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

  Future<Object?> changePasswordDialog(BuildContext context, Size size) {
    return showAnimatedDialog(
      barrierDismissible: true,
      animationType: DialogTransitionType.slideFromBottomFade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 700),
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25.0),
            ),
          ),
          titlePadding: const EdgeInsets.all(20),
          actionsPadding: const EdgeInsets.all(0),
          buttonPadding: const EdgeInsets.all(0),
          title: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: passwordFormKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Change Password",
                        style: TextStyle(
                          color: themeblackcolor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: themeredcolor,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: oldPasswordC,
                    obscureText: oldPass,
                    decoration: InputDecoration(
                      hintText: "Old Password",
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
                      suffixIcon: CustomIconButton(
                        onTap: () {
                          if (oldPass == true) {
                            setState(() {
                              oldPass = false;
                            });
                          } else if (oldPass == false) {
                            setState(() {
                              oldPass = true;
                            });
                          }
                        },
                        child: Icon(
                          oldPass == false
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined,
                          color: themegreytextcolor,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Old Password is empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: newPasswordC,
                    obscureText: changePass,
                    decoration: InputDecoration(
                      hintText: "Change Password",
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
                      suffixIcon: CustomIconButton(
                        onTap: () {
                          if (changePass == true) {
                            setState(() {
                              changePass = false;
                            });
                          } else if (changePass == false) {
                            setState(() {
                              changePass = true;
                            });
                          }
                        },
                        child: Icon(
                          changePass == false
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined,
                           color: themegreytextcolor,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "New Password is empty";
                      } else if (value.length <= 6) {
                        return "Password length should be greater than 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: confirmPasswordC,
                    obscureText: confirmChangePass,
                    cursorColor: themewhitecolor,
                    decoration: InputDecoration(
                      hintText: "Confirm Change Password",
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
                      suffixIcon: CustomIconButton(
                        onTap: () {
                          if (confirmChangePass == true) {
                            setState(() {
                              confirmChangePass = false;
                            });
                          } else if (confirmChangePass == false) {
                            setState(() {
                              confirmChangePass = true;
                            });
                          }
                        },
                        child: Icon(
                          confirmChangePass == false
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined,
                         color: themegreytextcolor,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Confirm Password is empty";
                      } else if (value != newPasswordC.text) {
                        return "Confirm new password doesn't match";
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CustomSimpleRoundedButton(
                      onTap: () {
                        if (passwordFormKey.currentState!.validate()) {
                          final authProvider =
                              Provider.of<AuthPro>(context, listen: false);

                          authProvider.userChangePasswordFunc(
                              oldPasswordC.text, newPasswordC.text, context);
                        }
                      },
                      height: 50,
                      width: size.width,
                      buttoncolor: Palette.themecolor,
                      borderRadius: BorderRadius.circular(30),
                      child: const Text(
                        "Done",
                        style: TextStyle(
                          color: themewhitecolor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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

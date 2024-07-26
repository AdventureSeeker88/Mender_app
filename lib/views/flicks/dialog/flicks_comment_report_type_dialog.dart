import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:mender/provider/flicks_pro.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/widgets/custom_elevated_button.dart';
import 'package:mender/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

Future<Object?> flicksCommentReportTypeDialog(
     String flickId,String commentId, BuildContext context, Size size) {  int value = 1;

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
        titlePadding: const EdgeInsets.all(0),
        actionsPadding: const EdgeInsets.all(0),
        buttonPadding: const EdgeInsets.all(0),
        title: SizedBox(
          width: size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: const [
                    Text(
                      "Report",
                      style: TextStyle(
                        color: themeblackcolor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Why do you want to report this?",
                      style: TextStyle(
                        color: themeblackcolor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Help us better understand the reason for this report",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: themegreytextcolor,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),

              RadioListTile(
                value: 1,
                groupValue: value,
                onChanged: (int? valueOne) {
                  setState(
                    () {
                      value = valueOne!;
                    },
                  );
                  log("Selected Value: $value");
                },
                title: const Text(
                  "I Just don't like it",
                ),
                activeColor: Palette.themecolor,
              ),
              RadioListTile(
                value: 2,
                groupValue: value,
                onChanged: (int? valueTwo) {
                  setState(
                    () {
                      value = valueTwo!;
                    },
                  );
                  log("Selected Value: $value");
                },
                title: const Text(
                  "It's spam",
                ),
                activeColor: Palette.themecolor,
              ),
              RadioListTile(
                value: 3,
                groupValue: value,
                onChanged: (int? valueThree) {
                  setState(
                    () {
                      value = valueThree!;
                    },
                  );
                  log("Selected Value: $value");
                },
                title: const Text(
                  "Inappropiate Language",
                ),
                activeColor: Palette.themecolor,
              ),
              RadioListTile(
                value: 4,
                groupValue: value,
                onChanged: (int? valueFour) {
                  setState(
                    () {
                      value = valueFour!;
                    },
                  );
                  log("Selected Value: $value");
                },
                title: const Text(
                  "False Information",
                ),
                activeColor: Palette.themecolor,
              ),
              RadioListTile(
                value: 5,
                groupValue: value,
                onChanged: (int? valueFive) {
                  setState(
                    () {
                      value = valueFive!;
                    },
                  );
                  log("Selected Value: $value");
                },
                title: const Text(
                  "Bullying or Harassement",
                ),
                activeColor: Palette.themecolor,
              ),

             
              const Divider(
                height: 0,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextButton(
                      buttonText: "Skip",
                      onTap: () {
                        Navigator.pop(context);
                      },
                      textstyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomElevatedButton(
                      onTap: () {
                        Provider.of<FlicksPro>(context, listen: false)
                            .flickCommentReportFunc(
                       
                        
                          flickId,
                          commentId,
                          context,
                        );
                        
                      },
                      buttonSize: const Size(100, 35),
                      buttoncolor: themelightgreencolor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      elevation: 5,
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: themewhitecolor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

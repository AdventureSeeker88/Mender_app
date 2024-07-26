
  import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/widgets/custom_text_button.dart';

Future<Object?> reportConfirmationDialog(BuildContext context, ) {
  
    return 
    showAnimatedDialog(
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
          child: Column(
            children: [
              const Text(
                "Report",
                style: TextStyle(
                  color: themeblackcolor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Icon(
                Icons.check_circle_outline,
                color: themelightgreencolor,
                size: 40,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Thanks for reporting this!",
                style: TextStyle(
                  color: themeblackcolor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We will review the post to determine if it violates our policies",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: themegreytextcolor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Thank you for helping make Mended a safe place",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: themegreytextcolor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: CustomTextButton(
                  buttonText: "Got it",
                  onTap: () {
                    Navigator.pop(context);
                  },
                  textstyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  
  }
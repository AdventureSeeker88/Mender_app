import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mender/helper/pick_image.dart';
import 'package:mender/provider/auth_pro.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/widgets/custom_icon_button.dart';
import 'package:mender/widgets/custom_outlined_button.dart';
import 'package:mender/widgets/custom_simple_rounded_button.dart';
import 'package:provider/provider.dart';

class ReportAProblemScreen extends StatefulWidget {
  const ReportAProblemScreen({super.key});

  @override
  State<ReportAProblemScreen> createState() => _ReportAProblemScreenState();
}

class _ReportAProblemScreenState extends State<ReportAProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController messageC = TextEditingController();

  Uint8List? selectImageV;
  Future selectImage() async {
    try {
      Uint8List file;
      file = await pickImage(ImageSource.gallery);

      selectImageV = file;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: themegreencolor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomSimpleRoundedButton(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              Provider.of<AuthPro>(context, listen: false)
                  .doReportFunc(selectImageV, messageC.text, context);
            }
          },
          height: 45,
          width: double.infinity,
          buttoncolor: Palette.themecolor,
          borderRadius: BorderRadius.circular(5),
          child: Text(
            "Submit Report".toUpperCase(),
            style: const TextStyle(
              color: themewhitecolor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                   
                    CustomIconButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: themewhitecolor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      "Report A Problem",
                      style: TextStyle(
                        color: themewhitecolor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                const Center(
                  child: Text(
                    "We will help you as soon as you describe the problem in the paragraphs below",
                    style: TextStyle(
                      color: themegreytextcolor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                selectImageV == null
                    ? Center(
                        child: CustomOutlinedButton(
                          onTap: () {
                            selectImage();
                          },
                          height: 45,
                          width: 200,
                          borderRadius: BorderRadius.circular(5),
                          borderColor: themewhitecolor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add,
                                color: themewhitecolor,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Add a Photo".toUpperCase(),
                                style: const TextStyle(
                                  color: themewhitecolor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: Stack(
                          children: [
                            Container(
                              height: size.height / 100 * 20,
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.memory(
                                    selectImageV!,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            Positioned(
                              right: 5,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectImageV = null;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                    color: Palette.themecolor,
                                    size: 28,
                                  )),
                            )
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 50,
                ),

                 
                const Text(
                  "Comments",
                  style: TextStyle(
                    color: themewhitecolor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    maxLines: 8,
                    cursorColor: themewhitecolor,
                    style: const TextStyle(
                      color: themewhitecolor,
                    ),
                    decoration: InputDecoration(
                      hintText: "Here you can describe the problem",
                      hintStyle: const TextStyle(
                        color: themegreycolor,
                      ),
                      filled: true,
                      fillColor: themegreycolor.withOpacity(0.4),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: themewhitecolor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: themewhitecolor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "message is empty";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

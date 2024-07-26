
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mender/model/auth_model.dart';

import 'package:mender/provider/auth_pro.dart';
import 'package:mender/route/go_router.dart';
import 'package:mender/route/navigator.dart';

import 'package:mender/theme/colors.dart';

import 'package:mender/widgets/custom_icon_button.dart';
import 'package:mender/widgets/custom_text_button.dart';
import 'package:mender/widgets/shimer.dart';
import 'package:provider/provider.dart';

import 'flicks_tab/profile_flicks_tab.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themewhitecolor,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              context.pushNamed(
                'add-flick',
              );
            },
            child: Image.asset("assets/images/png/mended-add-reel.png"),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<AuthM>(
              stream:
                  filter_doctor_detail(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong! ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final doctorData = snapshot.data!;
                  return doctorData.name.isEmpty
                      ? Expanded(
                          child: Center(
                              child: Image.asset(
                            "assets/images/png/mender-circular-logo.png",
                          )),
                        )
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomIconButton(
                                    onTap: () {
                                      context.pushNamed(
                                        'view-notifications',
                                      );
                                    },
                                    child: const Icon(
                                      Icons.notifications,
                                      color: themeorangecolor,
                                    ),
                                  ),
                                  const Spacer(),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  CustomIconButton(
                                      onTap: () {

                                          Provider.of<AuthPro>(context, listen: false)
                                .logoutFunc(context);
                                      }, child: Icon(Icons.logout)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomTextButton(
                                    buttonText: "Settings",
                                    onTap: () {
                                      context.pushNamed(
                                        'mender-account-settings',
                                      );
                                      // context.pushNamed(
                                      //   'view-account-settings',
                                      // );
                                    },
                                    textstyle: const TextStyle(
                                      color: themeblackcolor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomCircleAvtar(
                              url: doctorData.image,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              doctorData.name,
                              style: const TextStyle(
                                color: themeblackcolor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              doctorData.bio,
                              style: const TextStyle(
                                color: themegreytextcolor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //           RatingBar.builder(
                                //   // initialRating: 1,
                                //   // minRating: 1,
                                //   direction: Axis.horizontal,
                                //   itemCount: 5,
                                //   unratedColor: Colors.amber.withAlpha(50),
                                //   itemPadding:
                                //       const EdgeInsets.symmetric(horizontal: 4.0),
                                //   itemBuilder: (context, _) => const Icon(
                                //     Icons.star,
                                //     color: Colors.amber,
                                //   ),
                                //   onRatingUpdate: (rating) {
                                //     setState(() {
                                //       ratingv = rating;
                                //      });
                                //     log("RatingValue: $ratingv");
                                //   },
                                // ),
                                // Row(
                                //   children: List.generate(
                                //     doctorData.averageRating.toInt(),
                                //     (index) => const Icon(
                                //       Icons.star,
                                //       color: themeorangecolor,
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(
                                //   width: 10,
                                // ),
                                // Text(doctorData.averageRating
                                //     .toStringAsPrecision(2)),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconButton(
                                    onTap: () {
                                      context.pushNamed(
                                        'view-buddy-list',
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.people_alt_outlined,
                                          color: Palette.themecolor,
                                          size: 30,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Buddy List",
                                          style: TextStyle(
                                            color: Palette.themecolor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const VerticalDivider(
                                    color: Palette.themecolor,
                                    width: 100,
                                    thickness: 1.5,
                                  ),
                                  CustomIconButton(
                                    onTap: () {
                                      Go.named(context, Routes.messagesScreen);
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          CupertinoIcons.chat_bubble,
                                          color: Palette.themecolor,
                                          size: 30,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Messages",
                                          style: TextStyle(
                                            color: Palette.themecolor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            FlicksTab(
                                id: FirebaseAuth.instance.currentUser!.uid)
                          ],
                        );
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }

//doctor detail filer stream
  Stream<AuthM> filter_doctor_detail(String doctor_id) =>
      FirebaseFirestore.instance
          .collection('auth')
          .doc(doctor_id)
          .snapshots()
          .map((snapshot) => AuthM.fromJson(snapshot.data() ?? {}));
}

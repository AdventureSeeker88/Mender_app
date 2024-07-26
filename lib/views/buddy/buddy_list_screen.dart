import 'dart:developer';

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
import 'package:mender/utils/database.dart';
import 'package:mender/widgets/custom_icon_button.dart';
import 'package:provider/provider.dart';

class BuddyListScreen extends StatefulWidget {
  const BuddyListScreen({super.key});

  @override
  State<BuddyListScreen> createState() => _BuddyListScreenState();
}

class _BuddyListScreenState extends State<BuddyListScreen> {
  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthPro>(context);
    log("authModel.myUserdata['buddyList']: ${authModel.myUserdata['buddyList']}");
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themewhitecolor,
              themewhitecolor,
              themewhitecolor,
              themebackgroundbottomcolor,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: CustomIconButton(
                          onTap: () {
                            context.pop();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                          ),
                        ),
                      ),
                      const Text(
                        "Buddy List",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  StreamBuilder<List<AuthM>>(
                    stream: filterBuddies(authModel.myUserdata['buddyList']),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;

                        return ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var buddyData = data[index];
                            return Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: themewhitecolor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: themegreycolor,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [

                                  (buddyData.image != "")
                                                ? CircleAvatar(
                                                    backgroundColor:
                                                        themelightgreencolor,
                                                    radius: 30,
                                                    backgroundImage:
                                                        NetworkImage(buddyData.image))
                                                : const CircleAvatar(
                                                    backgroundColor:
                                                        themelightgreencolor,
                                                    radius: 30,
                                                    backgroundImage: AssetImage(
                                                        "assets/images/png/hand-6.png")),
                                 
                                  const SizedBox(
                                    width: 10,
                                  ),
                                   Text(
                                   buddyData.name,
                                    style: TextStyle(
                                      color: themegreytextcolor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(
                                    flex: 3,
                                  ),
                                  InkWell(
                                    onTap: (){

                                       Go.named(
                                      context,
                                      Routes.chatScreen,
                                      {
                                        'id': buddyData.uid,
                                        'type': "1",
                                      },
                                    );
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Palette.themecolor.withOpacity(0.1),
                                      child: const Icon(
                                        CupertinoIcons.chat_bubble,
                                        color: Palette.themecolor,
                                      ),
                                    ),
                                  ),
                                 
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, separator) {
                            return const SizedBox(
                              height: 15,
                            );
                          },
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CupertinoActivityIndicator(
                            color: Palette.themecolor,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
                  )
               
               
               
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Stream<List<AuthM>> filterBuddies(List buddyList) =>
      FirebaseFirestore.instance
          .collection(
            Database.auth,
          )
          .where("uid", whereIn: buddyList)
          .where("type", isEqualTo: 1)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => AuthM.fromJson(doc.data())).toList());
}

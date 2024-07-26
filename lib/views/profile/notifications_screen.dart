import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mender/model/notification_model.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/utils/database.dart';
import 'package:mender/utils/future.dart';
import 'package:mender/widgets/custom_icon_button.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Palette.themecolor.withOpacity(0.5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CustomIconButton(
                    onTap: () {
                      context.pop();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: themewhitecolor,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Notifications",
                      style: TextStyle(
                        color: themewhitecolor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: CustomIconButton(
                      onTap: () async {
                      

                        await FirebaseFirestore.instance
                            .collection(
                              Database.notifications,
                            )
                            .where("receiverId", arrayContainsAny: [
                              FirebaseAuth.instance.currentUser!.uid
                            ])
                            .get()
                            .then((QuerySnapshot<Map<String, dynamic>>
                                querySnapshot) async {
                              if (querySnapshot.docs.isNotEmpty) {
                                querySnapshot.docs.forEach(
                                    (QueryDocumentSnapshot<Map<String, dynamic>>
                                        document) async {
                                  var data = document.data();

                                  await FirebaseFirestore.instance
                                      .collection(Database.notifications)
                                      .doc(data['notifyId'])
                                      .update({'status': "1"});
                                
                                });
                              }
                            });
                      },
                      child: const Icon(
                        Icons.clear_all,
                        color: themewhitecolor,
                      ),
                    ),
                  ),
              
              
               ],
              ),
              const Divider(
                height: 80,
                color: Palette.themecolor,
              ),
              StreamBuilder<List<NotificationM>>(
                stream: filterNotification(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    final notification = snapshot.data!;
                    log("notification: ${notification.length}");
                    if (notification.isEmpty) {
                      return Column(
                        children: [
                          Center(
                            child: Image.asset(
                              "assets/images/png/notification.png",
                              height: 250,
                              width: 250,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "No Notification to show.",
                            style: TextStyle(
                              color: themewhitecolor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return ListView.separated(
                        itemCount: notification.length,
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<String>(
                                  future: userImageGet(
                                    notification[index].senderId,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      String getD = snapshot.data!;
                                      return CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                          (getD != "")
                                              ? getD
                                              : "https://img.freepik.com/free-vector/cute-rabbit-holding-carrot-cartoon-vector-icon-illustration-animal-nature-icon-isolated-flat_138676-7315.jpg?w=2000",
                                        ),
                                      );
                                    } else {
                                      return const CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                          "https://img.freepik.com/free-vector/cute-rabbit-holding-carrot-cartoon-vector-icon-illustration-animal-nature-icon-isolated-flat_138676-7315.jpg?w=2000",
                                        ),
                                      );
                                    }
                                  }),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  FutureBuilder<String>(
                                      future: userNameGet(
                                        notification[index].senderId,
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          String getD = snapshot.data!;
                                          return Text(
                                            "$getD ",
                                            style: const TextStyle(
                                              color: Palette.themecolor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        } else {
                                          return const Text(
                                            "",
                                            style: TextStyle(
                                              color: Palette.themecolor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }
                                      }),
                                  Text(
                                    notification[index].description,
                                    style: const TextStyle(
                                      color: themegreycolor,
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              )
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 80,
                            color: Palette.themecolor,
                          );
                        },
                      );
                    }
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
              ),
              const Divider(
                height: 80,
                color: Palette.themecolor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<List<NotificationM>> filterNotification() => FirebaseFirestore.instance
      .collection(
        Database.notifications,
      )
      .where("receiverId",
          arrayContainsAny: [FirebaseAuth.instance.currentUser!.uid])
      .where("status", isEqualTo: 0)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => NotificationM.fromJson(doc.data()))
          .toList());
}

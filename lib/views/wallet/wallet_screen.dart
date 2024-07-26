import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mender/helper/time.dart';
import 'package:mender/model/auth_model.dart';
import 'package:mender/model/call/call_m.dart';
import 'package:mender/route/go_router.dart';
import 'package:mender/route/navigator.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/utils/database.dart';
import 'package:mender/utils/future.dart';
import 'package:mender/widgets/custom_simple_rounded_button.dart';
import 'package:mender/widgets/custom_text_button.dart';
import 'package:mender/widgets/dailog.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
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
                      const Text(
                        'Wallet',
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
                  StreamBuilder<AuthM>(
                      stream:
                          filterDoctor(FirebaseAuth.instance.currentUser!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                              'Something went wrong! ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final doctorData = snapshot.data!;
                          return doctorData.name.isEmpty
                              ? Expanded(
                                  child: Center(
                                      child: Image.asset(
                                    "assets/images/png/mender-circular-logo.png",
                                  )),
                                )
                              : Container(
                                  width: size.width,
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Total Balance",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "\$${doctorData.coin}",
                                        style: const TextStyle(
                                          color: Palette.themecolor,
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        } else {
                          return Container();
                        }
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextButton(
                    buttonText: "Full account access on web",
                    onTap: () {
                      commingSoonDailog(context);
                    },
                    textstyle: const TextStyle(
                      color: Palette.themecolor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    "Last Mended Sessions",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  StreamBuilder<List<CallModel>>(
                    stream: filterAttendedSessions(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return SingleChildScrollView(
                          child: ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              var sessionData = data[index];
                              return Row(
                                children: [
                                  FutureBuilder<String>(
                                      future: userImageGet(
                                        sessionData.callerId ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                            ? sessionData.receiverId
                                            : sessionData.callerId,
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          String userimage = snapshot.data!;
                                          return CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                              (userimage != "")
                                                  ? userimage
                                                  : "https://img.freepik.com/free-vector/cute-rabbit-holding-carrot-cartoon-vector-icon-illustration-animal-nature-icon-isolated-flat_138676-7315.jpg?w=2000",
                                            ),
                                          );
                                        } else {
                                          return const CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                              "https://img.freepik.com/free-vector/cute-rabbit-holding-carrot-cartoon-vector-icon-illustration-animal-nature-icon-isolated-flat_138676-7315.jpg?w=2000",
                                            ),
                                          );
                                        }
                                      }),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<String>(
                                          future: userNameGet(
                                            sessionData.callerId ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                ? sessionData.receiverId
                                                : sessionData.callerId,
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              String username = snapshot.data!;
                                              return Text(
                                                username,
                                                style: const TextStyle(
                                                  color: themegreytextcolor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              return const Text(
                                                "",
                                                style: TextStyle(
                                                  color: themegreytextcolor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          }),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        timeAgo(sessionData.dateTime),
                                        style: const TextStyle(
                                          color: themegreytextcolor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(
                                    flex: 2,
                                  ),
                                  Text(
                                    // "+\$45.50",

                                    "+\$${sessionData.deductCoins.toStringAsPrecision(2)}",
                                    style: const TextStyle(
                                      color: themedarkgreencolor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, separator) {
                              return Image.asset(
                                "assets/images/png/wave-divider-big.png",
                                height: 50,
                                // width: double.infinity,
                              );
                            },
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: Text("no data "),
                          // child: CupertinoActivityIndicator(
                          //   color: Palette.themecolor,
                          // ),
                        );
                      } else {
                        return Container(
                          child: Text("no data"),
                        );
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

  Stream<AuthM> filterDoctor(String doctor_id) => FirebaseFirestore.instance
      .collection(Database.auth)
      .doc(doctor_id)
      .snapshots()
      .map((snapshot) => AuthM.fromJson(snapshot.data() ?? {}));

  Stream<List<CallModel>> filterAttendedSessions() => FirebaseFirestore.instance
      .collection(
        Database.callColl,
      )
      .where('join', arrayContainsAny: [FirebaseAuth.instance.currentUser!.uid])
      .where("status", isEqualTo: 1)
        .orderBy("dateTime", descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => CallModel.fromJson(doc.data())).toList());
}

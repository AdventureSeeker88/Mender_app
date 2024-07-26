import 'dart:async';
import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:intl/intl.dart';
import 'package:mender/model/auth_model.dart';
import 'package:mender/model/calender/session_model.dart';
import 'package:mender/provider/auth_pro.dart';
import 'package:mender/provider/call_pro.dart';
import 'package:mender/provider/session_pro.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/utils/constants.dart';
import 'package:mender/utils/database.dart';
import 'package:mender/views/calender/add_session_screen.dart';
import 'package:mender/widgets/custom_elevated_button.dart';
import 'package:mender/widgets/custom_icon_button.dart';
import 'package:mender/widgets/custom_simple_rounded_button.dart';
import 'package:mender/widgets/custom_text_button.dart';
import 'package:mender/widgets/shimer.dart';
import 'package:provider/provider.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  List<DateTime?> _value = [
    DateTime.now(),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
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
                        "Calender",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: CustomIconButton(
                          onTap: () {
                            createSessionWidget(context, size);
                          },
                          child: const Icon(
                            Icons.add,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
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
                    child: CalendarDatePicker2(
                      config: CalendarDatePicker2Config(
                        selectedDayHighlightColor: Palette.themecolor,
                        selectedDayTextStyle: const TextStyle(
                          color: themewhitecolor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        dayTextStyle: const TextStyle(
                          color: themeblackcolor,
                          fontSize: 18,
                        ),
                      ),
                      value: _value,
                      onValueChanged: (dates) => _value = dates,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  StreamBuilder<List<SessionModel>>(
                    stream: sessionStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong! ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;

                        return ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final model = data[index];

                            log("Date Time:${Timestamp.now()}");
                            log("${model.sessionDate.toDate()}");

                            return FutureBuilder<AuthM>(
                                future:
                                    Provider.of<AuthPro>(context, listen: false)
                                        .getUserById(model.uid),
                                builder: ((context, snapshot) {
                                  if (snapshot.hasData) {
                                    final authdata = snapshot.data!;
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 5,
                                          decoration: BoxDecoration(
                                            color: themedarkgreencolor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          "${DateFormat.d().format(model.sessionDate.toDate())}, ${DateFormat.E().format(model.sessionDate.toDate())}",
                                          style: const TextStyle(
                                            color: themedarkgreencolor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomCircleAvtar(
                                          url: authdata.image,
                                          height: 35,
                                          width: 35,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              model.title,
                                              style: const TextStyle(
                                                color: themegreytextcolor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${model.startTime} - ${model.endTime}",
                                              style: const TextStyle(
                                                color: themegreytextcolor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        SessionButtonWidget(model: model)
                                      ],
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                }));
                          },
                          separatorBuilder: (context, separator) {
                            return Image.asset(
                              "assets/images/png/wave-divider-big.png",
                              height: 50,
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: themegreycolor,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Stream<List<SessionModel>> sessionStream() => FirebaseFirestore.instance
      .collection(Database.session)
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy("sessionDate", descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => SessionModel.fromJson(doc.data()))
          .toList());

  Future<Object?> mendedRequest(size) {
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
          titlePadding: const EdgeInsets.all(24),
          actionsPadding: const EdgeInsets.all(0),
          buttonPadding: const EdgeInsets.all(0),
          title: SizedBox(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Mended Request",
                    style: TextStyle(
                      color: themeblackcolor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/png/wave-divider.png",
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        "https://img.freepik.com/free-vector/cute-rabbit-holding-carrot-cartoon-vector-icon-illustration-animal-nature-icon-isolated-flat_138676-7315.jpg?w=2000",
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Kai Liu",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "30 minutes session / 30 Tokens",
                          style: TextStyle(
                            color: themegreytextcolor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Kai feel anxious this week and need someone to talk to",
                  style: TextStyle(
                    color: themegreytextcolor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/png/wave-divider.png",
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomTextButton(
                      buttonText: "Next Client",
                      onTap: () {},
                      textstyle: const TextStyle(
                        color: themegreytextcolor,
                        fontSize: 15,
                      ),
                    ),
                    CustomElevatedButton(
                      onTap: () {
                        context.pushNamed(
                          'call-screen',
                        );
                      },
                      buttonSize: const Size(120, 40),
                      buttoncolor: Palette.themecolor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(25),
                      elevation: 10,
                      child: const Text(
                        "Accept",
                        style: TextStyle(
                          color: themewhitecolor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SessionButtonWidget extends StatefulWidget {
  final SessionModel model;
  const SessionButtonWidget({super.key, required this.model});

  @override
  State<SessionButtonWidget> createState() => _SessionButtonWidgetState();
}

class _SessionButtonWidgetState extends State<SessionButtonWidget> {
  bool buttonShow = false;
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 3), (Timer) {
      sessionTimeCheckFunc();
    });
    super.initState();
  }

  sessionTimeCheckFunc() {
    final currentTime = Timestamp.now();

    if (currentTime.seconds >= widget.model.sessionDate.seconds &&
        currentTime.seconds <= widget.model.sessionEndDate.seconds) {
      setState(() {
        buttonShow = true;
      });

      log("showJoinButton: true");
    } else {
      setState(() {
        buttonShow = false;
      });
      log("showJoinButton: false");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomSimpleRoundedButton(
      onTap: () {
        if (buttonShow) {
          FirebaseFirestore.instance
              .collection(Database.callColl)
              .where('callerId',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .where("status", isEqualTo: 0)
              .get()
              .then((value) {
            final post = Provider.of<CallPro>(context, listen: false);
            if (value.docs.isEmpty) {
              log("createCall");
              post.createCall(
                  10, "Hello world", 5, widget.model.cleintId, context);
            } else {
              log("joinCall");

              post.joinCall(
                  value.docs[0]['callData'], widget.model.cleintId, 5, context);
            }
          });
        } else {}
      },
      height: 40,
      width: size.width / 100 * 22,
      buttoncolor: Palette.themecolor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(30),
      child: Text(
        "Join Call",
        style: TextStyle(
          color: buttonShow
              ? Palette.themecolor
              : Palette.themecolor.withOpacity(0.5),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

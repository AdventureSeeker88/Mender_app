import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mender/model/auth_model.dart';
import 'package:mender/model/cleint_model.dart';
import 'package:mender/provider/auth_pro.dart';
import 'package:mender/provider/session_pro.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/utils/constants.dart';
import 'package:mender/utils/database.dart';
import 'package:mender/utils/future.dart';
import 'package:mender/widgets/custom_simple_rounded_button.dart';
import 'package:mender/widgets/custom_text_button.dart';
import 'package:intl/intl.dart';
import 'package:mender/widgets/shimer.dart';
import 'package:mender/widgets/toast.dart';
import 'package:provider/provider.dart';

Future<dynamic> createSessionWidget(BuildContext context, Size size) {
  return showModalBottomSheet(
    backgroundColor: themewhitecolor,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: const AddSessionWidget(),
          );
        },
      );
    },
  );
}

class AddSessionWidget extends StatefulWidget {
  const AddSessionWidget({super.key});

  @override
  State<AddSessionWidget> createState() => _AddSessionWidgetState();
}

class _AddSessionWidgetState extends State<AddSessionWidget> {
   //TEST
  DateTime startDateWithDayNumberTime = DateTime.now();
  DateTime endDateWithDayNumberTime = DateTime.now();

  DateTime selectedDay = DateTime.now();
  // String formatedSelectedDay = "";
  DateTime now = DateTime.now();
  late DateTime lastDayOfMonth;
  int? selectedDayNumber;
  @override
  void initState() {
    lastDayOfMonth = DateTime(now.year, now.month, 0);
    selectedDay = DateTime(now.year, now.month, now.day + 1);
    Provider.of<SessionPro>(context, listen: false).changeCleintId("");
    super.initState();
  }
  final formKey = GlobalKey<FormState>();
  String sessionCategoryValue = "";
  final TextEditingController sessionTitleC = TextEditingController();
  final TextEditingController sessionStartTimeC = TextEditingController();
  final TextEditingController sessionEndTimeC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      key: formKey,
      child: Container(
        height: size.height / 100 * 90,
        width: size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: CustomTextButton(
                        buttonText: "Cancel",
                        onTap: () {
                          Navigator.pop(context);
                        },
                        textstyle: const TextStyle(
                          color: Palette.themecolor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      "New Session",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Consumer<SessionPro>(
                        builder: ((context, modelValue, child) {
                      return Align(
                        alignment: Alignment.topRight,
                        child: CustomTextButton(
                          buttonText: "Create",
                          onTap: () {
                            DateTime endDateWithDayNumber = DateTime(
                                now.year, now.month, selectedDayNumber!);
                            log("new endDateWithDayNumber: ${endDateWithDayNumber}");
                            String formattedDate =
                                DateFormat.yMMMd().format(endDateWithDayNumber);
                            log("new formattedDate: ${formattedDate}");

                            if (formKey.currentState!.validate()) {
                              // // -- GENERATING SESSION END TIME --
                              // TimeOfDay selectedEndTime =
                              //     TimeOfDay.fromDateTime(DateFormat.jm()
                              //         .parse(sessionEndTimeC.text));
                              // DateTime endDateWithDayNumberTime = DateTime(
                              //   now.year,
                              //   now.month,
                              //   selectedDayNumber!,
                              //   selectedEndTime.hour,
                              //   selectedEndTime.minute,
                              // );
                              // log("endDateWithDayNumberTime: $endDateWithDayNumberTime");

                              if (modelValue.cleintId != "") {
                                // -- CREATING SESSION --
                                final sessionProvider = Provider.of<SessionPro>(
                                    context,
                                    listen: false);
                                sessionProvider.addSession(
                                    Timestamp.fromDate(
                                        startDateWithDayNumberTime),
                                    Timestamp.fromDate(
                                        endDateWithDayNumberTime), //remove
                                    sessionTitleC.text,
                                    sessionStartTimeC.text,
                                    sessionEndTimeC.text,
                                    sessionCategoryValue,
                                    context);
                              } else {
                                customToast(
                                    "Please Select client first", context);
                              }
                            }
                          },
                          textstyle: const TextStyle(
                              color: Palette.themecolor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    }))
                  
                  
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Today"),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${now.day} Date, ${now.month.toString()} Month, ${now.year.toString()} Year",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: Row(
                        children: List.generate(
                          DateTime(now.year, now.month, 0).day - now.day,
                          (index) {
                            log("lastDayOfMonth: $index");
                            // DateTime currentDate = lastDayOfMonth
                            //     .add(Duration(days: (now.day + index)));

                            DateTime currentDate = DateTime(now.year,now.month,now.day+index);

                            var dayName = DateFormat('EEE').format(currentDate);
                            var day = DateFormat('dd').format(currentDate);

                            return Padding(
                              padding: const EdgeInsets.only(
                                right: 16.0,
                              ),
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    selectedDayNumber = index + 1;
                                    DateTime now = DateTime.now();

                                    selectedDay = currentDate;
                                    sessionStartTimeC.clear();
                                    sessionEndTimeC.clear();
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedDay == currentDate
                                        ? Palette.themecolor
                                        : null,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: selectedDay == currentDate
                                          ? Colors.transparent
                                          : themegreytextcolor,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dayName.toString(),
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: selectedDay == currentDate
                                              ? themewhitecolor
                                              : themeblackcolor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        "$day",
                                        style: TextStyle(
                                          fontSize: 28.0,
                                          color: selectedDay == currentDate
                                              ? themewhitecolor
                                              : themeblackcolor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Container(
                                        height: 6.0,
                                        width: 6.0,
                                        decoration: BoxDecoration(
                                          color: selectedDay == currentDate
                                              ? themewhitecolor
                                              : Palette.themecolor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "Client",
                      style: TextStyle(
                        color: themegreytextcolor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Consumer<SessionPro>(
                      builder: ((context, modelvalue, child) {
                        return Row(
                          children: [
                            modelvalue.cleintId == ""
                                ? const SizedBox()
                                : FutureBuilder<String>(
                                    future: userImageGet(modelvalue.cleintId),
                                    builder: ((context, snapshot) {
                                      return CustomCircleAvtar(
                                        height: 60,
                                        width: 60,
                                        url: snapshot.data ?? "",
                                      );
                                    })),
                            modelvalue.cleintId == ""
                                ? const SizedBox()
                                : const SizedBox(
                                    width: 10,
                                  ),
                            InkWell(
                              onTap: () {
                                cleintDailog(context, size);
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: themegreytextcolor),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Palette.themecolor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "Title",
                      style: TextStyle(
                        color: themegreytextcolor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        controller: sessionTitleC,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: themegreytextcolor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "Please Select Session Title.";
                          }
                          return null;
                        })),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: size.height / 100 * 2,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            autofocus: false,
                            controller: sessionStartTimeC,
                            keyboardType: TextInputType.none,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: themegreytextcolor,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isDense: true,
                              prefixIcon: const Icon(
                                CupertinoIcons.clock,
                                color: themegreytextcolor,
                              ),
                              hintText: "Starts",
                            ),
                            readOnly:
                                true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              if (selectedDayNumber != null) {
                                TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        const TimeOfDay(hour: 10, minute: 47),
                                    builder: (context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: false),
                                        child: child!,
                                      );
                                    });

                                if (pickedTime != null) {
                                  DateTime now = DateTime.now();

                                  DateTime selectedDateTime = DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );

                                  String formattedTime =
                                      DateFormat.jm().format(selectedDateTime);
                                  log('formattedTime: $formattedTime');

                                  setState(() {
                                    sessionStartTimeC.text = formattedTime;
                                  });

                                  // -- GENERATING SESSION START TIME --
                                  TimeOfDay selectedStartTime =
                                      TimeOfDay.fromDateTime(DateFormat.jm()
                                          .parse(sessionStartTimeC.text));
                                  log("selectedStartTime: $selectedStartTime");
                                  startDateWithDayNumberTime = DateTime(
                                    now.year,
                                    now.month,
                                    selectedDayNumber!,
                                    selectedStartTime.hour,
                                    selectedStartTime.minute,
                                  );
                                  log("startDateWithDayNumberTime: $startDateWithDayNumberTime");
                                }
                              } else {
                                customToast(
                                    "Please select date first", context);
                              }
                            },
                            validator: ((value) {
                              if (value!.isEmpty && value == "") {
                                return "Please Select the starting time.";
                              }
                              return null;
                            }),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            autofocus: false,
                            controller: sessionEndTimeC,
                            keyboardType: TextInputType.none,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: themegreytextcolor,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isDense: true,
                              prefixIcon: const Icon(
                                CupertinoIcons.clock,
                                color: themegreytextcolor,
                              ),
                              hintText: "End",
                            ),
                            readOnly: true,
                            onTap: () async {
                              if (selectedDayNumber != null) {
                                TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        const TimeOfDay(hour: 10, minute: 47),
                                    builder: (context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: false),
                                        child: child!,
                                      );
                                    });

                                if (pickedTime != null) {
                                  DateTime now = DateTime.now();

                                  DateTime selectedDateTime = DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );

                                  String formattedTime =
                                      DateFormat.jm().format(selectedDateTime);

                                  log('formattedTime: $formattedTime');

                                  setState(() {
                                    sessionEndTimeC.text = formattedTime;
                                  });

                                  // -- GENERATING SESSION END TIME --
                                  TimeOfDay selectedEndTime =
                                      TimeOfDay.fromDateTime(DateFormat.jm()
                                          .parse(sessionEndTimeC.text));

                                  log("selectedEndTime: $selectedEndTime");
                                  endDateWithDayNumberTime = DateTime(
                                    now.year,
                                    now.month,
                                    selectedDayNumber!,
                                    selectedEndTime.hour,
                                    selectedEndTime.minute,
                                  );
                                  log("endDateWithDayNumberTime: $endDateWithDayNumberTime");
                                } else {
                                  log('No time selected');
                                }
                              } else {
                                customToast(
                                    "Please select date first", context);
                              }
                            },
                            validator: ((value) {
                              if (value!.isEmpty && value == "") {
                                return "Please Select the ending time.";
                              }
                            }),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Repeat",
                      style: TextStyle(
                        color: themegreytextcolor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField(
                        icon: const Icon(
                          CupertinoIcons.arrow_up_down,
                        ),
                        style: const TextStyle(
                          color: themegreytextcolor,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: themegreycolor.withOpacity(0.4),
                          hintText: "Select Session Timing",
                          hintStyle: const TextStyle(
                            color: themegreytextcolor,
                          ),
                          isDense: true,
                          alignLabelWithHint: true,
                          contentPadding: const EdgeInsets.all(20),
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
                        ),
                        items: Constants.sessionCategoriesList
                            .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    color: themegreytextcolor,
                                    fontSize: 16,
                                  ),
                                )))
                            .toList(),
                        onChanged: (item) {
                          sessionCategoryValue = item.toString();
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Please Select Session Timing";
                          }
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> cleintDailog(
    BuildContext context,
    Size size,
  ) {
    return showModalBottomSheet(
      backgroundColor: themewhitecolor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(Database.cleint)
                  .where('receiverId',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!.docs;
                  return SingleChildScrollView(
                    child: ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        CleintModel model = CleintModel.fromSnap(data[index]);
                        return FutureBuilder<AuthM>(
                            future: Provider.of<AuthPro>(context, listen: false)
                                .getUserById(model.uid),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                final authdata = snapshot.data!;
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
                                      CustomCircleAvtar(
                                        url: authdata.image,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        authdata.name,
                                        style: const TextStyle(
                                          color: themegreytextcolor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(
                                        flex: 2,
                                      ),
                                      const Spacer(),
                                      Consumer<SessionPro>(
                                        builder: ((context, modelvalue, child) {
                                          return CustomSimpleRoundedButton(
                                            onTap: () {
                                              setState(
                                                () {
                                                  modelvalue.changeCleintId(
                                                      model.uid);
                                                },
                                              );
                                              Navigator.pop(context);
                                            },
                                            height: 40,
                                            width: size.width / 100 * 22,
                                            buttoncolor:
                                                modelvalue.cleintId == model.uid
                                                    ? themegreycolor
                                                    : Palette.themecolor
                                                        .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Text(
                                              modelvalue.cleintId == model.uid
                                                  ? "Already"
                                                  : "Add Cleint",
                                              style: const TextStyle(
                                                color: Palette.themecolor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            }));
                      },
                      separatorBuilder: (context, separator) {
                        return const SizedBox(
                          height: 15,
                        );
                      },
                    ),
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
            );
          },
        );
      },
    );
  }
}

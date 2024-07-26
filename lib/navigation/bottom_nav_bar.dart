import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:mender/model/call/call_m.dart';
import 'package:mender/provider/call_pro.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/utils/database.dart';
import 'package:mender/utils/future.dart';
import 'package:mender/views/calender/calender_screen.dart';
import 'package:mender/views/client/client_list_screen.dart';
import 'package:mender/views/profile/profile_screen.dart';
import 'package:mender/views/flicks/flicks_screen.dart';
import 'package:mender/views/wallet/wallet_screen.dart';
import 'package:mender/widgets/custom_elevated_button.dart';
import 'package:mender/widgets/custom_icon_button.dart';
import 'package:mender/widgets/custom_simple_rounded_button.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_text_button.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: CustomIconButton(
        onTap: () {
          findInstantsClients(size);
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: themewhitecolor.withOpacity(0.5),
            child: CircleAvatar(
              radius: 34,
              backgroundColor: themewhitecolor,
              child: Image.asset(
                "assets/images/png/mender-logo.png",
                height: 40,
                width: 40,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        height: 120,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/png/bottom-nav-bar-n.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              label: "",
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Image.asset(
                  _currentIndex == 0
                      ? "assets/images/png/calendar-selected.png"
                      : "assets/images/png/calendar-unselected.png",
                  width: 50,
                  height: 35,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: "",
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Image.asset(
                  _currentIndex == 1
                      ? "assets/images/png/people-selected.png"
                      : "assets/images/png/people-unselected.png",
                  width: 50,
                  height: 35,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: "",
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Image.asset(
                  _currentIndex == 2
                      ? "assets/images/png/home-selected.png"
                      : "assets/images/png/home-unselected.png",
                  width: 50,
                  height: 35,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: "",
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Image.asset(
                  _currentIndex == 3
                      ? "assets/images/png/wallet-selected.png"
                      : "assets/images/png/wallet-unselected.png",
                  width: 50,
                  height: 35,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: "",
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Image.asset(
                  _currentIndex == 4
                      ? "assets/images/png/profile-selected.png"
                      : "assets/images/png/profile-unselected.png",
                  width: 50,
                  height: 35,
                ),
              ),
            ),
          ],
          currentIndex: _currentIndex,
          onTap: navigationTapped,
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: const [
          CalenderScreen(),
          ClientListScreen(),
          FlicksScreen(),
          WalletScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }

  Widget findMender(setState) {
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: SizedBox(
        height: size.height / 100 * 70,
        child: Scaffold(
          backgroundColor: Palette.themecolor,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  themelightgreencolor.withOpacity(0.2),
                  themelightgreencolor.withOpacity(0.4),
                  Palette.themecolor.withOpacity(0.6),
                  Palette.themecolor.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.4, 0.8, 1],
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Stack(
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Find Mender",
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
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              color: themewhitecolor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "How many minutes you want to take therapy session?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: themewhitecolor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: themewhitecolor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          4,
                          (index) => Container(
                            height: 70,
                            width: size.width / 100 * 18,
                            decoration: BoxDecoration(
                              color: themelightgreenshade2color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  index == 0
                                      ? "10"
                                      : index == 1
                                          ? "30"
                                          : index == 2
                                              ? "45"
                                              : "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: themelightgreencolor,
                                    fontSize: index == 3 ? 0 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  index == 3 ? "Ongoing" : "min",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: themelightgreencolor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "What do you need to cover this session",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: themewhitecolor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: themewhitecolor,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: themegreytextcolor,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Write Something here...",
                      ),
                    ),
                  ),
                  const Spacer(),
                  CustomIconButton(
                    onTap: () {
                      Navigator.pop(context);
                      connectingWithMender(
                        size,
                      );
                      Timer(
                        const Duration(seconds: 3),
                        () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25),
                              ),
                            ),
                            context: context,
                            builder: (context) => StatefulBuilder(
                              builder: (context, setState) =>
                                  foundedMender(setState),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/png/mended-button-small.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Next",
                          style: TextStyle(
                            color: themewhitecolor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [],
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

  Widget foundedMender(setState) {
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: SizedBox(
        height: size.height / 100 * 80,
        child: Scaffold(
          backgroundColor: Palette.themecolor,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  themelightgreencolor.withOpacity(0.2),
                  themelightgreencolor.withOpacity(0.4),
                  Palette.themecolor.withOpacity(0.6),
                  Palette.themecolor.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.4, 0.8, 1],
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Stack(
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Find Mender",
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
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              color: themewhitecolor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 50,
                        ),
                        child: Container(
                          height: size.height / 100 * 46,
                          width: size.width,
                          decoration: BoxDecoration(
                            color: themewhitecolor,
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: const DecorationImage(
                                  image: NetworkImage(
                                    "https://cdn.theatlantic.com/thumbor/vDZCdxF7pRXmZIc5vpB4pFrWHKs=/559x0:2259x1700/1080x1080/media/img/mt/2017/06/shutterstock_319985324/original.jpg",
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "Dr.Nancy Stark",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Licensed Professional Counselor PHD, LPC",
                              style: TextStyle(
                                color: themelightgreencolor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(
                              color: themelightgreencolor,
                              height: 40,
                              indent: 60,
                              endIndent: 60,
                            ),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40.0),
                                child: Text(
                                  "About Doctor",
                                  style: TextStyle(
                                    color: themegreytextcolor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.0),
                              child: Text(
                                "Dr. Nancy Stark is a top specialist at London Bridge Hospital at London. She has achieved several awards and recognition for is contribution and service in her own field.",
                                style: TextStyle(
                                  color: themegreytextcolor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Divider(
                              color: themelightgreencolor,
                              height: 40,
                              indent: 60,
                              endIndent: 60,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.star,
                                  color: themeyellowcolor,
                                  size: 20,
                                ),
                                Text(
                                  "4.5(1245)",
                                  style: TextStyle(
                                    color: themegreytextcolor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "1 Token/Minute",
                                  style: TextStyle(
                                    color: themegreytextcolor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: themegreycolor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: themeblackcolor.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(5, 10)),
                      ],
                    ),
                    child: const Text(
                      "00:29",
                      style: TextStyle(
                        color: themewhitecolor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomSimpleRoundedButton(
                        onTap: () {},
                        height: 50,
                        width: size.width / 100 * 30,
                        buttoncolor: themelightgreencolor,
                        borderRadius: BorderRadius.circular(30),
                        child: const Text(
                          "Pick Another",
                          style: TextStyle(
                            color: themewhitecolor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomSimpleRoundedButton(
                        onTap: () {
                          // RouteNavigator.replacementroute(
                          //   context,
                          //   const VideoCallScreen(),
                          // );
                        },
                        height: 50,
                        width: size.width / 100 * 30,
                        buttoncolor: themewhitecolor,
                        borderRadius: BorderRadius.circular(30),
                        child: const Text(
                          "Start Call",
                          style: TextStyle(
                            color: themelightgreencolor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Future<Object?> connectingWithMender(size) {
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
              children: [
                Column(
                  children: [
                    const Text(
                      "Connecting with the Mender",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: themeblackcolor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Please wait for a mender to approve your session',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: themegreytextcolor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const CircularProgressIndicator(
                      color: themelightgreenshade2color,
                      backgroundColor: themelightgreencolor,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextButton(
                      buttonText: "Cancel",
                      onTap: () {
                        Navigator.pop(context);
                      },
                      textstyle: const TextStyle(
                        color: themegreytextcolor,
                        fontSize: 16,
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

  Future<Object?> findInstantsClients(size) {
    int selectedIndex = 0;
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
              Radius.circular(30.0),
            ),
          ),
          titlePadding: const EdgeInsets.all(24),
          actionsPadding: const EdgeInsets.all(0),
          buttonPadding: const EdgeInsets.all(0),
          title: SizedBox(
            width: size.width,
            child: Column(
              children: [
                Text(
                  selectedIndex == 1
                      ? "Looking for clients"
                      : "Find instants clients",
                  style: const TextStyle(
                    color: themeblackcolor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    setState(
                      () {
                        selectedIndex = 1;
                        Timer(
                          const Duration(seconds: 3),
                          () {
                            Navigator.pop(context);
                            mendedRequest(size);
                          },
                        );
                      },
                    );
                  },
                  child: selectedIndex == 1
                      ? Column(
                          children: const [
                            CircularProgressIndicator(
                              color: themelightgreenshade2color,
                              backgroundColor: themelightgreencolor,
                            ),
                          ],
                        )
                      : Container(
                          height: 70,
                          width: size.width / 100 * 40,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/images/png/mender-button-small.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Find Clients",
                              style: TextStyle(
                                color: themewhitecolor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

  Future<Object?> mendedRequest(size) {
    log("Current User: ${FirebaseAuth.instance.currentUser!.uid}");
    Stream<List<CallModel>> filter_mender_sessions() => FirebaseFirestore
        .instance
        .collection(Database.callColl)
        .where("receiverId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("status", isEqualTo: 0)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CallModel.fromJson(doc.data()))
            .toList());
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
          title: StreamBuilder<List<CallModel>>(
            stream: filter_mender_sessions(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong! ${snapshot.error}');
              } else if (snapshot.hasData) {
                final menderRequest = snapshot.data!;
                return menderRequest.isEmpty
                    ? Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        
                        Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: IconButton(onPressed: (){
                        
                            Navigator.pop(context);
                          }, icon: const Icon(Icons.cancel,size: 25,)),
                        ),
                          Image.asset(
                            "assets/images/png/problem.png",
                            height: 200,
                            width: 200,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Center(
                            child: Text("No Clients available right now!",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                        ],
                      )
                    : SizedBox(
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
                                FutureBuilder<String>(
                                    future: userImageGet(
                                      menderRequest[0].callerId,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        String getD = snapshot.data!;
                                        return CircleAvatar(
                                          radius: 25,
                                          backgroundImage: NetworkImage(
                                            (getD != "")
                                                ? getD
                                                : "https://img.freepik.com/free-vector/cute-rabbit-holding-carrot-cartoon-vector-icon-illustration-animal-nature-icon-isolated-flat_138676-7315.jpg?w=2000",
                                          ),
                                        );
                                      } else {
                                        return const CircleAvatar(
                                          radius: 25,
                                          backgroundImage: NetworkImage(
                                            "https://img.freepik.com/free-vector/cute-rabbit-holding-carrot-cartoon-vector-icon-illustration-animal-nature-icon-isolated-flat_138676-7315.jpg?w=2000",
                                          ),
                                        );
                                      }
                                    }),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder<String>(
                                        future: userNameGet(
                                          menderRequest[0].callerId,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            String getD = snapshot.data!;
                                            return Text(
                                              getD,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          } else {
                                            return const Text(
                                              "",
                                              style: TextStyle(
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
                                      "${menderRequest[0].duration} minutes session / ${menderRequest[0].deductCoins} Tokens",
                                      style: const TextStyle(
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
                            Text(
                              menderRequest[0].message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
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
                                    FirebaseFirestore.instance
                                        .collection(Database.callColl)
                                        .where('callerId',
                                            isEqualTo:
                                                menderRequest[0].callerId)
                                        .where("status", isEqualTo: 0)
                                        .get()
                                        .then((value) {
                                      final post = Provider.of<CallPro>(context,
                                          listen: false);
                                      if (value.docs.isEmpty) {
                                        post.createCall(
                                            menderRequest[0].duration,
                                            menderRequest[0].message,
                                            menderRequest[0].deductCoins,
                                            menderRequest[0].callerId,
                                            context);
                                      } else {
                                        post.joinCall(
                                            value.docs[0]['callData'],
                                            menderRequest[0].callerId,
                                            menderRequest[0].deductCoins,
                                            context);
                                      }
                                    });
                                  },
                                  buttonSize: const Size(120, 40),
                                  buttoncolor: Palette.themecolor,
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
        ),
      ),
    );
  }
}

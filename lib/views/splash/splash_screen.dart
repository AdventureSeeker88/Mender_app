import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mender/provider/auth_pro.dart';
import 'package:mender/route/go_router.dart';
import 'package:mender/route/navigator.dart';
import 'package:mender/service/notification_service.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/utils/database.dart';
import 'package:mender/utils/path.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  String messageTitle = "Empty";
  String notificationAlert = "alert";
  NotificationServices notificationServices = NotificationServices();
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    final post = Provider.of<AuthPro>(context, listen: false);
    post.getmyData();
    Timer(const Duration(seconds: 3), () async{
      FirebaseAuth.instance.idTokenChanges();
      notificationServices.getDeviceToken().then((value) {
        post.updatetoken(value);
      });
      WidgetsBinding.instance.addObserver(this);
      await setStatus(true);
      // userIsLoggedInFunc(context);
      Go.namedreplace(context, Routes.navbar);

      // islogin(context);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus(true);
    } else {
      setStatus(false);
    }
  }

   setStatus(bool status) async {
    try {
      FirebaseFirestore.instance
          .collection(Database.auth)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'onlineStatus': status ? "online" : "offline"});
    } catch (e) {
      debugPrint("Catch Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            Assets.menderBackground,
            fit: BoxFit.cover,
            width: size.width,
            // height: size.height,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.menderLogo,
                ),
                const Text(
                  "Mender",
                  style: TextStyle(
                    color: Palette.themecolor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

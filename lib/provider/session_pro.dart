import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mender/model/calender/session_model.dart';
import 'package:mender/utils/database.dart';
import 'package:mender/widgets/dailog.dart';
import 'package:mender/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'notification_pro.dart';

class SessionPro with ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  String cleintId = "";
  changeCleintId(id) {
    cleintId = id;
    notifyListeners();
  }

  addSession(Timestamp sessionDate, Timestamp sessionEndDate, title, startTime,
      endTime, repeat, context) async {
    log("---> $sessionDate");
    log("---> $sessionEndDate");
    log("---> $title");
    log("---> $startTime");
    log("---> $endTime");
    log("---> $repeat");

    showCircularLoadDialog(context);
    String id = const Uuid().v4();
    bool result = await firestore
        .collection(Database.session)
        .doc(id)
        .set(
          SessionModel(
                  id: id,
                  uid: auth.currentUser!.uid,
                  cleintId: cleintId,
                  title: title,
                  sessionDate: sessionDate,
                  sessionEndDate: sessionEndDate,
                  startTime: startTime,
                  endTime: endTime,
                  sessionType: repeat,
                  dateTime: Timestamp.now())
              .toJson(),
        )
        .then((value) async {
      customToast("Session Create Successfully", context);
      // --SEND SMS NOTIFICATION
      log("cleintId: ${cleintId}");
      await sendNotificationToUser(
          cleintId,
          "Created a session on ${DateFormat.yMEd().format(sessionDate.toDate())} - ${DateFormat.yMEd().format(sessionEndDate.toDate())}",
          context);
      cleintId = "";

      return true;
    }).onError((error, stackTrace) {
      customToast(error.toString(), context);
      return false;
    });

    if (result) {
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

// -- SEND NOTIFICATION TO USER
  sendNotificationToUser(opisterid, message, context) async {
    String token =
        await firestore.collection("auth").doc(opisterid).get().then((value) {
      return value.data()!['token'];
    });
    String senderName = await firestore
        .collection("auth")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      return value.data()!['name'];
    });
    final post = Provider.of<NotificationPro>(context, listen: false);
    debugPrint("sendNotification");
    log("token: $token");
    log("opisterid: $opisterid");
    post.sendNotification(
        senderName,
        message,
        {
          'senderId': FirebaseAuth.instance.currentUser!.uid,
          'receiverId': opisterid,
          'type': 'mendedtomender'
        },
        token);
  }
}

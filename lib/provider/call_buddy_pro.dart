import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mender/model/call/call_m.dart';
import 'package:mender/provider/notification_pro.dart';
import 'package:mender/route/navigator.dart';
import 'package:mender/utils/database.dart';
import 'package:mender/views/call/audio_call_screen.dart';
import 'package:mender/views/call/buddy_call_screen.dart';
import 'package:provider/provider.dart';

class CallBuddyPro with ChangeNotifier {
  // calltype 0 - audio, 1 - video

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  bool isCallLoading = false;

  void createCall(receiverId, context) async {
    isCallLoading = true;
    notifyListeners();


    log("createCall");
    log("receiverId: $receiverId");
    Map callData = await generateToken();
    CallModel model = CallModel(
      duration: 0,
      message: "",
      deductCoins: 0,
      callerId: auth.currentUser!.uid,
      receiverId: receiverId,
      callData: callData,
      join: [auth.currentUser!.uid],
      dateTime: Timestamp.now(),
      status: 0,
      channelId: callData['channelId'],
      audio: [],
      camera: [],callType: 1

    );

    firestore
        .collection(Database.callBuddy)
        .doc(callData['channelId'])
        .set(model.toJson())
        .then((value) async {
      log(callData.toString());
  isCallLoading = false;
      notifyListeners();
      Go.route(context, BuddyCallScreen(callData: callData));
      await sendNotificationToUser(receiverId, "Is calling you.", context);
    });
  }

  void joinCall(Map callData, String callerId, context) {
     isCallLoading = true;
    notifyListeners();
    log("joinCall");
    log("callerId: $callerId");

    firestore.collection(Database.callBuddy).doc(callData['channelId']).update({
      'join': FieldValue.arrayUnion([auth.currentUser!.uid])
    }).then((value) async {
isCallLoading = false;
      notifyListeners();
      log("auth.currentUser!.uid: ${auth.currentUser!.uid}");
      Go.route(context, BuddyCallScreen(callData: callData));
    });
  }

  void enableCamera(bool type, Map callData) {
    FirebaseFirestore.instance
        .collection(Database.callBuddy)
        .doc(callData['channelId'])
        .update({
      'camera': type
          ? FieldValue.arrayUnion([auth.currentUser!.uid])
          : FieldValue.arrayRemove([auth.currentUser!.uid]),
    }).then((value) {});
  }

  void setCallStatus(Map callData) {
    FirebaseFirestore.instance
        .collection(Database.callBuddy)
        .doc(callData['channelId'])
        .update({
      'status': 1,
    }).then((value) {});
  }

  generateToken() async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://us-central1-my-kashmir-7c12f.cloudfunctions.net/createCallsWithTokens"),
        headers: {
          "content-type": "application/json",
        },
        body: jsonEncode({'data': {}}),
      );

      if (response.statusCode == 200) {
        var decodedData = json.decode(response.body.toString());

        Map callData = decodedData["result"]['data'];
        return callData;
      }
    } catch (e) {
      debugPrint("exception $e");
      return {'error': '$e'};
    }

    notifyListeners();
  }

  //
  Stream<List<CallModel>> getBuddyChatStream(uid) => FirebaseFirestore.instance
      .collection(Database.callBuddy)
      .where('callerId', isEqualTo: uid)
      .where("status", isEqualTo: 0)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((document) => CallModel.fromJson(document.data()))
          .toList());

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
          'type': 'mendertomender'
        },
        token);
  }



  
  //AUDIO CALL SECTION
  bool isAudioCallLoading = false;
  void createAudioCall(receiverId, context) async {
    isAudioCallLoading = true;
    notifyListeners();

    log("createCall");
    log("receiverId: $receiverId");
    Map callData = await generateToken();
    CallModel model = CallModel(
        duration: 0,
        message: "",
        deductCoins: 0,
        callerId: auth.currentUser!.uid,
        receiverId: receiverId,
        callData: callData,
        join: [auth.currentUser!.uid],
        dateTime: Timestamp.now(),
        status: 0,
        channelId: callData['channelId'],
        audio: [],
        camera: [],
        callType: 0,);

    firestore
        .collection(Database.callBuddy)
        .doc(callData['channelId'])
        .set(model.toJson())
        .then((value) async {
      isAudioCallLoading = false;
      notifyListeners();
      log(callData.toString());

      Go.route(context, AudioCallScreen(callData: callData));
      await sendNotificationToUser(receiverId, "Is calling you.", context);
    });
  }

  void joinAudioCall(Map callData, String callerId, context) {
    log("joinCall");
    log("callerId: $callerId");

    firestore.collection(Database.callBuddy).doc(callData['channelId']).update({
      'join': FieldValue.arrayUnion([auth.currentUser!.uid])
    }).then((value) async {
      log("auth.currentUser!.uid: ${auth.currentUser!.uid}");
      Go.route(context, AudioCallScreen(callData: callData));
    });
  }
}

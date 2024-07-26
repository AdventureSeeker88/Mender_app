import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mender/model/call/call_m.dart';
import 'package:mender/route/navigator.dart';
import 'package:mender/utils/database.dart';
import 'package:mender/views/call/new_call_screen.dart';

class CallPro with ChangeNotifier {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  void createCall(int duration, String message, int deductCoins, receiverId,
      context) async {
    log("createCall");
    log("receiverId: $receiverId");
    Map callData = await generateToken();
    CallModel model = CallModel(
      duration: duration,
      message: message,
      deductCoins: deductCoins,
      callerId: auth.currentUser!.uid,
      receiverId: receiverId,
      callData: callData,
      join: [auth.currentUser!.uid],
      dateTime: Timestamp.now(),
      status: 0,
      channelId: callData['channelId'],
      audio: [],
      camera: [],
      callType: 1
    );

    firestore
        .collection("call-coll")
        .doc(callData['channelId'])
        .set(model.toJson())
        .then((value) async {
      // //fetching mender coins and then deducting 
      // await firestore
      //     .collection(Database.auth)
      //     .doc(receiverId)
      //     .get()
      //     .then((value) async {
      //   if (value.exists) {
      //     //charging user coins
      //     final mendedCoins = value.data()!["coin"].toString();
      //     int coinsDeduction = int.parse(mendedCoins) - deductCoins;
      //     log("coinsDeduction: $coinsDeduction");
      //     firestore
      //         .collection(Database.auth)
      //         .doc(receiverId)
      //         .update({'coin': coinsDeduction});
      //   }
      // });

      log(callData.toString());
      Go.route(context, NewCallScreen(callData: callData));
    });
  }

  void joinCall(Map callData, String callerId, int deductCoins, context) {
    log("joinCall");
    log("callerId: $callerId");
    log("deductCoins: $deductCoins");
    firestore.collection("call-coll").doc(callData['channelId']).update({
      'join': FieldValue.arrayUnion([auth.currentUser!.uid])
    }).then((value) async {
      // //fetching mender coins and then deducting
      // await firestore
      //     .collection(Database.auth)
      //     .doc(callerId)
      //     .get()
      //     .then((value) async {
      //   if (value.exists) {
      //     //charging user coins
      //     final mendedCoins = value.data()!["coin"].toString();
      //     int coinsDeduction = int.parse(mendedCoins) - deductCoins;
      //     log("coinsDeduction: $coinsDeduction");
      //     firestore
      //         .collection(Database.auth)
      //         .doc(callerId)
      //         .update({'coin': coinsDeduction});
      //   }
      // });
      

      log("auth.currentUser!.uid: ${auth.currentUser!.uid}");
      Go.route(context, NewCallScreen(callData: callData));
    });
  }

  void enableCamera(bool type, Map callData) {
    FirebaseFirestore.instance
        .collection("call-coll")
        .doc(callData['channelId'])
        .update({
      'camera': type
          ? FieldValue.arrayUnion([auth.currentUser!.uid])
          : FieldValue.arrayRemove([auth.currentUser!.uid]),
    }).then((value) {});
  }

  void setCallStatus(Map callData) {
    FirebaseFirestore.instance
        .collection("call-coll")
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
}

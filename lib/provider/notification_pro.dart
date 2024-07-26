import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mender/model/notification_model.dart';
import 'package:uuid/uuid.dart';

class NotificationPro with ChangeNotifier {
  final auth = FirebaseAuth.instance.currentUser;
  final firebase = FirebaseFirestore.instance;

  void SendMessage(msg, data) async {
    print("SendMessage");
    firebase.collection("auth").doc(auth!.uid).get().then((value) {
      print("sendNotification");
      print(value.data());
      sendNotification(
        value.data()!['name'],
        msg,
        {},
        value.data()!['token'],
      );
    });
  }

  void sendNotification(title, des, data, token) async {
    var body = {
      'to': token,
      'priority': 'high',
      'notification': {
        'title': title,
        'body': des,
      },
      'android': {
        'notification': {
          'channel_id': 'com.therapist.mender',
        },
      },
      'data': data,
    };

    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAPGT3-7c:APA91bFtJedUTbUfT5nuyq1NNBf6ssud0JLbwFd1ws4C-CS6zQ6tCEih4C9mrDGw80hdf5jAMd-ToiDiKOHJdhH2-7VrGHOJXeVHLjGM8SKEvn2a-cdRDEdZpwvUXjUCkep7rLcEZFyp',
        });
  }

  sendNotificationbulk(
    title,
    des,
    Map data,
    List token,
    List uidlist,
  ) async {
    print(title);
    print(des);
    print(data);
    print(token);
    print(uidlist);
    savefirebase(
      title,
      des,
      data,
      uidlist,
    );
    for (int i = 0; i < token.length; i++) {
      var body = {
        'to': token[i],
        'priority': 'high',
        'notification': {
          'title': title,
          'body': des,
        },
        'android': {
          'notification': {
            'channel_id': 'com.therapist.mender',
          },
        },
        'data': data,
      };

      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(body),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAPGT3-7c:APA91bEv8NtQJbttP_-mpVa7jc3IEyK66Aw1jQUy2phjh9FmPSfDUXXjVn7YUare4ltOE43fU_t1-8xw4Szo4FWE3OHc1UgtzCBJU3K71dxBzpHWJrP91WQVyLtuFk22LnS0utohBnoV',
          }).then((value) {
        print("value.toString()");
        print(value.body.toString());
      });
    }
  }

  void savefirebase(title, description, Map data, List receiverId) {
    var notifyId = const Uuid().v4();
    NotificationM model = NotificationM(
      senderId: auth!.uid,
      notifyId: notifyId,
      title: title,
      description: description,
      data: data,
      receiverId: receiverId,
      seenId: [],
      status: 0,
      dateTime: Timestamp.now(),
    );
    FirebaseFirestore.instance.collection("notification").doc(notifyId).set(
          model.toJson(),
        );
  }

  void addseen(notifyId) {
    FirebaseFirestore.instance.collection("notification").doc(notifyId).update({
      'seenId': FieldValue.arrayUnion([auth!.uid])
    });
  }
}

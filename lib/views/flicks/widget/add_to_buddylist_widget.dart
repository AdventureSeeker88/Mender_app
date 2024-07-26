import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mender/model/auth_model.dart';
import 'package:mender/provider/auth_pro.dart';
import 'package:mender/utils/path.dart';
import 'package:provider/provider.dart';

class AddtoBuddyListWidget extends StatefulWidget {
  final String menderUid;

  const AddtoBuddyListWidget({
    super.key,
    required this.menderUid,
  });

  @override
  State<AddtoBuddyListWidget> createState() => _AddtoBuddyListWidgetState();
}

class _AddtoBuddyListWidgetState extends State<AddtoBuddyListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthM>(
        stream: filterCurrentUser(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;

            return IconButton(
              onPressed: () {

                Provider.of<AuthPro>(context, listen: false)
                    .addMendertoBuddy( userData.buddyList.contains(widget.menderUid)? false: true, widget.menderUid);
              },
              icon: Image.asset(
                userData.buddyList.contains(widget.menderUid)
                    ? Assets.addSupported
                    : Assets.addSupporter,
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

Stream<AuthM> filterCurrentUser(String userUid) {
  return FirebaseFirestore.instance
      .collection('auth')
      .doc(userUid)
      .snapshots()
      .map((snapshot) => AuthM.fromJson(snapshot.data() ?? {}));
}

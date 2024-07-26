import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:mender/model/comment_model.dart';
import 'package:mender/model/flicks_model.dart';
import 'package:mender/utils/database.dart';
import 'package:mender/views/flicks/dialog/report_confirmation_widget.dart';
import 'package:mender/widgets/dailog.dart';
import 'package:uuid/uuid.dart';

class FlicksPro with ChangeNotifier {

  //flicks type = 0 - Mended
  //flicks type = 1 - Mender

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  void flicksLike(int value, id) {
    firestore.collection(Database.flicks).doc(id).update({
      'like': value == 0
          ? FieldValue.arrayUnion([auth.currentUser!.uid])
          : FieldValue.arrayRemove([auth.currentUser!.uid])
    });
  }


  void flickCommentReportFunc( id, commentId, context) {
    
       firestore.collection(Database.flicks).doc(id)
        .collection(Database.comment)
        .doc(commentId)
        .update({
      'reportedUids': FieldValue.arrayUnion([auth.currentUser!.uid])
    }).then((value) {
        Navigator.pop(context);

      reportConfirmationDialog(context);
      notifyListeners();
    });
  }

  updateFlicks(id, json) async {
    await firestore.collection(Database.flicks).doc(id).update(json);
  }

  addViews(id) {
    updateFlicks(id, {
      'views': FieldValue.arrayUnion([auth.currentUser!.uid])
    });
  }

  void AddFlicks(description, hashtags, file_video, context) async {
    try {
      showCircularLoadDialog(context);
      String id = const Uuid().v1();
      var imagefile = FirebaseStorage.instance
          .ref()
          .child("reels/video/")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(id);
      UploadTask task = imagefile.putFile(file_video!);
      TaskSnapshot snapshot = await task;
      String url = await snapshot.ref.getDownloadURL();

      var flicksId = const Uuid().v4();
      FlicksModel model = FlicksModel(
          id: flicksId,
          uid: auth.currentUser!.uid,
          video: url,
          caption: description,
          hashtags: hashtags,
          like: [],
          views: [],
          comment: 0,
          type: 1, // type 1 for mender
          status: 0,
          dateTime: Timestamp.now(),
          shares: 0);

      firestore
          .collection(Database.flicks)
          .doc(flicksId)
          .set(model.toJson())
          .then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
      }).onError((error, stackTrace) {
        Navigator.pop(context);
      });
    } catch (e) {
      Navigator.pop(context);
    }
  }

  void postComment(
    String text,
    String id,
  ) async {
    var commentId = const Uuid().v1();
    CommentModel model = CommentModel(
      uid: auth.currentUser!.uid,
      text: text,
      like: [],
      reportedUids: [],
      id: commentId,
      refid: id,
      status: 0,
      dateTime: Timestamp.now(),
    );

    firestore
        .collection(Database.flicks)
        .doc(id)
        .collection(Database.comment)
        .doc(commentId)
        .set(model.toJson());
    updateFlicks(id, {
      'comment': FieldValue.increment(1),
    });
  }

  void commentLike(int value, id, commentId) {
    firestore
        .collection(Database.flicks)
        .doc(id)
        .collection(Database.comment)
        .doc(commentId)
        .update({
      'like': value == 0
          ? FieldValue.arrayUnion([auth.currentUser!.uid])
          : FieldValue.arrayRemove([auth.currentUser!.uid])
    });
  }

  Future<List<DocumentSnapshot>> getFlicksByUserId(id) async {
    return await firestore
        .collection(Database.flicks)
        .where('uid', isEqualTo: id)
        .orderBy(
          'dateTime',
          descending: true,
        )
        .get()
        .then((value) {
      return value.docs;
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class ReportProblemModel {
  final String id;
  final String uid;
  final String image;
  final String message;
  final int status;
  final Timestamp dateTime;

  const ReportProblemModel({
    required this.id,
    required this.uid,
    required this.image,
    required this.message,
    required this.status,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'image': image,
        'message': message,
        'status': status,
        'dateTime': dateTime,
      };
  static ReportProblemModel fromJson(Map<String, dynamic> json) =>
      ReportProblemModel(
        id: json['id'] ?? '',
        uid: json['uid'] ?? '',
        image: json['image'] ?? '',
        message: json['message'] ?? '',
        status: json['status'] ?? '',
        dateTime: json['dateTime'] ?? '',
      );
  static ReportProblemModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ReportProblemModel(
      id: snapshot["id"],
      uid: snapshot["uid"],
      image: snapshot["image"],
      message: snapshot["message"],
      status: snapshot["status"],
      dateTime: snapshot["dateTime"],
    );
  }
}

import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mender/helper/storage_methods.dart';
import 'package:mender/model/auth_model.dart';
import 'package:mender/model/call/call_m.dart';
import 'package:mender/model/report_problem_model.dart';
import 'package:mender/route/go_router.dart';
import 'package:mender/route/navigator.dart';
import 'package:mender/utils/database.dart';
import 'package:mender/widgets/dailog.dart';
import 'package:mender/widgets/toast.dart';
import 'package:uuid/uuid.dart';

class AuthPro with ChangeNotifier {
  //type = 0 : Mended
  //type = 1 : Mender
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  void loginFun(email, password, BuildContext context) async {
    String errorMessage = "";
    showCircularLoadDialog(context);
    bool exits = await firestore
        .collection(Database.auth)
        .where('email', isEqualTo: email)
        .where('type', isEqualTo: 1)
        .get()
        .then((value) {
      return value.docs.isEmpty ? false : true;
    });

    if (exits) {
      try {
        await auth.signInWithEmailAndPassword(
            email: email.toString(), password: password.toString());
        getmyData();
        log("User Logged In.................");
        // ignore: use_build_context_synchronously
        // Navigator.pop(context);
        // Go.namedreplace(context, Routes.splash);
        context.pushNamed(
          Routes.splash,
        );
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "invalid-credential":
            errorMessage = "Your email or password is invalid.";
            break;
          case "ERROR_INVALID_EMAIL":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "ERROR_USER_NOT_FOUND":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "ERROR_USER_DISABLED":
            errorMessage = "User with this email has been disabled.";
            break;
          case "email-already-in-use":
            errorMessage = "This Email is Already Taken.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests. Try again later.";
            break;

          case "ERROR_OPERATION_NOT_ALLOWED":
            errorMessage = "Signing in with Email and Password is not enabled.";

            break;
          case "INVALID_LOGIN_CREDENTIALS":
            errorMessage = "Signing in with Email and Password is not valid.";

            break;

          default:
            errorMessage = "An undefined Error happened.";
        }
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        customToast(errorMessage, context);
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      customToast("These Account Doesn't Exist", context);
    }
  }

  void signupFun(String name, String aboutDoctor, String email, String password,
      String bio, BuildContext context) async {
    String errorMessage = "";
    try {
      showCircularLoadDialog(context);
      UserCredential cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      AuthM model = AuthM(
        uid: cred.user!.uid,
        chargeCoins: 1,
        image: "",
        name: name,
        bio: bio,
        aboutDoctor: aboutDoctor,
        email: email,
        dateTime: Timestamp.now(),
        type: 1,
        buddyList: [],
        supporterList: [],
        blockList: [],
        views: 0,
        category: [],
        token: "",
        status: 0,
        license: "",
        onlineStatus: "Online",
        coin: 0,
      );
      await firestore
          .collection(Database.auth)
          .doc(
            cred.user!.uid,
          )
          .set(model.toJson())
          .then((value) async {
        // getmyData();
        Navigator.pop(context);
        Go.namedreplace(context, Routes.splash);
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "email-already-in-use":
          errorMessage = "This Email is Already Taken.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Navigator.pop(context);
      customToast(errorMessage, context);
    }
  }

  void forgotPassword(email, context) async {
    try {
      log("email: $email");
      showCircularLoadDialog(context);
      firestore
          .collection(Database.auth)
          .where('email', isEqualTo: email)
          .where('type', isEqualTo: 1)
          .get()
          .then(
        (value) async {
          if (value.docs.isNotEmpty) {
            await auth.sendPasswordResetEmail(
              email: email,
            );
            Navigator.pop(context);

            successfullyDailog(context,
                "The Password Recovery mail has been sent to your email");
          } else {
            Navigator.pop(context);
            customToast("There isn't any user with this email adress", context);
          }
        },
      );
    } catch (e) {
      debugPrint("Catch Exception: $e");
    }
  }

  Map myUserdata = {};
  getmyData() async {
    await firestore
        .collection(Database.auth)
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) {
      myUserdata = value.data() ?? {};
      print(myUserdata);
      notifyListeners();
    });
    notifyListeners();
  }

  void updatetoken(token) {
    firestore
        .collection('auth')
        .doc(auth.currentUser!.uid)
        .update({'token': token});
  }

  Future<AuthM> getUserById(id) async {
    return await firestore
        .collection(Database.auth)
        .doc(id)
        .get()
        .then((value) {
      AuthM result = AuthM.fromSnap(value);
      return result;
    });
  }

  updateAuth(id, json) async {
    await firestore.collection(Database.auth).doc(id).update(json);
  }

  void addBuddy(bool add, bool notify, id) async {
    await updateAuth(auth.currentUser!.uid, {
      'buddyList': add == true
          ? FieldValue.arrayUnion([id])
          : FieldValue.arrayRemove([id]),
    });
    getmyData();
  }

  void addSupporter(bool add, bool notify, id) async {
    await updateAuth(id, {
      'supporterList': add == true
          ? FieldValue.arrayUnion([auth.currentUser!.uid])
          : FieldValue.arrayRemove([auth.currentUser!.uid]),
    });
    getmyData();
  }

  void addMendertoBuddy(bool isAdd, id) async {
    log("currentUid: ${auth.currentUser!.uid}");
    await updateAuth(auth.currentUser!.uid, {
      'buddyList':
          isAdd ? FieldValue.arrayUnion([id]) : FieldValue.arrayRemove([id]),
    });
    getmyData();
  }

  void blockUser(bool add, id) async {
    await updateAuth(auth.currentUser!.uid, {
      'blockList': add == true
          ? FieldValue.arrayUnion([id])
          : FieldValue.arrayRemove([id]),
    });
    getmyData();
  }

  Stream<List<AuthM>> get_my_profile(uid) => FirebaseFirestore.instance
      .collection('auth')
      .where("uid", isEqualTo: uid)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((document) => AuthM.fromJson(document.data()))
          .toList());
  
  updateAuthUserImage(id, Uint8List image) async {
    String url = await StorageMethods()
        .uploadImageToStoragee('mender/profiles/', image, true);
    await updateAuth(id, {'image': url});
  }

  updateMenderLicenseImage(id, Uint8List image) async {
    String url = await StorageMethods()
        .uploadImageToStoragee('mender/license/', image, true);
    await updateAuth(id, {'license': url});
  }

  profileUpdateFunc(String name, bio, String aboutDoc, Uint8List? image,
      Uint8List? licenseImage, id, context) async {
    showCircularLoadDialog(context);
    if (image != null) {
      await updateAuthUserImage(
        id,
        image,
      );
    }
    if (licenseImage != null) {
      await updateMenderLicenseImage(
        id,
        licenseImage,
      );
    }
    await updateAuth(id, {
      'name': name,
      'bio': bio,
      'aboutDoctor': aboutDoc,
    });
    Navigator.pop(context);
    Navigator.pop(context);
    customToast("Profile Updated Successfully", context);
  }

  // -- USER CHANGE PASSWORD FUNCTION
  userChangePasswordFunc(oldPassword, newPassword, BuildContext context) async {
    try {
      showCircularLoadDialog(context);

      await firestore
          .collection(Database.auth)
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) async {
        if (value.exists) {
          final mender = value.data()!["email"].toString();
          log("mender: $mender");

          var cred = EmailAuthProvider.credential(
              email: mender, password: oldPassword);
          await auth.currentUser!
              .reauthenticateWithCredential(cred)
              .then((value) async {
            debugPrint("Value >>>> $value");
            await auth.currentUser!
                .updatePassword(newPassword)
                .then((value) async {
              await auth.signOut();
              Navigator.pop(context);
              Navigator.pop(context);

              context.replaceNamed(Routes.splash);
            });
          }).catchError((error) {
            Navigator.pop(context);
            customToast("Please Enter your correct Old Password", context);
          });
        }
      });
    } catch (e) {
      debugPrint("Catch Exception: $e");
    }
  }

  // -- REPORT A PROBLEM FUNCTION

  doReportFunc(Uint8List? pickimage, String message, context) async {
    showCircularLoadDialog(context);

    var id = const Uuid().v4();
    String url = "";
    if (pickimage != null) {
      url = await StorageMethods()
          .uploadImageToStoragee('mended/report/', pickimage, true);
    }

    await firestore
        .collection(Database.problemReport)
        .doc(id)
        .set(
          ReportProblemModel(
            id: id,
            uid: auth.currentUser!.uid,
            image: url,
            message: message,
            status: 0,
            dateTime: Timestamp.now(),
          ).toJson(),
        )
        .then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      Navigator.pop(context);

      customToast(error.toString(), context);
    });
  }

  logoutFunc(BuildContext context) async {
    try {
      await firestore
          .collection(Database.auth)
          .doc(
            auth.currentUser!.uid,
          )
          .update({'token': ""}).then((value) {
        FirebaseAuth.instance.signOut();
        context.pushNamed(
          Routes.splash,
        );
      });
    } catch (e) {
      debugPrint("Catch Exception: $e");
    }
  }


  
  // -- SIGNING WITH GOOGLE --
  void signinWithGoogle(BuildContext context) async {
    showCircularLoadDialog(context);
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    FirebaseAuth.instance.signInWithCredential(credential).then(
      (cred) async {
        bool exists = await FirebaseFirestore.instance
            .collection(Database.auth)
            .doc(cred.user!.uid)
            .get()
            .then(
          (value) {
            return value.exists;
          },
        );
        if (exists) {
          log("already have account");
          Navigator.pop(context);
          // Go.namedreplace(
          //   context,
          //   Routes.onboarding,
          // );
           context.pushNamed(
          Routes.splash,
        );
        } else {
        
          AuthM model = AuthM(
            uid: cred.user!.uid,
            chargeCoins: 1,
            image: "",
            name: "",
            bio: "I am using Mender",
            aboutDoctor: "",
            email: "",
            dateTime: Timestamp.now(),
            type: 1,
            buddyList: [],
            supporterList: [],
            blockList: [],
            views: 0,
            category: ["Anxiety"],
            token: "",
           license: "",
            status: 0,
            onlineStatus: "Online",
            coin: 0,
          );
          await firestore
              .collection(Database.auth)
              .doc(
                cred.user!.uid,
              )
              .set(model.toJson())
              .then((value) async {
            getmyData();
            log("account created");

            Navigator.pop(context);
            // Go.namedreplace(
            //   context,
            //   Routes.onboarding,
            // );

             context.pushNamed(
          Routes.splash,
        );
          });
        }
      },
    );
  }

}

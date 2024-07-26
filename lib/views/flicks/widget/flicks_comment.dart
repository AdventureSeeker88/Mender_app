import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:mender/helper/time.dart';
import 'package:mender/model/auth_model.dart';
import 'package:mender/model/comment_model.dart';
import 'package:mender/provider/auth_pro.dart';
import 'package:mender/provider/flicks_pro.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/utils/database.dart';
import 'package:mender/views/flicks/dialog/flicks_comment_report_type_dialog.dart';
import 'package:mender/widgets/custom_icon_button.dart';
import 'package:mender/widgets/shimer.dart';
import 'package:provider/provider.dart';

class FlicksCommentScreen extends StatefulWidget {
  final String id;
  const FlicksCommentScreen({super.key, required this.id});

  @override
  State<FlicksCommentScreen> createState() => _FlicksCommentScreenState();
}

class _FlicksCommentScreenState extends State<FlicksCommentScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: SizedBox(
        height: size.height / 100 * 70,
        child: Scaffold(
          backgroundColor: themegreencolor,
          bottomNavigationBar: Container(
            height: 120,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/png/bottom-nav-bar.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: commentEditingController,
                            style: const TextStyle(color: themewhitecolor),
                            decoration: InputDecoration(
                                hintText: "Add Comment",
                                hintStyle: const TextStyle(
                                  color: themewhitecolor,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: themewhitecolor,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        CustomIconButton(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              final post = Provider.of<FlicksPro>(context,
                                  listen: false);
                              post.postComment(
                                commentEditingController.text,
                                widget.id,
                              );
                              commentEditingController.clear();
                            }
                          },
                          child: const Icon(
                            Icons.send_outlined,
                            color: themewhitecolor,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  themelightgreencolor.withOpacity(0.2),
                  themelightgreencolor.withOpacity(0.4),
                  themegreencolor.withOpacity(0.6),
                  themegreencolor.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.4, 0.8, 1],
              ),
            ),
            child: Center(
              child: StreamBuilder<List<CommentModel>>(
                stream: filterComments(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong! ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final commentslistdata = snapshot.data!;
                    if (commentslistdata.isEmpty) {
                      return Center(
                        child: Image.asset(
                          "assets/images/png/no-comments.png",
                          height: 250,
                          width: 250,
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${commentslistdata.length} comments",
                                    style: const TextStyle(
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
                          const Divider(
                            height: 40,
                            color: themewhitecolor,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: ListView.separated(
                                itemCount: commentslistdata.length,
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final model = commentslistdata[index];
                                  return FutureBuilder<AuthM>(
                                      future: Provider.of<AuthPro>(context,
                                              listen: false)
                                          .getUserById(model.uid),
                                      builder: ((context, snapshot) {
                                        if (snapshot.hasData) {
                                          AuthM auth = snapshot.data!;

                                          return Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomCircleAvtar(
                                                  url: auth.image,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            auth.name,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  themewhitecolor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            timeAgo(
                                                                model.dateTime),
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  themegreycolor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                     
                                                      ( model.reportedUids.contains(FirebaseAuth.instance.currentUser!.uid))?
                                                      Text(
                                                        "Comment is hidden!",
                                                        style: const TextStyle(
                                                          color:
                                                              themegreytextcolor,
                                                          fontSize: 16,
                                                        ),
                                                      ):  Text(
                                                        model.text,
                                                        style: const TextStyle(
                                                          color:
                                                              themewhitecolor,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      ( model.reportedUids.contains(FirebaseAuth.instance.currentUser!.uid))? SizedBox(): 
                                                       Row(
                                                        children: [
                                                          CustomIconButton(
                                                            onTap: () {
                                                              if (model.like.contains(
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid)) {
                                                                final post =
                                                                    Provider.of<
                                                                            FlicksPro>(
                                                                        context,
                                                                        listen:
                                                                            false);
                                                                post.commentLike(
                                                                    1,
                                                                    model.refid,
                                                                    model.id);
                                                              } else {
                                                                final post =
                                                                    Provider.of<
                                                                            FlicksPro>(
                                                                        context,
                                                                        listen:
                                                                            false);
                                                                post.commentLike(
                                                                    0,
                                                                    model.refid,
                                                                    model.id);
                                                              }
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  model.like.contains(FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid)
                                                                      ? "assets/images/png/reel-liked.png"
                                                                      : "assets/images/png/reel-like.png",
                                                                  width: 28,
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  model.like
                                                                      .length
                                                                      .toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    color:
                                                                        themewhitecolor,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          InkWell(
                                                             onTap: (){


                                                              flicksCommentReportTypeDialog( widget.id, model.id, context, size);
                                                           
                                                            },
                                                            child: Column(children: [
                                                          Image.asset(
                                                              "assets/images/png/report.png",
                                                              width: 28,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            const Text(
                                                              "Report",
                                                              style: TextStyle(
                                                                color:
                                                                    themewhitecolor,
                                                              ),
                                                            ),
                                                            ],),
                                                          )
                                                          
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }));
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider(
                                    color: themewhitecolor,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
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
        ),
      ),
    );
  }

  Stream<List<CommentModel>> filterComments() => FirebaseFirestore.instance
      .collection(Database.flicks)
      .doc(widget.id)
      .collection(Database.comment)
      // .orderBy('DateTime', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => CommentModel.fromJson(doc.data()))
          .toList());
}
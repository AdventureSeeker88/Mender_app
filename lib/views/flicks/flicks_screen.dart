import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mender/model/auth_model.dart';
import 'package:mender/model/flicks_model.dart';
import 'package:mender/provider/auth_pro.dart';
import 'package:mender/provider/flicks_pro.dart';
import 'package:mender/route/go_router.dart';
import 'package:mender/route/navigator.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/utils/database.dart';
import 'package:mender/utils/path.dart';
import 'package:mender/views/flicks/widget/add_supported_button.dart';
import 'package:mender/views/flicks/widget/add_to_buddylist_widget.dart';
import 'package:mender/views/flicks/widget/flicks_comment.dart';
import 'package:mender/views/flicks/widget/video_widget.dart';
import 'package:mender/widgets/shimer.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class FlicksScreen extends StatefulWidget {
  const FlicksScreen({Key? key}) : super(key: key);

  @override
  State<FlicksScreen> createState() => _FlicksScreenState();
}

class _FlicksScreenState extends State<FlicksScreen> {
  int limit = 2;
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();

    _pageController.addListener(_scrollListner);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _scrollListner() {
    if (_pageController.position.pixels ==
        _pageController.position.maxScrollExtent) {
      setState(() {
        filter(
          limit++,
        );
      });
    } else {}
  }

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(11),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(profilePhoto),
                  fit: BoxFit.cover,
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<FlicksModel>>(
          stream: filter(limit),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final listdata = snapshot.data!;

              if (snapshot.data!.isEmpty) {
                return const Text("No Flicks Available for mender");
              } else {
                return PageView.builder(
                    pageSnapping: true,
                    itemCount: snapshot.data!.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final data = listdata[index];
                      log("Flicks: ${data.type}");
                      log("Flicks: ${data.id}");

                      return FutureBuilder<AuthM>(
                          future: Provider.of<AuthPro>(context, listen: false)
                              .getUserById(data.uid),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              AuthM auth = snapshot.data!;
                              return Stack(
                                children: [
                                  FlicksVideoWidget(
                                    videoUrl: data.video,
                                    play: true,
                                    id: data.id,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        left: 25,
                                        right: 25,
                                        bottom: 40),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const Spacer(),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      child: CustomCircleAvtar(
                                                        url: auth.image,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      auth.name,
                                                      style: const TextStyle(
                                                        color: themewhitecolor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  width: size.width / 100 * 70,
                                                  child: Text(
                                                    data.caption,
                                                    style: const TextStyle(
                                                      color: themewhitecolor,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                             
                                                data.uid ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                    ? SizedBox()
                                                    : AddtoBuddyListWidget(
                                                        menderUid: data.uid),

                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    final post =
                                                        Provider.of<FlicksPro>(
                                                            context,
                                                            listen: false);
                                                    if (data.like.contains(
                                                        FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)) {
                                                      post.flicksLike(
                                                        1,
                                                        data.id,
                                                      );
                                                    } else {
                                                      post.flicksLike(
                                                        0,
                                                        data.id,
                                                      );
                                                    }
                                                  },
                                                  icon: data.like.contains(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                  )
                                                      ? Image.asset(
                                                          Assets.likedButton)
                                                      : Image.asset(
                                                          Assets.likeButton,
                                                        ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data.like.length.toString(),
                                                  style: const TextStyle(
                                                    color: themewhitecolor,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .vertical(
                                                          top: Radius.circular(
                                                              25),
                                                        ),
                                                      ),
                                                      context: context,
                                                      builder: (context) =>
                                                          StatefulBuilder(
                                                        builder: (context,
                                                                setState) =>
                                                            FlicksCommentScreen(
                                                          id: data.id,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  icon: Image.asset(
                                                    Assets.commentButton,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data.comment.toString(),
                                                  style: const TextStyle(
                                                    color: themewhitecolor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    await Share.share(
                                                        "${data.id}\n\n${data.caption}");
                                                  },
                                                  icon: Image.asset(
                                                    Assets.shareButton,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          }));
                    });
              }
            } else {
              return const Center();
            }
          },
        ),
      ),
    );
  }

  Stream<List<FlicksModel>> filter(limit1) => FirebaseFirestore.instance
      .collection(
        Database.flicks,
      )
      .where("type", isEqualTo: 1)

      // .limit(limit1)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => FlicksModel.fromJson(doc.data()))
          .toList());
}
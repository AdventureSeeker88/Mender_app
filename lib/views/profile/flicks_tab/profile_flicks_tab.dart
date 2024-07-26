
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mender/model/flicks_model.dart';
import 'package:mender/provider/flicks_pro.dart';
import 'package:mender/route/navigator.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/views/flicks/widget/video_widget.dart';
import 'package:provider/provider.dart';

import '../../../route/go_router.dart';

class FlicksTab extends StatefulWidget {
  final String id;
  const FlicksTab({super.key, required this.id});

  @override
  State<FlicksTab> createState() => _FlicksTabState();
}

class _FlicksTabState extends State<FlicksTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: Provider.of<FlicksPro>(context, listen: false)
          .getFlicksByUserId(widget.id),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            itemCount: snapshot.data!.length,
            primary: false,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
            ),
            itemBuilder: (context, index) {
              var model = FlicksModel.fromSnap(snapshot.data![index]);
              return InkWell(
                onTap: () {
                
                Go.named(context, Routes.viewProfileFlicks, {
                'page_index': index.toString(),
                'currentUid': FirebaseAuth.instance.currentUser!.uid,
              });
              
                },
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    FlicksVideoWidget(
                      videoUrl: model.video,
                      play: false,
                      id: model.id,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.play_arrow_outlined,
                            color: themewhitecolor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            model.views.length.toString(),
                            style: const TextStyle(color: themewhitecolor),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        } else {
          return Container();
        }
      }),
    );
  }
}

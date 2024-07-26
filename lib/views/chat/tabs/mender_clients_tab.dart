import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mender/helper/time.dart';
import 'package:mender/model/auth_model.dart';
import 'package:mender/model/chat/chatting_model.dart';
import 'package:mender/provider/auth_pro.dart';
import 'package:mender/route/go_router.dart';
import 'package:mender/route/navigator.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/utils/future.dart';
import 'package:mender/views/chat/chating_screen.dart';
import 'package:provider/provider.dart';

class MenderClientsTab extends StatefulWidget {
  const MenderClientsTab({super.key});

  @override
  State<MenderClientsTab> createState() => _MenderClientsTabState();
}

class _MenderClientsTabState extends State<MenderClientsTab> {
  TextEditingController searchcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Column(
          //     children: [
          //       SizedBox(
          //         height: 45,
          //         child: TextField(
          //           controller: searchcontroller,
          //           decoration: InputDecoration(
          //             prefixIcon: const Icon(
          //               Icons.search,
          //               color: Palette.themecolor,
          //             ),
          //             hintText: "Search",
          //             hintStyle: const TextStyle(
          //               color: Palette.themecolor,
          //               fontSize: 18,
          //             ),
          //             enabledBorder: OutlineInputBorder(
          //               borderSide: const BorderSide(
          //                 color: Palette.themecolor,
          //               ),
          //               borderRadius: BorderRadius.circular(12),
          //             ),
          //             focusedBorder: OutlineInputBorder(
          //               borderSide: const BorderSide(
          //                 color: Palette.themecolor,
          //               ),
          //               borderRadius: BorderRadius.circular(12),
          //             ),
          //             contentPadding: const EdgeInsets.all(8),
          //           ),
          //           onChanged: (value) {
          //             print(value);
          //             setState(() {
          //               filterUsers(searchcontroller.text);
          //             });
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder<List<general_message_model>>(
              stream: filter_chats(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final chatModel = snapshot.data!;
                  return chatModel.isEmpty
                      ? Container()
                      : ListView.builder(
                                itemCount: chatModel.length,
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final _model = chatModel[index];
                                  return  FutureBuilder<AuthM>(
                          future: Provider.of<AuthPro>(context, listen: false)
                              .getUserById(FirebaseAuth.instance
                                                      .currentUser!.uid ==
                                                  _model.sender_id
                                              ? _model.reciver_id
                                              : _model.sender_id,),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              final authdata = snapshot.data!;
                              log("authdata: ${authdata.type}");
                           
                              return authdata.type == 0?   ListTile(
                                    onTap: () {
                                      Go.named(
                                        context,
                                        Routes.chatScreen,
                                        {
                                          'id': FirebaseAuth.instance
                                                      .currentUser!.uid ==
                                                  _model.sender_id
                                              ? _model.reciver_id
                                              : _model.sender_id,
                                                  'type': "0",
                                        },
                                      );
                                    },
                                    minVerticalPadding: 0,
                                    leading: FutureBuilder<String>(
                                        future: userImageGet(
                                          FirebaseAuth.instance.currentUser!
                                                      .uid ==
                                                  _model.sender_id
                                              ? _model.reciver_id
                                              : _model.sender_id,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            String Datara = snapshot.data!;
                                            return 
                                            
                                            
                                            (Datara != "")
                                                ? CircleAvatar(
                                                    backgroundColor:
                                                        themelightgreencolor,
                                                    radius: 30,
                                                    backgroundImage:
                                                        NetworkImage(Datara))
                                                : const CircleAvatar(
                                                    backgroundColor:
                                                        themelightgreencolor,
                                                    radius: 30,
                                                    backgroundImage: AssetImage(
                                                        "assets/images/png/hand-6.png"));
                                          } else {
                                            return const CircleAvatar(
                                              backgroundColor:
                                                  themelightgreencolor,
                                              radius: 30,
                                            );
                                          }
                                        }),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FutureBuilder<String>(
                                            future: userNameGet(
                                              FirebaseAuth.instance.currentUser!
                                                          .uid ==
                                                      _model.sender_id
                                                  ? _model.reciver_id
                                                  : _model.sender_id,
                                            ),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                String Datara = snapshot.data!;
                                                return Text(
                                                  Datara,
                                                  style: const TextStyle(
                                                    color: themeblackcolor,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            }),
                                        Text(
                                          timeAgo(_model.date_time),
                                          style: const TextStyle(
                                            color: themegreycolor,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        _model.last_message,
                                        style: const TextStyle(
                                          color: themegreycolor,
                                        ),
                                      ),
                                    ),
                                  ): SizedBox();
                               
                            } else {
                              return const SizedBox();
                            }
                          }));
                                  
                                  
                                  
                                  
                                  
                               
                               
                                },


                              );
                           
                           
                      
                      
                      
                    
                } else {
                  return Container();
                }
              })
        ],
      ),
    );
  }

  Stream<List<general_message_model>> filter_chats() =>
      FirebaseFirestore.instance
          .collection("chats")
          .where('uid_list',
              arrayContainsAny: [FirebaseAuth.instance.currentUser!.uid])
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => general_message_model.fromJson(doc.data()))
              .toList());
  Stream<List<general_message_model>> filterchatssearch(uid) =>
      FirebaseFirestore.instance
          .collection("chats")
          // .where('uid_list', arrayContains: [auth.currentUser!.uid, uid])
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => general_message_model.fromJson(doc.data()))
              .toList());
  Stream<List<AuthM>> filterUsers(search) => FirebaseFirestore.instance
      .collection('auth')
      .where('username', isGreaterThanOrEqualTo: search)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((document) => AuthM.fromJson(document.data()))
          .toList());
}

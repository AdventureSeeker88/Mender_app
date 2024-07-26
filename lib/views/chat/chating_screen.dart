import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mender/helper/pick_image.dart';
import 'package:mender/model/auth_model.dart';
import 'package:mender/model/call/call_m.dart';
import 'package:mender/model/chat/InnerMessageModel.dart';
import 'package:mender/model/chat/chatting_model.dart';
import 'package:mender/provider/auth_pro.dart';
import 'package:mender/provider/call_buddy_pro.dart';
import 'package:mender/provider/chat_pro.dart';
import 'package:mender/route/navigator.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/utils/database.dart';
import 'package:mender/utils/id.dart';
import 'package:mender/widgets/custom_icon_button.dart';
import 'package:provider/provider.dart';

class ChattingScreen extends StatefulWidget {
  final String id;
  final String type;

  const ChattingScreen({
    super.key,
    required this.id,
    required this.type,
  });

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    availableChatUser(widget.id, true);
    super.initState();
  }

  @override
  void dispose() {
    availableChatUser(widget.id, false);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      availableChatUser(widget.id, true);
    } else {
      availableChatUser(widget.id, false);
    }
  }

  void availableChatUser(oppisterUid, bool condition) {
    FirebaseFirestore.instance
        .collection("chats")
        .doc(
          get_chat_id(
            FirebaseAuth.instance.currentUser!.uid,
            oppisterUid,
          ),
        )
        .update({
      'availableUser': condition
          ? FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
          : FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
    });
  }

  TextEditingController _msg_controller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  Uint8List? _image;

  bool isBuddyCallingFunc(uid) {
    FirebaseFirestore.instance
        .collection(Database.callBuddy)
        .where('callerId', isEqualTo: uid)
        .where("status", isEqualTo: 0)
        .get()
        .then((value) {
      final post = Provider.of<CallBuddyPro>(context, listen: false);
      if (value.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themewhitecolor,
              themewhitecolor,
              themewhitecolor,
              themebackgroundbottomcolor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    StreamBuilder<List<AuthM>>(
                        stream: Provider.of<AuthPro>(context)
                            .get_my_profile(widget.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                'Something went wrong! ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            final datamodel = snapshot.data!;
                            final model = datamodel[0];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                children: [
                                  CustomIconButton(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(
                                      Icons.arrow_back_ios,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Palette.themecolor,
                                    backgroundImage: NetworkImage(
                                      model.image,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        model.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                  const Spacer(),

 //CALLING
                                  widget.type == "1"
                                      ? StreamBuilder<List<CallModel>>(
                                          stream: Provider.of<CallBuddyPro>(
                                                  context)
                                              .getBuddyChatStream(widget.id),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Something went wrong! ${snapshot.error}');
                                            } else if (snapshot.hasData) {
                                              final datamodel = snapshot.data!;
                                              if (datamodel.isEmpty) {
                                                return Consumer<CallBuddyPro>(
                                                    builder: ((context,
                                                        modelValue, child) {
                                                  return Row(
                                                    children: [
                                                    //audio
                                                   modelValue
                                                          .isAudioCallLoading
                                                      ? const SpinKitThreeBounce(
                                                          size: 25,
                                                          color:
                                                              Palette.themecolor,
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child:
                                                              CustomIconButton(
                                                            onTap: () {
                                                              final post =
                                                                  Provider.of<
                                                                          CallBuddyPro>(
                                                                      context,
                                                                      listen:
                                                                          false);
                                                              post.createAudioCall(
                                                                  model.uid,
                                                                  context);
                                                            },
                                                            child: const Icon(
                                                              CupertinoIcons
                                                                  .phone,
                                                              color:
                                                                   Palette.themecolor,
                                                              size: 25,
                                                            ),
                                                          ),
                                                        ),
                                                    
                                                    
                                                      //video
                                                      modelValue.isCallLoading
                                                          ? const SpinKitThreeBounce(
                                                              size: 25,
                                                              color:
                                                                  Palette.themecolor,
                                                            )
                                                          : CustomIconButton(
                                                              onTap: () {
                                                                final post =
                                                                    Provider.of<
                                                                            CallBuddyPro>(
                                                                        context,
                                                                        listen:
                                                                            false);
                                                                post.createCall(
                                                                    model.uid,
                                                                    context);
                                                              },
                                                              child: const Icon(
                                                                CupertinoIcons
                                                                    .video_camera,
                                                                color:
                                                                     Palette.themecolor,
                                                                size: 35,
                                                              ),
                                                            )
                                                   
                                                   
                                                   
                                                    ],
                                                  );
                                                }));
                                              } else {
                                                return Consumer<CallBuddyPro>(
                                                    builder: ((context,
                                                        modelValue, child) {
                                                  return Row(
                                                    children: [


                                                    //audio calling
                                                    datamodel[0].callType == 0?
                                                    modelValue
                                                          .isAudioCallLoading
                                                      ? const SpinKitThreeBounce(
                                                          size: 25,
                                                          color:
                                                               Palette.themecolor,
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            final post = Provider
                                                                .of<CallBuddyPro>(
                                                                    context,
                                                                    listen:
                                                                        false);

                                                            post.joinAudioCall(
                                                                datamodel[0]
                                                                    .callData,
                                                                model.uid,
                                                                context);
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                color:
                                                                     Palette.themecolor),
                                                            child: Row(
                                                              children: const [
                                                                Icon(
                                                                  CupertinoIcons
                                                                      .phone,
                                                                  color: themewhitecolor,
                                                                  size: 35,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  "Join Audio Call",
                                                                  style: TextStyle(
                                                                      color: themewhitecolor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ):SizedBox(),

                                                      //video calling
                                                      datamodel[0].callType == 1?    modelValue.isCallLoading
                                                          ? const SpinKitThreeBounce(
                                                              size: 25,
                                                              color:
                                                                   Palette.themecolor,
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                final post =
                                                                    Provider.of<
                                                                            CallBuddyPro>(
                                                                        context,
                                                                        listen:
                                                                            false);

                                                                post.joinCall(
                                                                    datamodel[0]
                                                                        .callData,
                                                                    model.uid,
                                                                    context);
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25),
                                                                    color:
                                                                         Palette.themecolor,),
                                                                child: Row(
                                                                  children: const [
                                                                    Icon(
                                                                      CupertinoIcons
                                                                          .video_camera,
                                                                      color: themewhitecolor,
                                                                      size: 35,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      "Join Call",
                                                                      style: TextStyle(
                                                                          color: themewhitecolor,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                   
                                                   :SizedBox()
                                                    ],
                                                  );
                                                }));
                                              }
                                            }

                                            return Container();
                                          })
                                      : const SizedBox(),


                              
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 80.0),
                          child: messages(),
                        ),
                      ),
                    ),
                  ],
                ),
                BottomWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget BottomWidget() {
    return Form(
      key: _formkey,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: TextFormField(
          controller: _msg_controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: themewhitecolor,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            alignLabelWithHint: true,
            prefixIcon: IconButton(
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    actions: [
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        onPressed: () async {
                          Uint8List file = await pickImage(ImageSource.gallery);
                          _image = file;
                          if (_image != null) {
                            final post =
                                Provider.of<ChatPro>(context, listen: false);

                            post.send_image(widget.id, _image!, context);

                            Navigator.pop(context);
                          }
                        },
                        child: Row(
                          children: const [
                            Icon(
                              CupertinoIcons.photo,
                              color: themeblackcolor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                color: themeblackcolor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.add,
                color: Palette.themecolor,
              ),
            ),
            hintText: "Write your message here..",
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomIconButton(
                onTap: () {
                  if (_formkey.currentState!.validate()) {
                    final post = Provider.of<ChatPro>(context, listen: false);

                    post.send_text_message(
                        widget.id, _msg_controller.text, context);
                    _msg_controller.clear();
                  }
                },
                child: const CircleAvatar(
                  backgroundColor: Palette.themecolor,
                  child: Icon(
                    Icons.send,
                    color: themewhitecolor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "";
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget messages() {
    return StreamBuilder<List<inner_message_model>>(
        stream: filter_chats(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final model = snapshot.data!;
            return ListView.builder(
                primary: false,
                shrinkWrap: true,
                reverse: true,
                itemCount: model.length,
                itemBuilder: ((context, index) {
                  final _model = model[index];
                  return _model.type == 0
                      ? text_messages(
                          _model.sender_id ==
                              FirebaseAuth.instance.currentUser!.uid,
                          _model.msg,
                          _model.date_time,
                          _model.seen,
                          _model.message_id,
                          model.length,
                          index,
                        )
                      : _model.type == 1
                          ? image_widget(
                              _model.sender_id ==
                                  FirebaseAuth.instance.currentUser!.uid,
                              _model.msg,
                              index)
                          : Container();
                }));
          } else {
            return Container();
          }
        });
  }

  Widget text_messages(
    bool isMe,
    text,
    Timestamp datetime,
    List seen,
    message_id,
    int length,
    int index,
  ) {
    if (seen.length == 1) {
      final post = Provider.of<ChatPro>(context, listen: false);
      post.addseen(widget.id, message_id);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: isMe
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Palette.themecolor.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: themeblackcolor,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: themegreycolor.withOpacity(0.4),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: themeblackcolor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget image_widget(bool isMe, text, index) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: InkWell(
        onTap: () {
          Go.route(context, Image.network(text));
        },
        child: isMe
            ? Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: size.width / 100 * 50,
                  padding: const EdgeInsets.symmetric(
                    vertical: 120,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(text),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: size.width / 100 * 50,
                    padding: const EdgeInsets.symmetric(
                      vertical: 150,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(text),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  index == (0)
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    final post = Provider.of<ChatPro>(context,
                                        listen: false);

                                    post.send_text_message(
                                        widget.id, "🧡", context);
                                  },
                                  child: const Text(
                                    "🧡",
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final post = Provider.of<ChatPro>(context,
                                        listen: false);

                                    post.send_text_message(
                                        widget.id, "👍", context);
                                  },
                                  child: const Text(
                                    "👍",
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final post = Provider.of<ChatPro>(context,
                                        listen: false);

                                    post.send_text_message(
                                        widget.id, "😂", context);
                                  },
                                  child: const Text(
                                    "😂",
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final post = Provider.of<ChatPro>(context,
                                        listen: false);

                                    post.send_text_message(
                                        widget.id, "😍", context);
                                  },
                                  child: const Text(
                                    "😍",
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final post = Provider.of<ChatPro>(context,
                                        listen: false);

                                    post.send_text_message(
                                        widget.id, "😡", context);
                                  },
                                  child: const Text(
                                    "😡",
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container()
                ],
              ),
      ),
    );
  }

  Stream<List<inner_message_model>> filter_chats() => FirebaseFirestore.instance
      .collection("chats")
      .doc(get_chat_id(widget.id, FirebaseAuth.instance.currentUser!.uid))
      .collection("messages")
      .orderBy('date_time', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => inner_message_model.fromJson(doc.data()))
          .toList());

  Stream<List<general_message_model>> filtergeneralchats() => FirebaseFirestore
      .instance
      .collection("chats")
      .where('chat_id',
          isEqualTo:
              get_chat_id(widget.id, FirebaseAuth.instance.currentUser!.uid))
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => general_message_model.fromJson(doc.data()))
          .toList());
}

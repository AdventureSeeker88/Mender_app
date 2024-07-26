

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:mender/model/call/call_m.dart';
import 'package:mender/provider/call_buddy_pro.dart';
import 'package:mender/provider/call_pro.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/utils/database.dart';
import 'package:mender/utils/future.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class BuddyCallScreen extends StatefulWidget {
  final Map callData;
  const BuddyCallScreen({super.key, required this.callData});

  @override
  State<BuddyCallScreen> createState() => _BuddyCallScreenState();
}

class _BuddyCallScreenState extends State<BuddyCallScreen> {
  String appId = "153bef51a0554ce9a89019a7747e6d37";

  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  late RtcEngine _engine;

  @override
  void dispose() {
    // clear users
    _users.clear();
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    // destroy sdk
    await _engine.leaveChannel();
    await _engine.destroy();
  }

  @override
  void initState() {
    super.initState();
    customCameraOepnFunc();
    initialize();
    // initialize agora sdk
  }

  var controller;
  //custom camera
  customCameraOepnFunc() async {
    try {
      final cameras = await availableCameras(); // Get list of available cameras
      final camera = cameras.first; //Select first camera from list

      controller = CameraController(
        camera,
        ResolutionPreset.medium,
      );

      await controller.initialize();
    } on CameraException catch (e) {
      if (e.code == 'CameraAccessDenied') {
        // Handle camera access denial...
      }
      if (e.code == 'CameraAccessRestricted') {
        // Handle camera access restriction...
      }
    }
  }
  //

  Future<void> initialize() async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    if (appId.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = const VideoDimensions(width: 1920, height: 1080);
    ChannelMediaOptions options = ChannelMediaOptions(
      autoSubscribeAudio: true,
      autoSubscribeVideo: true,
      publishLocalAudio: true,
      publishLocalVideo: true,
    );

    await _engine.setVideoEncoderConfiguration(configuration);

    await _engine.joinChannel(
        widget.callData['token'], widget.callData['channelId'], null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appId);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (ClientRole.Broadcaster == ClientRole.Broadcaster) {
      list.add(const RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(
        channelId: widget.callData['channelId'], uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget videoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Row(
      children: wrappedViews,
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        );
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    if (ClientRole.Broadcaster == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return const Text(
                    "null"); // return type can't be null, a widget was required
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    setState(() {
      _users.clear();
      _dispose();
    });
    final post = Provider.of<CallBuddyPro>(context, listen: false);
    post.setCallStatus(widget.callData);
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
    // _engine.muteLocalVideoStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<List<CallModel>>(
          stream: callStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final callModel = snapshot.data!;
              final views = _getRenderViews();

              return callModel.isEmpty
                  ? sessionCreate()
                  : views.length == 1
                      ? connectingCall(callModel[0])
                      : Stack(
                          children: [
                            callModel[0].camera.contains(
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            callModel[0].receiverId
                                        ? callModel[0].callerId
                                        : callModel[0].receiverId)
                                ? Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          "assets/images/png/fondo.png",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            themeblackcolor.withOpacity(0.3),
                                            themeblackcolor.withOpacity(0.4),
                                            themeblackcolor.withOpacity(0.6),
                                            themeblackcolor.withOpacity(0.8),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: const [0, 0.4, 0.8, 1],
                                        ),
                                      ),
                                    ),
                                  )
                                : videoRow([views[1]]),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(
                                  height: 120,
                                ),
                                Center(
                                  child: Text(
                                    callModel[0].camera.contains(FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid ==
                                                callModel[0].receiverId
                                            ? callModel[0].callerId
                                            : callModel[0].receiverId)
                                        ? "Camera Off"
                                        : "",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: themewhitecolor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FutureBuilder<String>(
                                                future: userNameGet(
                                                  FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid ==
                                                          callModel[0]
                                                              .receiverId
                                                      ? callModel[0].callerId
                                                      : callModel[0].receiverId,
                                                ),
                                                builder: ((context, snapshot) {
                                                  String get =
                                                      snapshot.data ?? "";
                                                  return Text(
                                                    get,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      color: themewhitecolor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  );
                                                })),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: size.width / 100 * 40,
                                              child: const Text(
                                                "Licensed Professional Counselor, PHD, LPC",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: themewhitecolor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                           
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      callModel[0].camera.contains(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          ? Container(
                                              height: 120,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                              child: const Icon(
                                                Icons.videocam_off_outlined,
                                                color: themewhitecolor,
                                              ),
                                            )
                                          : Container(
                                              height: 120,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: videoRow([views[0]]),
                                            ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                bottomBar(callModel[0]),
                              ],
                            ),
                          ],
                        );
            } else {
              return Container();
            }
          }),
    );
  }

  Widget sessionCreate() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/png/fondo.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  themeblackcolor.withOpacity(0.3),
                  themeblackcolor.withOpacity(0.4),
                  themeblackcolor.withOpacity(0.6),
                  themeblackcolor.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.4, 0.8, 1],
              ),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.all(50.0),
                child: CupertinoActivityIndicator(
                  radius: 30,
                  color: themelightgreenshade2color,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Please wait for a creating session',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: themegreytextcolor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget connectingCall(CallModel model) {
    String opisterId = "";
    if (FirebaseAuth.instance.currentUser!.uid == model.callerId) {
      opisterId = model.receiverId;
    } else {
      opisterId = model.callerId;
    }
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/png/fondo.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  themeblackcolor.withOpacity(0.3),
                  themeblackcolor.withOpacity(0.4),
                  themeblackcolor.withOpacity(0.6),
                  themeblackcolor.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.4, 0.8, 1],
              ),
            ),
          ),
        ),
              SizedBox(
            
            height: MediaQuery.of(context).size.height,
            
            child: CameraPreview(controller)),
        Column(
          children: [
            const SizedBox(
              height: 120,
            ),
            FutureBuilder<String>(
              future: userImageGet(opisterId),
              builder: ((context, snapshot) {
                String get = snapshot.data ?? "";
                return CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(get),
                );
              }),
            ),
            FutureBuilder<String>(
              future: userNameGet(opisterId),
              builder: ((context, snapshot) {
                String get = snapshot.data ?? "";
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      get,
                      style: const TextStyle(
                        fontSize: 24,
                        color: themewhitecolor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Connecting",
              style: TextStyle(
                fontSize: 16,
                color: themewhitecolor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Spacer(),
            bottomBar(model),
          ],
        ),
      ],
    );
  }

  Widget bottomBar(CallModel model) {
    final formKey = GlobalKey<FormState>();
    TextEditingController messageController = TextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: const BoxDecoration(
        // color: themeblackcolor.withOpacity(0.5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        gradient: LinearGradient(
          colors: [
            themelightgreencolor,
            themegreencolor,
            themegreencolor,
            themegreencolor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 0.4, 0.8, 1],
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: themegreycolor,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: themewhitecolor.withOpacity(0.5),
                child: const Icon(
                  Icons.add,
                  color: themewhitecolor,
                  size: 28,
                ),
              ),
              InkWell(
                onTap: _onToggleMute,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: themewhitecolor.withOpacity(0.5),
                  child: Icon(
                    muted ? Icons.mic_off : Icons.mic,
                    color: themewhitecolor,
                    size: 28,
                  ),
                ),
              ),
              InkWell(
                onTap: () => _onCallEnd(context),
                child: const CircleAvatar(
                  radius: 25,
                  backgroundColor: themeredcolor,
                  child: Icon(
                    Icons.call_end,
                    color: themewhitecolor,
                    size: 28,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  bool type = false;
                  if (model.camera
                      .contains(FirebaseAuth.instance.currentUser!.uid)) {
                    type = false;
                  } else {
                    type = true;
                  }
                  final post = Provider.of<CallBuddyPro>(context, listen: false);
                  post.enableCamera(type, widget.callData);
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: themewhitecolor.withOpacity(0.5),
                  child: Icon(
                    model.camera
                            .contains(FirebaseAuth.instance.currentUser!.uid)
                        ? Icons.videocam_off_outlined
                        : Icons.videocam_outlined,
                    color: themewhitecolor,
                    size: 28,
                  ),
                ),
              ),
              InkWell(
                onTap: _onSwitchCamera,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: themewhitecolor.withOpacity(0.5),
                  child: const Icon(
                    Icons.cameraswitch,
                    color: themewhitecolor,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
         
       
        ],
      ),
    );
  }

  Stream<List<CallModel>> callStream() => FirebaseFirestore.instance
      .collection(Database.callBuddy)
      .where('channelId', isEqualTo: widget.callData['channelId'])
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((document) => CallModel.fromJson(document.data()))
          .toList());
}

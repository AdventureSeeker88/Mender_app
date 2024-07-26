import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/widgets/custom_icon_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareProfileScreen extends StatefulWidget {
  const ShareProfileScreen({super.key});

  @override
  State<ShareProfileScreen> createState() => _ShareProfileScreenState();
}

class _ShareProfileScreenState extends State<ShareProfileScreen> {
  shareLinkFunc(
    String type,
    String url,
  ) async {
    var platformType = type;
    var platformLink = url;

    var platformAndroid = Uri.parse("$platformType:$platformLink");
    if (await canLaunchUrl(platformAndroid)) {
      await launchUrl(platformAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to open url"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themegreencolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      CustomIconButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: themewhitecolor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        "Share Profile",
                        style: TextStyle(
                          color: themewhitecolor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/png/share.png",
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "Share",
                  style: TextStyle(
                    color: themewhitecolor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: "dripping",
                  ),
                ),
                const Text(
                  "Share for a chance to win a token",
                  style: TextStyle(
                    color: themegreycolor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),

                GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: socialmediamodel.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      // mainAxisSpacing: 20,
                      // crossAxisSpacing: 20,
                      // mainAxisExtent: 230,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          if (index == 0) {
                            shareLinkFunc(
                              "whatsapp",
                              "send?phone=03959965150&text=Mended Application",
                            );
                          } else if (index == 1) {
                            //  SocialShare.shareWhatsapp("Mended Application");
                            shareLinkFunc("https", "messenger.com");
                          } else if (index == 2) {
                            //  SocialShare.shareFacebookStory(appId: appId)

                            shareLinkFunc("https", "facebook.com");
                          } else if (index == 3) {
                            shareLinkFunc("https", "instagram.com");
                          } else if (index == 4) {
                            shareLinkFunc("https", "tiktok.com");
                          } else if (index == 5) {
                            shareLinkFunc("https", "twitter.com");
                          } else if (index == 6) {
                            shareLinkFunc("https", "telegram.org");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            children: [
                              Image.asset(
                                socialmediamodel[index].image,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                socialmediamodel[index].title,
                                style: const TextStyle(
                                  color: themewhitecolor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Divider(
                    color: themegreycolor,
                  ),
                ),

                //other types

                const SizedBox(
                  height: 20,
                ),
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: 4,
                  primary: false,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (index == 1) {
                          //  FlutterClipboard.copy(getPropertyLinkShare +
                          //                                           modelValue.dPropertyUrl)
                          //                                       .then((value) {
                          //                                     ScaffoldMessenger.of(context)
                          //                                         .showSnackBar(const SnackBar(
                          //                                             content: Text("Link Copied")));
                          // });

                        }
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: themewhitecolor,
                            child: CircleAvatar(
                              radius: 23,
                              backgroundColor: themelightgreencolor,
                              child: optionsmodel[index].icon,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            optionsmodel[index].title,
                            style: const TextStyle(
                              color: themewhitecolor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SocialMediaModels {
  final String image;
  final String title;
  SocialMediaModels({
    required this.image,
    required this.title,
  });
}

List<SocialMediaModels> socialmediamodel = [
  SocialMediaModels(
    image: "assets/images/png/WhatsApp.png",
    title: "Whatsapp",
  ),
  SocialMediaModels(
    image: "assets/images/png/Facebook-Messenger.png",
    title: "Messenger",
  ),
  SocialMediaModels(
    image: "assets/images/png/Facebook.png",
    title: "Facebook",
  ),
  SocialMediaModels(
    image: "assets/images/png/Instagram.png",
    title: "Instagram",
  ),
  SocialMediaModels(
    image: "assets/images/png/TikTok.png",
    title: "Tiktok",
  ),
  SocialMediaModels(
    image: "assets/images/png/Twitter.png",
    title: "Twitter",
  ),
  SocialMediaModels(
    image: "assets/images/png/Telegram.png",
    title: "Telegram",
  ),
];

class OptionsModels {
  final Icon icon;
  final String title;
  OptionsModels({required this.icon, required this.title});
}

List<OptionsModels> optionsmodel = [
  OptionsModels(
    icon: const Icon(
      Icons.flag,
      color: themegreycolor,
    ),
    title: "Report",
  ),
  OptionsModels(
    icon: const Icon(
      CupertinoIcons.link,
      color: themegreycolor,
    ),
    title: "Copy Link",
  ),
  OptionsModels(
    icon: const Icon(
      CupertinoIcons.eye_slash_fill,
      color: themegreycolor,
    ),
    title: "Not interested",
  ),
  OptionsModels(
    icon: const Icon(
      Icons.sticky_note_2_rounded,
      color: themegreycolor,
    ),
    title: "Create Sticker",
  ),
];

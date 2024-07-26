import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/widgets/custom_icon_button.dart';
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: themewhitecolor,
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
                    Padding(
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
                          const CircleAvatar(
                            backgroundColor: Palette.themecolor,
                            backgroundImage: NetworkImage(
                              "https://img.freepik.com/free-vector/cute-rabbit-holding-carrot-cartoon-vector-icon-illustration-animal-nature-icon-isolated-flat_138676-7315.jpg?w=2000",
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Magicwhirl Star",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Online",
                                style: TextStyle(
                                  color: Palette.themecolor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          CustomIconButton(
                            onTap: () {},
                            child: const Icon(
                              CupertinoIcons.phone,
                              color: Palette.themecolor,
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          CustomIconButton(
                            onTap: () {},
                            child: const Icon(
                              CupertinoIcons.video_camera,
                              color: Palette.themecolor,
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: messages(),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TextFormField(
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
                      label: IntrinsicHeight(
                        child: Row(
                          children: [
                            CustomIconButton(
                              onTap: () {},
                              child: const Icon(
                                Icons.add,
                                color: Palette.themecolor,
                              ),
                            ),
                            const VerticalDivider(
                              width: 25,
                            ),
                            const Text(
                              "Write your message here..",
                            ),
                          ],
                        ),
                      ),
                      hintText: "Write your message here..",
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomIconButton(
                          onTap: () {},
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget messages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text("Today"),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                "https://hips.hearstapps.com/hmg-prod/images/portrait-of-a-happy-young-doctor-in-his-clinic-royalty-free-image-1661432441.jpg?crop=0.66698xw:1xh;center,top&resize=1200:*",
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              width: 250,
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
              child: const Text(
                "Hello, How may i help you today?",
                style: TextStyle(
                  color: themeblackcolor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
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
            child: const Text(
              "I need therapy",
              style: TextStyle(
                color: themeblackcolor,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                "https://hips.hearstapps.com/hmg-prod/images/portrait-of-a-happy-young-doctor-in-his-clinic-royalty-free-image-1661432441.jpg?crop=0.66698xw:1xh;center,top&resize=1200:*",
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                  child: const Text(
                    "I can help you",
                    style: TextStyle(
                      color: themeblackcolor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
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
                  child: const Text(
                    "Tell me how you feel",
                    style: TextStyle(
                      color: themeblackcolor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        const Center(
          child: Text("Yesterday, 24, 2023"),
        ),
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 100,
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
            child: Stack(
              alignment: Alignment.center,
              children: const [
                Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    CupertinoIcons.waveform_path,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: themewhitecolor,
                    child: Icon(
                      CupertinoIcons.play_fill,
                      color: Palette.themecolor,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                "https://hips.hearstapps.com/hmg-prod/images/portrait-of-a-happy-young-doctor-in-his-clinic-royalty-free-image-1661432441.jpg?crop=0.66698xw:1xh;center,top&resize=1200:*",
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                  child: const Text(
                    "Hi, That's alright",
                    style: TextStyle(
                      color: themeblackcolor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: themegreycolor.withOpacity(0.4),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: const [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            CupertinoIcons.waveform_path,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: themewhitecolor,
                            child: Icon(
                              CupertinoIcons.play_fill,
                              color: Palette.themecolor,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
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
                  child: const Text(
                    "Ok! let's have a session",
                    style: TextStyle(
                      color: themeblackcolor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

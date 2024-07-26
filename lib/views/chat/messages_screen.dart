import 'package:flutter/material.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/views/chat/tabs/mender_buddies_tab.dart';
import 'package:mender/views/chat/tabs/mender_clients_tab.dart';
import 'package:mender/widgets/custom_icon_button.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    CustomIconButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: themeblackcolor,
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Messages",
                        style: TextStyle(
                          color: themeblackcolor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                color: Palette.themecolor.withOpacity(0.1),
                child: TabBar(
                  controller: tabController,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide.none,
                  ),
                  labelColor: Palette.themecolor,
                  unselectedLabelColor: Palette.themecolor.withOpacity(0.5),
                  tabs: const [
                    Tab(
                      text: "Mender Buddies",
                    ),
                    Tab(
                      text: "Clients",
                    ),
                  ],
                ),
              ),
               Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    MenderBuddiesTab(),
                   MenderClientsTab()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mender/model/auth_model.dart';
import 'package:mender/model/cleint_model.dart';
import 'package:mender/provider/auth_pro.dart';
import 'package:mender/route/go_router.dart';
import 'package:mender/route/navigator.dart';
import 'package:mender/theme/colors.dart';
import 'package:mender/utils/database.dart';
import 'package:mender/widgets/custom_simple_rounded_button.dart';
import 'package:mender/widgets/shimer.dart';
import 'package:provider/provider.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  TextEditingController searchCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: const [
                      Text(
                        "Client List",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: searchCtrl,
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: const TextStyle(
                        color: Palette.themecolor,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Palette.themecolor,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Palette.themecolor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Palette.themecolor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  // searchCtrl.text.isEmpty?

                  StreamBuilder<List<CleintModel>>(
                    stream: filterClients(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return SingleChildScrollView(
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              var model = data[index];
                              return FutureBuilder<AuthM>(
                                  future: Provider.of<AuthPro>(context,
                                          listen: false)
                                      .getUserById(model.uid),
                                  builder: ((context, snapshot) {
                                    if (snapshot.hasData) {
                                      final authdata = snapshot.data!;
                                      return
                                    
                                      
                                       Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: themewhitecolor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: themegreycolor,
                                              blurRadius: 10,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            CustomCircleAvtar(
                                              url: authdata.image,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              authdata.name,
                                              style: const TextStyle(
                                                color: themegreytextcolor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(flex: 2,),
                                            InkWell(
                                              onTap: () {
                                                Go.named(
                                                  context,
                                                  Routes.chatScreen,
                                                  {
                                                    'id': model.uid,
                                                        'type': "0",
                                                  },
                                                );
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Palette
                                                    .themecolor
                                                    .withOpacity(0.1),
                                                child: const Icon(
                                                  CupertinoIcons.chat_bubble,
                                                  color: Palette.themecolor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  }));
                            },
                           
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CupertinoActivityIndicator(
                            color: Palette.themecolor,
                          ),
                        );
                      } else {
                        return Container(
                          child: Text("no data "),
                        );
                      }
                    }),
                  )
                
                
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Stream<List<CleintModel>> filterClients() => FirebaseFirestore.instance
      .collection(
        Database.cleint,
      )
      .where('receiverId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => CleintModel.fromJson(doc.data()))
          .toList());

  //       Stream<List<CleintModel>> filterSearchedClients(String search) => FirebaseFirestore.instance
  //   .collection(
  //     Database.cleint,
  //   )
  //   .where('receiverId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //  .where('full_name', isGreaterThanOrEqualTo: search)
  //   .snapshots()
  //   .map((snapshot) => snapshot.docs
  //       .map((doc) => CleintModel.fromJson(doc.data()))
  //       .toList());
}

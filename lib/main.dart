import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mender/provider/auth_pro.dart';
import 'package:mender/provider/call_buddy_pro.dart';
import 'package:mender/provider/call_pro.dart';
import 'package:mender/provider/chat_pro.dart';
import 'package:mender/provider/flicks_pro.dart';
import 'package:mender/provider/notification_pro.dart';
import 'package:mender/provider/session_pro.dart';
import 'package:mender/route/go_router.dart';
import 'package:mender/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthPro>(
          create: (_) => AuthPro(),
        ),
        ChangeNotifierProvider<FlicksPro>(
          create: (_) => FlicksPro(),
        ),
        ChangeNotifierProvider<ChatPro>(
          create: (_) => ChatPro(),
        ),
        ChangeNotifierProvider<CallPro>(
          create: (_) => CallPro(),
        ),
        ChangeNotifierProvider<SessionPro>(
          create: (_) => SessionPro(),
        ),
        ChangeNotifierProvider<NotificationPro>(
          create: (_) => NotificationPro(),
        ),
        ChangeNotifierProvider<CallBuddyPro>(
          create: (_) => CallBuddyPro(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: Routes().myrouter,
        title: 'Mender',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Palette.themecolor,
          useMaterial3: true,
        ),
        builder: (context, child) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, child!),
          maxWidth: 1900,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(450, name: MOBILE),
            const ResponsiveBreakpoint.resize(800, name: TABLET),
            const ResponsiveBreakpoint.resize(1000, name: TABLET),
            const ResponsiveBreakpoint.autoScale(1900, name: DESKTOP),
          ],
        ),
      ),
    );
  }
}

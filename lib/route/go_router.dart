import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mender/navigation/bottom_nav_bar.dart';
import 'package:mender/views/auth/forgot_password_screen.dart';
import 'package:mender/views/buddy/buddy_list_screen.dart';
import 'package:mender/views/chat/chating_screen.dart';
import 'package:mender/views/chat/messages_screen.dart';
import 'package:mender/views/profile/account/account_screen.dart';
import 'package:mender/views/profile/account/change_password_screen.dart';
import 'package:mender/views/profile/account/share_profile_screen.dart';
import 'package:mender/views/profile/content/content_preferences_screen.dart';
import 'package:mender/views/profile/flicks_tab/profile_flicks_screen.dart';
import 'package:mender/views/profile/help_and_information/help_screen.dart';
import 'package:mender/views/profile/help_and_information/report_a_problem_screen.dart';
import 'package:mender/views/profile/help_and_information/terms_and_conditions_screen.dart';
import 'package:mender/views/profile/mender_profile_settings_screen.dart';
import 'package:mender/views/profile/notifications_screen.dart';
import 'package:mender/views/profile/privacy/privacy_policy_screen.dart';
import 'package:mender/views/profile/settings_privacy_screen.dart';
import 'package:mender/views/auth/login_screen.dart';
import 'package:mender/views/auth/signup_screen.dart';
import 'package:mender/views/flicks/add_flicks_screen.dart';
import 'package:mender/views/flicks/flicks_screen.dart';
import 'package:mender/views/splash/splash_service.dart';

class Routes {
  static String splash = "splash";
  static String login = "login";
  static String signup = "signup";
  static String forgotPassword = "forgot-password";
  static String navbar = "navbar";
  static String addflick = "add-flick";
  static String flicks = "flicks";
  static String viewAccountSettings = "view-account-settings";
  static String menderAccountSettings = "mender-account-settings";
  static String viewNotifications = "view-notifications";
  static String menderAccount = "mender-account";
  static String shareProfile = "share-profile";
  static String reportProblem = "report-problem";
  static String help = "help";
  static String termsAndConditions = "terms-and-conditions";
  static String contentPreferences = "content-preferences";
  static String viewBuddyList = "view-buddy-list";
  static String messagesScreen = "messages-screen";
  static String chatScreen = "chat-screen";
  static String privacyPolicy = "privacy-policy";
  static String changePassword = "change-password";
  static String viewProfileFlicks = "view-profile-flicks";




  GoRouter myrouter = GoRouter(
    routes: [
      GoRoute(
        name: splash,
        path: '/',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SplashService(),
          );
        },
      ),
      GoRoute(
        name: login,
        path: '/$login',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: LoginScreen(),
          );
        },
      ),
      GoRoute(
        name: signup,
        path: '/$signup',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SignupScreen(),
          );
        },
      ),
       GoRoute(
        name: forgotPassword,
        path: '/$forgotPassword',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: ForgotPasswordScreen(),
          );
        },
      ),
      GoRoute(
        name: navbar,
        path: '/$navbar',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: BottomNavBar(),
          );
        },
      ),
      GoRoute(
        name: addflick,
        path: '/$addflick',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: AddFlickScreen(),
          );
        },
      ),
      GoRoute(
        name: flicks,
        path: '/$flicks',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: FlicksScreen(),
          );
        },
      ),
        GoRoute(
          name: viewProfileFlicks,
          path: '/$viewProfileFlicks/:page_index/:currentUid',
          builder: (BuildContext context, GoRouterState state) {
            return ProfileFlicksScreen(
              pageindex:
                  int.parse(state.pathParameters['page_index'].toString()),
              uid: state.pathParameters['currentUid'].toString(),
            );
          }),
      GoRoute(
        name: viewAccountSettings,
        path: '/$viewAccountSettings',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SettingsPrivacyScreen(),
          );
        },
      ),
      GoRoute(
        name: menderAccountSettings,
        path: '/$menderAccountSettings',
        pageBuilder: (context, state) {
          return  MaterialPage(
            child: MenderProfileSettingScreen(),
          );
        },
      ),
        GoRoute(
          name: viewNotifications,
          path: '/$viewNotifications',
          builder: (BuildContext context, GoRouterState state) {
            return const NotificationsScreen();
          }),
      GoRoute(
        name: menderAccount,
        path: '/$menderAccount',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: AccountScreen(),
          );
        },
      ),
      GoRoute(
        name: reportProblem,
        path: '/$reportProblem',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: ReportAProblemScreen(),
          );
        },
      ),
      GoRoute(
        name: help,
        path: '/$help',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: HelpScreen(),
          );
        },
      ),
      GoRoute(
        name: termsAndConditions,
        path: '/$termsAndConditions',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: TermsAndConditionsScreen(),
          );
        },
      ),
      GoRoute(
        name: contentPreferences,
        path: '/$contentPreferences',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: ContentPreferencesScreen(),
          );
        },
      ),
      GoRoute(
        name: shareProfile,
        path: '/$shareProfile',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: ShareProfileScreen(),
          );
        },
      ),
      GoRoute(
        name: viewBuddyList,
        path: '/$viewBuddyList',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: BuddyListScreen(),
          );
        },
      ),
      GoRoute(
        name: messagesScreen,
        path: '/$messagesScreen',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: MessagesScreen(),
          );
        },
      ),
      GoRoute(
        name: chatScreen,
        path: '/$chatScreen/:id/:type',  // TYPE -- 0 CLIENT,  TYPE 1 BUDDY 
        pageBuilder: (context, state) {
          return MaterialPage(
            child: ChattingScreen(
              id: state.pathParameters['id'].toString(),
              type: state.pathParameters['type'].toString(),
            ),
          );
        },
      ),
      GoRoute(
          name: changePassword,
          path: '/$changePassword',
          builder: (BuildContext context, GoRouterState state) {
            return const ChangePasswordScreen();
          }),
      GoRoute(
          name: privacyPolicy,
          path: '/$privacyPolicy',
          builder: (BuildContext context, GoRouterState state) {
            return const PrivacyPolicyScreen();
          }),
    ],
  );
}

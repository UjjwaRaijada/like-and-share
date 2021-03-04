import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/splash.dart';
import './screens/login.dart';
import './screens/register.dart';
import './screens/forgotPassword.dart';
import './screens/enterOtp.dart';
import './screens/resetPassword.dart';
import './screens/home.dart';
import './screens/socialMediaPage.dart';
import './screens/socialMediaDetails.dart';
import './screens/socialMediaName.dart';
import './screens/history.dart';
import './screens/historyDetails.dart';
import './screens/createCampaign.dart';
import './screens/profile.dart';
import './screens/changePassword.dart';
import './screens/myCampaign.dart';
import './screens/myCampaignDetails.dart';
import './screens/restartCampaign.dart';
import './screens/openWeb.dart';
import './menuScreens/referAndEarn.dart';
import './menuScreens/buyHearts.dart';
import './menuScreens/faq.dart';
import './menuScreens/tAndC.dart';
import './menuScreens/aboutUs.dart';
import './menuScreens/contactUs.dart';
import './menuScreens/fte.dart';
import './providers/campaignData.dart';
import './providers/myProfile.dart';
import './providers/completed.dart';
import './providers/auth.dart';
import './providers/campComplain.dart';
import './providers/otp.dart';
import './providers/misc.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, CampaignData>(
          create: (_) => CampaignData('', '', []),
          update: (ctx, auth, prevCampaignData) => CampaignData(
            auth.token,
            auth.user,
            prevCampaignData == null ? [] : prevCampaignData.data,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, MyProfileData>(
          create: (_) => MyProfileData('', 0),
          update: (ctx, auth, _) => MyProfileData(
            auth.token,
            auth.user,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => MyProfile(),
        ),
        ChangeNotifierProxyProvider<Auth, CompletedData>(
          create: (_) => CompletedData('', 0),
          update: (ctx, auth, _) => CompletedData(
            auth.token,
            auth.user,
          ),
        ),
        // ChangeNotifierProvider(
        //   create: (context) => ComplainData(),
        // ),
        ChangeNotifierProxyProvider<Auth, CampComplainData>(
          create: (_) => CampComplainData('', 0),
          update: (ctx, auth, _) => CampComplainData(
            auth.token,
            auth.user,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Misc>(
          create: (_) => Misc('', 0),
          update: (ctx, auth, _) => Misc(
            auth.token,
            auth.user,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => OtpData(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Colors.pinkAccent,
            primarySwatch: Colors.blue,
            accentColor: Colors.yellow,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: Colors.black.withOpacity(0.1)),
            textTheme: TextTheme(
              button: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              headline1: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              headline2: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              headline3: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              bodyText1: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          // initialRoute: Splash.id,
          home: auth.isAuth
              ? Home()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, authResult) =>
                      authResult.connectionState == ConnectionState.waiting
                          ? Splash()
                          : Login()),

          // auth.isAuth ? Login() : Home(),
          routes: {
            Splash.id: (context) => Splash(),
            Login.id: (context) => Login(),
            Register.id: (context) => Register(),
            ForgotPassword.id: (context) => ForgotPassword(),
            EnterOtp.id: (context) => EnterOtp(),
            ResetPassword.id: (context) => ResetPassword(),
            // Home.id: (context) => Home(),
            SocialMediaPage.id: (context) => SocialMediaPage(),
            SocialMediaDetails.id: (context) => SocialMediaDetails(),
            History.id: (context) => History(),
            HistoryDetails.id: (context) => HistoryDetails(),
            CreateCampaign.id: (context) => CreateCampaign(),
            TAndC.id: (context) => TAndC(),
            Profile.id: (context) => Profile(),
            ChangePassword.id: (context) => ChangePassword(),
            MyCampaign.id: (context) => MyCampaign(),
            MyCampaignDetails.id: (context) => MyCampaignDetails(),
            SocialMediaName.id: (context) => SocialMediaName(),
            RestartCampaign.id: (context) => RestartCampaign(),
            OpenWeb.id: (context) => OpenWeb(),
            ReferAndEarn.id: (context) => ReferAndEarn(),
            BuyHearts.id: (context) => BuyHearts(),
            FAQ.id: (context) => FAQ(),
            AboutUs.id: (context) => AboutUs(),
            ContactUs.id: (context) => ContactUs(),
            FTE.id: (context) => FTE(),
          },
        ),
      ),
    );
  }
}

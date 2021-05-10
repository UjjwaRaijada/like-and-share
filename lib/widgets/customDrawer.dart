import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../screens/profile.dart';
import '../screens/changePassword.dart';
import '../menuScreens/referAndEarn.dart';
import '../menuScreens/buyHearts.dart';
import '../menuScreens/faq.dart';
import '../menuScreens/tAndC.dart';
import '../menuScreens/aboutUs.dart';
import '../menuScreens/contactUs.dart';
import '../menuScreens/fte.dart';
import '../providers/auth.dart';
import '../widgets/customDivider.dart';

class CustomDrawer extends StatelessWidget {
  void _logoutUser(BuildContext context) async {
    Navigator.pop(context);
    Provider.of<Auth>(context, listen: false).logout();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF150029), Color(0xFF0B0014)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerHeader(
                child: Center(
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
              CustomDivider(),
              DrawerButton(
                onPress: () => Navigator.popAndPushNamed(context, Profile.id),
                icon: FontAwesomeIcons.child,
                title: 'My Profile',
              ),
              DrawerButton(
                onPress: () =>
                    Navigator.popAndPushNamed(context, ReferAndEarn.id),
                icon: FontAwesomeIcons.solidHeart,
                title: 'Refer & Earn',
              ),
              DrawerButton(
                onPress: () => Navigator.popAndPushNamed(context, BuyHearts.id),
                icon: FontAwesomeIcons.handHoldingHeart,
                title: 'Buy Hearts',
              ),
              DrawerButton(
                onPress: () =>
                    Navigator.popAndPushNamed(context, ChangePassword.id),
                icon: FontAwesomeIcons.unlockAlt,
                title: 'Change Password',
              ),
              CustomDivider(),
              DrawerButton(
                onPress: () => Navigator.popAndPushNamed(context, FAQ.id),
                icon: FontAwesomeIcons.question,
                title: 'FAQ',
              ),
              DrawerButton(
                onPress: () => Navigator.popAndPushNamed(context, TAndC.id),
                icon: FontAwesomeIcons.asterisk,
                title: 'Terms Of Use',
              ),
              DrawerButton(
                onPress: () => Navigator.popAndPushNamed(context, AboutUs.id),
                icon: FontAwesomeIcons.palette,
                title: 'About Us',
              ),
              DrawerButton(
                onPress: () => Navigator.popAndPushNamed(context, ContactUs.id),
                icon: FontAwesomeIcons.solidAddressCard,
                title: 'Contact Us',
              ),
              CustomDivider(),
              DrawerButton(
                onPress: () => Navigator.popAndPushNamed(context, FTE.id),
                icon: FontAwesomeIcons.bookReader,
                title: 'Freedom Through Education',
              ),
              CustomDivider(),
              DrawerButton(
                onPress: () => _logoutUser(context),
                icon: FontAwesomeIcons.signOutAlt,
                title: 'Logout',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerButton extends StatelessWidget {
  final Function? onPress;
  final IconData? icon;
  final String? title;

  DrawerButton({this.onPress, this.icon, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 38,
      child: RawMaterialButton(
        onPressed: onPress as void Function()?,
        child: Row(
          children: [
            Container(
              width: 25,
              child: FaIcon(
                icon,
                color: Colors.pinkAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const FaIcon(
              FontAwesomeIcons.angleDoubleRight,
              color: Colors.grey,
              size: 15,
            )
          ],
        ),
      ),
    );
  }
}

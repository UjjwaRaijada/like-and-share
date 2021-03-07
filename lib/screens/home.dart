import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import './myCampaign.dart';
import './socialMediaNew.dart';
import './socialMediaPremium.dart';
import './badge.dart';
import '../providers/campaignData.dart';
import '../providers/myProfile.dart';
import '../widgets/customDrawer.dart';
import '../widgets/customDivider.dart';
import '../widgets/socialMediaIcon.dart';
import '../widgets/homeButtonModal.dart';

class Home extends StatefulWidget {
  static const String id = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _spinner = false;
  MyProfile _myProfile;
  List<CampaignClass> _premium = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    media = Media.Facebook;
    action = ActionType.Like;
    setState(() {
      _spinner = true;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // if (ModalRoute.of(context).settings.arguments == 'snackBar') {
    //   _addSnackBar(context);
    // }
    if (_spinner == true) {
      Provider.of<MyProfileData>(context, listen: false).refreshData();
      Provider.of<CampaignData>(context, listen: false).premiumCamp().then((_) {
        setState(() {
          _spinner = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  // void _addSnackBar(BuildContext context) {
  //   _scaffoldKey.currentState.showSnackBar(
  //     SnackBar(
  //       content: Padding(
  //         padding: const EdgeInsets.all(14.0),
  //         child: const Text(
  //           'Congratulations! Your campaign is ready to be supported by many.',
  //           textAlign: TextAlign.center,
  //           style: const TextStyle(fontSize: 16),
  //         ),
  //       ),
  //       duration: const Duration(seconds: 3),
  //       margin: const EdgeInsets.only(bottom: 80),
  //       behavior: SnackBarBehavior.floating,
  //       backgroundColor: Colors.blueAccent,
  //     ),
  //   );
  // }

  void _modalBottomSheetMenu(){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return HomeBottomModal();
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    _myProfile = Provider.of<MyProfileData>(context).data;
    _premium = Provider.of<CampaignData>(context).premiumData;

    if (_premium.isNotEmpty) {
      actionIcon = _premium[0].action;
      mediaImage = _premium[0].media;
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF150029), Color(0xFF0B0014)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Like & Share',
                      style: const TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 22,
                          // fontWeight: FontWeight.bold,
                          fontFamily: 'Lobster'),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            _myProfile.hearts.toString(),
                            style: const TextStyle(
                                color: Colors.redAccent, fontSize: 20),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                margin: const EdgeInsets.only(top: 10),
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8967), Color(0xFFFF64A4)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  ),
                ),
                child: _spinner == true
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                        ),
                      )
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SocialMediaIcon(
                                onPress: () {
                                  Provider.of<CampaignData>(context, listen: false).clearData();
                                  Navigator.pushNamed(
                                      context, SocialMediaNew.id,
                                      arguments: Media.Facebook);
                                },
                                iconUrl: 'assets/images/v_facebook.png',
                              ),
                              SocialMediaIcon(
                                onPress: () {
                                  Provider.of<CampaignData>(context, listen: false).clearData();
                                  Navigator.pushNamed(
                                      context, SocialMediaNew.id,
                                      arguments: Media.Instagram);
                                },
                                iconUrl: 'assets/images/v_instagram.png',
                              ),
                              SocialMediaIcon(
                                onPress: () {
                                  Provider.of<CampaignData>(context, listen: false).clearData();
                                  Navigator.pushNamed(
                                      context, SocialMediaNew.id,
                                      arguments: Media.Twitter);
                                },
                                iconUrl: 'assets/images/v_twitter.png',
                              ),
                              SocialMediaIcon(
                                onPress: () {
                                  Provider.of<CampaignData>(context, listen: false).clearData();
                                  Navigator.pushNamed(
                                      context, SocialMediaNew.id,
                                      arguments: Media.YouTube);
                                },
                                iconUrl: 'assets/images/v_youtube.png',
                              ),
                              SocialMediaIcon(
                                onPress: () {
                                  Provider.of<CampaignData>(context, listen: false).clearData();
                                  Navigator.pushNamed(
                                      context, SocialMediaNew.id,
                                      arguments: Media.GoogleReview);
                                },
                                iconUrl: 'assets/images/v_google.png',
                              ),
                            ],
                          ),
                          CustomDivider(),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25),
                                  Text(
                                    'Premium',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  RawMaterialButton(
                                    onPressed: _premium.isNotEmpty
                                        ? () => Navigator.pushNamed(
                                            context, SocialMediaPremium.id,
                                            arguments: _premium[0].id)
                                        : () {},
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.yellowAccent,
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      child: _premium.isNotEmpty
                                          ? Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(20),
                                                  width: 150,
                                                  height: 150,
                                                  child: Image.asset(mediaToImage),
                                                ),
                                                Text(
                                                  _premium[0].authorName,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline1,
                                                ),
                                                Text(
                                                  _premium[0].pageUrl,
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline3,
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(15),
                                                    ),
                                                  ),
                                                  child: DefaultTextStyle(
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline2,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('Action Required :  '),
                                                            Icon(
                                                              actionToIcon,
                                                              size: 18,
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text('Reward :  '),
                                                            Text(
                                                              _premium[0].cost
                                                                  .toString(),
                                                            ),
                                                            const Icon(
                                                              Icons.favorite,
                                                              color: Colors.pink,
                                                              size: 18,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(
                                              height: 300,
                                              child: Center(
                                                child: Text(
                                                  'Do you want to see your campaign here? Contact us today.',
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline2,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomButton(
              onPress: () {
                _scaffoldKey.currentState.openDrawer();
              },
              icon: FontAwesomeIcons.bars,
              label: 'Menu',
            ),
            // BottomButton(
            //   onPress: () {
            //     // Navigator.pushNamed(context, History.id);
            //     Navigator.pushNamed(context, HistoryNew.id);
            //   },
            //   icon: FontAwesomeIcons.history,
            //   label: 'History',
            // ),
            BottomButton(
              onPress: () {
                // Navigator.pushNamed(context, History.id);
                Navigator.pushNamed(context, Badge.id);
              },
              icon: FontAwesomeIcons.medal,
              label: 'Badge',
            ),
            BottomButton(
              onPress: () {
                // Navigator.pushNamed(context, CreateCampaign.id).then((value) {
                //   if (value == 'snackBar') {
                //     _addSnackBar(context);
                //   }
                // });
                _modalBottomSheetMenu();
              },
              icon: FontAwesomeIcons.plus,
              label: 'Add',
            ),
            BottomButton(
              onPress: () {
                Navigator.pushNamed(context, MyCampaign.id);
              },
              icon: FontAwesomeIcons.database,
              label: 'Campaigns',
            ),
          ],
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final Function onPress;
  final IconData icon;
  final String label;
  BottomButton({
    this.onPress,
    this.icon,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: const BoxConstraints(
        maxHeight: 45,
        minHeight: 45,
      ),
      onPressed: onPress,
      child: Column(
        children: [
          Icon(
            icon,
            color: Theme.of(context).accentColor,
            size: 25,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}


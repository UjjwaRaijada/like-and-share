import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/createCampaign.dart';
import '../providers/campaignData.dart';
import '../widgets/customDivider.dart';
import '../widgets/socialMediaIcon.dart';

class HomeBottomModal extends StatefulWidget {

  @override
  _HomeBottomModalState createState() => _HomeBottomModalState();
}

class _HomeBottomModalState extends State<HomeBottomModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      color: Colors.transparent, //could change this to Color(0xFF737373),
      //so you don't have to change MaterialApp canvasColor
      child: Container(
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF8967), Color(0xFFFF64A4)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            // color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Add Campaign",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            CustomDivider(),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SocialMediaIcon(
                    onPress: () {
                      setState(() {
                        media = Media.Facebook;
                        action = ActionType.Like;
                      });
                    },
                    iconUrl: media == Media.Facebook
                        ? 'assets/images/facebook.png'
                        :'assets/images/v_facebook.png',
                  ),
                  SocialMediaIcon(
                    onPress: () {
                      setState(() {
                        media = Media.Instagram;
                        action = ActionType.Like;
                      });
                    },
                    iconUrl: media == Media.Instagram
                        ? 'assets/images/instagram.png'
                        : 'assets/images/v_instagram.png',
                  ),
                  SocialMediaIcon(
                    onPress: () {
                      setState(() {
                        media = Media.Twitter;
                        action = ActionType.Love;
                      });
                    },
                    iconUrl: media == Media.Twitter
                        ? 'assets/images/twitter.png'
                        : 'assets/images/v_twitter.png',
                  ),
                  SocialMediaIcon(
                    onPress: () {
                      setState(() {
                        media = Media.YouTube;
                        action = ActionType.Like;
                      });
                    },
                    iconUrl: media == Media.YouTube
                        ? 'assets/images/youtube.png'
                        : 'assets/images/v_youtube.png',
                  ),
                  SocialMediaIcon(
                    onPress: () {
                      setState(() {
                        media = Media.GoogleReview;
                        action = ActionType.Rate;
                      });
                    },
                    iconUrl: media == Media.GoogleReview
                        ? 'assets/images/google.png'
                        : 'assets/images/v_google.png',
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 48,
              child: ((() {
                if (media == Media.Facebook) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /// Facebook Like
                        BottomButtonAny(
                          onPress: (){
                            setState(() {
                              action = ActionType.Like;
                            });
                          },
                          icon: FontAwesomeIcons.solidThumbsUp,
                          iconColor: action == ActionType.Like
                              ? Theme.of(context).accentColor
                              : Colors.black,
                          label: 'Like',
                        ),

                        /// Face Share
                        BottomButtonAny(
                          onPress: (){
                            setState(() {
                              action = ActionType.Share;
                            });
                          },
                          icon: FontAwesomeIcons.shareAlt,
                          iconColor: action == ActionType.Share
                              ? Theme.of(context).accentColor
                              : Colors.black,
                          label: 'Share',
                        ),

                        /// Face Follow
                        BottomButtonAny(
                          onPress: (){
                            setState(() {
                              action = ActionType.Follow;
                            });
                          },
                          icon: FontAwesomeIcons.users,
                          iconColor: action == ActionType.Follow
                              ? Theme.of(context).accentColor
                              : Colors.black,
                          label: 'Follow',
                        ),
                      ]);
                } else if (media == Media.Instagram) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /// Insta Like
                        BottomButtonAny(
                          onPress: (){
                            setState(() {
                              action = ActionType.Like;
                            });
                          },
                          icon: FontAwesomeIcons.solidThumbsUp,
                          iconColor: action == ActionType.Like
                              ? Theme.of(context).accentColor
                              : Colors.black,
                          label: 'Like',
                        ),

                        /// Insta Share
                        BottomButtonAny(
                          onPress: (){setState(() {
                            action = ActionType.Share;
                          });},
                          icon: FontAwesomeIcons.shareAlt,
                          iconColor: action == ActionType.Share
                              ? Theme.of(context).accentColor
                              : Colors.black,
                          label: 'Share',
                        ),

                        /// Insta Follow
                        BottomButtonAny(
                          onPress: (){
                            setState(() {
                              action = ActionType.Follow;
                            });
                          },
                          icon: FontAwesomeIcons.users,
                          iconColor: action == ActionType.Follow
                              ? Theme.of(context).accentColor
                              : Colors.black,
                          label: 'Follow',
                        ),
                      ]);
                } else if (media == Media.Twitter) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /// Twitter Like (Love)
                        BottomButtonAny(
                          onPress: (){
                            setState(() {
                              action = ActionType.Love;
                            });
                          },
                          icon: FontAwesomeIcons.solidHeart,
                          iconColor: action == ActionType.Love
                              ? Theme.of(context).accentColor
                              : Colors.black,
                          label: 'Like',
                        ),

                        /// Twitter Retweet
                        BottomButtonAny(
                          onPress: (){
                            setState(() {
                              action = ActionType.Retweet;
                            });
                          },
                          icon: FontAwesomeIcons.retweet,
                          iconColor: action == ActionType.Retweet
                              ? Theme.of(context).accentColor
                              : Colors.black,
                          label: 'Retweet',
                        ),

                        /// Twitter Follow
                        BottomButtonAny(
                          onPress: (){
                            setState(() {
                              action = ActionType.Follow;
                            });
                          },
                          icon: FontAwesomeIcons.users,
                          iconColor: action == ActionType.Follow
                              ? Theme.of(context).accentColor
                              : Colors.black,
                          label: 'Follow',
                        ),
                      ]);
                } else if (media == Media.YouTube) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /// YouTube Like
                        BottomButtonAny(
                          onPress: (){
                            setState(() {
                              action = ActionType.Like;
                            });
                          },
                          icon: FontAwesomeIcons.solidThumbsUp,
                          iconColor: action == ActionType.Like
                              ? Theme.of(context).accentColor
                              : Colors.black,
                          label: 'Like',
                        ),

                        /// YouTube Subscribe
                        BottomButtonAny(
                          onPress: (){
                            setState(() {
                              action = ActionType.Subscribe;
                            });
                          },
                          icon: FontAwesomeIcons.solidBell,
                          iconColor: action == ActionType.Subscribe
                              ? Theme.of(context).accentColor
                              : Colors.black,
                          label: 'Subscribe',
                        ),
                      ]);
                } else if (media == Media.GoogleReview) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /// Google Rating
                        BottomButtonAny(
                          onPress: (){
                            setState(() {
                              action = ActionType.Rate;
                            });
                          },
                          icon: FontAwesomeIcons.solidStar,
                          iconColor: action == ActionType.Rate
                              ? Theme.of(context).accentColor
                              : Colors.black,
                          label: 'Rating',
                        ),

                        /// Google Review
                        BottomButtonAny(
                          onPress: (){
                            setState(() {
                              action = ActionType.Review;
                            });
                          },
                          icon: FontAwesomeIcons.penFancy,
                          iconColor: action == ActionType.Review
                              ? Theme.of(context).accentColor
                              : Colors.black,
                          label: '5 Rating & Good Review',
                        ),
                      ]);
                }
              })()),
            ),
            const SizedBox(height: 20),
            Text(
              'Create campaign for :  $mediaString',
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              'Requesting action for :  $actionString',
              style: Theme.of(context).textTheme.headline2,
            ),
            const SizedBox(height: 20),
            Container(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  CampaignClass newCamp = CampaignClass(
                    media: media,
                    action: action,
                  );
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context, CreateCampaign.id,
                    arguments: newCamp,
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Next',
                      style: Theme.of(context).textTheme.button,
                    ),
                    FaIcon(
                      FontAwesomeIcons.arrowRight,
                      size: 15,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomButtonAny extends StatelessWidget {
  final Function onPress;
  final IconData icon;
  final Color iconColor;
  final String label;
  BottomButtonAny({
    this.onPress,
    this.icon,
    this.iconColor,
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
            color: iconColor,
            size: 25,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

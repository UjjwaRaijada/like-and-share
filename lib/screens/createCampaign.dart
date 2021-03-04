import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import '../providers/campaignData.dart';
import '../providers/myProfile.dart';
import '../widgets/customDivider.dart';
import '../widgets/startingCode.dart';
import '../widgets/alertBox.dart';

class CreateCampaign extends StatefulWidget {
  static const String id = 'CreateCampaign';

  @override
  _CreateCampaignState createState() => _CreateCampaignState();
}

class _CreateCampaignState extends State<CreateCampaign> {
  final _form = GlobalKey<FormState>();
  bool _spinner = false;
  int heart = 0;
  String error = '';

  File snippet;

  TextEditingController _forPageUrl = TextEditingController();

  @override
  void initState() {
    media = Media.Facebook;
    action = ActionType.Like;
    super.initState();
  }

  var _newCampaign = CampaignClass(
    author: 0,
    media: Media.Facebook,
    action: ActionType.Like,
    urlImage: '',
    pageUrl: '',
    qty: 0,
    cost: 2,
    createdOn: DateTime.now(),
  );

  var _editedProfile = MyProfile(
    id: 0,
    name: '',
    email: '',
    mobile: 0,
    city: '',
    password: '',
    hearts: 0,
    holdOut: 0,
  );

  @override
  void didChangeDependencies() {
    _editedProfile = Provider.of<MyProfileData>(context).data;
    if (_editedProfile.hearts == null) {
      heart = 0;
    } else {
      heart = _editedProfile.hearts;
    }
    super.didChangeDependencies();
  }

  Future<void> _pickImage(ImageSource source) async {
    final selected = await ImagePicker().getImage(
      source: source,
      imageQuality: 50,
      maxWidth: 450,
      maxHeight: 450,
    );

    final cropped = await ImageCropper.cropImage(
      sourcePath: selected.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
        hideBottomControls: true,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ),
    );

    setState(() {
      snippet = File(cropped.path);
      _newCampaign = CampaignClass(
        id: _newCampaign.id,
        media: _newCampaign.media,
        action: _newCampaign.action,
        urlImage: cropped.path,
        pageUrl: _newCampaign.pageUrl,
        qty: _newCampaign.qty,
        cost: _newCampaign.cost,
        createdOn: _newCampaign.createdOn,
      );
    });
  }

  void _saveForm() {
    /// form validation
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    setState(() {
      print('spinner true');
      _spinner = true;
    });

    /// add new campaign
    if (_newCampaign.urlImage.isNotEmpty &&
        _newCampaign.pageUrl.isNotEmpty &&
        _newCampaign.qty != 0 &&
        _newCampaign.qty != null) {
      Provider.of<CampaignData>(context, listen: false)
          .addCampaign(_newCampaign)
          .then((value) {
        print('createCampaign.dart :::::: value :::::::::::: $value');
        if (value == false) {
          setState(() {
            _spinner = false;
          });
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred!'),
              content: Text('Something went wrong. Please try again.'),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Ok'),
                ),
              ],
            ),
          );
        }
      }).then((value) {
        setState(() {
          Provider.of<MyProfileData>(context, listen: false).refreshData();

          // Navigator.pop(context, 'snackBar');
        });
        AlertBox(
          title: 'Superrrrb!!',
          body: 'Your campaign was created successfully',
        );
      }).then((value) => Navigator.pushReplacementNamed(context, '/'));
    } else {
      setState(() {
        print('spinner false');

        error = 'Fill all the fields';
        _spinner = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return StartingCode(
      title: 'Create Campaign',
      widget: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            children: [
              Container(
                height: 40,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /// Facebook
                    Container(
                      height: 25,
                      child: RawMaterialButton(
                        constraints: const BoxConstraints(),
                        child: media == Media.Facebook
                            ? Image.asset(
                                'assets/images/facebook_full.png',
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/facebook.png',
                                fit: BoxFit.cover,
                              ),
                        onPressed: () {
                          setState(() {
                            media = Media.Facebook;
                            action = ActionType.Like;
                            _newCampaign = CampaignClass(
                              media: Media.Facebook,
                              action: ActionType.Like,
                              urlImage: _newCampaign.urlImage,
                              pageUrl: _newCampaign.pageUrl,
                              qty: 0,
                              cost: 2,
                              createdOn: _newCampaign.createdOn,
                            );
                          });
                        },
                      ),
                    ),

                    /// Instagram
                    Container(
                      height: 25,
                      child: RawMaterialButton(
                        constraints: const BoxConstraints(),
                        child: media == Media.Instagram
                            ? Image.asset(
                                'assets/images/instagram_full.png',
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/instagram.png',
                                fit: BoxFit.cover,
                              ),
                        onPressed: () {
                          setState(() {
                            media = Media.Instagram;
                            action = ActionType.Like;
                            _newCampaign = CampaignClass(
                              media: Media.Instagram,
                              action: ActionType.Like,
                              urlImage: _newCampaign.urlImage,
                              pageUrl: _newCampaign.pageUrl,
                              qty: 0,
                              cost: 2,
                              createdOn: _newCampaign.createdOn,
                            );
                          });
                        },
                      ),
                    ),

                    /// Twitter
                    Container(
                      height: 25,
                      child: RawMaterialButton(
                        constraints: const BoxConstraints(),
                        child: media == Media.Twitter
                            ? Image.asset(
                                'assets/images/twitter_full.png',
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/twitter.png',
                                fit: BoxFit.cover,
                              ),
                        onPressed: () {
                          setState(() {
                            media = Media.Twitter;
                            action = ActionType.Love;
                            _newCampaign = CampaignClass(
                              media: Media.Twitter,
                              action: ActionType.Love,
                              urlImage: _newCampaign.urlImage,
                              pageUrl: _newCampaign.pageUrl,
                              qty: 0,
                              cost: 2,
                              createdOn: _newCampaign.createdOn,
                            );
                          });
                        },
                      ),
                    ),

                    /// YouTube
                    Container(
                      height: 25,
                      child: RawMaterialButton(
                        constraints: const BoxConstraints(),
                        child: media == Media.YouTube
                            ? Image.asset(
                                'assets/images/youtube_full.png',
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/youtube.png',
                                fit: BoxFit.cover,
                              ),
                        onPressed: () {
                          setState(() {
                            media = Media.YouTube;
                            action = ActionType.Like;
                            _newCampaign = CampaignClass(
                              media: Media.YouTube,
                              action: ActionType.Like,
                              urlImage: _newCampaign.urlImage,
                              pageUrl: _newCampaign.pageUrl,
                              qty: 0,
                              cost: 2,
                              createdOn: _newCampaign.createdOn,
                            );
                          });
                        },
                      ),
                    ),

                    /// Google
                    Container(
                      height: 25,
                      child: RawMaterialButton(
                        constraints: const BoxConstraints(),
                        child: media == Media.GoogleReview
                            ? Image.asset(
                                'assets/images/google_full.png',
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/google.png',
                                fit: BoxFit.cover,
                              ),
                        onPressed: () {
                          setState(() {
                            media = Media.GoogleReview;
                            action = ActionType.Rate;
                            _newCampaign = CampaignClass(
                              media: Media.GoogleReview,
                              action: ActionType.Rate,
                              urlImage: _newCampaign.urlImage,
                              pageUrl: _newCampaign.pageUrl,
                              qty: 0,
                              cost: 4,
                              createdOn: _newCampaign.createdOn,
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              CustomDivider(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 40,
                child: ((() {
                  if (media == Media.Facebook || media == Media.Instagram) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          /// Facebook Insta Like
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                action = ActionType.Like;
                                _newCampaign = CampaignClass(
                                  id: _newCampaign.id,
                                  media: _newCampaign.media,
                                  action: ActionType.Like,
                                  urlImage: _newCampaign.urlImage,
                                  pageUrl: _newCampaign.pageUrl,
                                  qty: 0,
                                  cost: 2,
                                  createdOn: _newCampaign.createdOn,
                                );
                              });
                            },
                            child: action == ActionType.Like
                                ? IconRowTile(
                                    icon: FontAwesomeIcons.thumbsUp,
                                    title: 'Like',
                                  )
                                : const FaIcon(FontAwesomeIcons.thumbsUp),
                          ),

                          /// Face Insta Share
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                action = ActionType.Share;
                                _newCampaign = CampaignClass(
                                  id: _newCampaign.id,
                                  media: _newCampaign.media,
                                  action: ActionType.Share,
                                  urlImage: _newCampaign.urlImage,
                                  pageUrl: _newCampaign.pageUrl,
                                  qty: 0,
                                  cost: 6,
                                  createdOn: _newCampaign.createdOn,
                                );
                              });
                            },
                            child: action == ActionType.Share
                                ? IconRowTile(
                                    icon: FontAwesomeIcons.shareAlt,
                                    title: 'Share',
                                  )
                                : const FaIcon(FontAwesomeIcons.shareAlt),
                          ),

                          /// Face Insta Follow
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                action = ActionType.Follow;
                                _newCampaign = CampaignClass(
                                  id: _newCampaign.id,
                                  media: _newCampaign.media,
                                  action: ActionType.Follow,
                                  urlImage: _newCampaign.urlImage,
                                  pageUrl: _newCampaign.pageUrl,
                                  qty: 0,
                                  cost: 10,
                                  createdOn: _newCampaign.createdOn,
                                );
                              });
                            },
                            child: action == ActionType.Follow
                                ? IconRowTile(
                                    icon: FontAwesomeIcons.users,
                                    title: 'Follow',
                                  )
                                : const Icon(FontAwesomeIcons.users),
                          ),
                        ]);
                  } else if (media == Media.Twitter) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          /// Twitter Like (Love)
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                action = ActionType.Love;

                                _newCampaign = CampaignClass(
                                  id: _newCampaign.id,
                                  media: _newCampaign.media,
                                  action: ActionType.Love,
                                  urlImage: _newCampaign.urlImage,
                                  pageUrl: _newCampaign.pageUrl,
                                  qty: 0,
                                  cost: 2,
                                  createdOn: _newCampaign.createdOn,
                                );
                              });
                            },
                            child: action == ActionType.Love
                                ? IconRowTile(
                                    icon: FontAwesomeIcons.heart,
                                    title: 'Like',
                                  )
                                : const FaIcon(FontAwesomeIcons.heart),
                          ),

                          /// Twitter Retweet
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                action = ActionType.Retweet;
                                _newCampaign = CampaignClass(
                                  id: _newCampaign.id,
                                  media: _newCampaign.media,
                                  action: ActionType.Retweet,
                                  urlImage: _newCampaign.urlImage,
                                  pageUrl: _newCampaign.pageUrl,
                                  qty: 0,
                                  cost: 6,
                                  createdOn: _newCampaign.createdOn,
                                );
                              });
                            },
                            child: action == ActionType.Retweet
                                ? IconRowTile(
                                    icon: FontAwesomeIcons.retweet,
                                    title: 'Retweet',
                                  )
                                : const FaIcon(FontAwesomeIcons.retweet),
                          ),

                          /// Twitter Follow
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                action = ActionType.Follow;
                                _newCampaign = CampaignClass(
                                  id: _newCampaign.id,
                                  media: _newCampaign.media,
                                  action: ActionType.Follow,
                                  urlImage: _newCampaign.urlImage,
                                  pageUrl: _newCampaign.pageUrl,
                                  qty: 0,
                                  cost: 10,
                                  createdOn: _newCampaign.createdOn,
                                );
                              });
                            },
                            child: action == ActionType.Follow
                                ? IconRowTile(
                                    icon: FontAwesomeIcons.users,
                                    title: 'Follow',
                                  )
                                : const FaIcon(FontAwesomeIcons.users),
                          ),
                        ]);
                  } else if (media == Media.YouTube) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          /// YouTube Like
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                action = ActionType.Like;
                                _newCampaign = CampaignClass(
                                  id: _newCampaign.id,
                                  media: _newCampaign.media,
                                  action: ActionType.Like,
                                  urlImage: _newCampaign.urlImage,
                                  pageUrl: _newCampaign.pageUrl,
                                  qty: 0,
                                  cost: 2,
                                  createdOn: _newCampaign.createdOn,
                                );
                              });
                            },
                            child: action == ActionType.Like
                                ? IconRowTile(
                                    icon: FontAwesomeIcons.solidThumbsUp,
                                    title: 'Like',
                                  )
                                : const FaIcon(FontAwesomeIcons.solidThumbsUp),
                          ),

                          /// YouTube Subscribe
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                action = ActionType.Subscribe;
                                _newCampaign = CampaignClass(
                                  id: _newCampaign.id,
                                  media: _newCampaign.media,
                                  action: ActionType.Subscribe,
                                  urlImage: _newCampaign.urlImage,
                                  pageUrl: _newCampaign.pageUrl,
                                  qty: 0,
                                  cost: 10,
                                  createdOn: _newCampaign.createdOn,
                                );
                              });
                            },
                            child: action == ActionType.Subscribe
                                ? IconRowTile(
                                    icon: FontAwesomeIcons.bell,
                                    title: 'Subscribe',
                                  )
                                : const FaIcon(FontAwesomeIcons.bell),
                          ),
                        ]);
                  } else if (media == Media.GoogleReview) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          /// Google Rating
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                action = ActionType.Rate;
                                _newCampaign = CampaignClass(
                                  id: _newCampaign.id,
                                  media: _newCampaign.media,
                                  action: ActionType.Rate,
                                  urlImage: _newCampaign.urlImage,
                                  pageUrl: _newCampaign.pageUrl,
                                  qty: 0,
                                  cost: 4,
                                  createdOn: _newCampaign.createdOn,
                                );
                              });
                            },
                            child: action == ActionType.Rate
                                ? IconRowTile(
                                    icon: FontAwesomeIcons.solidStar,
                                    title: '5 Star Rating',
                                  )
                                : const FaIcon(FontAwesomeIcons.solidStar),
                          ),

                          /// Google Review
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                action = ActionType.Review;
                                _newCampaign = CampaignClass(
                                  id: _newCampaign.id,
                                  media: _newCampaign.media,
                                  action: ActionType.Review,
                                  urlImage: _newCampaign.urlImage,
                                  pageUrl: _newCampaign.pageUrl,
                                  qty: 0,
                                  cost: 12,
                                  createdOn: _newCampaign.createdOn,
                                );
                              });
                            },
                            child: action == ActionType.Review
                                ? IconRowTile(
                                    icon: FontAwesomeIcons.penFancy,
                                    title: '5 Star Rating & Good Review',
                                  )
                                : const FaIcon(FontAwesomeIcons.penFancy),
                          ),
                        ]);
                  }
                })()),
              ),
              CustomDivider(),
              Text(
                '$mediaString campaign for $actionString',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Container(
                width: width,
                height: width,
                decoration: BoxDecoration(border: Border.all(width: 1)),
                child: Center(
                  child: _spinner == true
                      ? CircularProgressIndicator()
                      : snippet != null
                          ? GestureDetector(
                              onTap: () {
                                _pickImage(ImageSource.gallery);
                              },
                              child: Image.file(snippet),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Text(
                                    'Add Image of your post / profile that you want people to $actionString. '
                                    'A clear picture will help people to identify the post quickly.',
                                    textAlign: TextAlign.justify,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                const SizedBox(height: 50),
                                RaisedButton(
                                  onPressed: () {
                                    _pickImage(ImageSource.gallery);
                                  },
                                  color: Colors.pinkAccent,
                                  child: Text(
                                    'Add Image',
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Enter URL'),
                    controller: _forPageUrl,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      var urlPattern =
                          r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
                      var result = RegExp(urlPattern, caseSensitive: false)
                          .firstMatch(value);
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (result == null) {
                        return 'Enter full url';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _newCampaign = CampaignClass(
                        id: _newCampaign.id,
                        author: _editedProfile.id,
                        media: _newCampaign.media,
                        action: _newCampaign.action,
                        urlImage: _newCampaign.urlImage,
                        pageUrl: newValue,
                        qty: _newCampaign.qty,
                        cost: _newCampaign.cost,
                        createdOn: _newCampaign.createdOn,
                      );
                    }),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        actionString,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text('Cost: ${_newCampaign.cost} '),
                          const FaIcon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.redAccent,
                            size: 12,
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        child: RawMaterialButton(
                          fillColor:
                              _newCampaign.qty == 0 ? Colors.grey : Colors.pink,
                          onPressed: () {
                            if (_newCampaign.qty > 0) {
                              setState(() {
                                _newCampaign = CampaignClass(
                                  id: _newCampaign.id,
                                  media: _newCampaign.media,
                                  action: _newCampaign.action,
                                  urlImage: _newCampaign.urlImage,
                                  pageUrl: _newCampaign.pageUrl,
                                  qty: _newCampaign.qty - 1,
                                  cost: _newCampaign.cost,
                                  createdOn: _newCampaign.createdOn,
                                );
                              });
                            }
                          },
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 22,
                          ),
                          shape: const CircleBorder(),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          _newCampaign.qty < 10
                              ? '0${_newCampaign.qty}'
                              : _newCampaign.qty.toString(),
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        child: RawMaterialButton(
                          fillColor:
                              (heart - (_newCampaign.qty * _newCampaign.cost)) <
                                      _newCampaign.cost
                                  ? Colors.grey
                                  : Colors.pink,
                          onPressed: () {
                            if ((heart -
                                    (_newCampaign.qty * _newCampaign.cost)) >=
                                _newCampaign.cost) {
                              setState(() {
                                _newCampaign = CampaignClass(
                                  id: _newCampaign.id,
                                  media: _newCampaign.media,
                                  action: _newCampaign.action,
                                  urlImage: _newCampaign.urlImage,
                                  pageUrl: _newCampaign.pageUrl,
                                  qty: _newCampaign.qty + 1,
                                  cost: _newCampaign.cost,
                                  createdOn: _newCampaign.createdOn,
                                );
                              });
                            }
                          },
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 22,
                          ),
                          shape: const CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        (_newCampaign.qty * _newCampaign.cost).toString(),
                        style: const TextStyle(fontSize: 25),
                      ),
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 30,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 45),
              error != ''
                  ? Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                    )
                  : const SizedBox(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _newCampaign = CampaignClass(
                      author: _editedProfile.id,
                      media: _newCampaign.media,
                      action: _newCampaign.action,
                      urlImage: _newCampaign.urlImage,
                      pageUrl: _newCampaign.pageUrl,
                      qty: _newCampaign.qty,
                      cost: _newCampaign.cost,
                      createdOn: DateTime.now(),
                    );
                  });
                  _saveForm();
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF8967), Color(0xFFFF64A4)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Create Campaign',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconRowTile extends StatelessWidget {
  final IconData icon;
  final String title;

  IconRowTile({
    this.icon,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(
          icon,
          color: Colors.pinkAccent,
        ),
        const SizedBox(width: 3),
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              color: Colors.pinkAccent,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

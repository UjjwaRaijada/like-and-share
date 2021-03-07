import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

import './socialMediaName.dart';
import './openWeb.dart';
import '../providers/myProfile.dart';
import '../providers/campaignData.dart';
import '../providers/completed.dart';
import '../providers/campComplain.dart';
import '../widgets/startingCode.dart';
import '../widgets/shadowBox.dart';

class SocialMediaDetails extends StatefulWidget {
  static const String id = 'SocialMediaDetails';

  @override
  _SocialMediaDetailsState createState() => _SocialMediaDetailsState();
}

class _SocialMediaDetailsState extends State<SocialMediaDetails> {
  bool _spinner = false;
  File snippetFile;
  Uint8List snippet;
  String snippetString;
  String _screenshot;
  ActionType actionA;
  ActionType actionIconA;
  Media mediaA;
  int _chosen = 0;
  CampaignClass _campaign;
  int _campId;
  MyProfile _userProfile;
  Completed _newCompleted;
  TextEditingController _cancelReason = TextEditingController();
  CampComplain _newComplain;

  bool _divert = false;
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    setState(() {
      _spinner = true;
    });
    super.initState();
  }

  @override
  didChangeDependencies() {
    /// get campaign id
    _campId = ModalRoute.of(context).settings.arguments;

    /// fetch single campaign data
    if (_spinner == true) {
      Provider.of<CampaignData>(context, listen: false)
          .fetchSingleCampaign(_campId)
          .then((value) {
        if (value == true) {
          setState(() {
            _campaign =
                Provider.of<CampaignData>(context, listen: false).singleData;
            mediaA = _campaign.media;
            actionA = _campaign.action;
            actionIconA = _campaign.action;
          });
        } else {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Something isn\'t right!'),
              content: Text('Internet seems to be down. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Ok'),
                ),
              ],
            ),
          );
        }
      }).then((_) {
        _userProfile = Provider.of<MyProfileData>(context, listen: false).data;

        if ((_campaign.media == Media.Facebook &&
                (_userProfile.facebook == '' ||
                    _userProfile.facebook == null)) ||
            (_campaign.media == Media.Instagram &&
                    _userProfile.instagram == '' ||
                _userProfile.instagram == null) ||
            (_campaign.media == Media.Twitter && _userProfile.twitter == '' ||
                _userProfile.twitter == null) ||
            (_campaign.media == Media.YouTube && _userProfile.youtube == '' ||
                _userProfile.youtube == null) ||
            (_campaign.media == Media.GoogleReview &&
                    _userProfile.google == '' ||
                _userProfile.google == null)) {
          setState(() {
            _divert = true;
          });
        }
        setState(() {
          _spinner = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  void _reportAlert() {
    final _form = GlobalKey<FormState>();

    Widget backButton = RawMaterialButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Cancel'),
    );

    Widget submitButton = RawMaterialButton(
      onPressed: () {
        final isValid = _form.currentState.validate();
        if (!isValid) {
          return;
        }
        _form.currentState.save();
        Provider.of<CampComplainData>(context, listen: false)
            .createComplain(_newComplain)
            .then((value) {
          if (value == true) {
            int count = 0;
            Navigator.popUntil(context, (route) {
              return count++ == 2;
            });
          } else {
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('An Error Occurred!'),
                content: Text('Something went wrong. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Ok'),
                  ),
                ],
              ),
            );
          }
        });
      },
      child: const Text('Submit'),
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Please state a reason"),
      content: Container(
        height: 220,
        child: Column(
          children: [
            const Text(
                'Please write your reason below and wait for Admin\s decision.'),
            Form(
              key: _form,
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Write here'),
                maxLength: 150,
                minLines: 1,
                maxLines: 10,
                controller: _cancelReason,
                onSaved: (val) => _newComplain = CampComplain(
                  campaign: _campaign.id,
                  author: _campaign.author,
                  user: _userProfile.id,
                  complain: val,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [backButton, submitButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Future<void> _pickImage(ImageSource source) async {
  //   final selected = await ImagePicker().getImage(
  //       source: source, imageQuality: 50, maxWidth: 450, maxHeight: 450);
  //
  //   final cropped = await ImageCropper.cropImage(
  //       sourcePath: selected.path,
  //       aspectRatioPresets: [CropAspectRatioPreset.square],
  //       androidUiSettings: AndroidUiSettings(
  //         toolbarTitle: 'Cropper',
  //         toolbarColor: Colors.deepOrange,
  //         toolbarWidgetColor: Colors.white,
  //         initAspectRatio: CropAspectRatioPreset.square,
  //         lockAspectRatio: true,
  //         hideBottomControls: true,
  //       ),
  //       iosUiSettings: IOSUiSettings(
  //         title: 'Cropper',
  //       ));
  //   setState(() {
  //     snippet = File(cropped.path);
  //     _screenshot = cropped.path;
  //   });
  // }

  void _launchURL(String pageUrl) async {
    Navigator.pushNamed(context, OpenWeb.id, arguments: pageUrl)
        .then((value) async {
          print('socialMediaDetails.dart :: launchURL :: value ::::::::::::::: $value');
      // setState(() {
      //   // snippet = value;
      //   // snippetString = value.toString();
      //   snippet = value;
      //   // snippetFile = value;
      //   // _screenshot = snippetFile.path;
      // });
        final directory = (await getApplicationDocumentsDirectory()).path;
        String fileName = DateTime.now().toIso8601String();
        var path = '$directory/$fileName.png';

        snippetFile = await File(path).writeAsBytes(value);
        snippetString = snippetFile.path;
        setState(() {

        });
    });
    print('socialMediaDetails.dart :: launchURL :: image path ::::::::::::::: $_screenshot');

    // String url = pageUrl;
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  void _choosen(int campId) {
    Provider.of<MyProfileData>(context, listen: false)
        .addChosen(campId)
        .then((value) {
      if (value == true) {
        _launchURL(_campaign.pageUrl);
      } else {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text('Something went wrong. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              ),
            ],
          ),
        );
      }
    }).catchError((error) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occurred!'),
          content: Text('Something went wrong. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok'),
            ),
          ],
        ),
      );
    });
  }

  void _save() {
    Provider.of<CompletedData>(context, listen: false)
        .createCompleted(_newCompleted)
        .then((value) {
      if (value == true) {
        if (_campaign.premium == 1) {
          Provider.of<CampaignData>(context, listen: false).premiumCamp();
        }
        Provider.of<CampaignData>(context, listen: false)
            .fetchCampaign(_campaign.media);
        Provider.of<MyProfileData>(context, listen: false).refreshData();
        Navigator.pop(context);
      } else {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Oooppsssssss!'),
            content: const Text('Something went wrong. Please try .'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              ),
            ],
          ),
        );
      }
    }).catchError((error) {
      print(error);
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Oooppsssssss!'),
          content: Text('$error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _chosen = Provider.of<MyProfileData>(context).data.chosen;

    action = actionA;
    actionIcon = actionIconA;
    media = mediaA;

    return _divert == true
        ? StartingCode(
            title: 'Name missing!',
            widget: SocialMediaName(),
            // hearts: _userProfile.hearts,
          )
        : WillPopScope(
            onWillPop: () async => _chosen == 0 ? true : false,
            child: StartingCode(
              backButton: _chosen == 0 ? true : false,
              title: _spinner == true ? '' : '${_userProfile.name}',
              widget: _spinner == true
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            '$mediaString',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent,
                            ),
                          ),
                        ),
                        ShadowBox(
                          widget: Row(
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                child: Image.network(
                                  _campaign.urlImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  height: 150,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _campaign.authorName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1,
                                      ),
                                      RawMaterialButton(
                                        onPressed: () =>
                                            _launchURL(_campaign.pageUrl),
                                        child: Text(
                                          _campaign.pageUrl,
                                          maxLines: 2,
                                          overflow: TextOverflow.fade,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Action: $actionString ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline2,
                                                  ),
                                                  Icon(
                                                    actionToIcon,
                                                    size: 15,
                                                    color: Colors.pinkAccent,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Hearts: ${_campaign.cost}  ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline2,
                                                  ),
                                                  const FaIcon(
                                                    FontAwesomeIcons.solidHeart,
                                                    size: 15,
                                                    color: Colors.redAccent,
                                                  ),
                                                ],
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
                        Expanded(
                          child: _chosen == 0
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: DefaultTextStyle(
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        child: Column(
                                          children: [
                                            const Text(
                                              '1. On activating this campaign, you will either have to complete it or cancel it before choosing any other campaign.',
                                              textAlign: TextAlign.justify,
                                            ),
                                            const SizedBox(height: 5),
                                            const Text(
                                                '2. You will be redirected to the website.'),
                                            const SizedBox(height: 5),
                                            const Text(
                                                '3. After completion, take a screenshot and upload it.'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 25),
                                    ElevatedButton(
                                      onPressed: () {
                                        _choosen(_campaign.id);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Theme.of(context)
                                                      .primaryColor)),
                                      child: Text(
                                        'Activate',
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _reportAlert();
                                      },
                                      child: Text(
                                        'Report',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                  ],
                                )
                              : snippetFile != null
                                  ? SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // _pickImage(ImageSource.gallery);
                                            },
                                            // child: Image.file(snippet),
                                            child: Container(
                                                height: 300,
                                                child: Image.file(snippetFile)),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Provider.of<MyProfileData>(
                                                          context,
                                                          listen: false)
                                                      .removeChosen(_campId);
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Colors
                                                                .black54)),
                                                child: Text(
                                                  'Cancel',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button,
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              ElevatedButton(
                                                onPressed: () {
                                                  _newCompleted = Completed(
                                                    authorId: _campaign.author,
                                                    campaignId: _campaign.id,
                                                    userId: _userProfile.id,
                                                    screenshot: snippetString,
                                                  );
                                                  _save();
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Theme
                                                                    .of(context)
                                                                .primaryColor)),
                                                child: Text(
                                                  'Save',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // _pickImage(ImageSource.gallery);
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          child: Text(
                                            'Upload Screenshot',
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Provider.of<MyProfileData>(context,
                                                    listen: false)
                                                .removeChosen(_campId);
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.black54)),
                                          child: Text(
                                            'Cancel',
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _reportAlert();
                                          },
                                          child: Text(
                                            'Report',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                        ),
                      ],
                    ),
            ),
          );
  }
}

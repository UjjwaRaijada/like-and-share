import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../providers/campaignData.dart';
import '../providers/myProfile.dart';
import '../providers/misc.dart';
import '../widgets/startingCode.dart';
import '../widgets/alertBox.dart';
import '../widgets/textFormBorder.dart';

class CreateCampaign extends StatefulWidget {
  static const String id = 'CreateCampaign';

  @override
  _CreateCampaignState createState() => _CreateCampaignState();
}

class _CreateCampaignState extends State<CreateCampaign> {
  // StreamSubscription _intentDataStreamSubscription;
  // String _sharedText;
  final _form = GlobalKey<FormState>();
  bool _spinner = false;
  int heart = 0;
  String error = '';
  String _url;
  String _urlWeb;
  File snippet;
  int cost;

  FocusNode _urlFocus = FocusNode();
  TextEditingController _forCampName = TextEditingController();
  TextEditingController _forPageUrl = TextEditingController();

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

  // @override
  // void initState() {
  //   _intentDataStreamSubscription =
  //       ReceiveSharingIntent.getTextStream().listen((String value) {
  //         setState(() {
  //           // _sharedText = value;
  //           _urlWeb = value;
  //         });
  //       }, onError: (err) {
  //         print("getLinkStream error: $err");
  //       });
  //
  //   // For sharing or opening urls/text coming from outside the app while the app is closed
  //   ReceiveSharingIntent.getInitialText().then((String value) {
  //     setState(() {
  //       // _sharedText = value;
  //       _urlWeb = value;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    CampaignClass _fromModalRoute = ModalRoute.of(context).settings.arguments;
    media = _fromModalRoute.media;
    action = _fromModalRoute.action;
    cost = actionCostData.firstWhere((ele) => ele.name == action).cost;

    _newCampaign = CampaignClass(
      author: 0,
      media: _fromModalRoute.media,
      action: _fromModalRoute.action,
      urlImage: '',
      pageUrl: '',
      qty: 0,
      cost: 2,
      createdOn: DateTime.now(),
    );
    _editedProfile = Provider.of<MyProfileData>(context).data;
    if (_editedProfile.hearts == null) {
      heart = 0;
    } else {
      heart = _editedProfile.hearts;
    }
    super.didChangeDependencies();
  }

  void _getUrl() async {
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      _spinner = false;
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
    if (_newCampaign.pageUrl.isNotEmpty &&
        _newCampaign.qty != 0 && _newCampaign.qty != null) {
        Provider.of<CampaignData>(context, listen: false)
          .addCampaign(_newCampaign)
          .then((value) {
            print('createCampaign.dart :: _saveForm() :: value :::::::::::::::: $value');
        if (value == false) {
          setState(() {
            _spinner = false;
          });
          return showDialog(
            context: context,
            builder: (ctx) => AlertBox(
                onPress: () => Navigator.pop(context)
            ),
          );
        } else {
          print('createCampaign.dart :: _saveForm() :: value inside true :::::::::::::::: $value');
          setState(() {
            _spinner = false;
          });
          return showDialog(
              context: context,
              builder: (ctx) => AlertBox(
              title: 'Superrrrb!!',
              body: 'Your campaign was created successfully!',
              onPress: () {
                Provider.of<MyProfileData>(context, listen: false).refreshData();
                Navigator.pushReplacementNamed(context, '/');
              },
            )
          ).then((value) => Navigator.pushReplacementNamed(context, '/'));
        }
      });
    } else {
      setState(() {
        error = 'Fill all the fields';
        _spinner = false;
      });
    }
  }

  @override
  void dispose() {
    _urlFocus.dispose();
    _forCampName.dispose();
    _forPageUrl.dispose();
    // _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StartingCode(
      title: 'Add Campaign',
      widget: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                color: Colors.black12,
                child: Text(
                  '$mediaString Campaign for $actionString',
                  style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Campaign Name',
                      enabledBorder: textFormBorder(context),
                      border: textFormBorder(context),
                    ),
                    maxLength: 100,
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_urlFocus),
                    controller: _forCampName,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _newCampaign = CampaignClass(
                        name: newValue,
                        media: _newCampaign.media,
                        action: _newCampaign.action,
                        pageUrl: _newCampaign.pageUrl,
                        qty: _newCampaign.qty,
                        cost: cost,
                      );
                    }),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter URL',
                      enabledBorder: textFormBorder(context),
                      border: textFormBorder(context),
                      suffixIcon: IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.search,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: _spinner == false
                          ? () {
                          setState(() {
                            _spinner = true;
                            _urlWeb = _url;
                            _getUrl();
                          });
                        }
                        : () {}
                      ),
                    ),
                    focusNode: _urlFocus,
                    onChanged: (val) => _url = val,
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
                        name: _newCampaign.name,
                        media: _newCampaign.media,
                        action: _newCampaign.action,
                        pageUrl: newValue,
                        qty: _newCampaign.qty,
                        cost: cost,
                      );
                    },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text(
                          'Cost',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('($cost'),
                        const FaIcon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.redAccent,
                          size: 14,
                        ),
                        Text(' / $actionString)'),
                      ],
                    ),
                    Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${cost * _newCampaign.qty} ',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const FaIcon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Qty',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
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
                                    name: _newCampaign.name,
                                    media: _newCampaign.media,
                                    action: _newCampaign.action,
                                    pageUrl: _newCampaign.pageUrl,
                                    qty: _newCampaign.qty - 1,
                                    cost: cost,
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
                                (heart - (_newCampaign.qty * cost)) <
                                        cost
                                    ? Colors.grey
                                    : Colors.pink,
                            onPressed: () {
                              if ((heart -
                                      (_newCampaign.qty * cost)) >=
                                  cost) {
                                setState(() {
                                  _newCampaign = CampaignClass(
                                    name: _newCampaign.name,
                                    media: _newCampaign.media,
                                    action: _newCampaign.action,
                                    pageUrl: _newCampaign.pageUrl,
                                    qty: _newCampaign.qty + 1,
                                    cost: cost,
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
                  ],
                ),
              ),
              const SizedBox(height: 25),
              _spinner == true ?
                  CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  )
              : _urlWeb != null
                  ? Container(
                height: 700,
                child: InAppWebView(
                  initialUrl: _urlWeb,
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(debuggingEnabled: true),
                  ),
                ),
              )
                  : SizedBox(height: 0),

              const SizedBox(height: 45),
              error != ''
                  ? Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
      bottomS: GestureDetector(
        onTap: () {
          setState(() {
            _newCampaign = CampaignClass(
              name: _editedProfile.name,
              media: _newCampaign.media,
              action: _newCampaign.action,
              pageUrl: _newCampaign.pageUrl,
              qty: _newCampaign.qty,
              cost: cost,
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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth.dart';
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

class _CreateCampaignState extends State<CreateCampaign> with WidgetsBindingObserver {
  late InAppWebViewController webView;
  final _form = GlobalKey<FormState>();
  bool _spinner = false;
  int? heart = 0;
  String error = '';
  String? _url;
  String? _urlWeb;
  File? snippet;
  late ActionCost _action;
  late int _actionId;

  FocusNode _urlFocus = FocusNode();
  TextEditingController _forCampName = TextEditingController();
  TextEditingController _forPageUrl = TextEditingController();

  var _newCampaign = CampaignClass(
    author: 0,
    pageUrl: '',
    qty: 0,
    cost: 2,
    createdOn: DateTime.now(),
    authorName: '',
    actionId: 0,
    id: 0, actionName: '',
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
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _actionId = ModalRoute.of(context)!.settings.arguments as int;
    _action = Provider.of<Misc>(context, listen: false).actionCostData.firstWhere((ele) => ele.id == _actionId);
    _editedProfile = Provider.of<MyProfileData>(context, listen: false).data;
    if (_editedProfile.hearts == null) {
      heart = 0;
    } else {
      heart = _editedProfile.hearts;
    }
    super.didChangeDependencies();
  }

  void _saveForm() {
    /// form validation
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      print('spinner true');
      _spinner = true;
    });

    /// add new campaign
    if (_newCampaign.pageUrl.isNotEmpty && _newCampaign.qty > 0) {
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
          setState(() {
            _spinner = false;
          });
          return showDialog(
              context: context,
              builder: (ctx) => AlertBox(
              title: 'Superrrrb!!',
              body: 'Your campaign has been created successfully!',
              onPress: () {
                Provider.of<MyProfileData>(context, listen: false).refreshData().then((value) {
                   if (value == 401) {
                     _logoutUser(context);
                   }
                });
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

  void _logoutUser(BuildContext context) async {
    Navigator.pop(context);
    Provider.of<Auth>(context, listen: false).logout();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _urlFocus.dispose();
    _forCampName.dispose();
    _forPageUrl.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state ::::::::::::::::::::::::::::::::: $state');
    if (state == AppLifecycleState.paused) {
      webView.pauseTimers();
      webView.android.pause();
    } else {
      webView.resumeTimers();
      webView.android.resume();
    }
    super.didChangeAppLifecycleState(state);
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
                padding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Campaign Name',
                      enabledBorder: textFormBorder(context),
                      border: textFormBorder(context),
                    ),
                    maxLength: 30,
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_urlFocus),
                    controller: _forCampName,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _newCampaign = CampaignClass(
                        id: 0,
                        author: 0,
                        authorName: '',
                        name: newValue,
                        actionId: _actionId,
                        pageUrl: _newCampaign.pageUrl,
                        qty: _newCampaign.qty,
                        cost: _action.cost,
                        createdOn: DateTime.now(),
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
                          _urlWeb == null ? FontAwesomeIcons.search : FontAwesomeIcons.times,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: _spinner == false
                          ? () {
                          setState(() {
                            FocusScope.of(context).unfocus();
                            // _spinner = true;
                            if(_urlWeb == null) {
                            _urlWeb = _url!.trim();
                            } else {
                              _urlWeb = null;
                            }
                            print("_urlWeb ::::::::::::::; $_urlWeb");
                            // _getUrl();
                          });
                        }
                        : () {}
                      ),
                    ),
                    focusNode: _urlFocus,
                    onChanged: (val) {
                      _url = val.trim();
                      print("url ::::::::::::::; $_url");
                    },
                  readOnly: _urlWeb == null ? false : true,
                    controller: _forPageUrl,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      var urlPattern =
                          r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
                      var result = RegExp(urlPattern, caseSensitive: false)
                          .firstMatch(value!);
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
                        id: 0,
                        author: 0,
                        authorName: '',
                        name: _newCampaign.name,
                        actionId: _actionId,
                        pageUrl: newValue!.trim(),
                        qty: _newCampaign.qty,
                        cost: _action.cost,
                        createdOn: DateTime.now(),
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
                        const SizedBox(width: 5),
                        Text('(${_action.cost}'),
                        const FaIcon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.redAccent,
                          size: 14,
                        ),
                        Text(' / ${_action.name})'),
                      ],
                    ),
                    Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_action.cost * _newCampaign.qty} ',
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
                                    id: 0,
                                    author: 0,
                                    authorName: '',
                                    name: _newCampaign.name,
                                    actionId: _actionId,
                                    pageUrl: _newCampaign.pageUrl,
                                    qty: _newCampaign.qty - 1,
                                    cost: _action.cost,
                                    createdOn: DateTime.now(),
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
                                (heart! - (_newCampaign.qty * _action.cost)) <
                                        _action.cost
                                    ? Colors.grey
                                    : Colors.pink,
                            onPressed: () {
                              if ((heart! -
                                      (_newCampaign.qty * _action.cost)) >=
                                  _action.cost) {
                                setState(() {
                                  _newCampaign = CampaignClass(
                                    id: 0,
                                    author: 0,
                                    authorName: '',
                                    name: _newCampaign.name,
                                    actionId: _actionId,
                                    pageUrl: _newCampaign.pageUrl,
                                    qty: _newCampaign.qty + 1,
                                    cost: _action.cost,
                                    createdOn: DateTime.now(),
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
              _spinner == true
                ? CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  )
                : _urlWeb != null
                  ? Container(
                    height: 700,
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(url: Uri.parse(_urlWeb!)),
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(),
                      ),
                      onWebViewCreated: (controller) {
                        webView = controller;
                      },
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
              id: 0,
              author: 0,
              authorName: '',
              name: _editedProfile.name,
              actionId: _actionId,
              pageUrl: _newCampaign.pageUrl,
              qty: _newCampaign.qty,
              cost: _action.cost,
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
                  .button!
                  .copyWith(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

}

class IconRowTile extends StatelessWidget {
  final IconData? icon;
  final String? title;

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
          title!,
          style: TextStyle(
              fontSize: 18,
              color: Colors.pinkAccent,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

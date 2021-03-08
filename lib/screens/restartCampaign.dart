import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


import '../providers/campaignData.dart';
import '../providers/myProfile.dart';
import '../widgets/startingCode.dart';
import '../widgets/alertBox.dart';
import '../widgets/textFormBorder.dart';

class RestartCampaign extends StatefulWidget {
  static const String id = 'RestartCampaign';

  @override
  _RestartCampaignState createState() => _RestartCampaignState();
}

class _RestartCampaignState extends State<RestartCampaign> {
  final _form = GlobalKey<FormState>();
  bool _spinner = false;
  int heart = 0;
  String error = '';
  String _url;
  String _urlWeb;
  File snippet;

  CampaignClass _camp = CampaignClass(
    id: 0,
    author: 0,
    media: Media.Facebook,
    action: ActionType.Like,
    urlImage: '',
    pageUrl: '',
    qty: 0,
    cost: 200,
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
      int _campId = ModalRoute.of(context).settings.arguments;
      CampaignClass _campData = Provider.of<CampaignData>(context)
          .data
          .firstWhere((val) => val.id == _campId);
      _camp = CampaignClass(
        id: _campData.id,
        author: _campData.author,
        media: _campData.media,
        action: _campData.action,
        pageUrl: _campData.pageUrl,
        qty: 0,
        cost: _campData.cost,
      );

    media = _camp.media;
    action = _camp.action;

    _editedProfile = Provider.of<MyProfileData>(context).data;
    super.didChangeDependencies();
  }

  void _getUrl() async {
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      _spinner = false;
    });
  }

  void _saveForm() {
    setState(() {
      _spinner = true;
    });

    /// add new campaign
    if (_camp.qty != null) {
      Provider.of<CampaignData>(context, listen: false)
          .addCampaign(_camp)
          .then((value) {
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
                  initialValue: _camp.name,
                  readOnly: true,
                  ),
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
                  initialValue: _camp.pageUrl,
                  readOnly: true,
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
                        Text('(${_camp.cost}'),
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
                            '${_camp.cost * _camp.qty} ',
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
                            _camp.qty == 0 ? Colors.grey : Colors.pink,
                            onPressed: () {
                              if (_camp.qty > 0) {
                                setState(() {
                                  _camp = CampaignClass(
                                    name: _camp.name,
                                    media: _camp.media,
                                    action: _camp.action,
                                    pageUrl: _camp.pageUrl,
                                    qty: _camp.qty - 1,
                                    cost: _camp.cost,
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
                            _camp.qty < 10
                                ? '0${_camp.qty}'
                                : _camp.qty.toString(),
                            style: const TextStyle(fontSize: 25),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          child: RawMaterialButton(
                            fillColor:
                            (heart - (_camp.qty * _camp.cost)) <
                                _camp.cost
                                ? Colors.grey
                                : Colors.pink,
                            onPressed: () {
                              if ((heart -
                                  (_camp.qty * _camp.cost)) >=
                                  _camp.cost) {
                                setState(() {
                                  _camp = CampaignClass(
                                    name: _camp.name,
                                    media: _camp.media,
                                    action: _camp.action,
                                    pageUrl: _camp.pageUrl,
                                    qty: _camp.qty + 1,
                                    cost: _camp.cost,
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
            _camp = CampaignClass(
              name: _editedProfile.name,
              media: _camp.media,
              action: _camp.action,
              pageUrl: _camp.pageUrl,
              qty: _camp.qty,
              cost: _camp.cost,
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

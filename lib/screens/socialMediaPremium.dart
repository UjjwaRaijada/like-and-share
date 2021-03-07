import 'dart:io';import 'dart:typed_data';import 'package:flutter/material.dart';import 'package:font_awesome_flutter/font_awesome_flutter.dart';import 'package:flutter_inappwebview/flutter_inappwebview.dart';import 'package:flutter_image_compress/flutter_image_compress.dart';import 'package:path_provider/path_provider.dart';import 'package:provider/provider.dart';import '../providers/campaignData.dart';// import '../providers/completed.dart';import '../providers/campComplain.dart';import '../widgets/startingCode.dart';import '../widgets/bottomButtonPink.dart';class SocialMediaPremium extends StatefulWidget {  static const String id = 'SocialMediaPremium';  @override  _SocialMediaPremiumState createState() => _SocialMediaPremiumState();}class _SocialMediaPremiumState extends State<SocialMediaPremium> {  InAppWebViewController webView;  Uint8List screenshotBytes;  bool _spinner = true;  bool firstTime = true;  bool _done = true;  bool autoFetch = true;  List<CampaignClass> _data = [];  Media _media;  CampaignClass _newCompleted;  // Completed _newCompletedCom;  CampComplain _newComplain;  TextEditingController _cancelReason = TextEditingController();  @override  void didChangeDependencies() {    setState(() {    });    if (_spinner == true && firstTime == true) {      print('socialMediaNew.dart ::::::::::::::::::: called didChangeDependencies');      Provider.of<CampaignData>(context, listen: false)          .premiumCamp()          .then((value) {        setState(() {          _spinner = false;          firstTime = false;        });      });    }    super.didChangeDependencies();  }  void _reportAlert() {    final _form = GlobalKey<FormState>();    Widget backButton = RawMaterialButton(      onPressed: () {        Navigator.pop(context);      },      child: const Text('Cancel'),    );    Widget submitButton = RawMaterialButton(      onPressed: () {        final isValid = _form.currentState.validate();        if (!isValid) {          return;        }        _form.currentState.save();        Provider.of<CampComplainData>(context, listen: false)            .createComplain(_newComplain)            .then((value) {          if (value == true) {            Provider.of<CampaignData>(context, listen: false).removeDataPremium(_data[0].id);            Navigator.pop(context);          } else {            return showDialog(              context: context,              builder: (ctx) => AlertDialog(                title: Text('An Error Occurred!'),                content: Text('Something went wrong. Please try again.'),                actions: [                  TextButton(                    onPressed: () => Navigator.pop(context),                    child: Text('Ok'),                  ),                ],              ),            );          }        });      },      child: const Text('Submit'),    );    AlertDialog alert = AlertDialog(      title: const Text("Complain!"),      content: Container(        height: 220,        child: Column(          children: [            const Text(                'Please write your complain below. Admin will take the decision asap.'),            Form(              key: _form,              child: TextFormField(                decoration: const InputDecoration(labelText: 'Write here'),                maxLength: 150,                minLines: 1,                maxLines: 10,                controller: _cancelReason,                onSaved: (val) => _newComplain = CampComplain(                  campaign: _data[0].id,                  author: _data[0].author,                  complain: val,                ),              ),            ),          ],        ),      ),      actions: [backButton, submitButton],    );    showDialog(      context: context,      builder: (BuildContext context) {        return alert;      },    );  }  void _save() {    setState(() {      _spinner = true;    });    Provider.of<CampaignData>(context, listen: false)        .createCompleted(_newCompleted).then((_) {      setState(() {        _spinner = false;        _done = true;      });    });  }  void _next() {    setState(() {      _spinner = true;    });    Provider.of<CampaignData>(context, listen: false)        .next(_newCompleted).then((_) {      setState(() {        _spinner = false;        _done = true;      });    });  }  void _refreshPage() {    Provider.of<CampaignData>(context, listen: false).premiumCamp();  }  @override  Widget build(BuildContext context) {    _data = Provider.of<CampaignData>(context).premiumData;    if(_data.isNotEmpty) {      actionIcon = _data[0].action;      _media = _data[0].media;      if(_data.length == 1 && autoFetch == true) {        _refreshPage();        setState(() {          autoFetch = false;        });      }    }    media = _media;    return StartingCode(      title: mediaString,      widget: _spinner == true ?        Center(          child: CircularProgressIndicator(            backgroundColor: Theme.of(context).primaryColor,          ),        )      : _data.isEmpty ?        Padding(          padding: const EdgeInsets.all(28.0),          child: DefaultTextStyle(            style: Theme.of(context).textTheme.headline2,            child: Column(              mainAxisAlignment: MainAxisAlignment.center,              children: [                Text(                    'Come back soon! We will get more Premium Campaigns for you.',                  textAlign: TextAlign.center,                ),                Text('You can also try Refreshing the page!'),                SizedBox(height: 5),                ElevatedButton(                  onPressed: () {                    setState(() {                      autoFetch = true;                    });                    _refreshPage();                  },                  style: ButtonStyle(                    backgroundColor: MaterialStateProperty.all<Color>(                        Theme.of(context).primaryColor                    ),                  ),                  child: Text('Refresh Page',                    style: Theme.of(context).textTheme.button,                  ),                ),              ],            ),          ),        )      : Column(        children: [          Container(            padding: EdgeInsets.only(bottom: 12),            child: DefaultTextStyle(              style: Theme.of(context).textTheme.headline2,              child: Row(                mainAxisAlignment: MainAxisAlignment.spaceEvenly,                children: [                  Row(                    crossAxisAlignment: CrossAxisAlignment.baseline,                    textBaseline: TextBaseline.alphabetic,                    children: [                      Text('Action Requested: '),                      Icon(                        actionToIcon,                        size: 15,                        color: Colors.pinkAccent,                      ),                    ],                  ),                  Row(                    children: [                      Text('Reward:'),                      Text(                        _data[0].cost.toString(),                        style: TextStyle(color: Theme.of(context).primaryColor),                      ),                      const Icon(                        Icons.favorite,                        size: 15,                        color: Colors.pink,                      ),                    ],                  ),                ],              ),            ),          ),          Expanded(            child: InAppWebView(              initialUrl: _data[0].pageUrl,              initialOptions: InAppWebViewGroupOptions(                crossPlatform: InAppWebViewOptions(debuggingEnabled: true),              ),              onWebViewCreated: (controller) {                webView = controller;              },              // onLoadStart: (InAppWebViewController controller, String url) {},            ),          ),          SizedBox(height: 85),        ],      ),      bottomS: _data.isEmpty ?      SizedBox(height: 0)      : Container(        height: 80,        color: Colors.white70,        child: Row(          mainAxisAlignment: MainAxisAlignment.spaceAround,          children: [            BottomButtonPink(              onPress: () {},              icon: FontAwesomeIcons.info,              label: 'Info',            ),            BottomButtonPink(              onPress: () => _reportAlert(),              icon: FontAwesomeIcons.solidFlag,              label: 'Report',            ),            BottomButtonPink(              onPress: _done == false ? (){}              :() async {                setState(() {                  _done = false;                });                final result = await webView.takeScreenshot();                /// compress file                var image = await FlutterImageCompress.compressWithList(                  result,                  minHeight: 960,                  minWidth: 540,                  quality: 40,                );                final directory = (await getApplicationDocumentsDirectory()).path;                String fileName = DateTime.now().toIso8601String();                var path = '$directory/$fileName.png';                // File imageFile = await File(path).writeAsBytes(image);                String snippetString = (await File(path).writeAsBytes(image)).path;                _newCompleted = CampaignClass(                  id: _data[0].id,                  author: _data[0].author,                  urlImage: snippetString,                  premium: 1,                );                _save();              },              icon: FontAwesomeIcons.check,              label: 'Done',            ),            BottomButtonPink(              onPress: () {                setState(() {                  _done = false;                });                _newCompleted = CampaignClass(                  id: _data[0].id,                  author: _data[0].author,                  premium: 1,                );                _next();              },              icon: FontAwesomeIcons.chevronRight,              label: 'Next',            ),          ],        ),      ),    );  }}
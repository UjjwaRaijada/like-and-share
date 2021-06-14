import 'dart:async';import 'dart:io';import 'package:flutter/material.dart';import 'package:flutter/scheduler.dart';import 'package:font_awesome_flutter/font_awesome_flutter.dart';import 'package:flutter_inappwebview/flutter_inappwebview.dart';import 'package:flutter_image_compress/flutter_image_compress.dart';import 'package:path_provider/path_provider.dart';import 'package:provider/provider.dart';import 'package:feature_discovery/feature_discovery.dart';import '../providers/campaignData.dart';import '../providers/campComplain.dart';import '../widgets/bottomButtonPink.dart';import '../widgets/alertBox.dart';import '../widgets/textFormBorder.dart';import '../widgets/customDivider.dart';class SocialMediaNew extends StatefulWidget {  static const String id = 'SocialMediaNew';  @override  _SocialMediaNewState createState() => _SocialMediaNewState();}class _SocialMediaNewState extends State<SocialMediaNew> with WidgetsBindingObserver {  late InAppWebViewController webView;  bool _spinner = true;  bool firstTime = true;  bool _done = true;  bool autoFetch = true;  List<CampaignClass> _data = [];  Media? _media;  late CampaignClass _newCompleted;  late CampComplain _newComplain;  TextEditingController _cancelReason = TextEditingController();  @override  void initState() {    WidgetsBinding.instance!.addObserver(this);    SchedulerBinding.instance!.addPostFrameCallback((Duration duration) {      FeatureDiscovery.discoverFeatures(        context,        const <String>{          // Feature ids for every feature that you want to showcase in order.          'info',          'report',          'done',          'cancel',          'refresh',        },      );    });    super.initState();  }  @override  void didChangeDependencies() {    setState(() {    _media = ModalRoute.of(context)!.settings.arguments as Media?;    });    if (_spinner == true && firstTime == true) {      Provider.of<CampaignData>(context, listen: false)          .fetchAvailableCampaign(_media)          .then((value) {        setState(() {          _spinner = false;          firstTime = false;        });      });    }    super.didChangeDependencies();  }  @override  void dispose() {    WidgetsBinding.instance!.removeObserver(this);    _timer!.cancel();    super.dispose();  }  @override  void didChangeAppLifecycleState(AppLifecycleState state) {    if (state == AppLifecycleState.paused) {      webView.pauseTimers();      webView.android.pause();    } else {      webView.resumeTimers();      webView.android.resume();    }    super.didChangeAppLifecycleState(state);  }  Timer? _timer;  int _start = 20;  void startTimer() {    const oneSec = const Duration(seconds: 1);    _timer = Timer.periodic(      oneSec,          (Timer timer) {        if (_start == 0) {          setState(() {            timer.cancel();            Navigator.pop(context);          });        } else {          setState(() {            _start--;          });        }      },    );  }  void _reportAlert() {    final _form = GlobalKey<FormState>();    Widget backButton = RawMaterialButton(      onPressed: () {        Navigator.pop(context);      },      child: Text(        'Cancel',        style: Theme.of(context)            .textTheme            .headline2!            .copyWith(color: Theme.of(context).primaryColor),      ),    );    Widget submitButton = RawMaterialButton(      onPressed: () {        final isValid = _form.currentState!.validate();        if (!isValid) {          return;        }        _form.currentState!.save();        Provider.of<CampComplainData>(context, listen: false)            .createComplain(_newComplain)            .then((value) {          if (value == true) {            Provider.of<CampaignData>(context, listen: false).removeData(_data[0].id);            Navigator.pop(context);          } else {            return showDialog(              context: context,              builder: (ctx) => AlertBox(                onPress: () => Navigator.pop(context),              ),            );          }        });      },      child: Text(        'Submit',        style: Theme.of(context)            .textTheme            .headline2!            .copyWith(color: Theme.of(context).primaryColor),      ),    );    AlertDialog alert = AlertDialog(      backgroundColor: Color(0xFFFFFFDD),      shape: RoundedRectangleBorder(        borderRadius: const BorderRadius.all(          const Radius.circular(20),        ),        side: BorderSide(          color: Theme.of(context).primaryColor,          width: 2,        ),      ),      title: Text(          "Complain!",        style: Theme.of(context)            .textTheme            .headline1!            .copyWith(color: Theme.of(context).primaryColor,        ),      ),      content: Container(        height: 200,        child: Column(          children: [            // Text(            //   'Please write your complain below. Admin will take the decision asap.',            //   style: Theme.of(context).textTheme.headline2,            // ),            // const SizedBox(height: 5),            Form(              key: _form,              child: TextFormField(                decoration: InputDecoration(                  labelText: 'Write here',                  border: textFormBorder(context),                  enabledBorder: textFormBorder(context),                ),                maxLength: 100,                maxLines: 4,                controller: _cancelReason,                onSaved: (val) => _newComplain = CampComplain(                  campaign: _data[0].id,                  author: _data[0].author,                  complain: val,                ),                // scrollPhysics: ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),              ),            ),          ],        ),      ),      actions: [backButton, submitButton],    );    showDialog(      context: context,      builder: (BuildContext context) {        return alert;      },    );  }  void _save() {    setState(() {      _spinner = true;    });    Provider.of<CampaignData>(context, listen: false)        .createCompleted(_newCompleted).then((_) {      setState(() {        _spinner = false;        _done = true;      });    });  }  void _next() {    setState(() {      _spinner = true;    });    Provider.of<CampaignData>(context, listen: false)        .next(_newCompleted).then((_) {      setState(() {        _spinner = false;        _done = true;      });    });  }  void _refreshPage() {    Provider.of<CampaignData>(context, listen: false).fetchAvailableCampaign(_media);  }  @override  Widget build(BuildContext context) {    _data = Provider.of<CampaignData>(context).data;    if(_data.isNotEmpty) {      actionIcon = _data[0].action;      action = _data[0].action;      if(_data.length == 1 && autoFetch == true) {        _refreshPage();        setState(() {          autoFetch = false;        });      }    }    media = _media;    print('data length ::::::::::: ${_data.length}');    return Scaffold(      body: Container(          width: double.infinity,          decoration: const BoxDecoration(            gradient: const LinearGradient(              colors: const [Color(0xFFFF8967), Color(0xFFFF64A4)],              begin: Alignment.topRight,              end: Alignment.topLeft,            ),          ),          child: Column(            children: [              SafeArea(            bottom: false,            child: Row(              mainAxisAlignment: MainAxisAlignment.spaceBetween,              children: [                Container(                    height: 35,                    width: 35,                    child: RawMaterialButton(                      constraints: BoxConstraints.expand(),                      child: const Icon(                        Icons.arrow_left,                        color: Colors.pink,                        size: 40,                      ),                      onPressed: () => Navigator.pushReplacementNamed(context, '/'),                    )                ),                Text(                  mediaString,                  style: const TextStyle(                      fontSize: 22,                      fontWeight: FontWeight.bold,                      color: Colors.white),                ),                DescribedFeatureOverlay(                  featureId: 'refresh',                  title: Text('Refresh'),                  description: Text('Like & Share does not store your login credentials of other websites. At times you will be asked to login by the social media pages. Once you are logged in, just click here to get back to the right page.' ),                  backgroundColor: Theme.of(context).primaryColor,                  targetColor: Colors.white,                  textColor: Colors.white,                  tapTarget: Icon(                    FontAwesomeIcons.syncAlt,                    color: Theme.of(context).primaryColor,                  ),                  child: Container(                    padding: const EdgeInsets.only(right: 15),                    child: IconButton(                      onPressed: () {                        Navigator.pop(context);                        Provider.of<CampaignData>(context, listen: false).clearData();                        Navigator.pushNamed(context, SocialMediaNew.id, arguments: _media);                      },                      icon: Icon(FontAwesomeIcons.syncAlt),                      color: Colors.pink,                    ),                  ),                ),              ],            ),          ),              Expanded(            child: Container(              padding: const EdgeInsets.only(top: 15),              margin: const EdgeInsets.only(top: 10),              width: double.infinity,              decoration: const BoxDecoration(                color: Colors.white,                borderRadius: const BorderRadius.only(                  topLeft: const Radius.circular(20),                  topRight: const Radius.circular(20),                ),              ),              child: _spinner == true ?                Center(                  child: CircularProgressIndicator(                    backgroundColor: Theme.of(context).primaryColor,                  ),                )                : _data.isEmpty ?                    Padding(                      padding: const EdgeInsets.all(28.0),                      child: DefaultTextStyle(                        style: Theme.of(context).textTheme.headline2!,                        child: Column(                          mainAxisAlignment: MainAxisAlignment.center,                          children: [                            const Text(                                'Come back soon! We will get more campaigns for you.',                              textAlign: TextAlign.center,                            ),                            const Text('You can also try Refreshing the page!'),                            const SizedBox(height: 5),                            ElevatedButton(                              onPressed: () {                                setState(() {                                  autoFetch = true;                                });                                _refreshPage();                              },                              style: ButtonStyle(                                backgroundColor: MaterialStateProperty.all<Color>(                                    Theme.of(context).primaryColor                                ),                              ),                              child: Text('Refresh Page',                                style: Theme.of(context).textTheme.button,                              ),                            ),                          ],                        ),                      ),                    )                  : Column(                    children: [                      Container(                        // padding: const EdgeInsets.only(bottom: 12),                        child: DefaultTextStyle(                          style: Theme.of(context).textTheme.headline2!,                          child: Row(                            mainAxisAlignment: MainAxisAlignment.center,                            children: [                              FaIcon(FontAwesomeIcons.longArrowAltDown, color: Theme.of(context).primaryColor, size: 16,),                              FaIcon(FontAwesomeIcons.longArrowAltDown, color: Theme.of(context).accentColor, size: 16,),                              const SizedBox(width: 10),                              Row(                                children: [                                  Text('Click '),                                  Text(actionString),                                  Text(' & then Done'),                                ],                              ),                              const SizedBox(width: 10),                              FaIcon(FontAwesomeIcons.longArrowAltDown, color: Theme.of(context).accentColor, size: 16,),                              FaIcon(FontAwesomeIcons.longArrowAltDown, color: Theme.of(context).primaryColor, size: 16,),                            ],                          ),                        ),                      ),                      CustomDivider(),                      Expanded(                        child: InAppWebView(                          initialUrlRequest: URLRequest(url: Uri.parse(_data[0].pageUrl!)),                          initialOptions: InAppWebViewGroupOptions(                            crossPlatform: InAppWebViewOptions(),                          ),                          onWebViewCreated: (controller) {                            webView = controller;                          },                        ),                      ),                      const SizedBox(height: 85),                    ],                  ),                ),              ),            ]          ),        ),        bottomSheet: _data.isEmpty          ? const SizedBox(height: 0)          : Container(          height: 80,          color: Colors.white70,          child: Row(            mainAxisAlignment: MainAxisAlignment.spaceAround,            children: [              DescribedFeatureOverlay(                featureId: 'info',                title: Text('Information'),                description: Text('What do you have to do in this campaign & how much you will be rewarded can be checked from here.'),                backgroundColor: Theme.of(context).primaryColor,                targetColor: Colors.white,                textColor: Colors.white,                tapTarget:  BottomButtonPinkInfo(                  icon: FontAwesomeIcons.info,                  label: 'Info',                ),                child: BottomButtonPink(                  onPress: () {                    return showDialog(                      context: context,                      builder: (context) => AlertBox(                        title: 'Information!',                        body: '```$actionString  the post & click Done to get ${_data[0].cost} Hearts.```  Do not click Done without clicking on $actionString. It will lead to penalty.',                        onPress: () => Navigator.pop(context),                      ),                    );                  },                  icon: FontAwesomeIcons.info,                  label: 'Info',                ),              ),              DescribedFeatureOverlay(                featureId: 'report',                title: Text('Report'),                description: Text('Like & Share does not allow restricted content to be promoted through this app. In case you find someone violating, we would request you to click here and report it to us.'),                backgroundColor: Theme.of(context).primaryColor,                targetColor: Colors.white,                textColor: Colors.white,                tapTarget:  BottomButtonPinkInfo(                  icon: FontAwesomeIcons.solidFlag,                  label: 'Report',                ),                child: BottomButtonPink(                  onPress: () => _reportAlert(),                  icon: FontAwesomeIcons.solidFlag,                  label: 'Report',                ),              ),              DescribedFeatureOverlay(                featureId: 'done',                title: Text('Done'),                description: Text('Once you take the action as per requested by the creator of the campaign, click here to go to the next Campaign. If you do not do as per requested in Information & press it, it will lead to DEDUCTION in POINTS.'),                backgroundColor: Theme.of(context).primaryColor,                targetColor: Colors.white,                textColor: Colors.white,                tapTarget:  BottomButtonPinkInfo(                  icon: FontAwesomeIcons.check,                  label: 'Done',                ),                child: BottomButtonPink(                  onPress: _done == false ? (){}                  :() async {                    setState(() {                      _done = false;                    });                    final result = await (webView.takeScreenshot());                    // var image = result;                    /// compress file                    var imageComp = await FlutterImageCompress.compressWithList(                      result!,                      minHeight: 960,                      minWidth: 540,                      quality: 40,                    );                    final directory = (await getApplicationDocumentsDirectory()).path;                    String fileName = DateTime.now().toIso8601String();                    var path = '$directory/$fileName.png';                    String snippetString = (await File(path).writeAsBytes(imageComp)).path;                    _newCompleted = CampaignClass(                      id: _data[0].id,                      author: _data[0].author,                      urlImage: snippetString,                      premium: 0,                    );                    _save();                  },                  icon: FontAwesomeIcons.check,                  label: 'Done',                ),              ),              DescribedFeatureOverlay(                featureId: 'cancel',                title: Text('Cancel'),                description: Text('Not interested in taking action as per requested by the creator? You can always cancel the campaign by clicking here. Once a Campaign is cancelled, it can not be accessed again.'),                backgroundColor: Theme.of(context).primaryColor,                targetColor: Colors.white,                textColor: Colors.white,                tapTarget:  BottomButtonPinkInfo(                  icon: FontAwesomeIcons.ban,                  label: 'Cancel',                ),                child: BottomButtonPink(                  onPress: () {                    setState(() {                      _done = false;                    });                    _newCompleted = CampaignClass(                      id: _data[0].id,                      author: _data[0].author,                      premium: 0,                    );                    _next();                  },                  icon: FontAwesomeIcons.ban,                  label: 'Cancel',                ),              ),            ],          ),        ),    );  }}
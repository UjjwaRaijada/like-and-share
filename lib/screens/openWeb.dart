import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';


import '../widgets/startingCode.dart';

class OpenWeb extends StatefulWidget {
  static const String id = 'OpenWeb';

  @override
  OpenWebState createState() => OpenWebState();
}

class OpenWebState extends State<OpenWeb> {
  InAppWebViewController webView;
  Uint8List screenshotBytes;

  @override
  void dispose() {

    super.dispose();
  }

  // Uint8List _imageFile;

  // @override
  // void initState() {
  //   super.initState();
  //   // Enable hybrid composition.
  //   if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  // }

  @override
  Widget build(BuildContext context) {
    String webPage = ModalRoute.of(context).settings.arguments;
    return StartingCode(
      title: 'Page',
      widget: InAppWebView(
        initialUrl: webPage,
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(debuggingEnabled: true),
        ),
        onWebViewCreated: (controller) {
          webView = controller;
        },
        // onLoadStart: (InAppWebViewController controller, String url) {},
      ),
      floatingButton:
          // FloatingActionButton(
          //   onPressed: () async {
          //     screenshotBytes = await webView.takeScreenshot();
          //     // File _imageFile = File.fromRawPath(screenshotBytes);
          //     showDialog(
          //       context: context,
          //       builder: (context) {
          //         return AlertDialog(
          //           content: Image.memory(screenshotBytes),
          //         );
          //       },
          //     );
          //   },
          //   tooltip: 'Increment',
          //   child: Icon(Icons.add),
          // ),

      FloatingActionButton(
        onPressed: () async {
          final result = await webView.takeScreenshot();
          // var len = result.lengthInBytes;
          // final directory = (await getApplicationDocumentsDirectory()).path;
          // String fileName = 'myImage';
          // var path = '$directory/$fileName.png';
          //
          // File image = await File(path).writeAsBytes(result);

          // File image = File(path);
          // print('openWeb :: image ::::::::::: $image');
          // showDialog(
          //           context: context,
          //           builder: (context) {
          //             return AlertDialog(
          //               content: Image.file(image),
          //             );
          //           },
          //         );
          Navigator.pop(context, result);
        },
        child: FaIcon(
          FontAwesomeIcons.check,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

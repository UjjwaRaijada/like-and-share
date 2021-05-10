import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './home.dart';
import '../providers/misc.dart';

class Disclaimer extends StatefulWidget {
  static const String id = 'Disclaimer';
  @override
  _DisclaimerState createState() => _DisclaimerState();
}

class _DisclaimerState extends State<Disclaimer> {
  bool _loadOnce = true;
  late String _disclaimer;


  void navigate() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('disclaimer')){
      Navigator.of(context).pushReplacementNamed(Home.id);
    }
  }

  @override
  void didChangeDependencies() {
    if(_loadOnce == true){
      Provider.of<Misc>(context, listen: false).getDisclaimer()
          .then((value) {
        _disclaimer = value;
        setState(() {
          _loadOnce = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    navigate();

    return Scaffold(
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
                child: Text(
                  'Disclaimer',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                margin: const EdgeInsets.only(top: 10),
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8967), Color(0xFFFF64A4)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: _loadOnce == true
                  ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  )
                  : SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          _disclaimer != ''
                            ? _disclaimer
                            : 'Like & Share uses logos & icons of other Social Media Pages & Brands only for categorization purposes.\r\n\r\nWhen you click on either of the logos, Like & Share displays the respective web page on its embedded browser. \r\n\r\nLike & Share neither claims to own these logos & icons nor does it claim to provide any of the services / features associated with them. \r\n\r\nLike & Share is not affiliated or linked to any other company or brand other than those specifically mentioned in its documentations.\r\n\r\nLike & Share holds all the rights of use of its own logo i.e., Like & Share.\r\n\r\nFor more details please read our \"Terms of Use\".',
                          style: Theme.of(context).textTheme.bodyText1!,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              decoration: const BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF150029), Color(0xFF0B0014)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            )
          ],
        ),
      ),
      bottomSheet: RawMaterialButton(
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('disclaimer', 'true');
          Navigator.of(context).pushReplacementNamed('/');
        },
        child: Container(
          width: double.infinity,
          height: 50,
          child: Text(
            'Ok, I Understood',
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

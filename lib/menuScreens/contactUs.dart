import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/misc.dart';
import '../widgets/startingCode.dart';
import '../widgets/alertBox.dart';

class ContactUs extends StatelessWidget {
  static const String id = 'ContactUs';

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String suggestion;
    return StartingCode(
      title: 'Contact Us',
      widget: Container(
        padding: EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   width: double.infinity,
            //   child: Image.asset('assets/images/map.png'),
            // ),
            // SizedBox(height: 25),
            // const Text(
            //     'We would like to meet you in person. Do drop by and we will discuss your social media promotions over coffee. Below is our address:'),
            // SizedBox(height: 5),
            // const Text('D36, Subahsh Marg, C-Scheme, Jaipur - 302001'),
            // SizedBox(height: 15),
            // const Text('Or else, you can reach us at:'),
            // SizedBox(height: 5),
            // const  Text('+91 9352851051'),
            // SizedBox(height: 15),
            const Text(
                'We have a dedicated team to resolve your queries and consider your valuable suggestions. Do write to us below or email us at:'),
            const SizedBox(height: 5),
            const Text('hello@likeandshare.app'),
            const SizedBox(height: 45),
            Form(
              key: _form,
              child: TextFormField(
                minLines: 5,
                maxLines: 8,
                maxLength: 250,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                validator: (val) {
                  if (val.length < 50) {
                    return 'Message too short. Please write at least 50 letters.';
                  }
                  return null;
                },
                onSaved: (newValue) => suggestion = newValue,
              ),
            ),
          ],
        ),
      ),
      bottomS: RawMaterialButton(
        onPressed: () {
          final isValid = _form.currentState.validate();
          if (!isValid) {
            return;
          }
          _form.currentState.save();

          Provider.of<Misc>(context, listen: false)
              .sendSuggestion(suggestion)
              .then((value) {
            if (value == true) {
              return showDialog(
                context: context,
                builder: (ctx) => AlertBox(
                  title: 'Thank you!!',
                  body: 'Your suggestions are important to us. Thank you!',
                ),
              );
            }
          });
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
              'Send',
              style: Theme.of(context).textTheme.button.copyWith(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

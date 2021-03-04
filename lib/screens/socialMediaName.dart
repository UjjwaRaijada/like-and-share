import 'package:flutter/material.dart';

import './profile.dart';
import '../providers/campaignData.dart';

class SocialMediaName extends StatelessWidget {
  static const String id = 'SocialMediaName';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              Text(
                'Please add your $mediaString name in your Profile',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 45),
              RaisedButton(
                color: Colors.pinkAccent,
                onPressed: () {
                  Navigator.pushNamed(context, Profile.id);
                },
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 150),
      ],
    );
  }
}

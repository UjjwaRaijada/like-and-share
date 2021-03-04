import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import '../providers/campaignData.dart';
import '../providers/myProfile.dart';
import '../widgets/customDivider.dart';
import '../widgets/startingCode.dart';

class RestartCampaign extends StatefulWidget {
  static const String id = 'RestartCampaign';

  @override
  _RestartCampaignState createState() => _RestartCampaignState();
}

class _RestartCampaignState extends State<RestartCampaign> {
  final _form = GlobalKey<FormState>();
  CampaignClass _camp;

  int heart = 0;
  int _qty = 0;
  String error = '';

  File snippet;

  MyProfile _editedProfile;

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
      urlImage: _campData.urlImage,
      pageUrl: _campData.pageUrl,
      qty: 0,
      cost: _campData.cost,
    );
    snippet = File(_camp.urlImage);

    _editedProfile = Provider.of<MyProfileData>(context).data;
    if (_editedProfile.hearts == null) {
      heart = 0;
    } else {
      heart = _editedProfile.hearts;
    }
    super.didChangeDependencies();
  }

  Future<void> _pickImage(ImageSource source) async {
    final selected =
        await ImagePicker().getImage(source: source, imageQuality: 10);

    final cropped = await ImageCropper.cropImage(
        sourcePath: selected.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls: true,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    setState(() {
      snippet = File(cropped.path);
      _camp = CampaignClass(
        id: _camp.id,
        author: _camp.author,
        media: _camp.media,
        action: _camp.action,
        urlImage: cropped.path,
        pageUrl: _camp.pageUrl,
        qty: 0,
        cost: _camp.cost,
      );
    });
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    if (_camp.qty != 0 && _camp.qty != null) {
      // Navigator.pushReplacementNamed(context, Home.id, arguments: 'snackBar');
      Navigator.pushReplacementNamed(context, '/', arguments: 'snackBar');
    } else {
      setState(() {
        error = 'Fill all the fields';
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return StartingCode(
      title: 'Create Campaign',
      widget: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            children: [
              Container(
                height: 40,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      'assets/images/facebook_full.png',
                      fit: BoxFit.cover,
                      height: 25,
                    ),
                    IconRowTile(
                      icon: FontAwesomeIcons.thumbsUp,
                      title: 'Like',
                    ),
                  ],
                ),
              ),
              CustomDivider(),
              Text(
                '$mediaString campaign for $actionString',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Container(
                width: width,
                height: width,
                decoration: BoxDecoration(border: Border.all(width: 1)),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: Image.file(snippet),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Enter URL'),
                  initialValue: _camp.pageUrl,
                  readOnly: true,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        actionString,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text('Cost: ${_camp.cost} '),
                          const FaIcon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.redAccent,
                            size: 12,
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        child: RawMaterialButton(
                          fillColor: _qty == 0 ? Colors.grey : Colors.pink,
                          onPressed: () {
                            if (_qty > 0) {
                              setState(() {
                                _qty -= 1;
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
                          _qty < 10 ? '0$_qty' : _qty.toString(),
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        child: RawMaterialButton(
                          fillColor: (heart - (_qty * _camp.cost)) < _camp.cost
                              ? Colors.grey
                              : Colors.pink,
                          onPressed: () {
                            if ((heart - (_qty * _camp.cost)) >= _camp.cost) {
                              setState(() {
                                _qty += 1;
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
                  Row(
                    children: [
                      Text(
                        (_qty * _camp.cost).toString(),
                        style: const TextStyle(fontSize: 25),
                      ),
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 30,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 45),
              error != ''
                  ? Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                    )
                  : const SizedBox(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _camp = CampaignClass(
                      id: _camp.id,
                      author: _camp.author,
                      media: _camp.media,
                      action: _camp.action,
                      urlImage: _camp.urlImage,
                      pageUrl: _camp.pageUrl,
                      qty: _qty,
                      cost: _camp.cost,
                      createdOn: DateTime.now(),
                    );

                    _editedProfile = MyProfile(
                      hearts: _qty * _camp.cost,
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
                  child: const Center(
                    child: const Text(
                      'Create Campaign',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../screens/createCampaign.dart';
import '../providers/misc.dart';
import '../widgets/customDivider.dart';

class HomeBottomModal extends StatefulWidget {

  @override
  _HomeBottomModalState createState() => _HomeBottomModalState();
}

class _HomeBottomModalState extends State<HomeBottomModal> {
  bool _loadOnce = true;
  int chosenId = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_loadOnce == true) {
      Provider.of<Misc>(context, listen: false).actionCost();
      setState(() {
        _loadOnce = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  List<ActionCost> _data = Provider.of<Misc>(context).actionCostData;

    return Container(
      color: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 20.0,
          sigmaY: 20.0,
        ),
        child: Container(
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8967), Color(0xFFFF64A4)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              // color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0))),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Add Campaign For?",
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              CustomDivider(),
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  actionIcon = _data[i].name;
                  return CustomRow(
                    onPress: (){
                      setState(() {
                        chosenId = _data[i].id;
                      });
                    },
                    id: _data[i].id,
                    name: _data[i].name,
                    icon: stringToAction,
                    chosenId: chosenId,
                    cost: _data[i].cost,
                  );
                },
                itemCount: _data.length,
              ),
              const SizedBox(height: 20),
              Container(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context, CreateCampaign.id,
                      arguments: chosenId,
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Next',
                        style: Theme.of(context).textTheme.button,
                      ),
                      FaIcon(
                        FontAwesomeIcons.arrowRight,
                        size: 15,
                        color: Colors.white,
                      )
                    ],
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

class CustomRow extends StatelessWidget {
  final Function onPress;
  final int id;
  final String name;
  final IconData icon;
  final int chosenId;
  final int cost;
  CustomRow({
    required this.onPress,
    required this.id,
    required this.name,
    required this.icon,
    required this.chosenId,
    required this.cost,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: RawMaterialButton(
            constraints: const BoxConstraints(
              maxHeight: 45,
              minHeight: 45,
            ),
            onPressed: onPress as void Function()?,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                      Icon(
                        icon,
                        color: id == chosenId
                            ? Theme.of(context).accentColor
                            : Colors.black,
                        size: 25,
                      ),
                    const SizedBox(width: 15),
                    Text(
                      name,
                      style: id == chosenId
                          ? Theme.of(context).textTheme.headline2!.copyWith(color: Theme.of(context).accentColor)
                          : Theme.of(context).textTheme.headline2,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      cost.toString(),
                      style: TextStyle(
                        color: id == chosenId
                            ? Colors.red
                            : Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.favorite,
                      color: id == chosenId
                          ? Colors.red
                          : Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: const Divider(
            height: 1,
            color: Colors.pinkAccent,
          ),
        ),
      ],
    );
  }
}


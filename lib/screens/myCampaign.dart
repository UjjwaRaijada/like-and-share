import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import './myCampaignDetails.dart';
import '../providers/campaignData.dart';
import '../widgets/customDivider.dart';
import '../widgets/halfRow.dart';
import '../widgets/shadowBox.dart';
import '../widgets/startingCode.dart';

class MyCampaign extends StatefulWidget {
  static const String id = 'MyCampaign';

  @override
  _MyCampaignState createState() => _MyCampaignState();
}

class _MyCampaignState extends State<MyCampaign> {
  List<CampaignClass> _data = [];
  bool _spinner = false;

  @override
  void initState() {
    setState(() {
      _spinner = true;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_spinner == true) {
      Provider.of<CampaignData>(context, listen: false).myCampaign().then((_) {
        _data = Provider.of<CampaignData>(context, listen: false).data;
      }).then((_) {
        setState(() {
          _spinner = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StartingCode(
      title: 'My Campaign',
      widget: _spinner == true
        ? Center(child: CircularProgressIndicator())
        : _data.isEmpty
          ? Padding(
            padding: const EdgeInsets.all(18.0),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    const Text(
                      'Support a campaign and get rewarded.',
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'To support a campaign, click on any social media icon on the home page.',
                    ),
                    const SizedBox(height: 5),
                    const Text(
                        'Do Like or Share or other action as per requested and click Done.'),
                    const SizedBox(height: 10),
                    const Text(
                        'You can use these heart points to promote your social media pages.'),
                  ],
                ),
            ),
          )
          : Column(
              children: [
                Row(
                  children: [
                    HalfRow(
                      title: 'Total: ${_data.length}',
                    ),
                    HalfRow(
                      title: 'Running: ${_data.where((ele) => ele.qty * ele.cost != ele.heartPending + ele.heartGiven + ele.heartReturned).length}',
                    ),
                  ],
                ),
                CustomDivider(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      actionIcon = _data[index].action;
                      media = _data[index].media;

                      return SocialMediaTile(
                        backColor: _data[index].heartPending > 0
                          ? Colors.red.withOpacity(0.2)
                          : Colors.transparent,
                        campaignId: _data[index].id,
                        name: _data[index].name,
                        imageUrl: _data[index].urlImage,
                        action: _data[index].action,
                        actionQty: _data[index].qty,
                        costPerAction: _data[index].cost * _data[index].qty,
                        date: _data[index].createdOn,
                      );
                    },
                    itemCount: _data.length,
                  ),
                ),
              ],
            ),
    );
  }
}

class SocialMediaTile extends StatelessWidget {
  final Color backColor;
  final int campaignId;
  final String imageUrl;
  final Media media;
  final String name;
  final ActionType action;
  final int actionQty;
  final int costPerAction;
  final DateTime date;

  SocialMediaTile({
    this.backColor,
    this.campaignId,
    this.imageUrl,
    this.media,
    this.name,
    this.action,
    this.actionQty,
    this.costPerAction,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RawMaterialButton(
          onPressed: () => Navigator.pushNamed(context, MyCampaignDetails.id,
              arguments: campaignId),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 110,
            color: backColor,
            child: ShadowBox(
              widget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '$name',
                      // '$mediaString :  $name',
                      style: Theme.of(context).textTheme.headline1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(mediaString),
                      Container(
                        child: Text(DateFormat.yMMMd().format(date).toString()),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              'Target: $actionQty',
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            actionToIcon,
                            size: 12,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            child: Text(
                              'Expense: $costPerAction',
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.red,
                            size: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: const Divider(
            height: 3,
            color: Colors.pinkAccent,
          ),
        ),
      ],
    );
  }
}

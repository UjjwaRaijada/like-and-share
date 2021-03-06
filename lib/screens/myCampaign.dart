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
                      children: [
                        Text(
                          'Support a campaign and get rewarded.',
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'To support a campaign, click on any social media icon on the home page.',
                        ),
                        const SizedBox(height: 5),
                        Text(
                            'Do Like or Share or other action as per requested and click Done.'),
                        const SizedBox(height: 10),
                        Text(
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
                          title: 'Running: ${_data.length}',
                        ),
                        HalfRow(
                          title: 'Total: ${_data.length}',
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
                            campaignId: _data[index].id,
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
  final int campaignId;
  final String imageUrl;
  final Media media;
  final ActionType action;
  final int actionQty;
  final int costPerAction;
  final DateTime date;

  SocialMediaTile({
    this.campaignId,
    this.imageUrl,
    this.media,
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
            child: ShadowBox(
              widget: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: Image.network(imageUrl),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          height: 20,
                          child: Text(
                            mediaString,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            DateFormat.yMMMd().format(date).toString(),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 16,
                                      child: Text(
                                        'Target: $actionQty',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(
                                      actionToIcon,
                                      size: 15,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 16,
                                      child: Text(
                                        'Expense: $costPerAction',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      FontAwesomeIcons.solidHeart,
                                      color: Colors.red,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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

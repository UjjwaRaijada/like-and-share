import 'package:flutter/material.dart';
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
  List<CampaignClass> _pending = [];
  List<CampaignClass> _completed = [];
  List<CampaignClass> _running = [];

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
        setState(() {
          _spinner = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _data = Provider.of<CampaignData>(context, listen: false).data;
    _pending = _data.where((ele) => ele.heartPending! > 0).toList();
    _completed = _data.where((ele) => ele.count == ele.qty).toList();
    _running = _data.where((ele) => ele.count! < ele.qty!).toList();

    return StartingCode(
      title: 'My Campaign',
      widget: _spinner == true
        ? Center(child: CircularProgressIndicator())
        : _data.isEmpty
          ? Padding(
            padding: const EdgeInsets.all(18.0),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyText1!,
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
                      title: 'Running: ${_data.where((ele) => ele.qty! * ele.cost! != ele.heartPending! + ele.heartGiven! + ele.heartReturned!).length}',
                    ),
                  ],
                ),
                CustomDivider(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            actionIcon = _pending[index].action;
                            media = _pending[index].media;
                            action = _pending[index].action;

                            return SocialMediaTile(
                              id: _pending[index].id!,
                              backColor: Colors.red.withOpacity(0.2),
                              campaignId: _pending[index].id,
                              name: _pending[index].name,
                              date: _pending[index].createdOn,
                              totalAction: _pending[index].count,
                              actionQty: _pending[index].qty,
                              actionPending: (_pending[index].heartPending! / _pending[index].cost! ) > 0
                                ? (_pending[index].heartPending! / _pending[index].cost!).round()
                                : 0
                              // imageUrl: _pending[index].urlImage,
                              // action: _pending[index].action,
                              // costPerAction: _pending[index].cost * _pending[index].qty,
                            );
                          },
                          itemCount: _pending.length,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            actionIcon = _running[index].action;
                            media = _running[index].media;
                            action = _running[index].action;

                            return SocialMediaTile(
                              id: _running[index].id!,
                              backColor: Colors.transparent,
                              campaignId: _running[index].id,
                              name: _running[index].name,
                              date: _running[index].createdOn,
                              totalAction: _running[index].count,
                              actionQty: _running[index].qty,
                              actionPending: (_running[index].heartPending! / _running[index].cost! ) > 0
                                ? (_running[index].heartPending! / _running[index].cost!).round()
                                : 0
                              // imageUrl: _running[index].urlImage,
                              // action: _running[index].action,
                              // costPerAction: _running[index].cost * _running[index].qty,
                            );
                          },
                          itemCount: _running.length,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            actionIcon = _completed[index].action;
                            media = _completed[index].media;
                            action = _completed[index].action;

                            return SocialMediaTile(
                              id: _completed[index].id!,
                              backColor: Colors.green.withOpacity(0.2),
                              campaignId: _completed[index].id,
                              name: _completed[index].name,
                              date: _completed[index].createdOn,
                              totalAction: _completed[index].count,
                              actionQty: _completed[index].qty,
                              actionPending: (_completed[index].heartPending! / _completed[index].cost! ) > 0
                                ? (_completed[index].heartPending! / _completed[index].cost!).round()
                                : 0
                              // imageUrl: _completed[index].urlImage,
                              // action: _completed[index].action,
                              // costPerAction: _completed[index].cost * _completed[index].qty,
                            );
                          },
                          itemCount: _completed.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class SocialMediaTile extends StatelessWidget {
  final int id;
  final Color? backColor;
  final int? campaignId;
  final String? name;
  final int? actionQty;
  final int? totalAction;
  final int? actionPending;
  final DateTime? date;

  SocialMediaTile({
    required this.id,
    this.backColor,
    this.campaignId,
    this.name,
    this.actionQty,
    this.totalAction,
    this.actionPending,
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
            // backColor,
            child: ShadowBox(
              widget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '$name',
                      style: Theme.of(context).textTheme.headline1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          DateFormat.yMMMd().format(date!).toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          mediaString,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  totalAction == actionQty
                    ? Expanded(
                      child: Text(
                        'Done',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                // 'Target: $actionQty',
                                '$actionString: $totalAction / $actionQty',
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                actionToIcon,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            // 'Expense: $costPerAction',
                            'Pending: $actionPending',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
       CustomDivider(),
      ],
    );
  }
}

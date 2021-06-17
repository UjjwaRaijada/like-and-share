import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import './myCampaignDetails.dart';
import '../providers/campaignData.dart';
import '../providers/misc.dart';
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
    _running = _data.where((ele) => ele.count! < ele.qty).toList();

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
                      title: 'Running: ${_data.where((ele) => ele.qty * ele.cost != ele.heartPending! + ele.heartGiven! + ele.heartReturned!).length}',
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
                          itemBuilder: (context, i) {
                            actionIcon = _pending[i].actionName!;
                            return SocialMediaTile(
                              id: _pending[i].id,
                              backColor: Colors.red.withOpacity(0.2),
                              campaignId: _pending[i].id,
                              name: _pending[i].name,
                              actionName: _pending[i].actionName!,
                              actionIcon: stringToAction,
                              date: _pending[i].createdOn,
                              totalAction: _pending[i].count,
                              actionQty: _pending[i].qty,
                              actionPending: (_pending[i].heartPending! / _pending[i].cost ) > 0
                                ? (_pending[i].heartPending! / _pending[i].cost).round()
                                : 0
                              // imageUrl: _pending[i].urlImage,
                              // action: _pending[i].action,
                              // costPerAction: _pending[i].cost * _pending[i].qty,
                            );
                          },
                          itemCount: _pending.length,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, i) {
                            actionIcon = _running[i].actionName!;
                            return SocialMediaTile(
                              id: _running[i].id,
                              backColor: Colors.transparent,
                              campaignId: _running[i].id,
                              name: _running[i].name,
                              actionName: _running[i].actionName!,
                              actionIcon: stringToAction,
                              date: _running[i].createdOn,
                              totalAction: _running[i].count,
                              actionQty: _running[i].qty,
                              actionPending: (_running[i].heartPending! / _running[i].cost ) > 0
                                ? (_running[i].heartPending! / _running[i].cost).round()
                                : 0
                            );
                          },
                          itemCount: _running.length,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, i) {
                            actionIcon = _completed[i].actionName!;
                            return SocialMediaTile(
                              id: _completed[i].id,
                              backColor: Colors.green.withOpacity(0.2),
                              campaignId: _completed[i].id,
                              name: _completed[i].name,
                              actionName: _completed[i].actionName!,
                              actionIcon: stringToAction,
                              date: _completed[i].createdOn,
                              totalAction: _completed[i].count,
                              actionQty: _completed[i].qty,
                              actionPending: (_completed[i].heartPending! / _completed[i].cost ) > 0
                                ? (_completed[i].heartPending! / _completed[i].cost).round()
                                : 0
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
  final String actionName;
  final IconData actionIcon;
  final int? actionQty;
  final int? totalAction;
  final int? actionPending;
  final DateTime? date;

  SocialMediaTile({
    required this.id,
    this.backColor,
    this.campaignId,
    this.name,
    required this.actionName,
    required this.actionIcon,
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
                          '',
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
                                '$actionName: $totalAction / $actionQty',
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                actionIcon,
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

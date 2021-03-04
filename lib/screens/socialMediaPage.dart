import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './socialMediaDetails.dart';
import '../providers/campaignData.dart';
import '../widgets/shadowBox.dart';
import '../widgets/startingCode.dart';

class SocialMediaPage extends StatefulWidget {
  static const String id = 'SocialMediaPage';

  @override
  _SocialMediaPageState createState() => _SocialMediaPageState();
}

class _SocialMediaPageState extends State<SocialMediaPage> {
  bool _spinner = false;
  Media _media;
  List<CampaignClass> _data = [];
  @override
  void initState() {
    print('initState');
    setState(() {
      _spinner = true;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _media = ModalRoute.of(context).settings.arguments;
    if (_spinner == true) {
      Provider.of<CampaignData>(context, listen: false)
          .fetchCampaign(_media)
          .then((value) {
        _data = Provider.of<CampaignData>(context, listen: false).data;
        setState(() {
          _spinner = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  Future<void> press(int id) async {
    Navigator.pushNamed(context, SocialMediaDetails.id, arguments: id)
        .then((value) => {
              // Provider.of<CampaignData>(context).fetchCampaign(_media)
            });
  }

  @override
  Widget build(BuildContext context) {
    print('inside');
    media = _media;
    return StartingCode(
      title: '$mediaString',
      widget: _spinner == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _data.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: const Center(
                    child: const Text(
                      'You have helped promote many campaigns... congratulations! Please come back soon and we will have some more campaigns for you!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  itemBuilder: (context, index) {
                    actionIcon = _data[index].action;
                    return SocialMediaTile(
                      onPress: () => press(_data[index].id),
                      url: _data[index].pageUrl,
                      snippetUrl: _data[index].urlImage,
                      author: _data[index].authorName,
                      heart: _data[index].cost,
                    );
                  },
                  itemCount: _data.length,
                ),
    );
  }
}

class SocialMediaTile extends StatelessWidget {
  final Function onPress;
  final String url;
  final String author;
  final String snippetUrl;
  final int heart;

  SocialMediaTile({
    this.onPress,
    this.url,
    this.author,
    this.snippetUrl,
    this.heart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GestureDetector(
            onTap: onPress,
            // Clipboard.setData(
            //   ClipboardData(text: url),

            child: Tooltip(
              message: 'Copied',
              child: ShadowBox(
                widget: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      child: Image.network(
                        snippetUrl,
                        fit: BoxFit.cover,
                      ),
                      // Image.file(File(snippetUrl)),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            height: 20,
                            child: Text(
                              author,
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            height: 40,
                            child: Text(
                              url,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  actionToIcon,
                                  size: 15,
                                  color: Colors.pinkAccent,
                                ),
                                Row(
                                  children: [
                                    Text(heart.toString()),
                                    const Icon(
                                      Icons.favorite,
                                      color: Colors.pink,
                                    ),
                                  ],
                                ),
                              ],
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

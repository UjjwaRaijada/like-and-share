import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/misc.dart';
import '../widgets/startingCode.dart';
import '../widgets/qATile.dart';

class FAQ extends StatelessWidget {
  static const String id = 'FAQ';

  @override
  Widget build(BuildContext context) {
    Provider.of<Misc>(context).faqs();
    List<FAQs> data = Provider.of<Misc>(context).faqData;
    return StartingCode(
      title: 'FAQs',
      widget: Container(
        padding: EdgeInsets.all(18),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return QATile(
              ques: data[index].ques,
              ans: data[index].ans,
            );
          },
          itemCount: data.length,
        ),
      ),
    );
  }
}

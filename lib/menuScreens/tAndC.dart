import 'package:flutter/material.dart';

import '../widgets/startingCode.dart';

class TAndC extends StatelessWidget {
  static const String id = 'TAndC';
  @override
  Widget build(BuildContext context) {
    return StartingCode(
      title: 'Terms Of Use',
      widget: Container(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyText1!,
            textAlign: TextAlign.justify,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to Like & Share!',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                    'At Like & Share, we build technologies & services to help people/businesses promote themselves on social media pages.The following Terms & Conditions govern your use of the Like & Share application. This Product is provided to you by LikeAndShare.app'),
                const Text(
                    'We do not sell your personal data to anyone. Your data, like your actual name & the name that appears on your social media page is shown to the creator of a particular campaign (whom you have helped), to enable the creator to verify your action & vice versa.'),
                const SizedBox(height: 15),
                const Text(
                  'Our Services',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                    'In this digital era, social media plays a very important role in promoting oneself as well as various small and large businesses. Generic promotion takes a lot of time. Big companies/individuals with good spending capacities, take the help of marketers to promote their pages and posts. However, not necessarily everyone has deep pockets.'),
                const Text(
                    'Like & Share is for everyone. It is primarily free to use and is intended to be so for ever. People/ organisations can help each other to promote their campaigns and can earn Heart points as reward. These Heart points can be used to promote your own campaigns.'),
                const Text(
                    'For faster promotion we also have paid services. Pricing completely depends on the volume of the promotion required.'),
                const SizedBox(height: 15),
                const Text(
                  'Restrictions',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                    'Below is the list of type of promotions which should not be promoted using Like & Share platform. If anyone is found to defy these conditions, they shall be reported to the appropriate authority of Indian Government and shall be blocked from Like & Share'),
                const Text('1. Pornography / adult content / nudity.'),
                const Text(
                    '2. Posts that can likely create any violence / unrest in the society.'),
                const Text('3. Fake content / rumours.'),
                const Text('4. Violence.'),
                const Text('5. Hate speech.'),
                const Text('6. Suicide / self injury.'),
                const Text('7. Unauthorised sales.'),
                const Text('8. Terrorism.'),
                const Text(
                    'Decision taken by Like & Share will be final. Any campaign can be blocked by the admin without  any reasoning given to the user, if necessary.'),
                const Text(
                    'While creating a campaign for a particular social media, the respective social media icon should only be selected and url of the selected social media page should only be provided. In case the user does not adhere to this condition, user will be penalised. Upon repetitive actions, the user’s account will be blocked and the user will be blacklisted from using any services of Like & Share.'),
                const SizedBox(height: 15),
                const Text(
                  'Content Privacy',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('Like & Share does not sell any content to anyone.'),
                const Text(
                    'By using the Like & Share application, you understand that campaigns promoted by you will be seen by other users. Your name will be visible to other users, along with other data shared by you in respect to that campaign. By taking action on campaigns posted by other users, your name and other information shared by you regarding that campaign promotion will be shared by the creator of the campaign.'),
                const SizedBox(height: 15),
                const Text(
                  'Disclaimer',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                    'Like & Share is not liable for any kind of loss incurred due to the use of this application. The user should take all the necessary precautions.'),
                const Text(
                    'In case of any discrepancy, decision taken by Like & Share will be final. Explanation for the decision taken by the admin might & might not be given to the user. Any loss of Heart points due to malfunction in the app will be reimbursed to the user on providing valid proof.'),
                const Text(
                    'Like & Share uses logos & icons of other Social Media Pages & Brands only for categorization purposes.\r\nWhen you click on either of the logos, Like & Share displays the respective web page on its embedded browser. \r\nLike & Share neither claims to own these logos & icons nor does it claim to provide any of the services / features associated with them. \r\nLike & Share is not affiliated or linked to any other company or brand other than those specifically mentioned in its documentations.\r\nLike & Share holds all the rights of use of its own logo i.e., Like & Share.\r\nFor more details please read our \"Terms of Use\".'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

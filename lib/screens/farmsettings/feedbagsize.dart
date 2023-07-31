import 'package:flutter/material.dart';
import 'package:poultry_app/screens/farmsettings/addfeedbag.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';

class FeedBagSizePage extends StatelessWidget {
  const FeedBagSizePage({super.key});

  @override
  Widget build(BuildContext context) {
    List feedBags = [
      "50 kg",
      "40 kg",
      "30 kg",
    ];
    return Scaffold(
      floatingActionButton: FloatedButton(onTap: () {
        NextScreen(context, const AddFeedBagSize());
      }),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Feed Bag Size",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            addVerticalSpace(20),
            const Divider(
              height: 0,
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: feedBags.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 0,
                  );
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      feedBags[index],
                      style: bodyText17w500(color: black),
                    ),
                  );
                }),
            const Divider(
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}

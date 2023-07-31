import 'package:flutter/material.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/otherwidgets.dart';

class TodayRatePage extends StatefulWidget {
  const TodayRatePage({super.key});

  @override
  State<TodayRatePage> createState() => _TodayRatePageState();
}

class _TodayRatePageState extends State<TodayRatePage> {
  List states = ["Maharashtra", "Delhi", "Chennai", "Kolkata"];
  List category = [
    {"image": "assets/images/hen.png", "title": "Broiler Chicken\nRates"},
    {"image": "assets/images/bdeshi.png", "title": "Broiler Chicken\nRates"},
    {"image": "assets/images/begg.png", "title": "Broiler Chicken\nRates"},
    {"image": "assets/images/bch.png", "title": "One Day Chicks-\nBroiler"},
    {"image": "assets/images/cd.png", "title": "One Day Chicks-\nDeshi"},
    {"image": "assets/images/be.png", "title": "Hatching Egg\nRates"},
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(title: "Today's Rates"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height(context) * .2,
              child: ListView.builder(
                  itemCount: 6,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      child: popularCategory(
                          context,
                          category[index]['image'],
                          category[index]['title'],
                          width(context) * .275,
                          width(context) * .275,
                          color: index == currentIndex ? yellow : normalGray,
                          bgColor: white),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  addVerticalSpace(15),
                  CustomDropdown(
                    hint: "Select State",
                    list: states,
                    height: 41,
                    textStyle: bodyText14normal(color: black),
                  ),
                  addVerticalSpace(20),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      "Broiler Chicken Rate per kg in Rupees (INR)",
                      style: bodyText11w400(color: darkGray),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        addVerticalSpace(5),
                        Text(
                          "Mumbai VHL",
                          style: bodyText14w500(color: darkGray),
                        ),
                        addVerticalSpace(10),
                        Row(
                          children: [
                            SizedBox(
                                width: width(context) * .45,
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: "Today: ",
                                      style: bodyText14w600(color: black)),
                                  TextSpan(
                                      text: "\u{20B9} ",
                                      style: bodyText18w400(color: black)),
                                  TextSpan(
                                      text: "117",
                                      style: bodyText14w600(color: black))
                                ]))),
                            SizedBox(
                                width: width(context) * .45,
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: "Yesterday: ",
                                      style: bodyText14w600(color: black)),
                                  TextSpan(
                                      text: "\u{20B9} ",
                                      style: bodyText18w400(color: black)),
                                  TextSpan(
                                      text: "--",
                                      style: bodyText14w600(color: black))
                                ]))),
                          ],
                        ),
                        addVerticalSpace(5)
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: 4),
            const Divider()
          ],
        ),
      ),
    );
  }
}

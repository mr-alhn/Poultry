import 'package:flutter/material.dart';
import 'package:poultry_app/screens/auth/login.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/navigation.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();

    int logIndex = 2;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: height(context),
            child: PageView(
              controller: pageController,
              onPageChanged: (i) {
                setState(() {
                  if (logIndex == i) {
                    NextScreen(context, const LogIn());
                  }
                });
              },
              children: const [
                PageViewItemWidget(
                  assetUrl: 'assets/images/intro1.png',
                  title: "Poultry Hub App",
                  subtitle:
                      "provides the poultry farmer to records day to day poultry activity in app, through which farmer can analyze and takes best decision to maximize poultry business profit.",
                ),
                PageViewItemWidget(
                  assetUrl: 'assets/images/intro2.png',
                  title: "Poultry Hub App",
                  subtitle:
                      "provides platform to Poultry Farmer, Trader, and Reatiler to connect with each other to grow business.",
                ),
                LogIn()
              ],
            ),
          ),
          Positioned(
              right: 35,
              bottom: height(context) * 0.025,
              child: Row(
                children: [
                  addHorizontalySpace(30),
                  InkWell(
                    onTap: () {
                      setState(() {});

                      pageController.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                    },
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: yellow,
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: white,
                        child: CircleAvatar(
                          radius: 29,
                          backgroundColor: yellow,
                          child: Icon(
                            Icons.arrow_forward,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class PageViewItemWidget extends StatelessWidget {
  final String assetUrl;
  final String title;
  final String subtitle;

  const PageViewItemWidget({
    Key? key,
    required this.assetUrl,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: height(context) * 0.5,
            width: width(context),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(
                assetUrl,
              ),
              fit: BoxFit.fill,
            ))),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: 165,
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Container(
                    height: 7,
                    width: 102,
                    color: yellow,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: bodyText24w600(color: black),
                    ),
                    addVerticalSpace(6),
                    SizedBox(
                      width: width(context) * 0.7,
                      child: Text(
                        subtitle,
                        style: bodyText15w500(color: black),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:poultry_app/screens/batches/batches.dart';
import 'package:poultry_app/screens/farmsettings/farmsettings.dart';
import 'package:poultry_app/screens/feed/myorder.dart';
import 'package:poultry_app/screens/mainscreens/homepage.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/otherwidgets.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  List body = [
    const HomePage(),
    const BatchPage(),
    const MyOrdersPage(),
    const FarmSettingsPage(),
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: body[index],
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatedWidget(onTap: () {
                  setState(() {
                    index = 0;
                  });
                },
                    "assets/images/sh.png",
                    "Buy/Sell",
                    index == 0 ? yellow : normalGray,
                    index == 0 ? black : black.withOpacity(.5)),
                FloatedWidget(onTap: () {
                  setState(() {
                    index = 1;
                  });
                },
                    "assets/images/b.png",
                    "Batches",
                    index == 1 ? yellow : normalGray,
                    index == 1 ? black : black.withOpacity(.5)),
                FloatedWidget(onTap: () {
                  setState(() {
                    index = 2;
                  });
                },
                    "assets/images/fe.png",
                    "Stock Room",
                    index == 2 ? yellow : normalGray,
                    index == 2 ? black : black.withOpacity(.5)),
                FloatedWidget(onTap: () {
                  setState(() {
                    index = 3;
                  });
                },
                    "assets/images/s.png",
                    "Settings",
                    index == 3 ? yellow : normalGray,
                    index == 3 ? black : black.withOpacity(.5)),
              ],
            ),
          ),
        ));
  }
}

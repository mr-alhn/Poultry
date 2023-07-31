import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/mainscreens/postad.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:poultry_app/widgets/otherwidgets.dart';

class HomepageSell extends StatefulWidget {
  const HomepageSell({super.key});

  @override
  State<HomepageSell> createState() => _HomepageSellState();
}

class _HomepageSellState extends State<HomepageSell> {
  @override
  void initState() {
    super.initState();
    getCategory();
  }

  List sell = [];

  void getCategory() async {
    DatabaseReference reference = FirebaseDatabase.instance.ref();
    await reference.child('Categories').once().then((value) {
      if (value.snapshot.value != null) {
        Map response = value.snapshot.value as Map;
        sell = response.values.toList();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // List sell = [
    //   {"image": "assets/images/birds.png", "name": "Broiler"},
    //   {"image": "assets/images/deshi.png", "name": "Deshi"},
    //   {"image": "assets/images/egg.png", "name": "Eggs"},
    //   {"image": "assets/images/eggs.png", "name": "Hatching Eggs"},
    //   {"image": "assets/images/chick.png", "name": "Chicks"},
    //   {"image": "assets/images/machine.png", "name": "Machine & Equipments"},
    //   {"image": "assets/images/meat.png", "name": "Chicken Meat"},
    //   {"image": "assets/images/medicine.png", "name": "Poultry Mediciine"},
    //   {"image": "assets/images/fee.png", "name": "Poultry Feed"},
    //   {"image": "assets/images/vac.png", "name": "Vaccines"},
    //   {"image": "assets/images/transport.png", "name": "Transportation"},
    // ];

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          title: "What are you selling?",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
                itemCount: sell.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: width(context) * .27 / 136,
                    crossAxisCount: 3),
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        NextScreen(
                            context,
                            PostAdPage(
                              title: sell[index]['name'],
                            ));
                      },
                      child: popularCategory(
                          context,
                          sell[index]['image'],
                          sell[index]['name'],
                          width(context) * .3,
                          width(context) * .3),
                    )),
          ],
        ),
      ),
    );
  }
}

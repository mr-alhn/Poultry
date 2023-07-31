import 'package:flutter/material.dart';
import 'package:poultry_app/screens/farmsettings/addeggtraysize.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';

class EggTraySize extends StatelessWidget {
  const EggTraySize({super.key});

  @override
  Widget build(BuildContext context) {
    List cat = [
      "30 Eggs",
      "20 Eggs",
      "25 Eggs",
    ];
    return Scaffold(
      floatingActionButton: FloatedButton(onTap: () {
        NextScreen(context, const AddTraysSize());
      }),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Egg Tray Size",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            addVerticalSpace(10),
            const Divider(
              height: 0,
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cat.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 0,
                  );
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      cat[index],
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

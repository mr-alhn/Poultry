import 'package:flutter/material.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/searchbox.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  List currency = [
    {"currency": "INR"},
    // {"currency": "USD"},
    // {"currency": "AFN"},
    // {"currency": "DZD"},
    // {"currency": "EUR"},
    // {"currency": "AUD"},
    // {"currency": "CAD"},
    // {"currency": "EGP"},
    // {"currency": "ILS"},
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Currency",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: CustomSearchBox(
                hint: "Search Currency",
                isEnabled: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Current',
                style: bodyText14Bold(color: black.withOpacity(0.3)),
              ),
            ),
            const Divider(
              height: 0,
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60,
                        child: Center(
                          child: ListTile(
                            onLongPress: () {
                              setState(() {
                                currentIndex == index;
                              });
                            },
                            leading: Image.asset("assets/images/flag.png"),
                            title: Text(
                              currency[index]['currency'],
                              style: bodyText16w500(color: black),
                            ),
                            trailing: currentIndex == index
                                ? Icon(
                                    Icons.check_circle_outline_outlined,
                                    color: black,
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 0,
                  );
                },
                itemCount: currency.length),
            const Divider(
              height: 0,
            )
          ],
        ),
      ),
    );
  }
}

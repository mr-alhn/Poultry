import 'package:flutter/material.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/stockin.dart';
import 'package:poultry_app/widgets/stockout.dart';

class TransferInventory extends StatefulWidget {
  const TransferInventory({super.key});

  @override
  State<TransferInventory> createState() => _TransferInventoryState();
}

class _TransferInventoryState extends State<TransferInventory> {
  String choice = "stockIn";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          bottom: true,
          title: "Transfer Inventory",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            addVerticalSpace(20),
            Row(
              children: [
                Transform.scale(
                  scale: 1.1,
                  child: Radio(
                    activeColor: yellow,
                    value: "stockIn",
                    groupValue: choice,
                    onChanged: (value) {
                      setState(() {
                        choice = value!;
                      });
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      choice = "stockIn";
                    });
                  },
                  child: Text(
                    "Stock In",
                    style: bodyText15w500(color: darkGray),
                  ),
                ),
                addHorizontalySpace(width(context) / 3.5),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 15),
                //   child: FlutterSwitch(
                //     padding: 3,
                //     value: stockin,
                //     inactiveColor: yellow,
                //     activeColor: yellow,
                //     onToggle: (value) {
                //       setState(() {
                //         stockin = value;
                //       });
                //     },
                //     width: 50,
                //     height: 25,
                //     toggleSize: 20,
                //   ),
                // ),
                Transform.scale(
                  scale: 1.1,
                  child: Radio(
                    activeColor: yellow,
                    value: "stockOut",
                    groupValue: choice,
                    onChanged: (value) {
                      setState(() {
                        choice = value!;
                      });
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      choice = "stockOut";
                    });
                  },
                  child: Text(
                    "Stock Out",
                    style: bodyText15w500(color: black),
                  ),
                ),
              ],
            ),
            addVerticalSpace(20),
            choice == "stockOut" ? const StockOutWidget() : const StockInWidget()
          ],
        ),
      ),
    );
  }
}

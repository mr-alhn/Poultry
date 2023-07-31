import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/feed/addinventory.dart';
import 'package:poultry_app/screens/feed/transferinventory.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/searchbox.dart';

class InventoryWidget extends StatefulWidget {
  const InventoryWidget({super.key});
  @override
  MyInventoryWidgetState createState() => MyInventoryWidgetState();
}

class MyInventoryWidgetState extends State<InventoryWidget> {
  List inventory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getInventoryDetails();
  }

  Future<void> getInventoryDetails() async {
    inventory.clear();
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('inventory')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        //data present
        for (int i = 0; i < value.data()!.length; i++) {
          int inventoryQuantity = int.parse(
              value.data()!["order${i + 1}"]["feedQuantity"].toString());
          if (inventoryQuantity != 0) {
            setState(() {
              inventory.add({
                "orderNo": "${i + 1}",
                "feedCompany": value.data()!["order${i + 1}"]["feedCompany"],
                "bagLocation": value.data()!["order${i + 1}"]["bagLocation"],
                "feedPrice": double.parse(
                    value.data()!["order${i + 1}"]["feedPrice"].toString()),
                "feedQuantity": inventoryQuantity,
                "feedType": value.data()!["order${i + 1}"]["feedType"],
              });
            });
          }
        }
        print(inventory);
      } else {
        print('No data!');
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        addVerticalSpace(15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: white,
                        minimumSize: Size(width(context), 45),
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(),
                            borderRadius: BorderRadius.circular(10))),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/addcircle.png",
                          height: 22,
                        ),
                        addHorizontalySpace(20),
                        Text(
                          "Add",
                          style: bodyText16w500(color: black),
                        )
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddInventoryPage()))
                          .then((value) {
                        if (value == null) {
                          return;
                        } else {
                          if (value) {
                            getInventoryDetails();
                          }
                        }
                      });
                    },
                  )),
                  addHorizontalySpace(15),
                  Expanded(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: white,
                        minimumSize: Size(width(context), 45),
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(),
                            borderRadius: BorderRadius.circular(10))),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/restore.png",
                          height: 22,
                        ),
                        addHorizontalySpace(20),
                        Text(
                          "Transfer",
                          style: bodyText16w500(color: black),
                        )
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TransferInventory()))
                          .then((value) {
                        if (value == null) {
                          return;
                        } else {
                          if (value) {
                            getInventoryDetails();
                          }
                        }
                      });
                    },
                  ))
                ],
              ),
              addVerticalSpace(25),
              GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(msg: "Coming Soon!");
                },
                child: const CustomSearchBox(
                  isEnabled: false,
                ),
              ),
            ],
          ),
        ),
        addVerticalSpace(20),
        const Divider(
          height: 0,
        ),
        isLoading == true
            ? const CircularProgressIndicator()
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              inventory[index]["feedType"],
                              style: bodyText15w500(color: black),
                            ),
                            Text(
                              inventory[index]["feedCompany"],
                              style: bodyText12normal(color: darkGray),
                            ),
                            Text(
                              "Quantity: ${inventory[index]["feedQuantity"]} bags",
                              style: bodyText12normal(color: black),
                            ),
                            Text(
                              "Bag Location: ${inventory[index]["bagLocation"]}",
                              style: bodyText12normal(color: black),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 15),
                                //   child: Image.asset("assets/images/tpad.png"),
                                // ),
                                // Image.asset("assets/images/editI.png")
                                Container(),
                              ],
                            ),
                            Text(
                              "Order No: ${inventory[index]["orderNo"]}",
                              style: bodyText12normal(color: black),
                            ),
                            Text(
                              "Price: ${inventory[index]["feedPrice"]}/bag",
                              style: bodyText12normal(color: black),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 0,
                  );
                },
                itemCount: inventory.length),
        // addVerticalSpace(
        //   10.0,
        // ),
//         Container(
//           width: width(context) * 0.85,
//           child: Center(
//             child: Text(
//               """How to use Stock Room section to keep records of feed ordered.

// For Every poultry farm poultry feed is needed.
// So farmer do following activity to stock management.

// 1.Place feed order to feed company along with payment details
// Step 1.  Click on Order>>>click plus sign>>>fill the form >>>Click on Place Order.

// 2. Placed feed order, received at Poultry Farm
// Step 2. Click on Add >>>Select Order No>>>Check order details>>>Click Feed Received .

// 3.Received Feed need to be transfer to specific Batch.
// Step 3. Click On Inventory >>> Click On Transfer>>>Select Stock Out >>> fill the Stock out form>>Click on Feed Transfer.

// 4. After Batch Sold remaining stock must be transfer to stock room.
// Step 4.Click On Inventory >>>Click On Transfer >>>Select Stock In >>>Fill the form>>Click on Transfer feed to Inventory""",
//               style: bodyText14w500(color: darkGray),
//               textAlign: TextAlign.left,
//             ),
//           ),
//         ),
//         addVerticalSpace(
//           10.0,
//         ),
      ],
    );
  }
}

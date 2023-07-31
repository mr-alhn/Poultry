import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/batches/batches.dart';
import 'package:poultry_app/screens/batches/newbatch.dart';

import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/analysis.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/records.dart';
import 'package:poultry_app/widgets/reports.dart';
import 'package:poultry_app/screens/batches/bodyweight.dart';
import 'package:poultry_app/screens/batches/eggs.dart';
import 'package:poultry_app/screens/batches/expense.dart';
import 'package:poultry_app/screens/batches/feedserved.dart';
import 'package:poultry_app/screens/batches/income.dart';
import 'package:poultry_app/screens/batches/medicine.dart';
import 'package:poultry_app/screens/batches/mortality.dart';
import 'package:poultry_app/screens/batches/notes.dart';
import 'package:poultry_app/screens/batches/stocks.dart';
import 'package:poultry_app/screens/batches/subuser.dart';
import 'package:poultry_app/screens/batches/vaccination.dart';

class BatchRecordPage extends StatefulWidget {
  final int index;

  const BatchRecordPage({super.key, required this.index});

  @override
  State<BatchRecordPage> createState() => _BatchRecordPageState();
}

//List<String> BatchName = [];

class _BatchRecordPageState extends State<BatchRecordPage> {
  String batchType = "";
  int totalChicks = 0;
  int sold = 0;
  int mortality = 0;
  int live = 0;
  String owner = "";
  bool isActive = true;
  int accessLevel = 0; //signifies admin
  //1 for view only
  //2 for edit :)

  Future<void> getOwnerAndAccessLevel() async {
    await FirebaseFirestore.instance
        .collection("batches")
        .doc(batchDocIds[widget.index])
        .get()
        .then((value) async {
      print(value.data()!["owner"].toString());
      setState(() {
        owner = value.data()!["owner"].toString();
      });

      await FirebaseFirestore.instance
          .collection("users")
          .doc(owner)
          .collection("Batches")
          .doc(batchDocIds[widget.index])
          .get()
          .then((value) {
        if (value.data()!["active"] == false) {
          setState(() {
            accessLevel = 1; //view only!
            switchindex = 1;
            isActive = false;
          });
          print(isActive);
        }
      });
      if (accessLevel != 1) {
        for (int i = 0; i < value.data()!["userIDs"].length; i++) {
          if (value.data()!["userIDs"][i]["id"] ==
              FirebaseAuth.instance.currentUser!.uid) {
            String accessType = value.data()!["userIDs"][i]["type"].toString();
            if (accessType == "View Only") {
              setState(() {
                accessLevel = 1;
                switchindex = 1;
              });
            } else if (accessType == "Edit Only") {
              setState(() {
                accessLevel = 2;
                switchindex = 0;
              });
            } else {
              accessLevel = 0; //admin
              switchindex = 1;
            }

            break;
          }
        }
      }
    });
  }

  Future<void> checkTypeAndGetDetails() async {
    await getOwnerAndAccessLevel();

    print("AccessLevel: $accessLevel");
    //get user access level!
    await FirebaseFirestore.instance
        .collection('users')
        .doc(owner)
        .collection('Batches')
        .doc(batchDocIds[widget.index])
        .get()
        .then((values) {
      print(values);
      setState(() {
        batchType = values["Breed"];
        totalChicks = int.parse(values["NoOfBirds"].toString());
        sold = int.parse(values["Sold"].toString());
        mortality = int.parse(values["Mortality"].toString());
        live = totalChicks - sold - mortality;
      });
    });
    print(batchType);
  }

  Future<void> getDetails() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(owner)
        .collection('Batches')
        .doc(batchDocIds[widget.index])
        .get()
        .then((values) {
      print(values);
      setState(() {
        batchType = values["Breed"];
        totalChicks = int.parse(values["NoOfBirds"].toString());
        sold = int.parse(values["Sold"].toString());
        mortality = int.parse(values["Mortality"].toString());
        live = totalChicks - sold - mortality;
      });
    });
    print(batchType);
  }

  // List<dynamic> record = [
  //   {
  //     "lead": "assets/images/income.png",
  //     "text": "income",
  //     "screen": IncomePage(index : widget.index)
  //   },
  //   {
  //     "lead": "assets/images/expense.png",
  //     "text": "Expenses",
  //     "screen": ExpensesPage()
  //   },
  //   {
  //     "lead": "assets/images/feed.png",
  //     "text": "Feed Served",
  //     "screen": FeedServedPage()
  //   },
  //   {
  //     "lead": "assets/images/mort.png",
  //     "text": "Mortality",
  //     "screen": MortalityPage()
  //   },
  //   {
  //     "lead": "assets/images/body.png",
  //     "text": "Body weight",
  //     "screen": BodyWeightPage()
  //   },
  //   {
  //     "lead": "assets/images/stock.png",
  //     "text": "Stocks",
  //     "screen": StocksPage()
  //   },
  //   {
  //     "lead": "assets/images/vaccine.png",
  //     "text": "Vaccination",
  //     "screen": VaccinationPage()
  //   },
  //   {
  //     "lead": "assets/images/medi.png",
  //     "text": "Medicine",
  //     "screen": MedicinePage()
  //   },
  //   {"lead": "assets/images/medi.png",
  //     "text": "Notes",
  //     "screen": NotesPage()},
  //   {"lead": "assets/images/medi.png",
  //     "text": "Eggs",
  //     "screen": EggsPage()},
  //   {
  //     "lead": "assets/images/medi.png",
  //     "text": "Sub User",
  //     "screen": SubUserPage()
  //   },
  // ];
  @override
  void initState() {
    super.initState();
    checkTypeAndGetDetails();
  }

  int switchindex = 0;
  @override
  Widget build(BuildContext context) {
    List<dynamic> recordEggs = [
      {
        "lead": "assets/images/income.png",
        "text": "Income",
        "screen": IncomePage(
            index: widget.index, accessLevel: accessLevel, owner: owner),
      },
      {
        "lead": "assets/images/expense.png",
        "text": "Expenses",
        "screen": ExpensesPage(
            docId: batchDocIds[widget.index],
            accessLevel: accessLevel,
            owner: owner)
      },
      {
        "lead": "assets/images/feed.png",
        "text": "Feed Served",
        "screen": FeedServedPage(
            docId: batchDocIds[widget.index],
            accessLevel: accessLevel,
            owner: owner),
      },
      {
        "lead": "assets/images/mort.png",
        "text": "Mortality",
        "screen": MortalityPage(
            index: widget.index, accessLevel: accessLevel, owner: owner),
      },
      {
        "lead": "assets/images/body.png",
        "text": "Body weight",
        "screen": BodyWeightPage(
            batchId: batchDocIds[widget.index],
            accessLevel: accessLevel,
            owner: owner)
      },
      {
        "lead": "assets/images/stock.png",
        "text": "Stocks",
        "screen": StocksPage(docId: batchDocIds[widget.index], owner: owner)
      },
      {
        "lead": "assets/images/vaccine.png",
        "text": "Vaccination",
        "screen": VaccinationPage(
            batchId: batchDocIds[widget.index],
            accessLevel: accessLevel,
            owner: owner)
      },
      {
        "lead": "assets/images/medi.png",
        "text": "Medicine",
        "screen": MedicinePage(
            index: widget.index, accessLevel: accessLevel, owner: owner),
      },
      {
        "lead": "assets/images/list.png",
        "text": "Notes",
        "screen": NotesPage(
            index: widget.index, accessLevel: accessLevel, owner: owner),
      },
      {
        "lead": "assets/images/eggtrau.png",
        "text": "Eggs",
        "screen": EggsPage(
            index: widget.index, accessLevel: accessLevel, owner: owner),
      },
      {
        "lead": "assets/images/useradd.png",
        "text": "Sub User",
        "screen": SubUserPage(
            index: widget.index, accessLevel: accessLevel, owner: owner),
      }
    ];

    List<dynamic> recordNormal = [
      {
        "lead": "assets/images/income.png",
        "text": "Income",
        "screen": IncomePage(
          index: widget.index,
          accessLevel: accessLevel,
          owner: owner,
        )
      },
      {
        "lead": "assets/images/expense.png",
        "text": "Expenses",
        "screen": ExpensesPage(
            docId: batchDocIds[widget.index],
            accessLevel: accessLevel,
            owner: owner)
      },
      {
        "lead": "assets/images/feed.png",
        "text": "Feed Served",
        "screen": FeedServedPage(
            docId: batchDocIds[widget.index],
            accessLevel: accessLevel,
            owner: owner),
      },
      {
        "lead": "assets/images/mort.png",
        "text": "Mortality",
        "screen": MortalityPage(
            index: widget.index, accessLevel: accessLevel, owner: owner),
      },
      {
        "lead": "assets/images/body.png",
        "text": "Body weight",
        "screen": BodyWeightPage(
            batchId: batchDocIds[widget.index],
            accessLevel: accessLevel,
            owner: owner)
      },
      {
        "lead": "assets/images/stock.png",
        "text": "Stocks",
        "screen": StocksPage(docId: batchDocIds[widget.index], owner: owner),
      },
      {
        "lead": "assets/images/vaccine.png",
        "text": "Vaccination",
        "screen": VaccinationPage(
            batchId: batchDocIds[widget.index],
            accessLevel: accessLevel,
            owner: owner)
      },
      {
        "lead": "assets/images/medi.png",
        "text": "Medicine",
        "screen": MedicinePage(
          index: widget.index,
          accessLevel: accessLevel,
          owner: owner,
        ),
      },
      {
        "lead": "assets/images/list.png",
        "text": "Notes",
        "screen": NotesPage(
          index: widget.index,
          accessLevel: accessLevel,
          owner: owner,
        ),
      },
      {
        "lead": "assets/images/useradd.png",
        "text": "Sub User",
        "screen": SubUserPage(
          index: widget.index,
          accessLevel: accessLevel,
          owner: owner,
        )
      }
    ];

    //print(batchName);
    //print (switchindex);
    List widgets = [
      RecordsWidget(
        record: batchType == "Layer" || batchType == "Breeder Farm"
            ? recordEggs
            : recordNormal,
      ),
      accessLevel == 0 || accessLevel == 1
          ? AnalysisWidget(
              owner: owner,
              batchId: batchDocIds[widget.index],
              disabled: accessLevel == 0 || accessLevel == 1 ? false : true,
            )
          : AnalysisWidget(
              owner: owner,
              batchId: batchDocIds[widget.index],
              disabled: true,
            ),
      accessLevel == 0 || accessLevel == 1
          ? ReportsWidget(
              owner: owner,
              batchId: batchDocIds[widget.index],
            )
          : null,
    ];
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Container(
                    height: 101,
                    padding: const EdgeInsets.only(left: 15, bottom: 10),
                    decoration: shadowDecoration(12, 0, white,
                        bcolor: yellow, width: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              batchName[widget.index],
                              style: bodyText16w600(color: black),
                            ),
                            Row(
                              children: [
                                Container(
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) => SubUserPage(
                                                      index: widget.index,
                                                      accessLevel: accessLevel,
                                                      owner: owner,
                                                    )));
                                      },
                                      icon: const ImageIcon(AssetImage(
                                          "assets/images/useradd.png"))),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) => NewBatch(
                                                    title: 'Edit Batch',
                                                    isEdit: true,
                                                    owner: owner,
                                                    docId: batchDocIds[
                                                        widget.index],
                                                  )));
                                    },
                                    icon: const ImageIcon(
                                        AssetImage("assets/images/edit.png"))),
                                isActive
                                    ? IconButton(
                                        onPressed: () {
                                          deleteWarning(context);
                                        },
                                        icon: const ImageIcon(
                                          AssetImage(
                                            "assets/images/cross.png",
                                          ),
                                          size: 20,
                                        ))
                                    : Container(),
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                          ),
                          child: Text(
                            "${details[widget.index]["weeks"]} weeks: ${details[widget.index]["days"]} days",
                            style: bodyText14normal(color: darkGray),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Chicks: $totalChicks",
                                style: bodyText12normal(color: darkGray),
                              ),
                              Text(
                                "Sold: $sold",
                                style: bodyText12normal(color: darkGray),
                              ),
                              Text(
                                "Mortality: $mortality",
                                style: bodyText12normal(color: darkGray),
                              ),
                              Text(
                                "Live: $live",
                                style: bodyText12normal(color: darkGray),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                            radius: 10,
                            textStyle: bodyText16w600(
                                color: switchindex == 0 ? white : darkGray),
                            text: "Records",
                            buttonColor: switchindex == 0 ? yellow : utbColor,
                            onClick: () {
                              setState(() {
                                switchindex = 0;
                              });
                            },
                            width: width(context),
                            height: 40),
                      ),
                      accessLevel == 2 ? Container() : addHorizontalySpace(12),
                      accessLevel == 2
                          ? Container()
                          : Expanded(
                              child: CustomButton(
                                  radius: 10,
                                  textStyle: bodyText16w600(
                                      color:
                                          switchindex == 1 ? white : darkGray),
                                  text: "Analysis",
                                  onClick: () {
                                    setState(() {
                                      switchindex = 1;
                                    });
                                  },
                                  buttonColor:
                                      switchindex == 1 ? yellow : utbColor,
                                  width: width(context),
                                  height: 40),
                            ),
                      accessLevel == 2 ? Container() : addHorizontalySpace(12),
                      accessLevel == 2
                          ? Container()
                          : Expanded(
                              child: CustomButton(
                                  radius: 10,
                                  textStyle: bodyText16w600(
                                      color:
                                          switchindex == 2 ? white : darkGray),
                                  text: "Reports",
                                  buttonColor:
                                      switchindex == 2 ? yellow : utbColor,
                                  onClick: () {
                                    setState(() {
                                      switchindex = 2;
                                    });
                                  },
                                  width: width(context),
                                  height: 40),
                            ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            owner == "" ? const CircularProgressIndicator() : widgets[switchindex],
            addVerticalSpace(20)
          ],
        ),
      ),
    );
  }

  Future<dynamic> deleteWarning(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.all(6),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return Container(
                      height: height * 0.34,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('assets/images/close 1.png'),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Are you sure you want to close the batch?',
                              textAlign: TextAlign.center,
                              style: bodyText16Bold(color: black),
                            ),
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 40,
                                  width: width * 0.3,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: yellow),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Center(
                                    child: Text(
                                      'Cancel',
                                      style: bodyText14Bold(color: black),
                                    ),
                                  ),
                                ),
                              ),
                              addHorizontalySpace(20),
                              InkWell(
                                onTap: () async {
                                  //check if inventory of batches and noBirds are 0
                                  bool containsInventory = false;
                                  bool containsChicken = false;
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(owner)
                                      .collection("Batches")
                                      .doc(batchDocIds[widget.index])
                                      .get()
                                      .then((value) {
                                    if (int.parse(value
                                                .data()!["NoOfBirds"]
                                                .toString()) -
                                            int.parse(value
                                                .data()!["Mortality"]
                                                .toString()) -
                                            int.parse(value
                                                .data()!["Sold"]
                                                .toString()) >
                                        0) {
                                      setState(() {
                                        containsChicken = true;
                                      });
                                    } else {
                                      Map inventoryMap =
                                          value.data()?["feedTypeQuantity"] ??
                                              {};
                                      for (var inventoryKeys
                                          in inventoryMap.keys.toList()) {
                                        if (inventoryKeys != "used") {
                                          Map orderMap =
                                              value.data()?["feedTypeQuantity"]
                                                      ?[inventoryKeys] ??
                                                  {};
                                          for (var orderMapKeys
                                              in orderMap.keys.toList()) {
                                            if (orderMapKeys != "used") {
                                              if (int.parse(value
                                                      .data()![
                                                          "feedTypeQuantity"]
                                                          [inventoryKeys]
                                                          [orderMapKeys]
                                                      .toString()) >
                                                  0) {
                                                setState(() {
                                                  containsInventory = true;
                                                });
                                                break;
                                              }
                                            }
                                            if (containsInventory) {
                                              break;
                                            }
                                          }
                                        }
                                      }
                                    }
                                  });

                                  if (containsInventory || containsChicken) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Please make sure your batch is empty before closing batch!");
                                    Navigator.pop(context);
                                  } else {
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(owner)
                                        .collection("Batches")
                                        .doc(batchDocIds[widget.index])
                                        .set({
                                      "active": false,
                                    }, SetOptions(merge: true));
                                    Fluttertoast.showToast(
                                        msg: "Batch Closed!");
                                    Navigator.pop(context, true);
                                    Navigator.pop(context, true);
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  width: width * 0.3,
                                  decoration: BoxDecoration(
                                      color: yellow,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Center(
                                    child: Text(
                                      'Close',
                                      style:
                                          bodyText14Bold(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ));
                },
              ),
            ));
  }
}

// void fetchData() async {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final querySnapshot = await firestore.collection('users').doc(
//       user.toString()).collection("Batches").get();
//   querySnapshot.docs.forEach((doc) {
//     //print("int " + doc.get("BatchName").toString());
//     Bname = doc.get("BatchName").toString();
//     BatchName.add(Bname);
//     print(Bname);
//   });
//
// }

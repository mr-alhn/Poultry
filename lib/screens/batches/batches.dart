//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/batches/batchrecord.dart';
import 'package:poultry_app/screens/batches/newbatch.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import '../../DataBase/batch_model.dart';

class BatchPage extends StatefulWidget {
  const BatchPage({super.key});

  @override
  State<BatchPage> createState() => _BatchPageState();
}

String bname = " ";

List<String> batchName = [];
List details = [];
List<String> batchDocIds = [];

class _BatchPageState extends State<BatchPage> with TickerProviderStateMixin {
  bool isLoading = true;
  Future<void> getListSubUserBatches(int index) async {
    bool status = index == 0 ? true : false;
    print('getting subusers');
    String owner = "";
    await FirebaseFirestore.instance
        .collection("batches")
        .get()
        .then((documents) async {
      // print(documents.docs);
      for (int i = 0; i < documents.docs.length; i++) {
        var data = documents.docs.toList()[i];
        print("i $i");
        print("data ${data.data().toString()}");
        for (int j = 0; j < data.data()["userIDs"].length; j++) {
          print("j $j");
          if (data.data()["userIDs"][j]["id"].toString() ==
              FirebaseAuth.instance.currentUser!.uid.toString()) {
            //get particular Batch details!
            //
            print('yes');
            setState(() {
              owner = data.data()["owner"];
            });

            await FirebaseFirestore.instance
                .collection("users")
                .doc(owner)
                .collection("Batches")
                .doc(data.id)
                .get()
                .then((value) {
              if (value.data()!["active"] == status) {
                List dates = value["date"].toString().split("/");
                int month = 0;
                int day = int.parse(dates[0]);
                switch (dates[1]) {
                  case "jan":
                    month = 1;
                    break;
                  case "feb":
                    month = 2;
                    break;
                  case "mar":
                    month = 3;
                    break;
                  case "apr":
                    month = 4;
                    break;
                  case "may":
                    month = 5;
                    break;
                  case "jun":
                    month = 6;
                    break;
                  case "jul":
                    month = 7;
                    break;
                  case "aug":
                    month = 8;
                    break;
                  case "sep":
                    month = 9;
                    break;
                  case "oct":
                    month = 10;
                    break;
                  case "nov":
                    month = 11;
                    break;
                  case "dec":
                    month = 12;
                    break;
                }
                int year = int.parse(dates[2]);

                DateTime batchTime = DateTime.utc(year, month, day);
                DateTime now = DateTime.now();
                DateTime currentTime =
                    DateTime.utc(now.year, now.month, now.day);
                print("${currentTime.difference(batchTime).inDays} days!");
                int differenceDays = currentTime.difference(batchTime).inDays;
                if (differenceDays < 0) {
                  setState(() {
                    details.add(
                      {
                        "weeks": 0,
                        "days": 0,
                        "type": value["Breed"].toString()
                      },
                    );
                  });
                } else {
                  setState(() {
                    details.add(
                      {
                        "weeks": differenceDays ~/ 7,
                        "days": differenceDays % 7,
                        "type": value["Breed"].toString(),
                      },
                    );
                  });
                }
                setState(() {
                  batchName.add(value.data()!["BatchName"]);
                });
              }
              setState(() {
                batchDocIds.add(data.id);
              });
            });
          } else {
            continue;
          }
        }
      }
    });
    print('eof');
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getBatches(int index) async {
    setState(() {
      isLoading = true;
    });
    bool status = index == 0 ? true : false;
    details.clear();
    batchName.clear();
    batchDocIds.clear();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Batches")
        .get()
        .then((value) {
      // int detailIndex = 0;
      for (var doc in value.docs) {
        //bname = doc.get("BatchName").toString();
        // getDateInformation();
        if (doc.get("active") == status) {
          List dates = doc.get("date").toString().split("/");
          int month = 0;
          int day = int.parse(dates[0]);
          switch (dates[1]) {
            case "jan":
              month = 1;
              break;
            case "feb":
              month = 2;
              break;
            case "mar":
              month = 3;
              break;
            case "apr":
              month = 4;
              break;
            case "may":
              month = 5;
              break;
            case "jun":
              month = 6;
              break;
            case "jul":
              month = 7;
              break;
            case "aug":
              month = 8;
              break;
            case "sep":
              month = 9;
              break;
            case "oct":
              month = 10;
              break;
            case "nov":
              month = 11;
              break;
            case "dec":
              month = 12;
              break;
          }
          int year = int.parse(dates[2]);

          DateTime batchTime = DateTime.utc(year, month, day);
          DateTime now = DateTime.now();
          DateTime currentTime = DateTime.utc(now.year, now.month, now.day);
          print("${currentTime.difference(batchTime).inDays} days!");
          int differenceDays = currentTime.difference(batchTime).inDays;
          setState(() {
            batchName.add(doc.get("BatchName").toString());
            batchDocIds.add(doc.id);
          });
          if (differenceDays < 0) {
            setState(() {
              details.add(
                {"weeks": 0, "days": 0, "type": doc.get("Breed").toString()},
              );
            });
          } else {
            setState(() {
              details.add(
                {
                  "weeks": differenceDays ~/ 7,
                  "days": differenceDays % 7,
                  "type": doc.get("Breed").toString()
                },
              );
            });
          }

          print(details);
          // setState(() {
          //   print(doc.get("Breed").toString());
          //   detailIndex += 1;
          // });
        }
      }
      print(batchDocIds);
      print(batchName);
    });
  }

  @override
  void initState() {
    super.initState();
    getBatches(index);
    getListSubUserBatches(index);
  }

  int index = 0;
  final FFInstance = FirebaseFirestore.instance;

  // Future<BatchModel> getUserDetails (String batchName) async {
  //   final snapshot = await FFInstance.collection('users').doc(user).collection("Batches")
  //       .doc("BVd0YvbKBfacEmMJIzrD")
  //       .get();
  //
  //   snapshot.data()!.map((key, value) =>{
  //   print("dsajf");
  //   }
  //   );
  //   return Bname;
  // }

// without loop fetching
  // void fetchData() async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   final querySnapshot = await firestore.collection('users').doc(user.toString()).collection("Batches").doc("BVd0YvbKBfacEmMJIzrD").get();
  //   // List<QueryDocumentSnapshot> docs = querySnapshot.('BVd0YvbKBfacEmMJIzrD');
  //
  //   print("int "+querySnapshot.get("date").toString());
  // }

// length of data
// void fetchData() async {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final querySnapshot = await firestore.collection('users').doc(user.toString()).collection("Batches").get();
//   // querySnapshot.docs.forEach((doc) {
//   //   print("int "+doc.get("date").toString());
//   // });
//   print("length "+querySnapshot.size.toString());
//
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatedButton(onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewBatch(
              title: 'New Batch',
              isEdit: false,
            ),
          ),
        ).then((value) {
          if (value == null) {
            return;
          } else {
            if (value) {
              getBatches(index);
              getListSubUserBatches(index);
            }
          }
        });
      }),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          title: "Batches",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                      child: CustomButton(
                          buttonColor: index == 0 ? yellow : normalGray,
                          textStyle: bodyText16w600(
                              color: index == 0 ? white : darkGray),
                          text: "Active Batch",
                          onClick: () async {
                            setState(() {
                              index = 0;
                            });
                            await getBatches(index);
                            await getListSubUserBatches(index);
                          },
                          width: width(context) * .35,
                          height: 40)),
                  addHorizontalySpace(15),
                  Expanded(
                      child: CustomButton(
                          buttonColor: index == 1 ? yellow : normalGray,
                          text: "Closed Batch",
                          textStyle: bodyText16w600(
                              color: index == 1 ? white : darkGray),
                          onClick: () async {
                            setState(() {
                              index = 1;
                            });
                            await getBatches(index);
                            await getListSubUserBatches(index);
                          },
                          width: width(context) * .35,
                          height: 40)),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: Text(
                    "Total Batches: ${batchName.length}",
                    textAlign: TextAlign.end,
                    style: bodyText18w400(color: darkGray),
                  ),
                ),
                addVerticalSpace(10),
                const Divider(),

                Flexible(
                    child: isLoading == true
                        ? const CircularProgressIndicator()
                        : ListView.separated(
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: batchName.length,
                            itemBuilder: (context, index) {
                              int days = 0;
                              int weeks = 0;
                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BatchRecordPage(
                                        index: index,
                                      ),
                                    ),
                                  ).then((value) {
                                    if (value == null) {
                                      return;
                                    } else {
                                      getBatches(index);
                                      getListSubUserBatches(index);
                                    }
                                  });
                                },
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: yellow,
                                  child: details[index]["type"] == "Layer" ||
                                          details[index]["type"] ==
                                              "Breeder Farm"
                                      ? Image.asset("assets/images/eggI.png")
                                      : Image.asset("assets/images/henI.png"),
                                ),
                                title: Text(
                                  batchName[index],
                                  style: bodyText16w500(color: black),
                                ),
                                subtitle: Text(
                                  "${details[index]["weeks"]} Weeks : ${details[index]["days"]} Days",
                                  style: bodyText12normal(color: darkGray),
                                ),
                              );
                            })),
                // ListView.separated(
                //
                //     separatorBuilder: (context, index) {
                //       return Divider();
                //     },
                //     shrinkWrap: true,
                //     physics: NeverScrollableScrollPhysics(),
                //     itemCount: Length,
                //     itemBuilder: (context, index) {
                //
                //       return ListTile(
                //
                //         onTap: () {
                //           NextScreen(context, BatchRecordPage());
                //         },
                //         leading: CircleAvatar(
                //           radius: 25,
                //           backgroundColor: yellow,
                //           child: Image.asset("assets/images/henI.png"),
                //         ),
                //         title: Text(
                //           BatchName[index],
                //           style: bodyText16w500(color: black),
                //         ),
                //         subtitle: Text(
                //           "6 Weeks : 5 Days",
                //           style: bodyText12normal(color: darkGray),
                //         ),
                //       );
                //     }),
                const Divider(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// fetch data with loop
// void fetchData() async {
//   BatchName.clear();
//   print(BatchName);
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final querySnapshot = await firestore.collection('users').doc(
//       user.toString()).collection("Batches").get();
//   querySnapshot.docs.forEach((doc) {
//     //print("int " + doc.get("BatchName").toString());
//     Bname = doc.get("BatchName").toString();
//     BatchName.add(Bname);
//
//   });
//   print(Bname);
//   }

// length of data



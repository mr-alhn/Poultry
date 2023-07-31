import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/screens/farmsettings/addincomecat.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import '../batches/addeggs.dart';

int length = 0;
List<String> incomeCategoryList = [];

class IncomeCategoryPage extends StatelessWidget {
  const IncomeCategoryPage({super.key});

  Future<List<String>?> fetchData() async {
    //print(incomeCategoryList);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore
        .collection('users')
        .doc(user)
        .collection("settings")
        .doc(user)
        .collection("Income Category")
        .get();
    List<String> newIncomeCategoryList = [];
    for (var doc in querySnapshot.docs) {
      newIncomeCategoryList.add(doc.get("IncomeCategory").toString());
    }
    incomeCategoryList =
        List.from(Set.from(incomeCategoryList)..addAll(newIncomeCategoryList));
    length = incomeCategoryList.length;
    print(incomeCategoryList);
    return Future.delayed(const Duration(seconds: 1), () {
      return incomeCategoryList;
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchLength();
    if (incomeCategoryList.length < length) {
      fetchData();
    }
    print(incomeCategoryList);

    return Scaffold(
      floatingActionButton: FloatedButton(onTap: () {
        NextScreen(context, AddIncomeCategory());
      }),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: true,
          bottom: true,
          title: "Income Category",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            addVerticalSpace(15),
            const Divider(
              height: 0,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder<List<String>?>(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot == null) {
                        return const Center(child: Text('Add Income Category'));
                      } else if (snapshot.hasData) {
                        return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: incomeCategoryList.length,
                            separatorBuilder: (context, index) {
                              return const Divider(
                                height: 0,
                              );
                            },
                            itemBuilder: (context, index) {
                              print(incomeCategoryList);
                              print(length);
                              print(index);
                              return ListTile(
                                title: Text(
                                  incomeCategoryList[index],
                                  style: bodyText17w500(color: black),
                                ),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })),
            // ListView.separated(
            //     shrinkWrap: true,
            //     physics: NeverScrollableScrollPhysics(),
            //     itemCount: incomeCategoryList.length,
            //     separatorBuilder: (context, index) {
            //       return const Divider(
            //         height: 0,
            //       );
            //     },
            //     itemBuilder: (context, index) {
            //       print(incomeCategoryList);
            //       print(length);
            //       print(index);
            //       return ListTile(
            //         title: Text(
            //           incomeCategoryList[index],
            //           style: bodyText17w500(color: black),
            //         ),
            //       );
            //     }),
            const Divider(
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}

void fetchLength() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final querySnapshot = await firestore
      .collection('users')
      .doc(user)
      .collection("settings")
      .doc()
      .collection("Income Category")
      .get();
  for (var doc in querySnapshot.docs) {
    //   print("int "+doc.get("date").toString());
    // });
    //print("length "+querySnapshot.size.toString());
    length = querySnapshot.size;
  }
}
// void fetchData() async {
//   incomeCategoryList.clear();
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final querySnapshot = await firestore.collection('users').doc(
//       user).collection("Income Category").get();
//   querySnapshot.docs.forEach((doc) {
//     //print("int " + doc.get("BatchName").toString());
//     incomeCategoryList.add(doc.get("IncomeCategory").toString());
//   });
//   print(incomeCategoryList);
// }



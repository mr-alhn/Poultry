import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/batches/addsubuser.dart';
import 'package:poultry_app/screens/batches/batches.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/floatbutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';

class SubUserPage extends StatefulWidget {
  final int index;
  int accessLevel;
  String owner;
  SubUserPage(
      {super.key,
      required this.index,
      required this.accessLevel,
      required this.owner});

  @override
  SubUserPageState createState() => SubUserPageState();
}

class SubUserPageState extends State<SubUserPage> {
  bool subUsersPresent = false;
  List subUserList = [];
  bool isLoading = true;

  Future<void> getSubUserList() async {
    setState(() {
      isLoading = true;
      subUserList.clear();
    });
    await FirebaseFirestore.instance
        .collection('batches')
        .doc(batchDocIds[widget.index])
        .get()
        .then((value) {
      if (!value.exists) {
      } else {
        for (int i = 0; i < value.data()!["userIDs"].length; i++) {
          setState(() {
            subUserList.add({
              "name": value.data()!["userIDs"][i]['name'],
              "type": value.data()!["userIDs"][i]['type'],
            });
          });
        }
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getSubUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.accessLevel == 0 || widget.accessLevel == 2
          ? FloatedButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddSubUserPage(
                      index: widget.index,
                      owner: widget.owner,
                    ),
                  ),
                ).then((value) {
                  if (value == null) {
                    return;
                  } else {
                    if (value) {
                      getSubUserList();
                    }
                  }
                });
              },
            )
          : null,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          title: 'Batch',
        ),
      ),
      body: Column(
        children: [
          addVerticalSpace(20),
          Text(
            "Sub User",
            style: bodyText22w600(color: black),
          ),
          addVerticalSpace(20),
          const Divider(
            height: 0,
          ),
          isLoading
              ? const CircularProgressIndicator()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: transparent,
                        backgroundImage:
                            const AssetImage("assets/images/adduser.png"),
                      ),
                      title: Text(
                        subUserList[index]['name'],
                        style: bodyText16w500(color: black),
                      ),
                      subtitle: Text(subUserList[index]['type']),
                      trailing: InkWell(
                        child: const Icon(Icons.delete_outline_rounded),
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  contentPadding: const EdgeInsets.all(6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  content: Builder(builder: (context) {
                                    var height =
                                        MediaQuery.of(context).size.height;
                                    var width =
                                        MediaQuery.of(context).size.width;

                                    return Container(
                                      height: height * 0.15,
                                      padding: const EdgeInsets.all(
                                        10.0,
                                      ),
                                      child: Column(
                                        children: [
                                          // SizedBox(
                                          //   height: 20.0,
                                          // ),
                                          Center(
                                            child: Text(
                                              "Do you want to delete this item?",
                                              textAlign: TextAlign.center,
                                              style: bodyText16Bold(
                                                color: black,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: width * 0.3,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: yellow),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6)),
                                                  child: Center(
                                                    child: Text(
                                                      'Cancel',
                                                      style: bodyText14Bold(
                                                          color: black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              addHorizontalySpace(20),
                                              InkWell(
                                                onTap: () async {
                                                  if (widget.accessLevel == 1) {
                                                    //view
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "You don't have the required permissions to edit!");
                                                    Navigator.pop(
                                                        context, false);
                                                  } else {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("batches")
                                                        .doc(batchDocIds[
                                                            widget.index])
                                                        .update({
                                                      "userIDs": subUserList
                                                              .sublist(
                                                                  0, index) +
                                                          subUserList.sublist(
                                                            index + 1,
                                                          ),
                                                    });
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Deletion successful!");

                                                    Navigator.pop(
                                                        context, true);
                                                  }
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: width * 0.3,
                                                  decoration: BoxDecoration(
                                                      color: red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6)),
                                                  child: Center(
                                                    child: Text(
                                                      'Delete',
                                                      style: bodyText14Bold(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }));
                            }).then((value) {
                          if (value == null) {
                            return;
                          } else {
                            if (value) {
                              getSubUserList();
                            }
                          }
                        }),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 0,
                    );
                  },
                  itemCount: subUserList.length),
          const Divider(
            height: 0,
          ),
          addVerticalSpace(20),
          SizedBox(
            width: width(context) * 0.85,
            child: Center(
              child: Text(
                'Note: To create a sub-user, User Account must be created in the App.',
                style: bodyText14w500(
                  color: gray,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

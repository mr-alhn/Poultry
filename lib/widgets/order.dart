import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_app/screens/feed/addorder.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  List list = ["lorem", "lorem", "lorem", "lorem"];
  String currentDate = DateFormat('dd/MMM/yyyy').format(DateTime.now());
  String hint = "Select Date";
  double totalOrderValue = 0.0;
  int totalBagQuantity = 0;
  List orderDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getOrderDetails();
  }

  Future<void> getOrderDetails() async {
    setState(() {
      isLoading = true;
      orderDetails.clear();
    });
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        // print(value.data()!["order1"]["date"]);
        for (int i = value.data()!.length - 1; i >= 0; i--) {
          List date =
              value.data()!["order${i + 1}"]["date"].toString().split("/");
          String day = date[0];
          String suffix = getSuffix(int.parse(day));
          String month = date[1];
          String monthFormatted = getMonth(month);
          String year = date[2];
          String formattedDate = "$day$suffix $monthFormatted $year";

          setState(() {
            orderDetails.add({
              "orderNo": "Order ${i + 1}",
              "date": formattedDate,
              "unformattedDate": value.data()!["order${i + 1}"]["date"],
              "feedCompany": value.data()!["order${i + 1}"]["feedCompany"],
              "originalQuantity": value.data()!["order${i + 1}"]
                  ["originalQuantity"],
              "feedType": value.data()!["order${i + 1}"]["feedType"],
              "feedWeight": value.data()!["order${i + 1}"]["feedWeight"],
              "orderStatus": value.data()!["order${i + 1}"]["orderStatus"],
              "totalPrice": value.data()!["order${i + 1}"]["totalPrice"],
              "paymentMethod": value.data()!["order${i + 1}"]["paymentMethod"],
              "feedPrice": value.data()!["order${i + 1}"]["feedPrice"],
            });

            totalBagQuantity += int.tryParse(value
                    .data()!["order${i + 1}"]["originalQuantity"]
                    .toString()) ??
                0;

            totalOrderValue += double.tryParse(
                    value.data()!["order${i + 1}"]["totalPrice"].toString()) ??
                0.0;
          });
          print(orderDetails);
        }
      } else {
        print('No data!');
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  String getMonth(String month) {
    switch (month) {
      case "jan":
        return "January";
      case "feb":
        return "February";
      case "mar":
        return "March";
      case "apr":
        return "April";
      case "may":
        return "May";
      case "jun":
        return "June";
      case "jul":
        return "July";
      case "aug":
        return "August";
      case "sep":
        return "September";
      case "oct":
        return "October";
      case "nov":
        return "November";
      case "dec":
        return "December";
      default:
        return "";
    }
  }

  String getSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(msg: "Coming Soon!");
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration:
                              shadowDecoration(6, 0, white, bcolor: darkGray),
                          width: 36,
                          height: 30,
                          child: Image.asset(
                            "assets/images/filter.png",
                          ),
                        ),
                        addHorizontalySpace(10),
                        InkWell(
                          onTap: () {
                            // showDialog(
                            //     context: context,
                            //     builder: (context) => showCalDialog());
                            Fluttertoast.showToast(msg: "Coming Soon!");
                          },
                          child: CustomDropdown(
                            icon: true,
                            hp: 5,
                            radius: 6,
                            bcolor: darkGray,
                            width: width(context) * .35,
                            list: const [],
                            height: 30,
                            iconSize: 12,
                            hint: hint,
                            textStyle: bodyText12w600(color: darkGray),
                          ),
                        ),
                        addHorizontalySpace(5),
                        CustomDropdown(
                          hp: 5,
                          radius: 6,
                          bcolor: darkGray,
                          width: width(context) * .3,
                          list: const [],
                          height: 30,
                          iconSize: 12,
                          hint: "Feed Type",
                          textStyle: bodyText12w600(color: darkGray),
                        )
                      ],
                    ),
                  ),
                  addVerticalSpace(20),
                  Container(
                    height: 85,
                    decoration:
                        shadowDecoration(10, 4, white, offset: const Offset(2, 2)),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Feed Order Value",
                              style: bodyText12w500(color: black),
                            ),
                            Text(
                              "$totalOrderValue",
                              style: bodyText12w500(color: black),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Order Bags Quantity",
                              style: bodyText12w500(color: black),
                            ),
                            Text(
                              "$totalBagQuantity",
                              style: bodyText12w600(color: green),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            addVerticalSpace(25),
            const Divider(
              height: 0,
            ),
            isLoading == true
                ? const CircularProgressIndicator()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (orderDetails[index]["orderStatus"] ==
                              "Not Received") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddOrderPage(
                                          isEdit: true,
                                          batchIndex:
                                              orderDetails.length - index - 1,
                                          date: orderDetails[index]
                                              ["unformattedDate"],
                                          company: orderDetails[index]
                                              ["feedCompany"],
                                          quantity: int.parse(
                                              orderDetails[index]
                                                      ["originalQuantity"]
                                                  .toString()),
                                          feedSelected: orderDetails[index]
                                              ["feedType"],
                                          size: orderDetails[index]
                                                  ["feedWeight"]
                                              .toString(),
                                          orderNo: orderDetails[index]
                                                  ["orderNo"]
                                              .toString()
                                              .split("Order ")[1],
                                          paymentMethod: orderDetails[index]
                                              ["paymentMethod"],
                                          price: double.parse(
                                              orderDetails[index]["feedPrice"]
                                                  .toString()),
                                          total: double.parse(
                                              orderDetails[index]["totalPrice"]
                                                  .toString()),
                                        ))).then((value) {
                              if (value == null) {
                                return;
                              } else {
                                if (value) {
                                  getOrderDetails();
                                }
                              }
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Cannot edit Orders that are Partially or Already Completed!");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${orderDetails[index]["orderNo"]}",
                                style: bodyText10w600(color: yellow),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${orderDetails[index]["feedType"]}",
                                    style: bodyText15w500(color: black),
                                  ),
                                  Text(
                                    "${orderDetails[index]["totalPrice"]}",
                                    style: bodyText18w600(color: black),
                                  ),
                                ],
                              ),
                              Text(
                                "${orderDetails[index]["originalQuantity"]}",
                                style: bodyText12w500(color: darkGray),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${orderDetails[index]["date"]}",
                                    style: bodyText12w500(color: darkGray),
                                  ),
                                  Text(
                                    "Order Status: ${orderDetails[index]["orderStatus"]}",
                                    style: bodyText12w500(color: darkGray),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 0,
                      );
                    },
                    itemCount: orderDetails.length)
          ],
        )
      ],
    );
  }

  Widget showCalDialog() {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
        height: 300,
        width: 275,
        child: TableCalendar(
          calendarStyle: const CalendarStyle(
            canMarkersOverflow: true,
          ),
          startingDayOfWeek: StartingDayOfWeek.monday,
          daysOfWeekHeight: 35,
          headerStyle: const HeaderStyle(
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              formatButtonVisible: false,
              titleCentered: true),
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              currentDate = DateFormat('dd/MMM/yyyy').format(selectedDay);
              hint = currentDate.toLowerCase();
              goBack(context);
            });
          },
          // selectedDayPredicate: (day) {
          //   return isSameDay(dateTime, day);
          // },
          calendarFormat: CalendarFormat.month,
          rowHeight: 40,
        ),
      ),
      // actions: [
      //   ElevatedButton(
      //       style: ElevatedButton.styleFrom(
      //           minimumSize: Size(80, 35),
      //           backgroundColor: Color.fromARGB(255, 237, 241, 245),
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(10))),
      //       onPressed: () {},
      //       child: Text(
      //         "Clear",
      //         style: bodyText16normal(color: black),
      //       )),
      //   Padding(
      //     padding: const EdgeInsets.only(left: 10, right: 5),
      //     child: ElevatedButton(
      //         style: ElevatedButton.styleFrom(
      //             minimumSize: Size(90, 40),
      //             shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(10))),
      //         onPressed: () {},
      //         child: Text(
      //           "Apply",
      //           style: bodyText16normal(color: white),
      //         )),
      //   ),
      // ],
    );
  }
}

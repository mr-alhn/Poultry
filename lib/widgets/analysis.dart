import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:intl/intl.dart';

class AnalysisWidget extends StatefulWidget {
  String owner;
  String batchId;
  bool disabled = true;
  AnalysisWidget({
    super.key,
    required this.owner,
    required this.batchId,
    this.disabled = true,
  });

  @override
  State<AnalysisWidget> createState() => _AnalysisWidgetState();
}

class _AnalysisWidgetState extends State<AnalysisWidget> {
  double totalQuantity = 0.0;
  double perBirdIntake = 0.0;
  double avgBodyWeight = 0.0;
  double expensesDiluted = 0.0;
  double feedToday = 0.0;
  double totalProfit = 0.0;
  double feedIntakePerBird = 0.0;
  double perBirdFeedCost = 0.0;
  int loadStatus = 0;
  List analysis = [
    {
      "title": "Financial Performance",
      "c1data1": "Rs. 2,00,000",
      "c1data2": "Total Expenses",
      "c2data1": "Rs. 2,50,000",
      "c2data2": "Total income",
      "c3data1": "Rs. 50,000",
      "c3data2": "Net Balance",
    },
    {
      "title": "Financial Analysis",
      "c1data1": "Rs. 100",
      "c1data2": "Cost per bird",
      "c2data1": "5,000",
      "c2data2": "Sold Birds",
      "c3data1": "Rs. 1,25,000",
      "c3data2": "Profit On Sold Birds",
    },
    {
      "title": "Feed",
      "c1data1": "15,000 kg",
      "c1data2": "Total Feed Consumed",
      "c2data1": "Rs. 120",
      "c2data2": "Per Bird Feed Cost",
    },
    {
      "title": "Feed Performance",
      "c1data1": "3,000 gms",
      "c1data2": "Per Bird Feed Intake/\ngms",
      "c2data1": "1,000 gms",
      "c2data2": "Average Body\nWeight",
      "c3data1": "3",
      "c3data2": "FCR",
    },
  ];

  // Map incomeMap = {};

  Future<void> getFinancialPerformance() async {
    // setState(() {
    //   incomeMap.clear();
    // });
    if (!mounted) return;
    double income = 0.0;
    double expenses = 0.0;
    print("Owner: ${widget.owner}");
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .collection("BatchData")
        .doc("Income")
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["incomeDetails"].length; i++) {
          // if (value.data()!["incomeDetails"][i]["IncomeCategory"] ==
          //     "Chicken") {
          //   if (incomeMap
          //       .containsKey(value.data()!["incomeDetails"][i]["date"])) {
          //     setState(() {
          //       incomeMap[value.data()!["incomeDetails"][i]["date"]] +=
          //           double.parse(
          //               value.data()!["incomeDetails"][i]["Rate"].toString());
          //     });
          //   } else {
          //     setState(() {
          //       incomeMap[value.data()!["incomeDetails"][i]["date"]] =
          //           double.parse(
          //               value.data()!["incomeDetails"][i]["Rate"].toString());
          //     });
          //   }
          // }
          if (value.data()!["incomeDetails"][i]["IncomeCategory"] ==
              "Chicken") {
            setState(() {
              totalProfit += (double.parse(value
                      .data()!["incomeDetails"][i]["BillAmount"]
                      .toString()) -
                  (int.parse(value
                          .data()!["incomeDetails"][i]["Quantity"]
                          .toString()) *
                      double.parse(value
                          .data()!["incomeDetails"][i]["CostPerBird"]
                          .toString())));
            });
            print(totalProfit);
            print(double.parse(
                value.data()!["incomeDetails"][i]["BillAmount"].toString()));
            print((int.parse(
                    value.data()!["incomeDetails"][i]["Quantity"].toString()) *
                double.parse(value
                    .data()!["incomeDetails"][i]["CostPerBird"]
                    .toString())));
          }
          setState(() {
            income += double.parse(
                value.data()!["incomeDetails"][i]["BillAmount"].toString());
          });
        }
      }
    });

    setState(() {
      analysis[0]["c2data1"] = "Rs. ${income.toStringAsFixed(2)}";
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .collection("BatchData")
        .doc("Expenses")
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["expenseDetails"].length; i++) {
          setState(() {
            expenses += double.parse(
                value.data()!["expenseDetails"][i]["Amount"].toString());
          });
        }
      }
    });

    setState(() {
      analysis[0]["c1data1"] = "Rs. ${expenses.toStringAsFixed(2)}";
    });

    setState(() {
      analysis[0]["c3data1"] = "Rs. ${(income - expenses).toStringAsFixed(2)}";
    });

    setState(() {
      loadStatus += 1;
    });
  }

  Future<void> getFinancialAnalysis() async {
    int netBirds = 0;
    double originalPrice = 0.0;
    double totalFeedPrice = 0.0;
    int mortality = 0;
    // Map feedData = {};

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .collection("BatchData")
        .doc("Feed Served")
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["feedServed"].length; i++) {
          // if (feedData.containsKey(value.data()!["feedServed"][i]["date"])) {
          //   setState(() {
          //     feedData[value.data()!["feedServed"][i]["date"]] += (double.parse(
          //             value.data()!["feedServed"][i]["feedPrice"].toString()) *
          //         int.parse(value
          //             .data()!["feedServed"][i]["feedQuantity"]
          //             .toString()));
          //   });
          // } else {
          //   setState(() {
          //     feedData[value.data()!["feedServed"][i]["date"]] = (double.parse(
          //             value.data()!["feedServed"][i]["feedPrice"].toString()) *
          //         int.parse(value
          //             .data()!["feedServed"][i]["feedQuantity"]
          //             .toString()));
          //   });
          // }

          setState(() {
            totalFeedPrice += double.parse(
                    value.data()!["feedServed"][i]["priceForFeed"].toString()) /
                double.parse(value
                    .data()!["feedServed"][i]["liveChicksThen"]
                    .toString());
          });
        }
      }
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .collection("BatchData")
        .doc("Expenses")
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["expenseDetails"].length; i++) {
          setState(() {
            if (value.data()!["expenseDetails"][i]["Expenses Category"] !=
                    "Chicks" &&
                value.data()!["expenseDetails"][i]["Expenses Category"] !=
                    "Feed Served") {
              expensesDiluted += double.parse(
                      value.data()!["expenseDetails"][i]["Amount"].toString()) /
                  double.parse(value
                      .data()!["expenseDetails"][i]["NoOfChicksThen"]
                      .toString());
            }
          });
        }
      }
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .get()
        .then((value) {
      setState(() {
        mortality = int.parse(value.data()!["Mortality"].toString());
      });
      int sold = int.parse(value.data()!["Sold"].toString());
      int noBirds = int.parse(value.data()!["NoOfBirds"].toString());

      setState(() {
        netBirds = noBirds - mortality;
        String costBird = value.data()!["CostPerBird"] ?? "";
        if (costBird == "") {
          originalPrice = 0;
        } else {
          originalPrice = double.parse(value.data()!["CostPerBird"].toString());
        }
        analysis[1]["c2data1"] = "$sold";
      });
    });
    print("Total Feed Price: $totalFeedPrice");
    print("Expenses diluted: $expensesDiluted");
    print(expensesDiluted + totalFeedPrice);
    double updatedPrice = originalPrice + ((expensesDiluted + totalFeedPrice));
    print(updatedPrice);
    if (mortality > 0) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.owner)
          .collection("Batches")
          .doc(widget.batchId)
          .collection("BatchData")
          .doc("Mortality")
          .get()
          .then((value) {
        for (int i = 0; i < value.data()!["mortalityDetails"].length; i++) {
          setState(() {
            updatedPrice += (double.parse(value
                        .data()!["mortalityDetails"][i]["costUptoHere"]
                        .toString()) *
                    int.parse(value
                        .data()!["mortalityDetails"][i]["Mortality"]
                        .toString())) /
                (int.parse(value
                    .data()!["mortalityDetails"][i]["liveChicksNow"]
                    .toString()));
          });
        }
      });
    }
    if (netBirds == 0) {
      setState(() {
        updatedPrice = originalPrice;
      });
    }
    print(updatedPrice);
    setState(() {
      analysis[1]["c1data1"] =
          netBirds == 0 ? "Rs. 0" : "Rs. ${updatedPrice.toStringAsFixed(2)}";
      analysis[1]["c3data1"] =
          "Rs. ${totalProfit.toStringAsFixed(2)}"; //profit on sold birds
    });

    // for(var keys in incomeMap.keys.toList()){
    //   double cp = 0;

    // }

    setState(() {
      loadStatus += 1;
    });
  }

  Future<void> getFeedDetails() async {
    if (!mounted) return;
    double priceSubTotal = 0.0;
    int netBirds = 0;
    double feedQuantity = 0.0;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .collection("BatchData")
        .doc("Feed Served")
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["feedServed"].length; i++) {
          // if (value.data()!["feedServed"][i]["date"] ==
          //     DateFormat("dd/MMM/yyyy")
          //         .format(DateTime.now())
          //         .toString()
          //         .toLowerCase()) {}
          setState(() {
            feedToday += double.parse(
                value.data()!["feedServed"][i]["feedQuantity"].toString());

            feedIntakePerBird += ((double.parse(value
                        .data()!["feedServed"][i]["feedQuantity"]
                        .toString()) *
                    1000) /
                double.parse(value
                    .data()!["feedServed"][i]["liveChicksThen"]
                    .toString()));

            perBirdFeedCost += ((double.parse(
                    value.data()!["feedServed"][i]["priceForFeed"].toString()) /
                double.parse(value
                    .data()!["feedServed"][i]["liveChicksThen"]
                    .toString())));

            priceSubTotal += double.parse(
                value.data()!["feedServed"][i]["priceForFeed"].toString());
            feedQuantity += double.parse(
                value.data()!["feedServed"][i]["feedQuantity"].toString());
            totalQuantity += double.parse(
                value.data()!["feedServed"][i]["feedQuantity"].toString());
          });
        }
      }
    });

    setState(() {
      analysis[2]["c1data1"] = "$feedQuantity KG";
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .get()
        .then((value) {
      int mortality = int.parse(value.data()!["Mortality"].toString());
      int sold = int.parse(value.data()!["Sold"].toString());
      int noBirds = int.parse(value.data()!["NoOfBirds"].toString());

      setState(() {
        netBirds = noBirds - mortality - sold;
      });
    });

    setState(() {
      analysis[2]["c2data1"] = "Rs. ${(perBirdFeedCost).toStringAsFixed(2)}";

      perBirdIntake = (feedToday * 1000) / netBirds;

      analysis[3]["c1data1"] =
          netBirds == 0 ? "0 gms" : "${((feedIntakePerBird).ceil())} gms";
    });
    setState(() {
      loadStatus += 1;
    });
  }

  Future<void> getFeedPerformance() async {
    if (!mounted) return;
    double avgWeight = 0.0;
    // int netBirds = 0;
    int length = 0;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .collection("BatchData")
        .doc("Body Weight")
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["weightDetails"].length; i++) {
          if (value.data()!["weightDetails"][i]["date"] ==
              DateFormat("dd/MMM/yyyy").format(DateTime.now()).toLowerCase()) {
            setState(() {
              length += 1;
              avgWeight += double.parse(
                  value.data()!["weightDetails"][i]["bodyWeight"].toString());
            });
          }
        }
        print(avgWeight);
      }
    });

    setState(() {
      print("Avg Weight : $avgWeight");
      print("length: $length");
      if (length == 0) {
        avgBodyWeight = 0;
      } else {
        avgBodyWeight = avgWeight / length;
      }

      analysis[3]["c2data1"] = "$avgBodyWeight gms";

      analysis[3]["c3data1"] = avgBodyWeight == 0
          ? "0"
          : (feedIntakePerBird / avgBodyWeight).toStringAsFixed(2);
    });

    setState(() {
      loadStatus += 1;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.disabled == false) {
      print('enabled!');
      if (mounted) {
        getFinancialPerformance();
        getFeedDetails();
        getFeedPerformance();
        getFinancialAnalysis();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loadStatus == 4
        ? ListView.separated(
            separatorBuilder: (context, index) {
              return addVerticalSpace(15);
            },
            itemCount: analysis.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Text(
                          analysis[index]['title'],
                          style: bodyText14w500(color: black),
                        ),
                      ),
                      Container(
                        height: 60,
                        decoration: shadowDecoration(
                            10, 1, const Color.fromRGBO(232, 236, 244, 1),
                            bcolor: const Color.fromRGBO(232, 236, 244, 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  analysis[index]['c1data1'],
                                  style: bodyText12w600(color: black),
                                ),
                                Text(
                                  analysis[index]['c1data2'],
                                  textAlign: TextAlign.center,
                                  style: bodyText10normal(color: black),
                                ),
                              ],
                            ),
                            verticalDivider(1, 60),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  analysis[index]['c2data1'],
                                  style: bodyText12w600(color: black),
                                ),
                                Text(
                                  analysis[index]['c2data2'],
                                  textAlign: TextAlign.center,
                                  style: bodyText10normal(color: black),
                                ),
                              ],
                            ),
                            analysis[index]['c3data1'] == null
                                ? addVerticalSpace(0)
                                : verticalDivider(1, 60),
                            analysis[index]['c3data2'] == null
                                ? addVerticalSpace(0)
                                : Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        analysis[index]['c3data1'],
                                        style: bodyText12w600(color: black),
                                      ),
                                      Text(
                                        analysis[index]['c3data2'],
                                        style: bodyText10normal(color: black),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            })
        : const CircularProgressIndicator();
  }
}

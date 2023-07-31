import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/customdropdown.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';

class ReportsWidget extends StatefulWidget {
  String owner;
  String batchId;
  ReportsWidget({super.key, required this.owner, required this.batchId});

  @override
  State<ReportsWidget> createState() => _ReportsWidgetState();
}

class _ReportsWidgetState extends State<ReportsWidget> {
  List list = [
    "Income",
    "Expenses",
    "Balance Sheet",
    'Batch Report',
    'Feed Report',
    "Eggs Report",
    "Stocks Report",
    "Order Report",
  ];

  String optionSelected = "";
  String currentUser = "";
  double exportPercentage = 0.0;
  String currentBatchName = "";

  Future<void> getBatchInformation() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          currentBatchName = value.data()!["BatchName"];
        });
      }
    });
  }

  Future<void> createDirectoriesIfNotPresent() async {
    final incomeDirectory =
        Directory("/storage/emulated/0/Download/Poultry/Income");
    final expenseDirectory =
        Directory("/storage/emulated/0/Download/Poultry/Expenses");
    final balanceSheetDirectory =
        Directory("/storage/emulated/0/Download/Poultry/Balance Sheet");
    final batchReportDirectory =
        Directory("/storage/emulated/0/Download/Poultry/Batch Report");
    final feedReportDirectory =
        Directory("/storage/emulated/0/Download/Poultry/Feed Report");
    final eggReportDirectory =
        Directory("/storage/emulated/0/Download/Poultry/Egg Report");
    final stocksReportDirectory =
        Directory("/storage/emulated/0/Download/Poultry/Stock Report");
    final orderReportDirectory =
        Directory("/storage/emulated/0/Download/Poultry/Order Report");

    if (!await incomeDirectory.exists()) {
      incomeDirectory.createSync(recursive: true);
    }
    if (!await expenseDirectory.exists()) {
      expenseDirectory.createSync(recursive: true);
    }
    if (!await balanceSheetDirectory.exists()) {
      balanceSheetDirectory.createSync(recursive: true);
    }
    if (!await batchReportDirectory.exists()) {
      batchReportDirectory.createSync(recursive: true);
    }
    if (!await feedReportDirectory.exists()) {
      feedReportDirectory.createSync(recursive: true);
    }
    if (!await eggReportDirectory.exists()) {
      eggReportDirectory.createSync(recursive: true);
    }
    if (!await stocksReportDirectory.exists()) {
      stocksReportDirectory.createSync(recursive: true);
    }
    if (!await orderReportDirectory.exists()) {
      orderReportDirectory.createSync(recursive: true);
    }
  }

  String path = "";
  List files = [];

  Future<void> loadExcelSheets(String path) async {
    setState(() {
      files = [];
      files = Directory(path).listSync();
    });
  }

  Future<void> getCurrentUserDetails() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        currentUser = value.data()!["name"].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      exportPercentage = 0.0;
    });
    checkPermissions();
    createDirectoriesIfNotPresent();
    getCurrentUserDetails();
    getBatchInformation();
  }

  Directory _directory = Directory("");

  Future<void> checkPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> checkPermissionsAndSetPath(String path) async {
    if (Platform.isAndroid) {
      setState(() {
        _directory = Directory("/storage/emulated/0/Download/Poultry/$path");
        path = _directory.path;
      });
    } else {
      _directory = await getApplicationDocumentsDirectory();
      path = _directory.path;
    }
  }

  Future<void> exportIncomeData() async {
    //check Permissions
    await checkPermissionsAndSetPath("Income");

    setState(() {
      exportPercentage = 0.0;
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .collection("BatchData")
        .doc("Income")
        .get()
        .then((value) async {
      if (value.exists) {
        final excel = Excel.createExcel();
        final sheet = excel[excel.getDefaultSheet()!];

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
            .value = "Batch Name";

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
            .value = "Date";

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
            .value = "Name";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
            .value = "Contact";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
            .value = "Quantity";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0))
            .value = "Rate";

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0))
            .value = "Amount";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0))
            .value = "Payment Method";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 0))
            .value = "Amount Paid";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 0))
            .value = "Due";

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: 0))
            .value = "Description";

        for (int i = 0; i < value.data()?["incomeDetails"].length; i++) {
          Map currentData = value.data()!["incomeDetails"][i];

          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: (i + 1)))
              .value = currentBatchName;

          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: (i + 1)))
              .value = currentData["date"];
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: (i + 1)))
              .value = currentData["name"];
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: (i + 1)))
              .value = currentData["Contact"];
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: (i + 1)))
              .value = currentData["Quantity"].toString();
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: (i + 1)))
              .value = currentData["Rate"].toString();
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: (i + 1)))
              .value = currentData["BillAmount"].toString();
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: (i + 1)))
              .value = currentData["PaymentMethod"];
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: (i + 1)))
              .value = currentData["AmountPaid"].toString();
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: (i + 1)))
              .value = currentData["AmountDue"].toString();
          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: 10, rowIndex: (i + 1)))
              .value = currentData["Description"];

          //lets try creating an excel sheet!

          setState(() {
            exportPercentage +=
                ((i + 1) / (value.data()!["incomeDetails"].length));
            print("Percent: $exportPercentage%");
          });
        }

        await Directory(_directory.path).create(recursive: true);
        var fileBytes = excel.save();
        print(_directory.path);
        DateTime now = DateTime.now();
        File("${_directory.path}/income${now.millisecondsSinceEpoch}.xlsx")
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!);

        if (exportPercentage >= 1.0) {
          Fluttertoast.showToast(msg: "File exported Successfully!");
        }
      } else {
        Fluttertoast.showToast(msg: "No Income data unavailable");
      }
    });
  }

  Future<void> exportExpensesData() async {
    await checkPermissionsAndSetPath("Expenses");

    setState(() {
      exportPercentage = 0.0;
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .collection("BatchData")
        .doc("Expenses")
        .get()
        .then((value) async {
      if (value.exists) {
        final excel = Excel.createExcel();
        final sheet = excel[excel.getDefaultSheet()!];

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
            .value = "Batch Name";

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
            .value = "Date";

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
            .value = "Expenses Category";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
            .value = "Amount";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
            .value = "Description";

        for (int i = 0; i < value.data()?["expenseDetails"].length; i++) {
          Map currentData = value.data()!["expenseDetails"][i];

          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: (i + 1)))
              .value = currentBatchName;

          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: (i + 1)))
              .value = currentData["Date"];
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: (i + 1)))
              .value = currentData["Expenses Category"];
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: (i + 1)))
              .value = currentData["Amount"].toString();
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: (i + 1)))
              .value = currentData["Description"];
          //lets try creating an excel sheet!

          setState(() {
            exportPercentage +=
                ((i + 1) / (value.data()!["expenseDetails"].length));
            print("Percent: $exportPercentage%");
          });
        }

        await Directory(_directory.path).create(recursive: true);
        var fileBytes = excel.save();
        print(_directory.path);
        DateTime now = DateTime.now();
        File("${_directory.path}/expense${now.millisecondsSinceEpoch}.xlsx")
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!);

        if (exportPercentage >= 1.0) {
          Fluttertoast.showToast(msg: "File exported Successfully!");
        }
      } else {
        Fluttertoast.showToast(msg: "No Expenses data unavailable");
      }
    });
  }

  Future<void> exportBalanceSheet() async {
    await checkPermissionsAndSetPath("Balance Sheet");
    List sortedDateKeys = [];
    Map expenseMap = {};
    Map incomeMap = {};

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
          List dates =
              value.data()!["expenseDetails"][i]["Date"].toString().split("/");
          int day = int.parse(dates[0]);
          int month = 0;

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
              month = 10;
              break;
            case "dec":
              month = 12;
              break;
          }
          int year = int.parse(dates[2]);

          String expenseDate =
              DateFormat("dd/MM/yyyy").format(DateTime.utc(year, month, day));
          setState(() {
            if (!sortedDateKeys.contains(expenseDate)) {
              sortedDateKeys.add(expenseDate);
            }
            if (expenseMap.containsKey(expenseDate)) {
              expenseMap[expenseDate] += double.parse(
                  value.data()!["expenseDetails"][i]["Amount"].toString());
            } else {
              expenseMap[expenseDate] = double.parse(
                  value.data()!["expenseDetails"][i]["Amount"].toString());
            }
          });
        }
      } else {
        Fluttertoast.showToast(msg: "No data!");
      }
    });

    setState(() {
      exportPercentage += 0.25;
    });

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
          String incomeDate = value.data()!["incomeDetails"][i]["date"];
          setState(() {
            if (!sortedDateKeys.contains(incomeDate)) {
              sortedDateKeys.add(incomeDate);
            }
            if (incomeMap.containsKey(incomeDate)) {
              incomeMap[incomeDate] += double.parse(
                  value.data()!["incomeDetails"][i]["BillAmount"].toString());
            } else {
              incomeMap[incomeDate] = double.parse(
                  value.data()!["incomeDetails"][i]["BillAmount"].toString());
            }
          });
        }
      } else {
        Fluttertoast.showToast(msg: "No data!");
      }
    });

    setState(() {
      exportPercentage += 0.25;
    });

    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet()!];

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
        "Batch Name";

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value =
        "Date";

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value =
        "Cash In";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value =
        "Cash Out";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)).value =
        "Balance";

    int row = 1;
    for (var dateKeys in sortedDateKeys..sort()) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = currentBatchName;

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          .value = dateKeys;

      if (incomeMap.containsKey(dateKeys) && expenseMap.containsKey(dateKeys)) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
            .value = incomeMap[dateKeys];
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
            .value = expenseMap[dateKeys];

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
            .value = incomeMap[dateKeys] - expenseMap[dateKeys];
      } else {
        if (incomeMap.containsKey(dateKeys)) {
          print("$dateKeys: income");
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
              .value = incomeMap[dateKeys];
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
              .value = 0;
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
              .value = incomeMap[dateKeys];
        } else if (expenseMap.containsKey(dateKeys)) {
          print("$dateKeys: export");
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
              .value = 0;
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
              .value = expenseMap[dateKeys];
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
              .value = expenseMap[dateKeys];
        }
      }
      setState(() {
        row += 1;
        exportPercentage += (row / sortedDateKeys.length) / 2;
      });
    }
    await Directory(_directory.path).create(recursive: true);
    var fileBytes = excel.save();
    print(_directory.path);
    DateTime now = DateTime.now();
    File("${_directory.path}/balance${now.millisecondsSinceEpoch}.xlsx")
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
    if (exportPercentage >= 1.00) {
      Fluttertoast.showToast(msg: "Export successful!");
    }
  }

  Future<void> exportBatchReport() async {
    await checkPermissionsAndSetPath("Batch Report");
    List sortedDateKeys = [];
    Map mortalityMap = {};
    Map soldMap = {};
    int NoBirds = 0;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .get()
        .then((value) {
      setState(() {
        NoBirds = int.parse(value.data()!["NoOfBirds"].toString());
      });
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .collection("BatchData")
        .doc("Mortality")
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["mortalityDetails"].length; i++) {
          List dates = value
              .data()!["mortalityDetails"][i]["Date"]
              .toString()
              .split("/");
          int day = int.parse(dates[0]);
          int month = 0;

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
              month = 10;
              break;
            case "dec":
              month = 12;
              break;
          }
          int year = int.parse(dates[2]);

          String mortalityDate =
              DateFormat("dd/MM/yyyy").format(DateTime.utc(year, month, day));
          setState(() {
            if (!sortedDateKeys.contains(mortalityDate)) {
              sortedDateKeys.add(mortalityDate);
            }
            mortalityMap[mortalityDate] = 0;
            mortalityMap[mortalityDate] += int.parse(
                value.data()!["mortalityDetails"][i]["Mortality"].toString());
          });
        }
      } else {
        Fluttertoast.showToast(msg: "No data!");
      }
    });

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
          if (value.data()!["incomeDetails"][i]["IncomeCategory"] ==
              "Chicken") {
            String incomeDate = value.data()!["incomeDetails"][i]["date"];
            setState(() {
              if (!sortedDateKeys.contains(incomeDate)) {
                sortedDateKeys.add(incomeDate);
              }
              soldMap[incomeDate] = 0;
              soldMap[incomeDate] += int.parse(
                  value.data()!["incomeDetails"][i]["Quantity"].toString());
            });
          }
        }
      } else {
        Fluttertoast.showToast(msg: "No data!");
      }
    });

    setState(() {
      exportPercentage += 0.25;
    });

    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet()!];

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
        "Batch Name";

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value =
        "Date";

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value =
        "Live Birds";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value =
        "Mortality";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)).value =
        "Sold";

    int row = 1;

    for (var dateKeys in sortedDateKeys..sort()) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = currentBatchName;

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          .value = dateKeys;

      if (mortalityMap.containsKey(dateKeys) && soldMap.containsKey(dateKeys)) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
            .value = NoBirds - mortalityMap[dateKeys] - soldMap[dateKeys];
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
            .value = mortalityMap[dateKeys];

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
            .value = soldMap[dateKeys];
      } else {
        if (mortalityMap.containsKey(dateKeys)) {
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
              .value = NoBirds - mortalityMap[dateKeys];
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
              .value = mortalityMap[dateKeys];

          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
              .value = 0;
        } else if (soldMap.containsKey(dateKeys)) {
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
              .value = NoBirds - soldMap[dateKeys];
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
              .value = 0;

          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
              .value = soldMap[dateKeys];
        }
      }
      setState(() {
        row += 1;
        exportPercentage += (row / sortedDateKeys.length) / 2;
      });
    }

    await Directory(_directory.path).create(recursive: true);
    var fileBytes = excel.save();
    print(_directory.path);
    DateTime now = DateTime.now();
    File("${_directory.path}/batch${now.millisecondsSinceEpoch}.xlsx")
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
    if (exportPercentage >= 1.00) {
      Fluttertoast.showToast(msg: "Export successful!");
    }
  }

  Future<List> costTillDate(DateTime date) async {
    setState(() {
      exportPercentage = 0.0;
    });
    double feedQuantity = 0.0;
    double costTillDate = 0.0;
    print("Sent date $date");
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
          List dates =
              value.data()!["feedServed"][i]["date"].toString().split("/");
          int day = int.parse(dates[0]);
          int month = 0;

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
              month = 10;
              break;
            case "dec":
              month = 12;
              break;
          }
          int year = int.parse(dates[2]);

          DateTime feedDate = DateTime.utc(year, month, day);
          print("calculated date $feedDate");

          if (feedDate.isBefore(date) ||
              DateFormat("dd/MM/yyyy").format(feedDate) ==
                  DateFormat("dd/MM/yyyy").format(date)) {
            print('yes');
            feedQuantity += double.parse(
                value.data()!["feedServed"][i]["feedQuantity"].toString());
            costTillDate += double.parse(
                value.data()!["feedServed"][i]["priceForFeed"].toString());
          }
        }
      }
    });

    return [feedQuantity, costTillDate];
  }

  Future<void> exportFeedReport() async {
    await checkPermissionsAndSetPath("Feed Report");
    List result = [];

    // List datesCovered = [];
    Map datesCovered = {};

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .collection("BatchData")
        .doc("Feed Served")
        .get()
        .then((value) async {
      if (value.exists) {
        print("exists");
        final excel = Excel.createExcel();
        final sheet = excel[excel.getDefaultSheet()!];

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
            .value = "Batch Name";

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
            .value = "Date";

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
            .value = "Feed Served (in KG)";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
            .value = "Feed Till Date (in KG)";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
            .value = "Till Date Cost";

        for (int i = 0; i < value.data()!["feedServed"].length; i++) {
          List dates =
              value.data()!["feedServed"][i]["date"].toString().split("/");
          int day = int.parse(dates[0]);
          int month = 0;

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
              month = 10;
              break;
            case "dec":
              month = 12;
              break;
          }
          int year = int.parse(dates[2]);

          DateTime currentFeedDate = DateTime.utc(year, month, day);

          if (datesCovered.containsKey(currentFeedDate)) {
            setState(() {
              datesCovered[currentFeedDate] += double.parse(
                  value.data()!["feedServed"][i]["feedQuantity"].toString());
            });
          } else {
            setState(() {
              datesCovered[currentFeedDate] = double.parse(
                  value.data()!["feedServed"][i]["feedQuantity"].toString());
            });
          }
        }

        print("Dates covered:  $datesCovered");

        int rowCovered = 1;
        for (var keys in datesCovered.keys.toList()..sort()) {
          await costTillDate(keys).then((value) {
            setState(() {
              result = value;
            });
            print("Feed Till date $keys: $result");
          });

          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: 0, rowIndex: rowCovered))
              .value = currentBatchName;

          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: 1, rowIndex: rowCovered))
              .value = DateFormat("dd/MM/yyyy").format(keys);

          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: 2, rowIndex: rowCovered))
              .value = datesCovered[keys];

          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: 3, rowIndex: rowCovered))
              .value = result[0];

          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: 4, rowIndex: rowCovered))
              .value = result[1];

          setState(() {
            exportPercentage += ((rowCovered) / datesCovered.length);

            rowCovered += 1;
            print(exportPercentage);
          });
        }

        await Directory(_directory.path).create(recursive: true);
        var fileBytes = excel.save();
        print(_directory.path);
        DateTime now = DateTime.now();
        File("${_directory.path}/feed${now.millisecondsSinceEpoch}.xlsx")
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!);
        if (exportPercentage >= 1.00) {
          Fluttertoast.showToast(msg: "Export successful!");
        }
      }
    });
  }

  Future<void> exportEggsReport() async {
    checkPermissionsAndSetPath("Egg Report");
    List sortedDateKeys = [];
    Map eggMap = {};
    Map soldMap = {};

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .collection("BatchData")
        .doc("Eggs")
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["eggDetails"].length; i++) {
          List dates =
              value.data()!["eggDetails"][i]["date"].toString().split("/");
          int day = int.parse(dates[0]);
          int month = 0;

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
              month = 10;
              break;
            case "dec":
              month = 12;
              break;
          }
          int year = int.parse(dates[2]);

          String eggDate =
              DateFormat("dd/MM/yyyy").format(DateTime.utc(year, month, day));
          setState(() {
            if (!sortedDateKeys.contains(eggDate)) {
              sortedDateKeys.add(eggDate);
            }
            eggMap[eggDate] = 0;
            eggMap[eggDate] += int.parse(
                value.data()!["eggDetails"][i]["EggTrayCollection"].toString());
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
        .doc("Income")
        .get()
        .then((value) {
      if (value.exists) {
        for (int i = 0; i < value.data()!["incomeDetails"].length; i++) {
          if (value.data()!["incomeDetails"][i]["IncomeCategory"] == "Eggs") {
            String incomeDate = value.data()!["incomeDetails"][i]["date"];
            setState(() {
              if (!sortedDateKeys.contains(incomeDate)) {
                sortedDateKeys.add(incomeDate);
              }
              soldMap[incomeDate] = 0;
              soldMap[incomeDate] += int.parse(
                  value.data()!["incomeDetails"][i]["Quantity"].toString());
            });
          }
        }
      } else {
        Fluttertoast.showToast(msg: "No data!");
      }
    });

    setState(() {
      exportPercentage += 0.25;
    });

    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet()!];

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
        "Batch Name";

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value =
        "Date";

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value =
        "Eggs Collection";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value =
        "Eggs Sold";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)).value =
        "Eggs Balance";

    int row = 1;

    for (var dateKeys in sortedDateKeys..sort()) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = currentBatchName;

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          .value = dateKeys;

      if (eggMap.containsKey(dateKeys) && soldMap.containsKey(dateKeys)) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
            .value = eggMap[dateKeys];
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
            .value = soldMap[dateKeys];

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
            .value = eggMap[dateKeys] - soldMap[dateKeys];
      } else {
        if (eggMap.containsKey(dateKeys)) {
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
              .value = eggMap[dateKeys];
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
              .value = 0;

          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
              .value = eggMap[dateKeys];
        } else {
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
              .value = 0;
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
              .value = soldMap[dateKeys];

          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
              .value = eggMap[dateKeys] - soldMap[dateKeys];
        }
      }
      setState(() {
        row += 1;
        exportPercentage += (row / sortedDateKeys.length) / 2;
      });
    }

    await Directory(_directory.path).create(recursive: true);
    var fileBytes = excel.save();
    print(_directory.path);
    DateTime now = DateTime.now();
    File("${_directory.path}/eggs${now.millisecondsSinceEpoch}.xlsx")
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
    if (exportPercentage >= 1.00) {
      Fluttertoast.showToast(msg: "Export successful!");
    }
  }

  Future<void> exportStocksReport() async {
    await checkPermissionsAndSetPath("Stock Report");
    List stocks = [];

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .get()
        .then((value) async {
      if (value.exists) {
        // if (value.data()!["feedTypeQuantity"] == null)
        Map feedMap = value.data()?["feedTypeQuantity"] ?? {};
        for (var feedKeys in feedMap.keys.toList()) {
          Map orderMap = value.data()!["feedTypeQuantity"][feedKeys] ?? {};
          for (var orderKeys in orderMap.keys.toList()..sort()) {
            if (orderKeys != "used") {
              double quantityReceived = double.parse(value
                  .data()!["feedTypeQuantity"][feedKeys][orderKeys]
                  .toString());
              await FirebaseFirestore.instance
                  .collection("orders")
                  .doc(widget.owner)
                  .get()
                  .then((orderData) {
                List date =
                    orderData.data()![orderKeys]["date"].toString().split("/");
                int month = 0;
                int day = int.parse(date[0]);
                switch (date[1]) {
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
                int year = int.parse(date[2]);
                String orderDate = DateFormat("dd/MM/yyyy")
                    .format(DateTime.utc(year, month, day));
                setState(() {
                  stocks.add({
                    "orderNo": orderKeys,
                    "quantityReceived": quantityReceived,
                    "feedCompany": orderData.data()![orderKeys]["feedCompany"],
                    "feedType": orderData.data()![orderKeys]["feedType"],
                    "date": orderDate,
                    "served": 0,
                    "remaining": quantityReceived,
                  });
                });
              });
            }
          }
        }
      }
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.owner)
        .collection("Batches")
        .doc(widget.batchId)
        .get()
        .then((value) async {
      Map feedMap = value.data()!["feedTypeQuantity"] ?? {};
      for (var feedKeys in feedMap.keys.toList()) {
        Map orderMap =
            value.data()!["feedTypeQuantity"][feedKeys]["used"] ?? {};
        int index = 0;
        for (var orderKeys in orderMap.keys.toList()..sort()) {
          setState(() {
            stocks[index]["served"] = double.parse(value
                .data()!["feedTypeQuantity"][feedKeys]["used"][orderKeys]
                .toString());
            stocks[index]["remaining"] =
                stocks[index]["quantityReceived"] - stocks[index]["served"];
          });
        }
      }
    });

    setState(() {
      exportPercentage += 0.50;
    });

    if (stocks.isNotEmpty) {
      final excel = Excel.createExcel();
      final sheet = excel[excel.getDefaultSheet()!];

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
          .value = "Batch Name";

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
          .value = "Date";

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
          .value = "Order No";

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
          .value = "Feed Company";
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
          .value = "Feed Type";
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0))
          .value = "Received Bags";

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0))
          .value = "Served Bags";

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0))
          .value = "Remaining Bags";

      for (int i = 0; i < stocks.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1))
            .value = currentBatchName;

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1))
            .value = stocks[i]["date"];

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1))
            .value = stocks[i]["orderNo"];

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1))
            .value = stocks[i]["feedCompany"];

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i + 1))
            .value = stocks[i]["feedType"];

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i + 1))
            .value = stocks[i]["quantityReceived"];

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: i + 1))
            .value = stocks[i]["served"];

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: i + 1))
            .value = stocks[i]["remaining"];

        setState(() {
          exportPercentage += ((i + 1) / stocks.length) / 2;
        });
      }
      await Directory(_directory.path).create(recursive: true);
      var fileBytes = excel.save();
      print(_directory.path);
      DateTime now = DateTime.now();
      File("${_directory.path}/stocks${now.millisecondsSinceEpoch}.xlsx")
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);
      if (exportPercentage >= 1.00) {
        Fluttertoast.showToast(msg: "Export successful!");
      }
    } else {
      Fluttertoast.showToast(msg: "Stock details not found!");
    }
  }

  Future<void> exportOrderReport() async {
    checkPermissionsAndSetPath("Order Report");

    await FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.owner)
        .get()
        .then((value) async {
      if (value.exists) {
        final excel = Excel.createExcel();
        final sheet = excel[excel.getDefaultSheet()!];
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
            .value = "Batch Name";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
            .value = "Date";

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
            .value = "Order No";

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
            .value = "Feed Type";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
            .value = "Feed Company";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0))
            .value = "Bag Size";

        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0))
            .value = "Bag Quantity";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0))
            .value = "Bag Price";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 0))
            .value = "Total";
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 0))
            .value = "Payment Method";

        for (int i = 0; i < value.data()!.length; i++) {
          Map currentData = value.data()!["order${i + 1}"];

          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: (i + 1)))
              .value = currentBatchName;
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: (i + 1)))
              .value = currentData["date"];
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: (i + 1)))
              .value = "Order ${i + 1}";
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: (i + 1)))
              .value = currentData["feedType"];
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: (i + 1)))
              .value = currentData["feedCompany"].toString();
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: (i + 1)))
              .value = currentData["feedWeight"].toString();
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: (i + 1)))
              .value = currentData["originalQuantity"].toString();
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: (i + 1)))
              .value = currentData["feedPrice"].toString();
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: (i + 1)))
              .value = currentData["totalPrice"].toString();
          sheet
              .cell(
                  CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: (i + 1)))
              .value = currentData["paymentMethod"].toString();

          setState(() {
            exportPercentage += ((i + 1) / (value.data()!.length));
            print("Percent: $exportPercentage%");
          });
        }

        await Directory(_directory.path).create(recursive: true);
        var fileBytes = excel.save();
        print(_directory.path);
        DateTime now = DateTime.now();
        File("${_directory.path}/order${now.millisecondsSinceEpoch}.xlsx")
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!);

        if (exportPercentage >= 1.0) {
          Fluttertoast.showToast(msg: "File exported Successfully!");
        }
      } else {
        Fluttertoast.showToast(msg: "No Income data unavailable");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: CustomDropdown(
                    list: list,
                    height: 30,
                    hint: "Select Report",
                    width: width(context) * .6,
                    textStyle: bodyText12w600(color: darkGray),
                    onchanged: (value) {
                      setState(() {
                        optionSelected = value;
                        switch (optionSelected) {
                          case "Income":
                            setState(() {
                              path =
                                  "/storage/emulated/0/Download/Poultry/Income";
                            });
                            break;
                          case "Expenses":
                            setState(() {
                              path =
                                  "/storage/emulated/0/Download/Poultry/Expenses";
                            });
                            break;
                          case "Balance Sheet":
                            setState(() {
                              path =
                                  "/storage/emulated/0/Download/Poultry/Balance Sheet";
                            });
                            break;
                          case "Batch Report":
                            setState(() {
                              path =
                                  "/storage/emulated/0/Download/Poultry/Batch Report";
                            });
                            break;
                          case "Feed Report":
                            setState(() {
                              path =
                                  "/storage/emulated/0/Download/Poultry/Feed Report";
                            });
                            break;
                          case "Eggs Report":
                            setState(() {
                              path =
                                  "/storage/emulated/0/Download/Poultry/Egg Report";
                            });
                            break;
                          case "Stocks Report":
                            setState(() {
                              path =
                                  "/storage/emulated/0/Download/Poultry/Stock Report";
                            });
                            break;
                          case "Order Report":
                            setState(() {
                              path =
                                  "/storage/emulated/0/Download/Poultry/Order Report";
                            });
                            break;
                          default:
                            Fluttertoast.showToast(msg: "Invalid Option!");
                        }
                        loadExcelSheets(path);
                      });
                    },
                  ),
                ),
              ],
            ),
            addVerticalSpace(10),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      print(files[index].toString().split("'")[1].toString());
                      OpenFile.open(
                        files[index].toString().split("'")[1],
                        type:
                            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                      );
                    },
                    leading: Image.asset("assets/images/excel.png"),
                    title: Text(
                      (files[index]).toString().split("'")[1].split("/").last,
                      style: bodyText14normal(color: black),
                    ),
                  );
                }),
            addVerticalSpace(height(context) * .1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomButton(
                  text: "Export",
                  onClick: () async {
                    switch (optionSelected) {
                      case "Income":
                        await exportIncomeData();
                        break;
                      case "Expenses":
                        await exportExpensesData();
                        break;
                      case "Balance Sheet":
                        await exportBalanceSheet();
                        break;
                      case "Batch Report":
                        await exportBatchReport();
                        break;
                      case "Feed Report":
                        await exportFeedReport();
                        break;
                      case "Eggs Report":
                        await exportEggsReport();
                        break;
                      case "Stocks Report":
                        await exportStocksReport();
                        break;
                      case "Order Report":
                        await exportOrderReport();
                        break;
                      default:
                        Fluttertoast.showToast(msg: "Invalid Option!");
                    }
                    showDialog(
                        context: context, builder: (context) => dialog());
                  }),
            )
          ],
        ),
      ],
    );
  }

  Widget dialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        height: 275,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/images/download.png",
              height: 82,
              width: 82,
              fit: BoxFit.fill,
            ),
            SizedBox(
              width: width(context) * 0.75,
              child: LinearProgressIndicator(
                value: exportPercentage,
                backgroundColor: Colors.black,
                color: yellow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

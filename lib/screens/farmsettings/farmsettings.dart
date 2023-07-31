import 'package:flutter/material.dart';
import 'package:poultry_app/screens/farmsettings/chickfeedreq.dart';
import 'package:poultry_app/screens/farmsettings/currency.dart';
import 'package:poultry_app/screens/farmsettings/customerlist.dart';
import 'package:poultry_app/screens/farmsettings/expensescat.dart';
import 'package:poultry_app/screens/farmsettings/feedtype.dart';
import 'package:poultry_app/screens/farmsettings/language.dart';
import 'package:poultry_app/screens/farmsettings/myads.dart';
import 'package:poultry_app/screens/farmsettings/reminder.dart';
import 'package:poultry_app/screens/farmsettings/userinfo.dart';
import 'package:poultry_app/screens/farmsettings/vaccinationschedule.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/generalappbar.dart';
import 'package:poultry_app/widgets/records.dart';

class FarmSettingsPage extends StatefulWidget {
  const FarmSettingsPage({super.key});

  @override
  State<FarmSettingsPage> createState() => _FarmSettingsPageState();
}

class _FarmSettingsPageState extends State<FarmSettingsPage> {
  List<dynamic> record = [
    {
      "lead": "assets/images/user.png",
      "text": "User Information",
      "screen": const UserInformationPage()
    },
    {
      "lead": "assets/images/expense.png",
      "text": "Expenses Category",
      "screen": const ExpensesCategoryPage()
    },
    {
      "lead": "assets/images/feedreq.png",
      "text": "Chick Feed Requirement",
      "screen": const ChickFeedRequirementPage()
    },
    {
      "lead": "assets/images/feed.png",
      "text": "Feed Type",
      "screen": const FeedType()
    },
    // {
    //   "lead": "assets/images/feedbag.png",
    //   "text": "Feed Bag Size",
    //   "screen": FeedBagSizePage()
    // },
    {
      "lead": "assets/images/vaccine.png",
      "text": "Vaccination Schedule",
      "screen": const VaccinationSchedulePage()
    },
    // {
    //   "lead": "assets/images/eggtrau.png",
    //   "text": "Egg Tray Size",
    //   "screen": EggTraySize()
    // },
    {
      "lead": "assets/images/remind.png",
      "text": "Notifications",
      "screen": const RemindersPage()
    },
    {
      "lead": "assets/images/ads.png",
      "text": "My Ads",
      "screen": const MyAds(),
    },
    {
      "lead": "assets/images/list.png",
      "text": "Customer List",
      "screen": const CustomerListPage()
    },
    {
      "lead": "assets/images/rs.png",
      "text": "Currency",
      "screen": const CurrencyPage()
    },
    {
      "lead": "assets/images/lang.png",
      "text": "Language",
      "screen": const LanguagePage()
    },
    // {
    //   "lead": "assets/images/report.png",
    //   "text": "Report",
    //   "screen": ReportsPage(
    //     owner: FirebaseAuth.instance.currentUser!.uid,
    //     batchId: "",
    //   ),
    // },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          islead: false,
          isNav: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "Farm Settings",
                style: bodyText18w500(color: black),
              ),
            ),
            addVerticalSpace(20),
            const Divider(
              height: 0,
            ),
            RecordsWidget(record: record),
            const Divider(
              height: 0,
            ),
            addVerticalSpace(20)
          ],
        ),
      ),
    );
  }
}

import 'package:easy_upi_payment/easy_upi_payment.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:poultry_app/utils/constants.dart';
import 'package:poultry_app/widgets/custombutton.dart';
import 'package:poultry_app/widgets/generalappbar.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

int selected = 0;

class _SubscriptionPageState extends State<SubscriptionPage> {
  DatabaseReference reference = FirebaseDatabase.instance.ref();

  List plans = [];

  @override
  void initState() {
    super.initState();
    getPlans();
  }

  void getPlans() async {
    await reference.child('Subscriptions').once().then((value) {
      if (value.snapshot.value != null) {
        Map response = value.snapshot.value as Map;
        plans = response.values.toList();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: GeneralAppBar(
          title: "Subscription",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              addVerticalSpace(30),
              Image.asset("assets/images/crown.png"),
              addVerticalSpace(20),
              Text(
                "Upgrade to Premium",
                style: bodyText20w600(color: black),
              ),
              addVerticalSpace(40),
              SizedBox(
                height: 267,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              "Services",
                              style: bodyText10w600(color: black),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 25),
                            height: 180,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "View Market Rates",
                                  style: bodyText10normal(color: black),
                                ),
                                Text(
                                  "Sell Products",
                                  style: bodyText10normal(color: black),
                                ),
                                Text(
                                  "Manage your Broiler,\nDeshi Farm",
                                  style: bodyText10normal(color: black),
                                ),
                                Text(
                                  "Manage Layer Farm",
                                  style: bodyText10normal(color: black),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ListView.separated(
                      itemCount: plans.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.only(top: 10),
                          decoration: shadowDecoration(8, 1.5, white,
                              bcolor: selected == index ? yellow : normalGray),
                          width: 80,
                          height: 267,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                plans[index]['name'],
                                style: bodyText10w600(color: black),
                              ),
                              Container(
                                padding: const EdgeInsets.only(bottom: 25),
                                height: 180,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (plans[index]['benefits'][0])
                                      const Icon(
                                        Icons.check,
                                        size: 18,
                                      )
                                    else
                                      const Icon(
                                        Icons.close,
                                        size: 18,
                                      ),
                                    if (plans[index]['benefits'][1])
                                      const Icon(
                                        Icons.check,
                                        size: 18,
                                      )
                                    else
                                      const Icon(
                                        Icons.close,
                                        size: 18,
                                      ),
                                    if (plans[index]['benefits'][2])
                                      const Icon(
                                        Icons.check,
                                        size: 18,
                                      )
                                    else
                                      const Icon(
                                        Icons.close,
                                        size: 18,
                                      ),
                                    if (plans[index]['benefits'][3])
                                      const Icon(
                                        Icons.check,
                                        size: 18,
                                      )
                                    else
                                      const Icon(
                                        Icons.close,
                                        size: 18,
                                      ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 10,
                        );
                      },
                    ),
                  ],
                ),
              ),
              addVerticalSpace(25),
              SizedBox(
                height: 90,
                child: ListView.separated(
                  itemCount: plans.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = index;
                        });
                      },
                      child: SubscriptionWidget(
                        plans[index]['duration'],
                        plans[index]['price'],
                        selected == index ? yellow : normalGray,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 17,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: CustomButton(
          text: "Buy Now",
          onClick: () async {
            try {
              await EasyUpiPaymentPlatform.instance.startPayment(
                EasyUpiPaymentModel(
                  payeeVpa: 'bhandurge.rahul@ybl',
                  payeeName: 'Poultry Hub',
                  amount: double.parse(
                    plans[selected]['price'],
                  ),
                  description: 'Poultry Hub',
                ),
              );
              await reference.child('Pro Users').child('path').set({});
            } on EasyUpiPaymentException {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(
                    milliseconds: 1200,
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  backgroundColor: Colors.red.shade100,
                  content: const Text(
                    'Payment Failed!',
                  ),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(
                    milliseconds: 1200,
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  backgroundColor: Colors.red.shade100,
                  content: const Text(
                    'Something went wrong!',
                  ),
                ),
              );
            }
          },
          width: width(context),
          height: 58,
        ),
      ),
    );
  }

  Widget SubscriptionWidget(String validity, String price, Color color) {
    return Container(
      width: width(context) * .28,
      height: width(context) * .2,
      decoration: shadowDecoration(10, 2, white, bcolor: color),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          validity,
          style: bodyText12w500(color: black),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "\u{20B9}",
              style: bodyText12normal(color: black),
            ),
            addHorizontalySpace(2),
            Text(
              price,
              style: bodyText24w600(color: black),
            ),
          ],
        )
      ]),
    );
  }
}

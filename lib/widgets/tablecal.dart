import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:poultry_app/widgets/navigation.dart';
import 'package:intl/intl.dart';

class ShowCalendar extends StatefulWidget {
  final TextEditingController controller;
  bool canSelectBefore = false;
  DateTime? cannotSelectBefore = DateTime.utc(2022, 12, 1);
  ShowCalendar(
      {super.key,
      required this.controller,
      this.canSelectBefore = false,
      this.cannotSelectBefore});

  @override
  State<ShowCalendar> createState() => _ShowCalendarState();
}

class _ShowCalendarState extends State<ShowCalendar> {
  String currentDate = DateFormat('dd/MMM/yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
        height: 350,
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
            if (selectedDay.isAfter(DateTime.now())) {
              Fluttertoast.showToast(msg: "Cannot select future date!");
            } else {
              setState(() {
                if (widget.canSelectBefore) {
                  currentDate = DateFormat('dd/MMM/yyyy').format(selectedDay);
                  widget.controller.text = currentDate.toLowerCase();
                  goBack(context);
                } else {
                  if (widget.cannotSelectBefore != null) {
                    if (selectedDay.isBefore(widget.cannotSelectBefore!) &&
                        !(DateUtils.isSameDay(
                            selectedDay, widget.cannotSelectBefore))) {
                      Fluttertoast.showToast(msg: 'Cannot choose before date!');
                    } else {
                      currentDate =
                          DateFormat('dd/MMM/yyyy').format(selectedDay);
                      widget.controller.text = currentDate.toLowerCase();
                      goBack(context);
                    }
                  } else {
                    //if cannotSelectBefore is null!
                    if (selectedDay.isBefore(DateTime.now()) &&
                        !(DateUtils.isSameDay(selectedDay, DateTime.now()))) {
                      Fluttertoast.showToast(msg: 'Cannot choose before date!');
                    } else {
                      currentDate =
                          DateFormat('dd/MMM/yyyy').format(selectedDay);
                      widget.controller.text = currentDate.toLowerCase();
                      goBack(context);
                    }
                  }
                }
              });
            }
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

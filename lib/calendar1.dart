import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Calendar1 extends StatefulWidget {
  const Calendar1({super.key});

  @override
  State<Calendar1> createState() => _Calendar1State();
}

class _Calendar1State extends State<Calendar1> {
  DateTime selectedDate = DateTime.now();
  int currentDateSelectedIndex = 0;
  ScrollController scrollController = ScrollController();

  DateTime intialTime = DateTime.now();
  DateTime? time;

  List<String> listOfMonths = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  List<String> listOfDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  List<String> listOfTimes = [];

  // List<List<String>> listOfDays = [
  //   ["Mon", ""],
  //   ["Tue", ""],
  //   ["Wed", ""],
  //   ["Thu", ""],
  //   ["Fri", ""],
  //   ["Sat", ""],
  //   ["Sun", ""]
  // ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: const Text('My Calendar'),
        ),
        body: Column(
          children: [
            //Text Widget to Show Current Date
            Container(
                height: 30,
                margin: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  '${selectedDate.day}-${listOfMonths[selectedDate.month - 1]}, ${selectedDate.year}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.indigo[700]),
                )),
            const SizedBox(height: 10),

            //ListView Widget for the Calendar
            SizedBox(
              height: 100,
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 10);
                },
                itemCount: 60,
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        currentDateSelectedIndex = index;
                        selectedDate =
                            DateTime.now().add(Duration(days: index));
                      });
                      showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return _buildBottomPicker(timePicker());
                          });
                    },
                    child: Container(
                      height: 80,
                      width: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(3, 3),
                                blurRadius: 5)
                          ],
                          color: currentDateSelectedIndex == index
                              ? Colors.black
                              : Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            listOfMonths[DateTime.now()
                                        .add(Duration(days: index))
                                        .month -
                                    1]
                                .toString(),
                            style: TextStyle(
                                fontSize: 16,
                                color: currentDateSelectedIndex == index
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateTime.now()
                                .add(Duration(days: index))
                                .day
                                .toString(),
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: currentDateSelectedIndex == index
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            // listOfDays[DateTime.now()
                            //             .add(Duration(days: index))
                            //             .weekday -
                            //         1][0]
                            //     .toString(),
                            listOfDays[index][1],
                            style: TextStyle(
                                fontSize: 16,
                                color: currentDateSelectedIndex == index
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            listOfDays[DateTime.now()
                                    .add(Duration(days: index))
                                    .weekday -
                                1][1],
                            style: TextStyle(
                                fontSize: 16,
                                color: currentDateSelectedIndex == index
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addTimeToIndex() {
    if (time == null) {
      listOfDays[currentDateSelectedIndex][1] = "";
    } else {
      listOfDays[currentDateSelectedIndex][1] =
          DateFormat.Hm().format(time!).toString();
    }
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 250,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  Widget timePicker() {
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.time,
      use24hFormat: true,
      minuteInterval: 1,
      initialDateTime: intialTime,
      onDateTimeChanged: (DateTime changedTime) {
        setState(() {
          intialTime = changedTime;
          time = changedTime;
          _addTimeToIndex();
        });
      },
    );
  }
}

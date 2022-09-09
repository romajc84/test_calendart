import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Calendar1 extends StatefulWidget {
  const Calendar1({super.key});

  @override
  State<Calendar1> createState() => _Calendar1State();
}

class _Calendar1State extends State<Calendar1> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  DateTime _initialTime = DateTime.now();
  DateTime? _time;
  final int _daysInCalendar = 60;

  final List<String> _listOfDays = [
    "MON",
    "TUE",
    "WED",
    "THU",
    "FRI",
    "SAT",
    "SUN"
  ];

  List<String> listOfTimes = List<String>.filled(60, "", growable: true);

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
    _selectedIndex = 0;
  }

  void _scrollToIndex(index) {
    _scrollController.animateTo(60.0 * index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  _resetTimesIndex(DateTime oldTime) {
    final today = DateTime.now();
    int daysBetween(DateTime from, DateTime to) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      return (to.difference(from).inHours / 24).round();
    }

    int dayDifference = daysBetween(oldTime, today);
    if (dayDifference > 0) {
      for (int i = 0; i < dayDifference; i++) {
        listOfTimes.removeAt(0);
        listOfTimes.add("");
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyTheme.primary,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 42.0,
        title: Text(
          DateFormat.yMMMMd('en_US').format(_selectedDate).toString(),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _resetSelectedDate();
                  _scrollToIndex(_selectedIndex);
                  _resetTimesIndex(_initialTime);
                });
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          //ListView Widget for the Calendar
          SizedBox(
            height: 75,
            child: ListView.builder(
              itemCount: _daysInCalendar,
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                      _selectedDate = DateTime.now().add(Duration(days: index));
                      _scrollToIndex(index);
                      _resetTimesIndex(_initialTime);
                    });
                    showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildBottomPicker(timePicker());
                        });
                  },
                  child: Container(
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: _selectedIndex == index
                            ? MyTheme.primary
                            : Colors.transparent),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 3),
                        Text(
                          _listOfDays[DateTime.now()
                                      .add(Duration(days: index))
                                      .weekday -
                                  1]
                              .toString(),
                          style: _selectedIndex == index
                              ? const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )
                              : const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                        ),
                        if (_selectedIndex == index) ...[
                          const Padding(
                            padding: EdgeInsets.fromLTRB(5, 1, 5, 9),
                            child: Divider(
                              color: Colors.white,
                              height: 0,
                              thickness: 1,
                            ),
                          ),
                        ] else
                          const SizedBox(),
                        Text(
                          DateTime.now()
                              .add(Duration(days: index))
                              .day
                              .toString(),
                          style: _selectedIndex == index
                              ? TextStyle(
                                  color: Colors.redAccent[100],
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  height: 0.8,
                                )
                              : TextStyle(
                                  color: MyTheme.primary,
                                  fontSize: 32,
                                ),
                        ),
                        Text(
                          listOfTimes[index],
                          style: _selectedIndex == index
                              ? const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                )
                              : const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                        ),
                        const SizedBox(height: 3),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
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
      initialDateTime: _initialTime,
      onDateTimeChanged: (DateTime changedTime) {
        setState(() {
          _initialTime = changedTime;
          _time = changedTime;
          if (_time == null) {
            listOfTimes[_selectedIndex] = "";
          } else {
            listOfTimes[_selectedIndex] =
                DateFormat.Hm().format(_time!).toString();
          }
        });
      },
    );
  }
}

class MyTheme {
  static Color primary = const Color.fromRGBO(17, 46, 81, 1);
  static Color secondary = const Color.fromRGBO(0, 113, 188, 1);
}

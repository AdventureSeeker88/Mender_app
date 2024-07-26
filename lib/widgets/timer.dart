import 'dart:async';

import 'package:flutter/cupertino.dart';

class CustomTimer extends StatefulWidget {
  final dynamic onSecond;
  final dynamic onMinute;
  final dynamic onHour;
  final TextStyle textStyle;
  CustomTimer(
      {super.key,
      this.onSecond,
      this.onMinute,
      this.onHour,
      this.textStyle = const TextStyle()});

  @override
  State<CustomTimer> createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> {
  int hour = 0;
  int minute = 0;
  int seconds = 1;
  Timer? timer;
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  init() async {
    widget.onMinute();
    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      if (seconds == 59) {
        if (minute == 60) {
          setState(() {
            minute = 0;
            hour += 1;
            seconds = 0;
          });
          widget.onHour();
        } else {
          setState(() {
            minute += 1;
            seconds = 0;
          });
          widget.onMinute();
        }
      } else {
        setState(() {
          seconds += 1;
        });

        widget.onSecond();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${hour.toString().padLeft(2, '0')}: ${minute.toString().padLeft(2, '0')}: ${seconds.toString().padLeft(2, '0')}',
      style: widget.textStyle,
    );
  }
}

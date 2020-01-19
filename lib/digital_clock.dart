// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:developer';

import 'package:digital_clock/digit_specs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    var digit1 = _dateTime.hour % 10;
    var digit2 = _dateTime.minute ~/ 10;
    var digit3 = _dateTime.minute % 10;
    var digit0 = _dateTime.hour ~/ 10;


    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        Expanded(
          flex: 2,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment(getAlignment(digit1, 1), 0),
                child: AspectRatio(
                  aspectRatio: digitSpecs[digit1].getAspectRatio(),
                  child: CustomPaint(
                    painter: DigitPainter(
                      digit: digit1,
                      position: 1,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(getAlignment(digit2, 2), 0),
                child: AspectRatio(
                  aspectRatio: digitSpecs[digit2]
                      .getAspectRatio(),
                  child: CustomPaint(
                    painter: DigitPainter(
                      digit: digit2,
                      position: 2,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(getAlignment(digit3, 3), 0),
                child: AspectRatio(
                  aspectRatio: digitSpecs[digit3]
                      .getAspectRatio(),
                  child: CustomPaint(
                    painter: DigitPainter(
                      digit: digit3,
                      position: 3,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(getAlignment(digit0, 0), 0),
                child: AspectRatio(
                  aspectRatio: digitSpecs[digit0]
                      .getAspectRatio(),
                  child: CustomPaint(
                    painter: DigitPainter(
                      digit: digit0,
                      position: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }
}

double getAlignment(int digit, int position) {
  var delta = digit == 3 ? 0.07 : 0.0;
  var align = 0.43;
  var shiftX = 0.15 - delta;
  switch (position) {
    case 0:
      {
        return -(align + 2 * shiftX);
      }
      break;
    case 1:
      {
        return -(align - shiftX);
      }
      break;
    case 2:
      {
        return shiftX;
      }
      break;
    default:
      {
        return align + shiftX;
      }
  }
}

class DigitPainter extends CustomPainter {
  const DigitPainter({
    @required this.digit,
    @required this.position,
  })
      : assert(digit != null),
        assert(position != null);

  final int digit;
  final int position;

  @override
  void paint(Canvas canvas, Size size) {
    switch (digit) {
      case 0:
        {
          drawEmptyCircle(canvas, size, digit, position);
        }
        break;
      case 1:
        {
          drawFilledCircle(canvas, size, digit, position);
        }
        break;
      case 2:
        {
          drawLine(canvas, size, digit, position);
        }
        break;
      default:
        {
          drawPolygon(canvas, size, digit, position);
        }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawEmptyCircle(Canvas canvas, Size size, int digit, int position) {
    var paint = getPaint(position);
    canvas.drawCircle(Offset(size.height / 2, size.height / 2), 12, paint);
  }

  void drawFilledCircle(Canvas canvas, Size size, int digit, int position) {
    var paint = getPaint(position);
    canvas.drawCircle(Offset(size.height / 2, size.height / 2), 12, paint);
  }

  void drawLine(Canvas canvas, Size size, int digit, int position) {
    var paint = getPaint(position);
    var point2 = Offset(size.height / 2, size.height);
    var point1 = Offset(size.height / 2, 0.0);
    canvas.drawLine(point1, point2, paint,);
  }

  void drawPolygon(Canvas canvas, Size size, int digit, int position) {
    var polygon = digitSpecs[digit];

    var paint = getPaint(position);

    var path = polygon.draw(size);
    canvas.drawPath(path, paint);
  }

  static const digit1 = [
    Color(0X395845),
    Color(0X9C92A0),
    Color(0XAD822D),
    Color(0X98B45C),
    Color(0XDCBE74),
    Color(0X41778E),
    Color(0X358C92),
    Color(0X4D5170),
    Color(0X7E236A),
    Color(0X515842),
  ];

  static const digit3 = [
    Color(0X395845),
    Color(0X9C92A0),
    Color(0XAD822D),
    Color(0X98B45C),
    Color(0XDCBE74),
    Color(0X41778E),
    Color(0X358C92),
    Color(0X4D5170),
    Color(0X7E236A),
    Color(0X515842),
  ];

  static const digit0 = Color(0X450303);
  static const digit2 = Color(0XDF7474);

  Paint getPaint(int position) =>
      Paint()
        ..color = getColor(position).withOpacity(getOpacity(position))
        ..style = getPaintStyle(position)
        ..strokeWidth = position == 3 ? 2 : 0.5;

  Color getColor(int position) {
    var color;
    switch (position) {
      case 0:
        {
          color = digit0;
        }
        break;
      case 1:
        {
          color = digit1[digit];
        }
        break;
      case 2:
        {
          color = digit2;
        }
        break;
      case 3:
        {
          color = digit3[digit];
        }
        break;
    }
    return color;
  }

  PaintingStyle getPaintStyle(int position) {
    if (digit == 0) return PaintingStyle.stroke;
    if (digit == 1) return PaintingStyle.fill;
    if (digit == 2) return PaintingStyle.stroke;

    return position == 1 ? PaintingStyle.fill : PaintingStyle.stroke;
  }

  double getOpacity(int position) {
    assert(position < 4);
    if (position == 0) return 0.9;
    if (position == 3) return 0.5;
    return 1;
  }
}




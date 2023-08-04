// ignore_for_file: prefer_const_constructors, prefer_final_fields, avoid_print

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:spin_wheel_app/Widgets/board_view.dart';
import 'package:spin_wheel_app/models/model.dart';

class WhellFortune extends StatefulWidget {
  const WhellFortune({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WhellFortuneState();
  }
}

class _WhellFortuneState extends State<WhellFortune>
    with SingleTickerProviderStateMixin {
  double _angle = 0;
  double _current = 0;
  late AnimationController _ctrl;
  late Animation _ani;
  late String finalresult;

  List<Luck> _items = [
    Luck("Reward 1", Color(0xFFDAA520), "10"),
    Luck("Reward 2", Color(0xFF8F00FF), "20"),
    Luck("Reward 3", Color(0xFFDAA520), "30"),
    Luck("Reward 4", Color(0xFF8F00FF), "40"),
    Luck("Reward 5", Color(0xFFDAA520), "50"),
    Luck("Reward 6", Color(0xFF8F00FF), "60"),
    Luck("Reward 7", Color(0xFFDAA520), "70"),
    Luck("Reward 8", Color(0xFF8F00FF), "80"),
    Luck("Reward 9", Color(0xFFDAA520), "90"),
    Luck("Reward 10", Color(0xFF8F00FF), "100"),
  ];

  @override
  void initState() {
    super.initState();

    var _duration = Duration(milliseconds: 5000);
    _ctrl = AnimationController(vsync: this, duration: _duration);
    _ani = CurvedAnimation(parent: _ctrl, curve: Curves.fastLinearToSlowEaseIn);
  }

  int _calIndex(value) {
    var _base = (2 * pi / _items.length / 2) / (2 * pi);
    return (((_base + value) % 1) * _items.length).floor();
  }

  _animation() {
    if (!_ctrl.isAnimating) {
      var _random = Random().nextDouble();
      _angle = 20 + Random().nextInt(5) + _random;
      _ctrl.forward(from: 0.0).then((_) {
        _current = (_current + _random);
        _current = _current - _current ~/ 1;

        _finalvalue(context, finalresult); //end whell
        _ctrl.reset();
      });
    }
  }

  _finalvalue(context, value) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 2,
            title: Text(
              "Congratulations !",
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            content: Text(
              "Win the price of $value USD.",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
          animation: _ani,
          builder: (context, child) {
            final _value = _ani.value;
            final _angle = _value * this._angle;
            finalresult = _items[_calIndex(_value * _angle + _current)].point;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Spin the Wheel',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF8F00FF),
                  ),
                ),
                Text(
                  'Win Money',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ),
                const SizedBox(height: 50),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Center(
                        child: BoardView(
                            items: _items, current: _current, angle: _angle)),
                    Material(
                      color: Color.fromARGB(255, 154, 54, 231),
                      shape: CircleBorder(),
                      child: InkWell(
                          customBorder: CircleBorder(),
                          child: Container(
                            alignment: Alignment.center,
                            height: 70,
                            width: 70,
                            child: Icon(
                              Icons.replay_circle_filled,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            _animation();
                          }),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
}

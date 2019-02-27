import 'package:flutter/material.dart';

///
/// This is a playground for experimenting with building custom widgets and/or animations.
///
class CustomWidgetPlayground extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidgetPlayground>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(child: BasicTabTitleBar()),
    );
  }
}

///
/// Simple tab title bar that uses only widgets and animation controllers to achieve a list of tab titles evenly
/// spaced and underlined when the tab is active.
class BasicTabTitleBar extends StatefulWidget  {

  BasicTabTitleBar();

  @override
  State createState() => _BasicTabTitleBarState();
}

class _BasicTabTitleBarState extends State<BasicTabTitleBar> with TickerProviderStateMixin  {

  Animation<double> titleBarAnimation;
  AnimationController _animationController;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
//    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  _onTapping(int index, double maxWidth) {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    Tween tween = new Tween<double>(begin: _currentIndex * (maxWidth * (4 / 7)), end: index * (maxWidth * (4 / 7)));

    titleBarAnimation = tween.chain(CurveTween(curve: Curves.decelerate)).animate(_animationController);
    titleBarAnimation.addListener(() {
      setState(() {
      });
    });

    _animationController.forward();

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var titleOne = Text(
      "One",
      style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: _currentIndex == 0 ? FontWeight.bold : FontWeight.normal),
      textAlign: TextAlign.center,
    );
    var titleTwo = Text(
      "Two",
      style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: _currentIndex == 1 ? FontWeight.bold : FontWeight.normal),
      textAlign: TextAlign.center,
    );

    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child: GestureDetector(child: titleOne, onTap:()=> _onTapping(0, constraints.maxWidth),)
                  ),
                  Expanded(flex: 1, child: Container()),//simple spacer...
                  Expanded(
                      flex: 3,
                      child: GestureDetector(child: titleTwo, onTap:()=> _onTapping(1, constraints.maxWidth),)
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(titleBarAnimation?.value ?? 0, 0, 0, 0),
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    height: 1,
                    width: constraints.maxWidth * (3 / 7),
                  )
                ],
              ),
            ],
          );
        }));
  }
}

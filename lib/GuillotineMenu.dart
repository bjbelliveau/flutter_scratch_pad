import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Animation Test',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        child: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            Page(),
            GuillotineMenu(),
          ],
        ),
      ),
    );
  }
}

class GuillotineMenu extends StatefulWidget {
  @override
  _GuillotineMenuState createState() => _GuillotineMenuState();
}

enum _GuillotineAnimationStatus { closed, open, animating }

class _GuillotineMenuState extends State<GuillotineMenu>
    with SingleTickerProviderStateMixin {
  double rotationAngle = 0.0;
  double screenWidth, screenHeight;

  AnimationController animationControllerMenu;
  Animation<double> animationMenu;
  Animation<double> animationTitleFadeInOut;
  _GuillotineAnimationStatus menuAnimationStatus =
      _GuillotineAnimationStatus.closed;

  _handleMenuOpenClose() {
    if (menuAnimationStatus == _GuillotineAnimationStatus.closed) {
      animationControllerMenu.forward().orCancel;
    } else if (menuAnimationStatus == _GuillotineAnimationStatus.open) {
      animationControllerMenu.reverse().orCancel;
    }
  }

  @override
  void initState() {
    super.initState();
    animationControllerMenu = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          menuAnimationStatus = _GuillotineAnimationStatus.open;
        } else if (status == AnimationStatus.dismissed) {
          menuAnimationStatus = _GuillotineAnimationStatus.closed;
        } else {
          menuAnimationStatus = _GuillotineAnimationStatus.animating;
        }
      });

    animationMenu = Tween(begin: -pi / 2.0, end: 0.0).animate(CurvedAnimation(
        parent: animationControllerMenu,
        curve: Curves.bounceOut,
        reverseCurve: Curves.bounceIn));

    animationTitleFadeInOut = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationControllerMenu,
        curve: Interval(
          0.0,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationControllerMenu.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;

    return Material(
      color: Colors.transparent,
      child: Transform.rotate(
        angle: animationMenu.value,
        origin: Offset(24.0, 56.0),
        alignment: Alignment.topLeft,
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: Color(0xff333333),
          child: Stack(
            children: <Widget>[
              _buildMenuTitle(),
              _buildMenuIcon(),
              _buildMenuContent(),
            ],
          ),
        ),
      ),
    );
  }

  _buildMenuTitle() {
    return Positioned(
      top: 32.0,
      left: 40.0,
      width: screenWidth,
      height: 24.0,
      child: Transform.rotate(
        alignment: Alignment.topLeft,
        origin: Offset.zero,
        angle: pi / 2.0,
        child: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Opacity(
              opacity: animationTitleFadeInOut.value,
              child: Text(
                'ACTIVITY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildMenuIcon() {
    return Positioned(
      top: 32.0,
      left: 4.0,
      child: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: _handleMenuOpenClose,
      ),
    );
  }

  _buildMenuContent() {
    final List<Map> _menus = <Map>[
      {
        "icon": Icons.person,
        "title": "profile",
        "color": Colors.white,
      },
      {
        "icon": Icons.view_agenda,
        "title": "feed",
        "color": Colors.white,
      },
      {
        "icon": Icons.swap_calls,
        "title": "activity",
        "color": Colors.cyan,
      },
      {
        "icon": Icons.settings,
        "title": "settings",
        "color": Colors.white,
      },
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 64.0, top: 96.0),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _menus.map((menuItem) {
            return ListTile(
              leading: Icon(
                menuItem["icon"],
                color: menuItem["color"],
              ),
              title: Text(
                menuItem["title"],
                style: TextStyle(color: menuItem["color"], fontSize: 24.0),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 90.0),
      color: Color(0xff222222),
    );
  }
}

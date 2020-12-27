import 'package:flutter/material.dart';
import 'package:thikthak/customs/bottom_nav_bar.dart';
import 'package:thikthak/customs/nav_drawer.dart';
import 'package:thikthak/pages/sales_module/sales_home.dart';

int currentIndex = 0;

void navigateToScreens(int index) {
  currentIndex = index;
}

class SalesMainPage extends StatefulWidget {
  @override
  _SalesMainPageState createState() => _SalesMainPageState();
}

class _SalesMainPageState extends State<SalesMainPage> {
  final List<Widget> viewContainer = [
    SalesHome(),
    SalesHome(),
    SalesHome(),
    SalesHome()
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Image.asset(
            "assets/images/ic_app_icon.png",
            width: 80,
            height: 40,
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppSignIn()),
                );*/
              },
              icon: Icon(Icons.person),
              color: Color(0xFF323232),
            ),
          ],
        ),
        drawer: DrawerWidget(),
        body: IndexedStack(
          index: currentIndex,
          children: viewContainer,
        ),
        bottomNavigationBar: BottomNavBarWidget(),
      ),
    );
  }
}

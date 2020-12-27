import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/tab_fragment/assigned_order.dart';
import 'package:thikthak/tab_fragment/new_order.dart';

class HomeFragmentTechnician extends StatefulWidget {
  @override
  _HomeFragmentTechnicianState createState() => _HomeFragmentTechnicianState();
}

class _HomeFragmentTechnicianState extends State<HomeFragmentTechnician> {
  /// Define textStyle for all
  final TextStyle _tabTextStyle = GoogleFonts.ubuntu(
    textStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.0,
      fontSize: 12.5,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.colorBlue,
          elevation: 4.0,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(child: Text('NEW ORDERS', style: _tabTextStyle)),
              Tab(child: Text('ASSIGNED', style: _tabTextStyle)),
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Dashboard',
                  style: GoogleFonts.lilyScriptOne(
                      textStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500))),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NewOrders(),
            AssignedOrders(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thikthak/app/app.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/models/service_item.dart';
import 'package:thikthak/widget/all_item_widget.dart';

class AllService extends StatefulWidget {
  @override
  _AllServiceState createState() => _AllServiceState();
}

class _AllServiceState extends State<AllService> {

  // All service list
  List<ServiceItem> serviceItemList = App.serviceItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Services',
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: Container(
        color: MyColor.colorGrey,
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: serviceItemList.length,
          itemBuilder: (BuildContext context, int index) {
            return AllItemWidget(serviceItemList[index]);
          },
        ),
      ),
    );
  }
}

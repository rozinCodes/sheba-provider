import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/pages/dashboard.dart';
import 'package:thikthak/utils/font_util.dart';

class OrderConfirmed extends StatefulWidget {
  @override
  _OrderConfirmedState createState() => _OrderConfirmedState();
}

class _OrderConfirmedState extends State<OrderConfirmed> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Order Confirmed',
            style: FontUtil.black87W600,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => _onBackPressed(),
          ),
        ),
        body: Container(
          color: MyColor.colorGrey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Card(
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Icon(Icons.check_circle,
                              color: Colors.teal[400], size: 80),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Thank You',
                            textAlign: TextAlign.center,
                            style: FontUtil.themeColorW600S20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            'Thank you for using our service.',
                            textAlign: TextAlign.center,
                            style: FontUtil.grey900W500S16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            'For any questions and further information, please contact our customer support.',
                            textAlign: TextAlign.center,
                            style: FontUtil.grey700W400S16,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: OutlineButton(
                            child: Text(
                              "Goto Dashboard",
                              style: FontUtil.themeColorW600S15,
                            ),
                            borderSide: BorderSide(color: MyColor.colorBlue),
                            onPressed: () => _onBackPressed(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    // Redirect to Home Screen
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Dashboard()),
        (Route<dynamic> route) => false);
    return Future.value(true);
  }
}

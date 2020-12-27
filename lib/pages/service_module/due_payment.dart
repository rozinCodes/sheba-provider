import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/models/due_amount.dart';
import 'package:http/http.dart' as http;
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:thikthak/widget/due_payment_widget.dart';

class DuePayment extends StatefulWidget {
  @override
  _DuePaymentState createState() => _DuePaymentState();
}

class _DuePaymentState extends State<DuePayment> {
  Future<List<DueAmount>> _dueAmountList;
  double totalDueAmount = 0;

  Future<List<DueAmount>> _getDueAmounts() async {

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    try {
      final response = await http.get(Config.DUE_AMOUNT + '${ConstantValues.userId}', headers: headers);
      Http.printResponse(response);

      if (response.statusCode > 204 || response.body == null) {
            return []; // something error
          } else {
            var json = jsonDecode(response.body);
            List<dynamic> data = json['services'];
            List<DueAmount> list = data.map((dynamic item) => DueAmount.fromJson(item)).toList();
            setState(() => totalDueAmount = json['totalDue']);
            return list;
          }
    } on Exception catch (e, _) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();

    _dueAmountList = _getDueAmounts();
    /*_dueAmountList.then((value) {
      /// Calculate total due amount
      //var amount = list.map((e) =>  e.toJson()['totalAmount']).toList();
      //var sum = amount.reduce((a, b) => a + b);
      setState(() => totalDueAmount = value.map<double>((m) => m.toJson()["totalAmount"]).reduce((a, b) => a + b));
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Due Payment',
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              color: Colors.black87,
            ),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text.rich(
                    TextSpan(children: [
                      WidgetSpan(child: Icon(Icons.settings, color: MyColor.colorBlue)),
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          child: Text('Services'.toUpperCase(), style: FontUtil.black87W400S13),
                        ),
                      ),
                    ]),
                  ),
                  Text('Charge', style: FontUtil.black87W400S14),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _dueAmountList,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.data.length == 0) {
                    return Container(
                      child: Center(
                        child: Text("You've no due payment :)",
                            style: FontUtil.black87W400S16),
                      ),
                    );
                  } else {
                    List list = snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return DuePaymentWidget(list[index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: MyColor.colorGrey,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 6.0),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Total: ',
                    style: FontUtil.black87W400S13,
                  ),
                  Text(
                    ConstantValues.CURRENCY_SYMBOL + '$totalDueAmount',
                    style: FontUtil.black87W600S16,
                  ),
                  Spacer(),
                  SizedBox(
                    height: 40.0,
                    child: RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text("Make Payment", style: FontUtil.whiteW500S13),
                      color: MyColor.colorBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

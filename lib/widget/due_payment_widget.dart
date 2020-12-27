import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/models/due_amount.dart';
import 'package:thikthak/utils/font_util.dart';

class DuePaymentWidget extends StatelessWidget {
  final DueAmount dueAmount;

  DuePaymentWidget(this.dueAmount);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      //padding: EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: dueAmount.serviceName,
                  style: FontUtil.black87W600,
                  children: <TextSpan>[
                    TextSpan(
                        text: ' x${dueAmount.totalService}',
                        style: FontUtil.grey700W400S14),
                  ],
                ),
              ),
              Spacer(),
              Text(ConstantValues.CURRENCY_SYMBOL + '${dueAmount.totalAmount}',
                  style: FontUtil.black87W600),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}

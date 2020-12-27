import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/models/offer.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:thikthak/utils/utilities.dart';

class PromoWidget extends StatelessWidget {
  final Offer offer;
  const PromoWidget(this.offer);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Transform(
                alignment: FractionalOffset.centerLeft,
                transform: Matrix4.identity()..scale(0.72),
                child: Chip(
                  elevation: 0.0,
                  label: Text(
                    '${ConstantValues.CURRENCY_SYMBOL} ${offer.discountAmount} OFF',
                    style: FontUtil.blackW500S15,
                  ),
                  backgroundColor: Colors.greenAccent.withOpacity(0.8),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              Divider(height: 6.0),
              Text(
                "Congrats! Your promo code '${offer.promoCode}' activated | ${offer.title}",
                style: FontUtil.black87W400S14,
              ),
              SizedBox(height: 6.0),
              Text(
                "Valid till: ${Utilities.formatDate(offer.expiryDate)}",
                style: FontUtil.grey700W400S12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

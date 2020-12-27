import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/models/offer.dart';
import 'package:thikthak/utils/font_util.dart';

class CouponWidget extends StatelessWidget {
  final Offer offer;

  const CouponWidget(this.offer);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.60,
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: offer.isSelected ? MyColor.colorBlue.withOpacity(0.1) : Colors.white,
          border: Border.all(color: MyColor.colorBlue),
          borderRadius: BorderRadius.all(Radius.circular(6.0))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            offer.promoCode,
            style: FontUtil.themeColorW600S15,
          ),
          const SizedBox(height: 6.0),
          Text(
            offer.title,
            style: FontUtil.black87W400S12,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

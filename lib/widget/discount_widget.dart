import 'package:flutter/material.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/models/offer.dart';
import 'package:thikthak/pages/offer_details.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:thikthak/utils/utilities.dart';

class DiscountWidget extends StatelessWidget {
  final Offer offer;

  const DiscountWidget(this.offer, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        color: Colors.white,
        elevation: 1.0,
        margin: const EdgeInsets.all(6.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                height: 100,
                width: double.maxFinite,
                //color: MyColor.randomColor(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                  color: MyColor.randomColor(),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        offer.promoCode +
                            '\n' +
                            'Tk ${offer.discountAmount.toInt()} off',
                        style: FontUtil.whiteW500S18),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
                child: Text(
                  offer.title,
                  style: FontUtil.black87W400S13,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 0.0),
                child: Text(
                    'Valid till: ${Utilities.formatDate(offer.expiryDate)}',
                    style: FontUtil.themeColorW500S13),
              ),
              Divider(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 8),
                  child: SizedBox(
                    height: 32.0,
                    child: RaisedButton(
                      child: Text("View Detail", style: FontUtil.whiteW500S12),
                      color: MyColor.colorBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {
                        // Goto offer details page
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => OfferDetails(this.offer)));
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        print('pressed');
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/models/service_item.dart';
import 'package:thikthak/pages/service_module/delivery_address.dart';
import 'package:thikthak/utils/font_util.dart';

class AllItemWidget extends StatelessWidget {
  final ServiceItem serviceItem;

  AllItemWidget(this.serviceItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              // Goto order page
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DeliveryAddress(serviceItem)));
            },
            child: Ink(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.0,
                        child: FadeInImage.assetNetwork(
                            imageScale: 4.0,
                            placeholderScale: 5.5,
                            placeholder: 'assets/images/placeholder.png',
                            image: Config.BASE_URL + serviceItem.iconImgPath),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                serviceItem.itemName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.ubuntu(
                                  textStyle: const TextStyle(
                                    color: MyColor.textColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(bottom: 6.0)),
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                      color: MyColor.textColor,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                    ),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: "min Charge "),
                                    TextSpan(
                                      // servicePrice = minPrice + techRatingPrice
                                      text: '${ConstantValues.CURRENCY_SYMBOL}${serviceItem.minPrice + serviceItem.techRatingPrice}',
                                      style: FontUtil.grey700W400S14,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: MyColor.colorBlue.withOpacity(0.8),
                        size: 18.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

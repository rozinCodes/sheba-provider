import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/models/offer.dart';
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:thikthak/utils/util.dart';
import 'package:thikthak/utils/utilities.dart';
import 'package:http/http.dart' as http;

class OfferDetails extends StatelessWidget {
  final Offer offer;

  OfferDetails(this.offer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Offer Detail',
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              color: Colors.black87,
            ),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.title,
                  style: FontUtil.black87W500S16,
                  textAlign: TextAlign.center,
                ),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DottedBorder(
                      color: MyColor.colorBlue,
                      strokeWidth: 1,
                      dashPattern: [4, 2],
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 80),
                      child: SelectableText(
                        offer.promoCode.toUpperCase(),
                        style: FontUtil.themeColorW600S18,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                Text(
                  'Conditions :',
                  style: FontUtil.black87W500S13,
                ),
                offer.conditions != null
                    ? Text(
                        offer.conditions,
                        style: GoogleFonts.ubuntu(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      )
                    : Text(
                        'No conditions are available',
                        style: GoogleFonts.ubuntu(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
              ],
            ),
          ),
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
              color: Colors.red,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              child: Text('Validity: ${Utilities.formatDate(offer.expiryDate)}',
                  style: FontUtil.whiteW400S12),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Save Upto: ',
                    style: FontUtil.black87W400S13,
                  ),
                  Text(
                    ConstantValues.CURRENCY_SYMBOL +
                        offer.discountAmount.toString(),
                    style: FontUtil.black87W600S16,
                  ),
                  Spacer(),
                  SizedBox(
                    height: 40.0,
                    child: RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text("Apply Promo", style: FontUtil.whiteW500S13),
                      color: MyColor.colorBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0)),
                      onPressed: () {
                        _addPromoCode(offer.promoCode);
                      },
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

  /*
   * Add promo code
   */
  void _addPromoCode(String promoCode) async {
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    Map data = {
      'promoUser': ConstantValues.userId,
      'promoCode': promoCode,
    };

    // encode Map to JSON
    var body = jsonEncode(data);
    debugPrint(body);

    try {
      final response = await http.post(Config.PROMO_OFFER, headers: headers, body: body);
      Http.printResponse(response);

      if (response.statusCode > 204 || response.body == null) {
        Util.showColorToast('Something went wrong!', Colors.red);
        return;
      }
      var json = jsonDecode(response.body);
      Util.showToast(json['message']);

    } on Exception catch (e, _) {
      Util.showErrorToast();
    }
  }
}

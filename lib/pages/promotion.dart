import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/models/offer.dart';
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:http/http.dart' as http;
import 'package:thikthak/utils/util.dart';
import 'package:thikthak/widget/promo_widget.dart';

class OfferAndPromo extends StatefulWidget {
  @override
  _OfferAndPromoState createState() => _OfferAndPromoState();
}

class _OfferAndPromoState extends State<OfferAndPromo> {
  /*
   * Request for offer & promo  list
   */
  Future<List<Offer>> _getPromoList() async {
    final userParam = {'promoUser': '${ConstantValues.userId}'};

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    var uri = Uri.parse(Config.PROMO_OFFER);
    uri = uri.replace(queryParameters: userParam);

    try {
      final response = await http.get(uri, headers: headers);
      Http.printResponse(response);

      if (response.statusCode > 204 || response.body == null) {
        return []; // something error
      } else {
        List<dynamic> data = jsonDecode(response.body);
        List<Offer> offers = data.map((dynamic item) => Offer.fromJson(item)).toList();
        return offers;
      }
    } on Exception catch (e, _) {
      return [];
    }
  }

  /*
   * Add promo code
   */
  void _addPromoCode(String promoCode) async {
    // Show progress dialog
    //_progressDialog.show();

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

    try {
      final response = await http.post(Config.PROMO_OFFER, headers: headers, body: body);
      Http.printResponse(response);

      // Hide progress dialog
      //_progressDialog.hide();
      if (response.statusCode > 204 || response.body == null) {
        Util.showErrorToast();
        return;
      }

      var json = jsonDecode(response.body);
      Util.showToast(json['message']);
    } on Exception catch (e, _) {
      Util.showErrorToast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Promotions',
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              color: Colors.black87,
            ),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        color: MyColor.colorGrey,
        child: FutureBuilder(
          future: _getPromoList(),
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
                  child: Text(
                    "You don't have any promo code",
                    style: GoogleFonts.ubuntu(
                      textStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              List results = snapshot.data;
              return ListView.builder(
                //padding: const EdgeInsets.all(8.0),
                itemCount: results.length,
                itemBuilder: (BuildContext context, int index) {
                  return PromoWidget(results[index]);
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            padding: EdgeInsets.all(13.0),
            //materialTapTargetSize:  MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0)),
            child: Text('Apply Code', style: FontUtil.whiteW500S13),
            color: MyColor.colorBlue,
            onPressed: () => _showAddPromoCodeModal(),
          ),
        ),
      ),
    );
  }

  _showAddPromoCodeModal() {
    var _promoController = new TextEditingController();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0))),
            title: Text(
              'Add Promo Code',
              style: GoogleFonts.ubuntu(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      style: FontUtil.w400S16,
                      controller: _promoController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Enter Promo Code",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MyColor.colorBlue),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Container(
                                child: OutlineButton(
                              child:
                                  Text("Cancel", style: FontUtil.blueW500S13),
                              borderSide: BorderSide(color: MyColor.colorBlue),
                              onPressed: () {
                                setState(() => Navigator.of(context).pop());
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            )),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Container(
                                child: RaisedButton(
                              child: Text("Add Promo",
                                  style: FontUtil.whiteW500S13),
                              color: MyColor.colorBlue,
                              onPressed: () {
                                Navigator.of(context).pop();
                                _addPromoCode(_promoController.text);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                            )),
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

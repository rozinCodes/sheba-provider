import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:http/http.dart' as http;
import 'package:thikthak/models/offer.dart';
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/widget/discount_widget.dart';

class GetDiscount extends StatefulWidget {
  @override
  _GetDiscountState createState() => _GetDiscountState();
}

class _GetDiscountState extends State<GetDiscount> {
  /*
   * Request for offer & promo  list
   */
  Future<List<Offer>> _getOfferList() async {
    final userParam = {'type': 'OFFER'};

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Offers For You',
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
          future: _getOfferList(),
          builder: (context, AsyncSnapshot snapshot) {
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
                    "No offers are available",
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
              return GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(10.0),
                childAspectRatio: 0.66,
                children: List<Widget>.generate(results.length, (index) {
                  return DiscountWidget(results[index]);
                }),
              );
            }
          },
        ),
      ),
    );
  }
}

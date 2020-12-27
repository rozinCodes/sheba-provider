import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thikthak/app/app.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/models/offer.dart';
import 'package:thikthak/models/place_order.dart';
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/pages/service_module/order_confirm.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:http/http.dart' as http;
import 'package:thikthak/utils/util.dart';
import 'package:thikthak/utils/utilities.dart';
import 'package:thikthak/widget/coupon_widget.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  /// Progress dialog
  ProgressDialog _progressDialog;

  // Get place order details
  PlaceOrder placeOrder = App.placeOrder;

  Future<List<Offer>> _promoList;
  double amount = 0;
  double deliveryCharge = 0;
  double discount = 0;
  double total;

  double defaultHeight = 94.0;

  /*
   * Request for promo list
   */
  Future<List<Offer>> _getPromotion() async {
    final userParam = {'promoUser': '${ConstantValues.userId}'};

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    var uri = Uri.parse(Config.PROMO_OFFER);
    uri = uri.replace(queryParameters: userParam);

    try {
      final response = await http.get(uri, headers: headers).timeout(Duration(seconds: 15));
      Http.printResponse(response);

      if (response.statusCode > 204 || response.body == null) {
        setState(() => defaultHeight = 0);
        return []; // something error
      } else {
        List<dynamic> data = jsonDecode(response.body);
        if (data.length == 0) setState(() => defaultHeight = 0);
        List<Offer> offers = data.map((dynamic item) => Offer.fromJson(item)).toList();
        return offers;
      }
    } on Exception catch (e, _) {
      await _progressDialog.hide();
      Util.showErrorToast();
    }
  }

  @override
  void initState() {
    super.initState();
    _promoList = _getPromotion();
    // get previously calculated value from based on technician rating
    amount = placeOrder.paymentAmount;
    // initialize total with amount
    total = amount;
  }

  @override
  Widget build(BuildContext context) {
    // Init progress dialog
    _progressDialog = ProgressDialog(context,
        isDismissible: false,
        customBody: Center(child: CircularProgressIndicator()));
    _progressDialog.style(elevation: 0, backgroundColor: Colors.transparent);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Checkout',
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
          color: MyColor.colorGrey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Promo'.toUpperCase(),
                              style: FontUtil.grey700W400S12),
                          Text('+ Add', style: FontUtil.themeColorW500S12),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 6.0)),
                      Container(
                        height: defaultHeight,
                        child: FutureBuilder(
                          future: _promoList,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (snapshot.data.length == 0) {
                              return Container();
                            } else {
                              List list = snapshot.data;
                              return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: list.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    child: CouponWidget(list[index]),
                                    onTap: () {
                                      setState(() {
                                        list.forEach((item) {
                                          item.isSelected = false;
                                        });
                                        list[index].isSelected = !list[index].isSelected;

                                        // do some calculation
                                        discount = list[index].discountAmount;
                                        total = (amount + deliveryCharge) - discount;
                                      });
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Bill'.toUpperCase(),
                        style: FontUtil.grey700W400S12,
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 14.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("${placeOrder.serviceItemName} Servicing",
                              style: FontUtil.blackW400S14),
                          Text(ConstantValues.CURRENCY_SYMBOL + '${amount.toStringAsFixed(2)}',
                              style: FontUtil.blackW400S14),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Subtotal', style: FontUtil.blackW500S14),
                          Text(ConstantValues.CURRENCY_SYMBOL + '${amount.toStringAsFixed(2)}',
                              style: FontUtil.blackW500S14),
                        ],
                      ),
                      const SizedBox(height: 6.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Delivery Charge', style: FontUtil.blackW500S14),
                          Text(
                              ConstantValues.CURRENCY_SYMBOL + '${deliveryCharge.toStringAsFixed(2)}',
                              style: FontUtil.blackW500S14),
                        ],
                      ),
                      const SizedBox(height: 6.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Discount', style: FontUtil.greenW400S14),
                          Text(ConstantValues.CURRENCY_SYMBOL + '${discount.toStringAsFixed(2)}',
                              style: FontUtil.greenW400S14),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Amount Payable', style: FontUtil.blackW500S14),
                          Text(ConstantValues.CURRENCY_SYMBOL + '${total.toStringAsFixed(2)}',
                              style: FontUtil.blackW500S14),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text('NB: Price may vary depending on your problem.',
                        style: GoogleFonts.ubuntu(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          padding: EdgeInsets.all(13.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
                          child: Text("Checkout", style: FontUtil.whiteW500S13),
                          color: MyColor.colorBlue,
                          onPressed: () => _checkoutOrder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
   * Request for checkout
   */
  Future<Null> _checkoutOrder() async {
    // Show progress dialog
    await _progressDialog.show();

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    placeOrder.paymentAmount = total; // assign newly calculated total price
    placeOrder.serviceCost = total; // service cost & paymentAmount will be same while placing order
    placeOrder.orderPlaceTime = Utilities.getCurrentDateTime();

    // encode Map to JSON
    var body = jsonEncode(placeOrder.toJson());

    try {
      final response = await http.post(Config.PLACE_ORDER, headers: headers, body: body);
      // Hide progress dialog
      await _progressDialog.hide();

      Http.printResponse(response);
      if (response.statusCode > 204 || response.body == null) {
        Util.showErrorToast();
        return;
      }

      // Goto order confirm page
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => OrderConfirmed()));
    } on Exception catch (e, _) {
      await _progressDialog.hide();
      Util.showErrorToast();
    }
  }
}

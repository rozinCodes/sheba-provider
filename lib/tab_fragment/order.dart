import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/constant/status.dart';
import 'package:thikthak/customs/rating_dialog.dart';
import 'package:thikthak/models/order_history.dart';
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:thikthak/utils/util.dart';
import 'package:thikthak/widget/order_history_widget.dart';

class OrderFragment extends StatefulWidget {
  @override
  _OrderFragmentState createState() => new _OrderFragmentState();
}

class _OrderFragmentState extends State<OrderFragment> {
  /// Progress dialog
  ProgressDialog _progressDialog;
  Future<List<OrderHistory>> _orderList;
  bool _isTechnician = false;

  /*
   * Request for user order list
   */
  Future<List<OrderHistory>> _getOrderList() async {

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    final clientUser = {
      'clientUser': '${ConstantValues.userId}',
    };

    final technicianUser = {
      'technicianUser': '${ConstantValues.userId}',
    };

    var uri = Uri.parse(Config.ORDER_LIST);
    uri = uri.replace(queryParameters: _isTechnician ? technicianUser : clientUser);

    var response = await http.get(uri, headers: headers);
    //Http.printResponse(response);

    if (response.statusCode > 204 || response.body == null) {
      return []; // something error
    } else {
      /*Map data = jsonDecode(response.body);
      final orders = (data as List).map((i) => OrderHistory.fromJson(i));
      return orders.toList();*/

      List<dynamic> data = jsonDecode(response.body);
      List<OrderHistory> orders =
          data.map((dynamic item) => OrderHistory.fromJson(item)).toList();
      return orders;
    }
  }

  void _showRatingDialog(OrderHistory order) {
    // We use the built in showDialog function to show our Rating Dialog
    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return RatingDialog(
            title: "Feedback",
            description: "Are you satisfied with your service, how would you rate your experience?",
            submitButton: "Submit",
            showCommentBox: false,
            onSubmitPressed: (value) {
              double rating = (value.item1 * 20);
              print("rating = $rating");
              print("review = ${value.item2}");

              _rateOrder(order, rating);
            },
          );
        });
  }

  void _rateOrder(OrderHistory order, double rating) async {
    // Show progress dialog
    await _progressDialog.show();

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    // update order rating
    order.rating = rating;
    order.isRated = true;

    //encode Map to JSON
    var body = jsonEncode(order);

    var url = Uri.encodeFull(Config.ORDER_LIST + '/${order.id}');
    final response = await http.put(url, headers: headers, body: body);
    // Hide progress dialog
    await _progressDialog.hide();

    Http.printResponse(response);
    if (response.statusCode > 204 || response.body == null) {
      Util.showColorToast('Something went wrong. Please try again.', Colors.red);
      return;
    }

    Util.showToast('Thanks for your feedback');
    refreshOrders();
  }

  Future<void> refreshOrders() {
    setState(() {
      _orderList = _getOrderList();
    });
    return _orderList;
  }

  @override
  void initState() {
    super.initState();

    /// check for user type
    _isTechnician = ConstantValues.userType != 'user';

    /// load order list from server
    _orderList = _getOrderList();
  }

  @override
  Widget build(BuildContext context) {
    // Init progress dialog
    _progressDialog = ProgressDialog(context,
        isDismissible: false,
        customBody: Center(child: CircularProgressIndicator()));
    _progressDialog.style(elevation: 0, backgroundColor: Colors.transparent);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order History',
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
          future: _orderList,
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
                    'Order list empty',
                    style: FontUtil.black87W400S16,
                  ),
                ),
              );
            } else {
              List orderHistory = snapshot.data;
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: orderHistory.length,
                itemBuilder: (BuildContext context, int index) {
                  return OrderHistoryWidget(orderHistory[index],
                      onRating: () => _showRatingDialog(orderHistory[index]),
                      onAgree: (price) => _agreeOrder(orderHistory[index], price),
                      onDisagree: () => _disagreeOrder(orderHistory[index]));
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _agreeOrder(OrderHistory order, double price) async {
    // Show progress dialog
    await _progressDialog.show();

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    // update payment amount
    order.paymentAmount = price;
    order.isAgreed = true;

    // encode Map to JSON
    var body = jsonEncode(order);

    var url = Uri.encodeFull(Config.ORDER_LIST + '/${order.id}');
    final response = await http.put(url, headers: headers, body: body);
    // Hide progress dialog
    await _progressDialog.hide();

    Http.printResponse(response);
    if (response.statusCode > 204 || response.body == null) {
      Util.showColorToast('Something went wrong!', Colors.red);
      return;
    }

    Util.showToast('New price updated successfully.');
    // refresh order list
    refreshOrders();
  }

  void _disagreeOrder(OrderHistory order) async {
    // Show progress dialog
    await _progressDialog.show();

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    // in case of accepted oder will not reject is customer disagree with price
    // but price will be updated, it will remain previous price
    if(order.status == Status.Accepted){
      order.isAgreed = true;
    } else {
      // reject the order if customer disagree with price
      order.status = Status.Rejected;
    }
    // encode Map to JSON
    var body = jsonEncode(order);

    var url = Uri.encodeFull(Config.ORDER_LIST + '/${order.id}');
    try {
      final response = await http.put(url, headers: headers, body: body);
      // Hide progress dialog
      await _progressDialog.hide();

      Http.printResponse(response);
      if (response.statusCode > 204 || response.body == null) {
        Util.showErrorToast();
        return;
      }

      order.status == Status.Accepted
          ? Util.showToast("You're disagree with new cost.")
          : Util.showToast('Order has been closed.');
      // refresh order list
      refreshOrders();

    } on Exception catch (e, _) {
      await _progressDialog.hide();
      Util.showErrorToast();
    }
  }
}

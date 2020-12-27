import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/constant/status.dart';
import 'package:thikthak/models/order_history.dart';
import 'package:http/http.dart' as http;
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/pages/service_module/required_parts_page.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:thikthak/utils/util.dart';
import 'package:thikthak/widget/new_order_widget.dart';


class NewOrders extends StatefulWidget {
  @override
  _NewOrdersState createState() => _NewOrdersState();
}

class _NewOrdersState extends State<NewOrders> {
  /// Progress dialog
  ProgressDialog _progressDialog;
  Future<List<OrderHistory>> _newOrderList;

  void refreshOrderList() {
    _newOrderList = _getNewOrder();
  }

/*
 * Request for new order list
*/
  Future<List<OrderHistory>> _getNewOrder() async {
    final queryParameters = {
      'status': '0', // 0 means pending
      'technicianUser': '${ConstantValues.userId}',
    };

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    var uri = Uri.parse(Config.ORDER_LIST);
    uri = uri.replace(queryParameters: queryParameters);

    var response = await http.get(uri, headers: headers);
    Http.printResponse(response);

    if (response.statusCode > 204 || response.body == null) {
      return []; // something error
    } else {
      List<dynamic> data = jsonDecode(response.body);
      List<OrderHistory> orders = data.map((dynamic item) => OrderHistory.fromJson(item)).toList();
      return orders;
    }
  }

  Future<void> refreshOrders() {
    setState(() {
      _newOrderList = _getNewOrder();
    });
    return _newOrderList;
  }

  @override
  void initState() {
    super.initState();
    _newOrderList = _getNewOrder();

    /// Callback listener
    addCostCallback.stream.listen((_) {
      refreshOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Init progress dialog
    _progressDialog = ProgressDialog(context,
        isDismissible: false,
        customBody: Center(child: CircularProgressIndicator()));
    _progressDialog.style(elevation: 0, backgroundColor: Colors.transparent);

    return RefreshIndicator(
      onRefresh: refreshOrders,
      child: Container(
        color: MyColor.colorGrey,
        child: FutureBuilder(
          future: _newOrderList,
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
                  child: Text('No new orders', style: FontUtil.black87W400S16),
                ),
              );
            } else {
              List orderItem = snapshot.data;
              return ListView.builder(
                itemCount: orderItem.length,
                itemBuilder: (BuildContext context, int index) {
                  return NewOrderWidget(
                    orderItem[index],
                    accept: () {
                      _acceptRejectOrder(orderItem[index], Status.Accepted);
                    },
                    reject: () {
                      _displayRejectConfirmDialog(onReject: () {
                        _acceptRejectOrder(orderItem[index], Status.Rejected);
                      });
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  _displayRejectConfirmDialog({Function() onReject}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
            title: Text(
              'Reject order?',
              style: GoogleFonts.ubuntu(
                fontSize: 18.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Text(
                  'Are you want to reject this order?',
                  style: GoogleFonts.ubuntu(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                );
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Yes',
                  style: GoogleFonts.ubuntu(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onReject();
                },
              ),
              FlatButton(
                child: Text(
                  'No',
                  style: GoogleFonts.ubuntu(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _acceptRejectOrder(OrderHistory order, int status) async {
    // Show progress dialog
    await _progressDialog.show();

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    // update order status
    order.status = status;

    //encode Map to JSON
    var body = jsonEncode(order);

    var url = Uri.encodeFull(Config.ORDER_LIST + '/${order.id}');
    try {
      final response = await http.put(url, headers: headers, body: body)
          .timeout(Duration(seconds: 30));
      // Hide progress dialog
      await _progressDialog.hide();

      Http.printResponse(response);
      if (response.statusCode > 204 || response.body == null) {
        Util.showErrorToast();
        return;
      }

      Util.showColorToast('Order ' + (status == Status.Accepted ? 'accepted' : 'rejected'),
          status == Status.Accepted ? Colors.green : Colors.red);
      //setState(() => orderItem.removeAt(index));
      refreshOrders();

    } on Exception catch (e, _) {
      await _progressDialog.hide();
      Util.showErrorToast();
    }
  }
}

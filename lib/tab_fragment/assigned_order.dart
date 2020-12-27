import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/constant/status.dart';
import 'package:thikthak/models/order_history.dart';
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/pages/service_module/payment.dart';
import 'package:thikthak/pages/service_module/required_parts_page.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:thikthak/utils/util.dart';
import 'package:thikthak/widget/assigned_order_widget.dart';

class AssignedOrders extends StatefulWidget {
  @override
  _AssignedOrdersState createState() => _AssignedOrdersState();
}

class _AssignedOrdersState extends State<AssignedOrders> {
  /// Progress dialog
  ProgressDialog _progressDialog;
  Future<List<OrderHistory>> _assignedOrderList;

  /*
   * Request for assigned order list
   */
  Future<List<OrderHistory>> _getAssignedOrder() async {
    final queryParameters = {
      'status': '1', // 1 means accepted
      'technicianUser': '${ConstantValues.userId}',
    };

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    var uri = Uri.parse(Config.ORDER_LIST);
    uri = uri.replace(queryParameters: queryParameters);

    try {
      final response = await http.get(uri, headers: headers);
      Http.printResponse(response);

      if (response.statusCode > 204 || response.body == null) {
        return []; // something error
      } else {
        List<dynamic> data = jsonDecode(response.body);
        List<OrderHistory> orders = data.map((dynamic item) => OrderHistory.fromJson(item)).toList();
        return orders;
      }
    } on Exception catch (e, _) {
      return [];
    }
  }

  Future<void> refreshOrders() {
    setState(() {
      _assignedOrderList = _getAssignedOrder();
    });
    return _assignedOrderList;
  }

  @override
  void initState() {
    super.initState();
    _assignedOrderList = _getAssignedOrder();

    /// Callback listener
    addCostCallback.stream.listen((_) {
      refreshOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Init progress dialog
    _progressDialog = ProgressDialog(context, isDismissible: false, customBody: Center(child: CircularProgressIndicator()));
    _progressDialog.style(elevation: 0, backgroundColor: Colors.transparent);

    return RefreshIndicator(
      onRefresh: refreshOrders,
      child: Container(
        color: MyColor.colorGrey,
        child: FutureBuilder(
          future: _assignedOrderList,
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
                  child: Text('No assigned orders',
                      style: FontUtil.black87W400S16),
                ),
              );
            } else {
              List<OrderHistory> orderItem = snapshot.data;
              return ListView.builder(
                itemCount: orderItem.length,
                itemBuilder: (BuildContext context, int index) {
                  OrderHistory order = orderItem[index];
                  return AssignedOrderWidget(
                    order,
                    complete: () {
                      if(order.servicePartsRequired && !order.isAgreed) {
                        _showIncompleteDialog();
                      } else {
                        _displayConfirmDialog(onConfirm: () {
                          _completeRejectOrder(order, Status.Complete);
                        });
                      }
                    },
                    reject: () {
                      _displayRejectDialog(onReject: () {
                        _completeRejectOrder(order, Status.Rejected);
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

  void _showIncompleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Request Pending', style: FontUtil.black87W600S18),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    "Your last 'Add Cost' request is pending. Your can't complete this order without customer acknowledgement.",
                    style: FontUtil.black87W400S16),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok', style: FontUtil.themeColorW500S16),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _displayConfirmDialog({Function() onConfirm}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0))),
            title: Text(
              'Order Complete?',
              style: FontUtil.black87W600S18),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Text(
                  'Do you want to mark this work as done?',
                  style: FontUtil.black87W400S16);
              },
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Yes', style: FontUtil.themeColorW500S16),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
              ),
              TextButton(
                child: Text('No', style: FontUtil.themeColorW500S16),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _displayRejectDialog({Function() onReject}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0))),
            title: Text(
              'Reject order?',
              style: FontUtil.black87W600S18),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Text(
                  'Are you want to reject this order?',
                  style: FontUtil.black87W400S16);
              },
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Yes', style: FontUtil.themeColorW500S16),
                onPressed: () {
                  Navigator.of(context).pop();
                  onReject();
                },
              ),
              TextButton(
                child: Text('No', style: FontUtil.themeColorW500S16),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _completeRejectOrder(OrderHistory order, int status) async {
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

      Util.showColorToast('Order ' + (status == Status.Complete ? 'completed' : 'rejected'),
          status == Status.Complete ? Colors.indigo : Colors.red);
      refreshOrders();

      if (status == Status.Complete) {
        // navigate to payment page
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Payment('Payment', order)));
      }
    } on Exception catch (e, _) {
      await _progressDialog.hide();
      Util.showErrorToast();
    }
  }
}

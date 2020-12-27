import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/constant/status.dart';
import 'package:thikthak/customs/flutter_rating_bar.dart';
import 'package:thikthak/models/order_history.dart';
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:thikthak/utils/util.dart';
import 'package:thikthak/utils/utilities.dart';
import 'package:http/http.dart' as http;

class Payment extends StatefulWidget {
  final String title;
  final OrderHistory order;

  Payment(this.title, this.order);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  /// Progress dialog
  ProgressDialog _progressDialog;
  bool _isTechnician = false;

  @override
  void initState() {
    super.initState();
    _isTechnician = ConstantValues.userType != 'user';
  }

  @override
  Widget build(BuildContext context) {
    // Init progress dialog
    _progressDialog = ProgressDialog(context, isDismissible: false, customBody: Center(child: CircularProgressIndicator()));
    _progressDialog.style(elevation: 0, backgroundColor: Colors.transparent);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              color: Colors.black87,
            ),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Stack(fit: StackFit.loose, children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:
                                    ExactAssetImage('assets/images/avatar.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Text(
                    _isTechnician
                        ? widget.order.clientUserName
                        : widget.order.technicianUserName,
                    style: FontUtil.w500S16,
                  ),
                  _isTechnician
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: RatingBarIndicator(
                                rating: widget.order.technicianUser.rating / ConstantValues.RATING_CONV,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 14.0,
                                ratingWidget: RatingWidget(
                                  full: Icon(Icons.star, color: Colors.amber),
                                  half: Icon(Icons.star_half, color: Colors.amber),
                                  empty: Icon(Icons.star_border, color: Colors.amber),
                                ),
                                unratedColor: Colors.amber,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              widget.order.technicianUser.rating != null
                                  ? '(${widget.order.technicianUser.rating.toStringAsFixed(2)})' : '(0.0)',
                              style: FontUtil.black87W400S12,
                            ),
                          ],
                        ),
                  Transform(
                    alignment: FractionalOffset.center,
                    transform: Matrix4.identity()..scale(0.7),
                    child: Chip(
                      elevation: 0.0,
                      label: RichText(
                        text: TextSpan(
                          style: GoogleFonts.ubuntu(
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: MyColor.textColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          children: <TextSpan>[
                            TextSpan(text: "Order Status: "),
                            TextSpan(
                              text: _getStatus(widget.order.status),
                              style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: _getBackgroundColor(widget.order.status)
                          .withOpacity(0.1),
                      shape: StadiumBorder(
                          side: BorderSide(
                              color: _getBackgroundColor(widget.order.status))),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 8.0)),
                  Divider(color: Colors.grey[400]),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.settings,
                                      color: Colors.black45,
                                      size: 18.0,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      widget.order.serviceItemName + ' Servicing',
                                      style: FontUtil.blackW400S14,
                                     ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.black45,
                                      size: 18.0,
                                    ),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        widget.order.clientGeoLocation,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: FontUtil.blackW400S14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.black45,
                                      size: 18.0,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      Utilities.formatDateTime(widget.order.orderPlaceTime),
                                      style: FontUtil.blackW400S14,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey[400]),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Order id',
                                textAlign: TextAlign.center,
                                style: FontUtil.blackW400S11,
                              ),
                              SizedBox(height: 3),
                              Text(
                                widget.order.orderCode,
                                textAlign: TextAlign.center,
                                style: FontUtil.blackW500S14,
                              ) // text
                            ],
                          ),
                        ),
                        VerticalDivider(color: Colors.grey[400]),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Amount',
                                textAlign: TextAlign.center,
                                style: FontUtil.blackW400S11,
                              ),
                              SizedBox(height: 3),
                              Text(
                                ConstantValues.CURRENCY_SYMBOL + widget.order.paymentAmount.toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: FontUtil.blackW500S14,
                              ) // text
                            ],
                          ),
                        ),
                        VerticalDivider(color: Colors.grey[400]),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Payment Type',
                                textAlign: TextAlign.center,
                                style: FontUtil.blackW400S11,
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Cash',
                                textAlign: TextAlign.center,
                                style: FontUtil.blackW500S14,
                              ) // text
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey[400]),
                  Padding(padding: EdgeInsets.only(bottom: 10)),
                  Visibility(
                    visible: widget.order.status != Status.Rejected,
                    child: Column(
                      children: [
                        Text(
                          _isTechnician ? 'User will pay'
                              : widget.order.status == Status.Complete
                              ? 'BDT' : 'You have to pay',
                          textAlign: TextAlign.center,
                          style: FontUtil.grey700W400S13,
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 8.0)),
                        Text(
                          ConstantValues.CURRENCY_SYMBOL +
                              widget.order.paymentAmount.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: FontUtil.black87W600S25,
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 16.0)),
                  Visibility(
                    visible: !_isTechnician,
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          SizedBox(width: 6.0),
                          Text(
                            'Add to favourite',
                            style: FontUtil.blackW400S14,
                          ),
                        ],
                      ),
                      onTap: _addTechnicianToFavourite,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _isTechnician && widget.order.status == Status.Complete
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  padding: EdgeInsets.all(12.0),
                  //materialTapTargetSize:  MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  child: Text("I have collected BDT ${widget.order.paymentAmount.toStringAsFixed(2)}".toUpperCase(),
                      style: FontUtil.whiteW500S12),
                  color: MyColor.colorBlue,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            )
          : null,
    );
  }

  String _getStatus(int status) {
    if (status == 1) {
      return 'Accepted';
    } else if (status == 2) {
      return 'Complete';
    } else if (status == 3) {
      return 'Rejected';
    } else {
      return 'Pending';
    }
  }

  Color _getBackgroundColor(int status) {
    if (status == 1) {
      return Colors.green;
    } else if (status == 2) {
      return Colors.indigo;
    } else if (status == 3) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  void _addTechnicianToFavourite() async {
    await _progressDialog.show();

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    Map data = {
      'clientUserId': ConstantValues.userId,
      'techUserId': widget.order.technicianUserId,
      'favorite': true,
    };

    // encode Map to JSON
    var body = jsonEncode(data);

    try {
      final response = await http.post(Config.FAVOURITE_LIST, headers: headers, body: body);
      await _progressDialog.hide();

      Http.printResponse(response);
      if (response.statusCode > 204 || response.body == null) {
        Util.showErrorToast();
        return;
      }
      var json = jsonDecode(response.body);
      Util.showToast(json['message']);

    } on Exception catch (e, _) {
      await _progressDialog.hide();
      Util.showErrorToast();
    }
  }
}

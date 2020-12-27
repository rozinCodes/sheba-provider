import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/models/order_history.dart';
import 'package:thikthak/pages/service_module/required_parts_page.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:thikthak/utils/map_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class NewOrderWidget extends StatelessWidget {
  /*
  * Callback function
  */
  final OrderHistory order;
  final VoidCallback accept;
  final VoidCallback reject;

  NewOrderWidget(this.order, {this.accept, this.reject});

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 95,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: IntrinsicHeight(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${order.clientUserName}',
                      style: FontUtil.black87W600S14,
                    ),
                    Spacer(),
                    Container(
                      alignment: AlignmentDirectional.centerEnd,
                      transform: Matrix4.translationValues(20.0, 0.0, 0.0),
                      child: _showPopup(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.phone, color: Colors.green, size: 14),
                          SizedBox(width: 3.0),
                          Text(
                            'Call to customer',
                            style: GoogleFonts.ubuntu(
                              textStyle: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () =>
                          launch("tel:${order.clientUser.phoneNumber}"),
                    ),
                    Spacer(),
                    Text(
                      '${order.serviceItemName}',
                      style: FontUtil.black87W500S12,
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
                            order.orderCode,
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
                            ConstantValues.CURRENCY_SYMBOL + '${order.paymentAmount.toStringAsFixed(2)}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ubuntu(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              decoration: order.servicePartsRequired != null && order.isAgreed != null &&
                                  order.servicePartsRequired && !order.isAgreed
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          if (order.servicePartsRequired != null && order.isAgreed != null)
                            if (order.servicePartsRequired && !order.isAgreed)
                              Text(
                                '(Request Pending)',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ubuntu(
                                    fontSize: 11.0,
                                    color: Colors.red[400],
                                    fontWeight: FontWeight.w400),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
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
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.location_on,
                              color: Colors.grey[600], size: 18),
                          SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              '${order.clientGeoLocation}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: FontUtil.black87W400S13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: SvgPicture.asset(
                        'assets/icons/navigate.svg',
                        height: 20,
                        width: 20,
                        color: MyColor.colorBlue,
                      ),
                      onTap: () => MapUtils.openMap(
                          order.clientLatitude, order.clientLongitude),
                    ),
                  ],
                ),
              ),
              Container(height: 1, width: double.infinity, color: Colors.grey[300]),
              Container(
                height: 36.0,
                color: Colors.grey[100],
                child: IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.check, color: Colors.green, size: 18),
                              SizedBox(width: 6),
                              Text(
                                "Accept".toUpperCase(),
                                style: FontUtil.black87W400S12,
                              ),
                            ],
                          ),
                          onPressed: this.accept,
                        ),
                      ),
                      VerticalDivider(color: Colors.grey[400]),
                      Expanded(
                        child: FlatButton(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.clear, color: Colors.red, size: 18),
                              SizedBox(width: 6),
                              Text(
                                "Reject".toUpperCase(),
                                style: FontUtil.black87W400S12,
                              ),
                            ],
                          ),
                          onPressed: this.reject,
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

  Widget _showPopup(context) => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text("Add Cost"),
          ),
          PopupMenuItem(
            value: 2,
            child: Text("Problem Details"),
          ),
        ],
        tooltip: 'More',
        padding: EdgeInsets.all(1.0),
        icon: Icon(Icons.more_vert, size: 18.0),
        onSelected: (value) {
          switch (value) {
            case 1:
              _requiredPartsModalBottomSheet(context);
              break;
            case 2:
              _problemDetailsModalBottomSheet(context);
              break;
          }
        },
      );

  void _requiredPartsModalBottomSheet(context) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Add Cost',
                  style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                      color: MyColor.textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                Divider(),
                RequiredPartsPage(order: order),
              ],
            ),
          );
        },
      );

  void _problemDetailsModalBottomSheet(context) => showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext bc) {
        return Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'Problem Details:',
                style: GoogleFonts.ubuntu(
                  textStyle: TextStyle(
                    color: MyColor.textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              Divider(),
              Text(
                order.serviceDetailsDesc == null
                    ? 'No details available.'
                    : order.serviceDetailsDesc,
                style: GoogleFonts.ubuntu(
                  textStyle: TextStyle(
                    color: MyColor.textColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        );
      });
}

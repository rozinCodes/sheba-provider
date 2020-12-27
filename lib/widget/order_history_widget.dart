import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/constant/status.dart';
import 'package:thikthak/customs/flutter_rating_bar.dart';
import 'package:thikthak/models/order_history.dart';
import 'package:thikthak/models/required_parts.dart';
import 'package:thikthak/pages/service_module/payment.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:thikthak/utils/utilities.dart';

class OrderHistoryWidget extends StatefulWidget {
  final OrderHistory order;
  final VoidCallback onRating;
  final ValueSetter<double> onAgree;
  final VoidCallback onDisagree;

  OrderHistoryWidget(this.order, {this.onRating, this.onAgree, this.onDisagree});

  @override
  _OrderHistoryWidgetState createState() => _OrderHistoryWidgetState();
}

class _OrderHistoryWidgetState extends State<OrderHistoryWidget> {
  final List<Map> _costItems = [
    {"id": "serviceCost", "name": "Service Cost"},
    {"id": "partsCost", "name": "Parts Cost"},
    {"id": "tadaCost", "name": "TA Cost"},
    {"id": "othersCost", "name": "Others"}
  ];

  bool _isTechnician = false;
  bool _isPartsRequired = false;
  bool _isAgree = false;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _isTechnician = ConstantValues.userType != 'user';
  }

  @override
  Widget build(BuildContext context) {
    /// update all value in setState call
    _isPartsRequired = widget.order.servicePartsRequired ?? false;
    _isAgree = widget.order.isAgreed ?? false;
    // show badge & agree/disagree only for pending & accepted order
    _isVisible = widget.order.status < Status.Complete;

    return Container(
      child: Card(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.order.orderCode,
                    style: FontUtil.black87W600S18,
                  ),
                  Spacer(),
                  Container(
                    transform: Matrix4.translationValues(18.0, 0.0, 0.0),
                    child: _showPopup(),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: <Widget>[
                  Transform(
                    alignment: FractionalOffset.topLeft,
                    transform: Matrix4.identity()..scale(0.7),
                    child: Chip(
                      elevation: 0.0,
                      label: Text(
                        _getStatus(widget.order.status),
                        style: FontUtil.black87W400S14,
                      ),
                      backgroundColor: _getBackgroundColor(widget.order.status).withOpacity(0.1),
                      shape: StadiumBorder(
                          side: BorderSide(
                              color: _getBackgroundColor(widget.order.status))),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  Container(
                    transform: Matrix4.translationValues(-10.0, 2.0, 0.0),
                    child: widget.order.isRated != null && widget.order.isRated
                        ? RatingBarIndicator(
                            rating: widget.order.rating / ConstantValues.RATING_CONV,
                            // Convert max (100) rating to 5
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemSize: 16.0,
                            ratingWidget: RatingWidget(
                              full: Icon(Icons.star, color: Colors.amber),
                              half: Icon(Icons.star_half, color: Colors.amber),
                              empty: Icon(Icons.star_border, color: Colors.amber),
                            ),
                            unratedColor: Colors.amber,
                          )
                        : RatingBarIndicator(
                            rating: 0,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemSize: 16.0,
                            itemBuilder: (context, index) =>
                                Icon(Icons.star_border),
                            unratedColor: Colors.amber,
                          ),
                  ),
                  //SizedBox(width: 6),
                  Text(
                    widget.order.rating != null
                        ? '(${widget.order.rating})'
                        : '(0.0)',
                    style: FontUtil.black87W400S14,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Divider(height: 1.0, thickness: 0.8, color: Colors.grey[200]),
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 6),
              child: Row(
                children: <Widget>[
                  Icon(Icons.settings,
                    color: Colors.black38,
                  ),
                  SizedBox(width: 6),
                  Text(
                    '${widget.order.serviceItemName}' + ' Servicing',
                    style: FontUtil.black87W400S16,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    color: Colors.black38,
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${widget.order.clientGeoLocation}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: FontUtil.black87W400S16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    color: Colors.black38,
                  ),
                  SizedBox(width: 6),
                  Text(
                    Utilities.formatDateTime(widget.order.orderPlaceTime),
                    style: FontUtil.black87W400S16,
                  ),
                ],
              ),
            ),
            // Show feedback button for user when order will completed
            !_isTechnician && widget.order.status == Status.Complete &&
                    (widget.order.isRated == null || !widget.order.isRated)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: OutlineButton(
                        child: Text(
                          "Give a feedback",
                          style: FontUtil.grey700W500S15,
                        ),
                        borderSide: BorderSide(color: Colors.grey[700]),
                        onPressed: () {
                          if (widget.onRating != null) widget.onRating();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                  )
                : Padding(padding: const EdgeInsets.only(bottom: 12.0)),
          ],
        ),
      ),
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

  Widget _showPopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Badge(
              showBadge: _isVisible && _isPartsRequired && !_isAgree && !_isTechnician,
              padding: EdgeInsets.all(3.5),
              elevation: 1.0,
              position: BadgePosition.topStart(top: -3.0),
              animationDuration: Duration(milliseconds: 300),
              animationType: BadgeAnimationType.fade,
              badgeColor: Colors.red,
              child: Text("View Cost"),
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Text("Problem Details"),
          ),
          PopupMenuItem(
            value: 3,
            child: Text("Order Details"),
          ),
        ],
        tooltip: 'More',
        padding: EdgeInsets.all(1.0),
        icon: Badge(
          showBadge: _isVisible && _isPartsRequired && !_isAgree && !_isTechnician,
          padding: EdgeInsets.all(3.5),
          elevation: 1.0,
          position: BadgePosition.topEnd(top: -3, end: -1),
          animationDuration: Duration(milliseconds: 300),
          animationType: BadgeAnimationType.fade,
          badgeColor: Colors.red,
          child: Icon(Icons.more_vert, size: 18.0),
        ),
        onSelected: (value) {
          switch (value) {
            case 1:
              _requiredPartsModalBottomSheet();
              break;
            case 2:
              _problemDetailsModalBottomSheet();
              break;
            case 3:
              _gotoOrderDetailsPage();
              break;
          }
        },
      );

  void _requiredPartsModalBottomSheet() => showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        builder: (BuildContext context) {
          RequiredParts _data = new RequiredParts();
          double _totalPrice = 0.0;

          Map _results = widget.order.addCost.toJson();
          for (var entry in _results.entries) {
            var price = entry.value;
            if (price != null && price > 0.0) {
              _costItems.forEach((parts) {
                if (entry.key == parts['id']) {
                  _data.addParts({"name": parts['name'], "price": "${price.toStringAsFixed(2)}"});
                  _totalPrice += price;
                }
              });
            }
          }

          return Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'All Cost:',
                  style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                      color: MyColor.textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                Divider(),
                _isPartsRequired
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: _data.parts.length,
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    RichText(
                                      text: TextSpan(
                                        text: '${index + 1}. ',
                                        style: FontUtil.black87W400S15,
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: _data.parts[index]['name']),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Text(_data.parts[index]['price'],
                                        style: FontUtil.black87W400S15),
                                  ]),
                                  Divider(),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Text('No parts required for this service.',
                        style: GoogleFonts.ubuntu(
                            textStyle: FontUtil.black87W400S16)),
                _isVisible && _isPartsRequired && !_isAgree && !_isTechnician
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                blurRadius: 2.0,
                                offset: Offset.zero,
                                color: Colors.grey.withOpacity(0.5))
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 2, 6, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  style: FontUtil.black87W600S18,
                                  children: <TextSpan>[
                                    TextSpan(text: "Total: "),
                                    TextSpan(text: ConstantValues.CURRENCY_SYMBOL + '$_totalPrice'),
                                  ],
                                ),
                              ),
                              OutlineButton(
                                child: Text("Disagree"),
                                textColor: MyColor.colorBlue,
                                borderSide: BorderSide(color: MyColor.colorBlue),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  widget.onDisagree();
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                              ),
                              RaisedButton(
                                child: Text("Agree"),
                                textColor: Colors.white,
                                color: MyColor.colorBlue,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  widget.onAgree(_totalPrice);
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
        },
      );

  void _problemDetailsModalBottomSheet() => showModalBottomSheet(
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
                widget.order.serviceDetailsDesc == null
                    ? 'No details available.'
                    : widget.order.serviceDetailsDesc,
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

  void _gotoOrderDetailsPage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Payment('Order Details', widget.order)));
  }
}

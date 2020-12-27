
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:thikthak/app/app.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/models/place_order.dart';
import 'package:thikthak/pages/service_module/checkout.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:thikthak/utils/utilities.dart';

class OrderBooking extends StatefulWidget {
  @override
  _OrderBookingState createState() => _OrderBookingState();
}

class _OrderBookingState extends State<OrderBooking> {
  /// Progress dialog
  ProgressDialog _progressDialog;

  int _scheduleBookingValue = 1;  // default urgent booking checked

  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  /*
   * Date picker dialog
   */
  Future<Null> _selectDate(BuildContext context,
      {DateTime selectedDate}) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? _date,
        firstDate: _date,
        lastDate: DateTime(_date.year + 1));
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  /*
   * Time picker dialog
   */
  Future<Null> _selectTime(BuildContext context, {TimeOfDay selectedTime}) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time);
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();  //"6:00 AM"
    return format.format(dt);
  }

  DateTime formatDateTime(TimeOfDay tod) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  }

  @override
  Widget build(BuildContext context) {
    // Init progress dialog
    _progressDialog = ProgressDialog(context, isDismissible: false, customBody: Center(child: CircularProgressIndicator()));
    _progressDialog.style(elevation: 0, backgroundColor: Colors.transparent);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Order',
          style: FontUtil.black87W600,
        ),
      ),
      body: Container(
        color: MyColor.colorGrey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Card(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTileTheme(
                      contentPadding: EdgeInsets.all(0),
                      child: RadioListTile(
                        value: 0,
                        groupValue: _scheduleBookingValue,
                        title: Text(
                          'Schedule',
                          style: FontUtil.w500S16,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _scheduleBookingValue = value;
                          });
                        },
                        dense: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: InkWell(
                                onTap: () => _selectDate(context),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Schedule Date',
                                        style: FontUtil.grey700W400S12,
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: FontUtil.black87W600S24,
                                        children: <TextSpan>[
                                          TextSpan(text: '${DateFormat("dd").format(_date)}'),
                                          TextSpan(
                                            text: ' ${DateFormat("MMM yyyy").format(_date)}'.toUpperCase(),
                                            style: FontUtil.black87W400S12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: VerticalDivider(color: Colors.black38),
                            ),
                            Flexible(
                              child: InkWell(
                                onTap: () => _selectTime(context),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Schedule Time',
                                        style: FontUtil.grey700W400S12,
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: FontUtil.black87W600S24,
                                        children: <TextSpan>[
                                          TextSpan(text: '${DateFormat("hh:mm").format(formatDateTime(_time))}'),
                                          TextSpan(
                                            text: ' ${DateFormat("a").format(formatDateTime(_time))}',
                                            style: FontUtil.black87W400S12,
                                          ),
                                        ],
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
                    SizedBox(height: 10.0),
                    ListTileTheme(
                      contentPadding: EdgeInsets.all(0),
                      child: RadioListTile(
                        value: 1,
                        groupValue: _scheduleBookingValue,
                        title: Text(
                          'Order Now',
                          style: FontUtil.w500S16,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _scheduleBookingValue = value;
                          });
                        },
                        dense: true,
                      ),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0)),
                        child:
                        Text("Place Order", style: FontUtil.whiteW500S13),
                        color: MyColor.colorBlue,
                        onPressed: () => _bookOrder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _bookOrder() {
    // format schedule date time
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String _scheduleDate = '${DateFormat("yyy-MM-dd").format(_date)}';
    String _scheduleTime = localizations.formatTimeOfDay(_time, alwaysUse24HourFormat: true);
    String _scheduleDateTime = Utilities.formatToServerDateTime('$_scheduleDate $_scheduleTime');

    // Get place order details
    PlaceOrder placeOrder = App.placeOrder;
    placeOrder.isScheduleOrder = _scheduleBookingValue == 0 ? true : false;
    placeOrder.scheduleDate = _scheduleDateTime;

    // Goto checkout page
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Checkout()));
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide Notification;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/models/notification.dart';
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/pages/dashboard.dart';
import 'package:thikthak/utils/notificationHelper.dart';
import 'package:thikthak/widget/notification_widget.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  /*
   * Request for notifications list
   */
  Future<List<Notification>> _getNotification() async {

    final userParam = {'user': '${ConstantValues.userId}'};

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    var uri = Uri.parse(Config.NOTIFICATION);
    uri = uri.replace(queryParameters: userParam);

    try {
      final response = await http.get(uri, headers: headers);
      Http.printResponse(response);

      if (response.statusCode > 204 || response.body == null) {
        return []; // something error
      } else {
        List<dynamic> data = jsonDecode(response.body);
        List<Notification> orders = data.map((dynamic item) => Notification.fromJson(item)).toList();
        return orders;
      }
    } on Exception catch (e, _) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();

    /// reset notification badge count
    notificationCounter = 0;

    /// Clear all pending notifications
    turnOffNotification(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
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
          future: _getNotification(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot.data);
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
                    'No available notification',
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
              List notifications = snapshot.data;
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  return NotificationWidget(notifications[index]);
                },
              );
            }
          },
        ),
      ),
    );
  }
}

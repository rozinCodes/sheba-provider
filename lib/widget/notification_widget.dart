import 'package:flutter/material.dart' hide Notification;
import 'package:thikthak/models/notification.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:thikthak/utils/utilities.dart';

class NotificationWidget extends StatelessWidget {
  final Notification notification;

  NotificationWidget(this.notification);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: notification.isPromotional
          ? Colors.amber
          : _getBackgroundColor(notification.status),
      child: Container(
        margin: EdgeInsets.only(left: 6.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(4.0),
              bottomRight: Radius.circular(4.0)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(notification.message, style: FontUtil.black87W400S14),
                    const Padding(padding: EdgeInsets.only(bottom: 6.0)),
                    Text(
                      Utilities.formatDateTime(notification.timestamp),
                      style: FontUtil.grey700W400S12,
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

  String _getStatus(int status) {
    if (status == 1) {
      return 'accepted';
    } else if (status == 2) {
      return 'completed';
    } else if (status == 3) {
      return 'rejected';
    } else {
      return 'pending';
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
}

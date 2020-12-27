import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/subjects.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/geoservices/location_service.dart';
import 'package:thikthak/tab_fragment/account.dart';
import 'package:thikthak/tab_fragment/more.dart';
import 'package:thikthak/tab_fragment/order.dart';
import 'package:thikthak/tab_fragment/technician_home.dart';
import 'package:thikthak/tab_fragment/user_home.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:thikthak/utils/notificationHelper.dart';
import 'package:thikthak/utils/util.dart';
import 'package:url_launcher/url_launcher.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;

int notificationCounter = 0;
final BehaviorSubject<int> notificationSubject = BehaviorSubject<int>();

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    debugPrint('myBackgroundMessageHandler() : data');
    debugPrint(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    debugPrint('myBackgroundMessageHandler() : notification');
    debugPrint(notification);
  }
  // Or do other work.
}

enum _TabItem { home, order, support, more }

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool _isTechnician = false;
  DateTime currentBackPressTime;
  _TabItem _currentItem = _TabItem.home;

  final List<_TabItem> _bottomTabs = [
    _TabItem.home,
    _TabItem.order,
    _TabItem.support,
    _TabItem.more,
  ];

  Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(milliseconds: 1500)) {
      currentBackPressTime = now;
      Util.showToast('Press back again to exit');
      return Future.value(false);
    }
    return Future.value(true);
  }

  void _fcmSubscribe() {
    _firebaseMessaging.subscribeToTopic('global');
    _firebaseMessaging.subscribeToTopic(_isTechnician ? 'technician' : 'user');
    _firebaseMessaging.subscribeToTopic(Platform.isAndroid ? 'android' : Platform.isIOS ? 'ios' : 'others');
  }

  @override
  void initState() {
    super.initState();

    /// Retrieve user info from Shared pref
    _getUserInfo();

    /// initialize local notification
    _initNotification();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        debugPrint("onMessage: $message");
        dynamic data = message['notification'] ?? message;

        /// add callback listener
        notificationCounter++;
        notificationSubject.add(notificationCounter);

        /// Show local notification when app in foreground
        showNotification(flutterLocalNotificationsPlugin, data['title'], data['body']);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      debugPrint("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      debugPrint("fcm token: $token");
    });

    /// subscribe to fcm topic
    _fcmSubscribe();

    /// update user location periodically
    LocationService().initService();
  }

  Future<void> _getUserInfo() async {
    _isTechnician = ConstantValues.userType != 'user';
    debugPrint('user_id: ' + '${ConstantValues.userId}');
    debugPrint('user_name: ' + ConstantValues.userName);
    debugPrint('user_type: ' + ConstantValues.userType);
  }

  Future<void> _initNotification() async {
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    await initNotifications(flutterLocalNotificationsPlugin);
    requestIOSPermissions(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: _buildBody(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _isTechnician
          ? null
          : FloatingActionButton(
              heroTag: "explore",
              backgroundColor: Colors.white,
              elevation: 3.0,
              child: Center(
                child: SvgPicture.asset('assets/icons/shopping_cart.svg'),
              ),
              onPressed: () {
                // goto sales part
                /*Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => SalesMainPage()));*/
                Util.showToast('This features is coming soon :)');
              },
            ),
      bottomNavigationBar: _buildBottomTab(),
    );
  }

  Widget _buildBody() {
    switch (_currentItem) {
      case _TabItem.order:
        return OrderFragment();
      case _TabItem.support:
        return AccountFragment();
      case _TabItem.more:
        return MoreFragment();
      case _TabItem.home:
      default:
        return _isTechnician ? HomeFragmentTechnician() : HomeFragmentUser();
    }
  }

  _buildBottomTab() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildTabItem(
            index: 0,
            tabItem: _TabItem.home,
          ),
          _buildTabItem(
            index: 1,
            tabItem: _TabItem.order,
          ),
          if (!_isTechnician) SizedBox(width: 42.0),
          _buildTabItem(
            index: 2,
            tabItem: _TabItem.support,
          ),
          _buildTabItem(
            index: 3,
            tabItem: _TabItem.more,
          ),
        ],
      ),
    );
  }

  _buildTabItem({int index, _TabItem tabItem}) {
    final String text = _title(tabItem);
    final IconData icon = _icon(tabItem);
    final Color color =
        _currentItem == tabItem ? MyColor.colorBlue : Colors.grey;

    return InkWell(
      onTap: () {
        _onSelectTab(index);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: color,
            ),
            Text(
              text,
              style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
                  color: color,
                ),
                fontWeight: _currentItem == tabItem
                    ? FontWeight.w600
                    : FontWeight.normal,
                fontSize: 10,
              ),
            )
          ],
        ),
      ),
    );
  }

  _onSelectTab(int index) {
    _TabItem selectedTabItem = _bottomTabs[index];
    setState(() {
      if (index != 2)
        _currentItem = selectedTabItem;
      else {
        _showEmergencyContactModal();
      }
    });
  }

  String _title(_TabItem item) {
    switch (item) {
      case _TabItem.home:
        return 'HOME';
      case _TabItem.order:
        return 'ORDER';
      case _TabItem.support:
        return 'SUPPORT';
      case _TabItem.more:
        return 'MORE';
      default:
        throw 'Unknown: $item';
    }
  }

  IconData _icon(_TabItem item) {
    switch (item) {
      case _TabItem.home:
        return Icons.home;
      case _TabItem.order:
        return Icons.list;
      case _TabItem.support:
        return Icons.phone;
      case _TabItem.more:
        return Icons.more_vert;
      default:
        throw 'Unknown: $item';
    }
  }

  /*
   * Open emergency call modal when tap on support tab
   */
  _showEmergencyContactModal() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
            title: Text(
              'Emergency Contact',
              style: FontUtil.black87W600S18,
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'For any query call: ${ConstantValues.HELP_CENTER}',
                    style: FontUtil.black87W400S14,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Container(
                              child: OutlineButton(
                                child: Text("Cancel"),
                                textColor: MyColor.colorBlue,
                                borderSide: BorderSide(color: MyColor.colorBlue),
                                onPressed: () {
                                  setState(() => Navigator.of(context).pop());
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Container(
                              child: RaisedButton(
                                child: Text("Call"),
                                textColor: Colors.white,
                                color: MyColor.colorBlue,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Make phone call via UrlLauncher
                                  launch("tel:${ConstantValues.HELP_CENTER}");
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ),
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

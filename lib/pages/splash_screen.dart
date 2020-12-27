import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:thikthak/app/app.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/models/service_item.dart';
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/pages/dashboard.dart';
import 'package:thikthak/pages/phone_input.dart';
import 'package:thikthak/shared/pref_manager.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:thikthak/utils/util.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// Shared preference
  PrefsManager _prefs = PrefsManager();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Make post request with JSON Raw data
  /// https://stackoverflow.com/a/55000232/5280371
  /// https://stackoverflow.com/a/50063163/5280371
  void _generateAccessToken()  {
    debugPrint('generating token...');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    Map data = {'username': 'system', 'password': 'system'};
    //encode Map to JSON
    var body = jsonEncode(data);

    try {
      http.post(Config.GENERATE_ACCESS_TOKEN, headers: headers, body: body)
          .timeout(Duration(seconds: 15), onTimeout: () {
        //Util.showColorToast('Request Timeout', Colors.red);
        debugPrint('Request Timeout');
        return;
      }).then((response) {
        Http.printResponse(response);
        if (response == null || response.body == null || response.statusCode > 204) {
          _displaySnackBar('Something went wrong. Please try again.');
          return;
        }

        var jsonData = json.decode(response.body);
        //ConstantValues.accessToken = jsonData['access_token'];

        // request for service item list
        _getServiceItems();
      });
    } on Exception catch (exception) {
      print('exception $exception');  // only executed if error is of type Exception
    } catch (error) {
      print('error $error');  // executed for errors of all types other than Exception
    }
  }

  void _getServiceItems() async {
    final queryParameters = {'max': '1000'};

    var uri = Uri.parse(Config.SERVICE_ITEMS);
    uri = uri.replace(queryParameters: queryParameters);

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    try {
      final response = await http.get(uri, headers: headers);
      Http.printResponse(response);

      if (response.statusCode > 204 || response.body == null) {
        Util.showErrorToast();
        return;
      }

      // Add to to list
      List<dynamic> data = jsonDecode(response.body);
      App.serviceItem = data.map((dynamic item) => ServiceItem.fromJson(item)).toList();
      /*
       * If all are successful
       * then check for login session
       */
      _checkLoginStatus();

    } on Exception catch (e, _) {
      Util.showErrorToast();
    }
  }

  void _displaySnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message, style: FontUtil.whiteW400S13),
      duration: Duration(days: 1),
      action: SnackBarAction(
        label: 'Retry',
        textColor: Colors.blue,
        onPressed: () {
          _scaffoldKey.currentState.hideCurrentSnackBar();
          _generateAccessToken();
        },
      ),
    );
    try {
    _scaffoldKey.currentState.showSnackBar(snackBar);
    } on Exception catch (e, s) {
      print(s);
    }
  }

  @override
  void initState() {
    super.initState();
    // Check network connection
    _checkNetworkConnection();
  }

  void _checkNetworkConnection() {
    (Connectivity().checkConnectivity()).then((connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        _showNetworkErrorDialog(context);
      } else {
        _generateAccessToken(); // Generate Token
      }
    });
  }

  void _showNetworkErrorDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Internet connection unavailable',
              style: FontUtil.black87W600S18),
          content: SingleChildScrollView(
            child: Text(
              'We are having trouble to connect with the internet. Check your internet connection and try again.',
              style: FontUtil.black87W400S14,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Refresh', style: FontUtil.themeColorW500S15),
              onPressed: () {
                Navigator.of(context).pop();
                _checkNetworkConnection(); // retry
              },
            ),
          ],
          contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        );
      },
    );
  }

  void _checkLoginStatus() {
    bool isLogin = _prefs.isUserLoggedIn();
    ConstantValues.isUserLogin = isLogin;
    //ConstantValues.isApproved = _prefs.getIsApproved();
    //ConstantValues.accountLocked = _prefs.getAccountLocked();
    //ConstantValues.enabled = _prefs.getEnabled();

    //await Future.delayed(const Duration(milliseconds: 300));

    if (isLogin) {
      // retrieve values from prefs
      ConstantValues.userId = _prefs.getUserId();
      ConstantValues.userName = _prefs.getUserName();
      ConstantValues.userType = _prefs.getUserType();
      ConstantValues.imageName = _prefs.getProfileImage();

      /// redirect to dashboard
      _navigateToHome();
    } else {
      /// redirect to login
      _navigateToLogin();
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => PhoneInput()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/images/splash_logo.png', scale: 2.5),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                    ),
                    RichText(
                      softWrap: true,
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'from',
                                  style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
                                  ),
                                ),
                                Text(
                                  'Walton',
                                  style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(color: Colors.grey, fontSize: 18.0, letterSpacing: 2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

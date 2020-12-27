import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/customs/pin_entry.dart';
import 'package:thikthak/customs/widgets.dart';
import 'package:thikthak/models/users.dart';
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/pages/dashboard.dart';
import 'package:thikthak/pages/profile.dart';
import 'package:thikthak/shared/pref_manager.dart';
import 'package:thikthak/utils/util.dart';

class PhoneVerify extends StatefulWidget {
  final String mobileNumber;

  PhoneVerify({Key key, @required this.mobileNumber})
      : assert(mobileNumber != null),
        super(key: key);

  @override
  _PhoneVerifyState createState() => _PhoneVerifyState();
}

class _PhoneVerifyState extends State<PhoneVerify> {
  /// Firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _deviceToken;
  String _verificationId;

  /// Control the input text field.
  final TextEditingController _pinEditingController = TextEditingController();

  /// Decorate the outside of the Pin.
  final PinDecoration _pinDecoration = UnderlineDecoration(enteredColor: Colors.black); // hintText: 'XXXXXX'

  /// Progress dialog
  ProgressDialog _progressDialog;

  /// Session manager class
  PrefsManager _prefs = PrefsManager();
  int _userChooserValue = 0;

  @override
  void initState() {
    super.initState();

    /// generate fcm token
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      debugPrint("Push Messaging token: $token");
      _deviceToken = token;
    });

    /// Verify OTP
    _onVerifyCode();
  }

  /// Send Authorization Header & Query Params
  /// https://stackoverflow.com/a/59503333/5280371
  /// https://stackoverflow.com/a/52148847/5280371
  void _getUserData() async {
    // Show progress dialog
    await _progressDialog.show();

    final queryParameters = {
      'property': 'username',
      'value': '${'0' + widget.mobileNumber}', // add zero (0) prefix
      'qf': '1'
    };
    var uri = Uri.parse(Config.GET_USER_DATA);
    uri = uri.replace(queryParameters: queryParameters);
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    try {
      final response = await http.get(uri, headers: headers);
      // Hide progress dialog
      await _progressDialog.hide();

      Http.printResponse(response);
      if (response.statusCode > 204 || response.body == null) {
        Util.showErrorToast();
        return;
      }

      //Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> jsonData = json.decode(response.body);

      if (jsonData.length > 0) {
        var user = Users.fromJson(jsonData[0]);
        // Save user info in shared pref
        _saveUserInfoToSharedPref(user);
        // update device token & redirect to dashboard
        _updateTokenAndGotoDashboard(user);
      } else {
        // Show dialog if data is empty
        _displayRegistrationDialog();
      }
    } on Exception catch (e, _) {
      await _progressDialog.hide();
      Util.showErrorToast();
    }
  }

  /*
   *  Register for new user
   */
  void _registerNewUser() async {
    // Show progress dialog
    await _progressDialog.show();

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    String mobileNumber = '0' + widget.mobileNumber;
    Map data = {
      'username': mobileNumber,
      'password': mobileNumber,
      'phoneNumber': mobileNumber,
      'userType': _userChooserValue == 0 ? 'User' : 'Technician',
      'displayName': mobileNumber,
      'deviceType': Platform.isAndroid ? 'android' : Platform.isIOS ? 'ios' : 'others',
      'deviceToken': _deviceToken,
    };
    //encode Map to JSON
    var body = json.encode(data);

    try {
      final response = await http.post(Config.REGISTER_USER, headers: headers, body: body);
      // Hide progress dialog
      await _progressDialog.hide();

      Http.printResponse(response);
      if (response.statusCode > 204 || response.body == null) {
        Util.showErrorToast();
        return;
      }

      Map userMap = jsonDecode(response.body);
      var user = Users.fromJson(userMap);
      // Save user info in shared pref
      _saveUserInfoToSharedPref(user);

      if (user.userType.toLowerCase() == 'user') {
        // Redirect to dashboard
        _gotoDashboard();
      } else {
        // Redirect to profile setup page for technician
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Profile(editable: true, goHome: true)));
      }
    } on Exception catch (e, _) {
      await _progressDialog.hide();
      Util.showErrorToast();
    }
  }

  Future<void> _saveUserInfoToSharedPref(Users user) async {
    // Save user info in shared pref
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(user));

    // save values
    _prefs.setUserId(user.id);
    _prefs.setUserName(user.username);
    _prefs.setUserType(user.userType.toLowerCase());
    _prefs.setProfileImage(user.imageName);
    _prefs.setIsApproved(user.isApproved);
    _prefs.setAccountLocked(user.accountLocked);
    _prefs.setEnabled(user.enabled);

    // assign values
    ConstantValues.userId = user.id;
    ConstantValues.userName = user.username;
    ConstantValues.userType = user.userType.toLowerCase();
    ConstantValues.imageName = user.imageName;
    ConstantValues.isApproved = user.isApproved;
    ConstantValues.accountLocked = user.accountLocked;
    ConstantValues.enabled = user.enabled;
  }

  /*
   * Update device token
   */
  void _updateTokenAndGotoDashboard(Users user) async {
    print('Updating token...');
    // Show progress dialog
    await _progressDialog.show();

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    String userName = ConstantValues.userName;
    Map<String, dynamic> data = new Map();
    data['username'] = userName;
    data['password'] = userName;
    data['deviceType'] =  Platform.isAndroid ? 'android' : Platform.isIOS ? 'ios' : 'others';
    data['deviceToken'] =  _deviceToken;

    // encode Map to JSON
    var body = json.encode(data);

    var url = Uri.encodeFull(Config.UPDATE_USER_INFO + '${ConstantValues.userId}');

    try {
      final response = await http.put(url, headers: headers, body: body);
      // Hide progress dialog
      await _progressDialog.hide();

      Http.printResponse(response);
      if (response.statusCode > 204 || response.body == null) {
        Util.showErrorToast();
        return;
      }

      // Check technician profile is complete or not!
      if (user.userType.toLowerCase() != 'user' && user.expertiseArea == null) {
        // Redirect to profile setup page for technician
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Profile(editable: true, goHome: true)));
      } else {
        // Redirect to dashboard
        _gotoDashboard();
      }
    } on Exception catch (e, _) {
      await _progressDialog.hide();
      Util.showErrorToast();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Init progress dialog
    _progressDialog = ProgressDialog(context, isDismissible: false, customBody: Center(child: CircularProgressIndicator()));
    _progressDialog.style(elevation: 0, backgroundColor: Colors.transparent);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          color: Colors.black87,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            PreferredSize(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //  Subtitle for Enter your phone
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 16.0, right: 16.0),
                          child: Widgets.subTitle("Enter the code send to " +
                              ConstantValues.COUNTRY_CODE +
                              "${widget.mobileNumber}"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(100),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PinInputTextField(
                pinLength: 6,
                autoFocus: true,
                decoration: _pinDecoration,
                controller: _pinEditingController,
                textInputAction: TextInputAction.done,
                onSubmit: (pin) async {
                  if (pin.length == 6) {
                    _onFormSubmitted();
                  } else {
                    Util.showColorToast("Invalid OTP", Colors.red);
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    color: MyColor.colorBlue,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    child: Text(
                      "Verify Code",
                      style: GoogleFonts.ubuntu(
                        textStyle: TextStyle(color: Colors.white),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () async {
                      if (_pinEditingController.text.length == 6) {
                        _onFormSubmitted();
                      } else {
                        Util.showColorToast("Invalid OTP", Colors.red);
                      }
                    },
                    padding: EdgeInsets.all(14.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Example code of how to verify phone number
  void _onVerifyCode() async {
    debugPrint("_onVerifyCode()");

    PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential phoneAuthCredential) async {
      await _firebaseAuth.signInWithCredential(phoneAuthCredential);
      onAuthenticationSuccessful();
    };

    PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException) {
      print(authException);
      Util.showColorToast("Error validating OTP, try again", Colors.red);
    };

    PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
      Util.showToast('Please check your phone for the verification code.');
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: ConstantValues.COUNTRY_CODE + "${widget.mobileNumber}",
          timeout: const Duration(seconds: 30),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      Util.showColorToast("Try again in sometime", Colors.red);
    }
  }

  // Example code of how to sign in with phone.
  void _onFormSubmitted() async {
    print("_onFormSubmitted()");
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _pinEditingController.text,
      );
      final User user = (await _firebaseAuth.signInWithCredential(credential)).user;
      debugPrint(user.phoneNumber);
      onAuthenticationSuccessful();
    } catch (e) {
      print(e);
      Util.showColorToast("Error validating OTP, Try again", Colors.red);
    }
  }

  void onAuthenticationSuccessful() async {
    // When auth successful then request for user data
    _getUserData();
  }

  _displayRegistrationDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            // Prevent close dialog on backPressed
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6.0))),
              title: Text(
                'Register as?',
                style: GoogleFonts.ubuntu(
                  fontSize: 18.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio<int>(
                        value: 0,
                        groupValue: _userChooserValue,
                        onChanged: (value) {
                          setState(() => _userChooserValue = value);
                        },
                      ),
                      Text(
                        'User',
                        style: GoogleFonts.ubuntu(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Radio<int>(
                        value: 1,
                        groupValue: _userChooserValue,
                        onChanged: (value) {
                          setState(() => _userChooserValue = value);
                        },
                      ),
                      Text(
                        'Technician',
                        style: GoogleFonts.ubuntu(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  );
                },
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Continue',
                    style: GoogleFonts.ubuntu(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Request to server
                    _registerNewUser();
                  },
                ),
              ],
            ),
          );
        });
  }

  _gotoDashboard() {
    // Save login session
    _prefs.setUserLoggedIn(true);
    ConstantValues.isUserLogin = true;

    // Redirect to Home Screen
    /*Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Dashboard()),
        (Route<dynamic> route) => false);*/

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) => Dashboard()),
        ModalRoute.withName('/'));
  }
}

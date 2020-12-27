import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thikthak/app/config.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/customs/flutter_rating_bar.dart';
import 'package:thikthak/models/users.dart';
import 'package:thikthak/network/auth.dart';
import 'package:thikthak/network/http_response.dart';
import 'package:thikthak/pages/discount.dart';
import 'package:thikthak/pages/phone_input.dart';
import 'package:thikthak/pages/profile.dart';
import 'package:thikthak/pages/promotion.dart';
import 'package:thikthak/pages/service_module/due_payment.dart';
import 'package:thikthak/pages/service_module/favourite_list.dart';
import 'package:thikthak/pages/web_loader.dart';
import 'package:thikthak/shared/pref_manager.dart';
import 'package:thikthak/utils/font_util.dart';
import 'package:http/http.dart' as http;
import 'package:thikthak/utils/util.dart';
import 'package:thikthak/utils/utilities.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class MoreFragment extends StatefulWidget {
  @override
  _MoreFragmentState createState() => _MoreFragmentState();
}

class _MoreFragmentState extends State<MoreFragment> {

  /// Session manager class
  PrefsManager _prefs = PrefsManager();

  /// Progress dialog
  ProgressDialog _progressDialog;

  /// Firebase auth
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isTechnician = false;

  /// username & phone number
  String _name = '';
  String _phone = '';
  String _imageName;
  double _rating;
  bool _showRatingWidget = false;
  bool _isDueAmount = false;

  /// Define textStyle for all
  final TextStyle _textStyle = GoogleFonts.ubuntu(
    textStyle: const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.w400,
      fontSize: 17,
    ),
  );

  // Application info
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();

    _getUserInfoFromShared();
    _initPackageInformation();
    _isTechnician = ConstantValues.userType != 'user';

    // get technician rating
    getRating();
  }

  void _initPackageInformation() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  /*
   * Retrieve user info from shared
   */
  void _getUserInfoFromShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map userMap = jsonDecode(prefs.getString('userData'));
    final user = Users.fromJson(userMap);
    setState(() {
      _name = user.displayName;
      _phone = user.phoneNumber;
      _imageName = user.imageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Init progress dialog
    _progressDialog = ProgressDialog(context, isDismissible: false, customBody: Center(child: CircularProgressIndicator()));
    _progressDialog.style(elevation: 0, backgroundColor: Colors.transparent);

    return Material(
      color: MyColor.colorGrey,
      child: ListView(
        children: <Widget>[
          InkWell(
            onTap: () {
              // Goto profile page
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile()));
            },
            child: Ink(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: SizedBox(
                  height: 65.0,
                  child: Row(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey[300]),
                            image: DecorationImage(
                              image: _imageName == null
                                  ? ExactAssetImage('assets/images/avatar.png')
                                  : NetworkImage(Config.PROFILE_IMAGE_URL + _imageName),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '$_name',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.ubuntu(
                                  textStyle: const TextStyle(
                                    color: MyColor.textColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: _isTechnician ? 3 : 6)),
                              Text(
                                '$_phone',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.ubuntu(
                                  textStyle: const TextStyle(
                                    color: MyColor.textColor,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              _isTechnician && _showRatingWidget ?
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child: RatingBarIndicator(
                                        rating: _rating != null ? _rating / ConstantValues.RATING_CONV : 0,
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
                                      _rating != null ? '(${_rating.toStringAsFixed(2)})' : '(0.0)',
                                      style: FontUtil.black87W400S12,
                                    ),
                                  ],
                                ) : Container(),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Card(
                          shape: CircleBorder(),
                          color: Colors.black.withAlpha(15),
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Icon(Icons.keyboard_arrow_right,
                                color: Colors.black87),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _isTechnician,
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(bottom: 6.0)),
                // Due Payment
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Payment'.toUpperCase(),
                          style: GoogleFonts.ubuntu(
                            textStyle: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 14.0)),
                        InkWell(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.payment_rounded, color: Colors.black54, size: 22.0),
                              SizedBox(width: 10),
                              Badge(
                                showBadge: _isDueAmount,
                                padding: EdgeInsets.all(3.5),
                                elevation: 1.0,
                                position: BadgePosition.topEnd(top: 1.0),
                                animationDuration: Duration(milliseconds: 300),
                                animationType: BadgeAnimationType.fade,
                                badgeColor: Colors.red,
                                child: Text('Due Payment', style: _textStyle),
                              ),
                            ],
                          ),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => DuePayment())),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !_isTechnician,
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(bottom: 6.0)),
                // Offers
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Favourite'.toUpperCase(),
                          style: GoogleFonts.ubuntu(
                            textStyle: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 14.0)),
                        InkWell(
                          child: generateRow('My Favourite', Icons.favorite),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => FavouriteList())),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 6.0)),
                // Offers
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Offers'.toUpperCase(),
                          style: GoogleFonts.ubuntu(
                            textStyle: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 14.0)),
                        InkWell(
                          child: generateRow('Promotions', Icons.local_offer),
                          onTap: () {
                            // Goto offer page
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => OfferAndPromo()));
                          },
                        ),
                        const Divider(),
                        InkWell(
                          child: generateRow('Get Discounts', Icons.confirmation_number),
                          onTap: () {
                            // Goto discount page
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => GetDiscount()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 6.0)),
          // Help & Legal
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Help & Legal'.toUpperCase(),
                    style: GoogleFonts.ubuntu(
                      textStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 14.0)),
                  InkWell(
                    child: generateRow('Help', Icons.help),
                    onTap: () {
                      // Goto policies page
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => WebLoader(title: 'Help',
                          url: 'https://support.google.com/?hl=en')));
                    },
                  ),
                  const Divider(),
                  InkWell(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.assignment, color: Colors.black54, size: 22.0),
                        SizedBox(width: 10),
                        Text('Policies', style: _textStyle),
                      ],
                    ),
                    onTap: () {
                      // Goto policies page
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => WebLoader(title: 'Policies',
                          url: 'https://terms.alicdn.com/legal-agreement/terms/suit_bu1_uc/suit_bu1_uc201906261439_98147.html')));
                    },
                  ),
                ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 6.0)),
          // Help & Legal
          Container(
            color: Colors.white,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Others'.toUpperCase(),
                    style: GoogleFonts.ubuntu(
                      textStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 14.0)),
                  InkWell(
                    child: generateRow('Join Us', Typicons.social_facebook, iconSize: 24, space: 6),
                    onTap: () => Utilities.openURL('https://www.facebook.com/waltoncomputer/'),
                  ),
                  const Divider(),
                  InkWell(
                    child: generateRow('Rate App', Icons.star),
                    onTap: () => Utilities.rateApp(context),
                  ),
                ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 6.0)),
          // Logout
          InkWell(
            child: Ink(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: generateRow('Log Out', Icons.exit_to_app),
              ),
            ),
            onTap: () => _showLogOutModal(),
          ),

          // App Version
          Container(
            color: MyColor.colorGrey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Text(
                    'Version ' + _packageInfo.version,
                    style: GoogleFonts.ubuntu(
                      textStyle: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 17.0),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Padding(padding: EdgeInsets.only(bottom: 50.0)),
        ],
      ),
    );
  }

  _showLogOutModal() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0))),
            title: Text(
              'Logout',
              style: FontUtil.black87W600S18,
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Are you sure to logout?',
                    style: FontUtil.black87W400S14
                    ,
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
                              child: Text("Logout"),
                              textColor: Colors.white,
                              color: MyColor.colorBlue,
                              onPressed: () {
                                Navigator.of(context).pop();
                                _logOutUser();
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            )),
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

  Widget generateRow(String text, IconData icon,
      {double iconSize = 22, double space = 10}) {
    return Row(
      children: [
        Icon(icon, size: iconSize, color: Colors.black54),
        SizedBox(width: space),
        Text(text, style: _textStyle),
      ],
    );
  }

  _logOutUser() async {
    // Show progress dialog
    await _progressDialog.show();

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };

    final queryParameters = {'userId': '${ConstantValues.userId}'};

    var uri = Uri.parse(Config.LOGOUT_USER);
    uri = uri.replace(queryParameters: queryParameters);

    try {
      final response = await http.post(uri, headers: headers);
      // Hide progress dialog
      await _progressDialog.hide();

      Http.printResponse(response);
      var json = jsonDecode(response.body);
      if (response.statusCode > 204 || response.body == null) {
        Util.showErrorToast();
        return;
      }
      // show success message
      Util.showColorToast(json['message'], Colors.green);

      // Clear login session
      _prefs.setUserLoggedIn(false);
      ConstantValues.isUserLogin = false;
      // Sign out from firebase
      _firebaseAuth.signOut();

      // Redirect to Home Screen
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => PhoneInput()),
          (Route<dynamic> route) => false);

    } on Exception catch (e, _) {
      await _progressDialog.hide();
      Util.showErrorToast();
    }
  }

  /*
  * Request for new order list
  */
  getRating() async {

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: await auth.token,
    };
    String url = Config.GET_TECHNICIAN_RATING + '/${ConstantValues.userId}';

    try {
      http.get(url, headers: headers).timeout(Duration(seconds: 30)).then((response) {
        print(response.body);
        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          // do this inside the setState() so Flutter gets notified
          // that a widget update is due
          if (!mounted) return;
          setState(() {
            _rating = jsonData['rating'] as double;
            _isDueAmount = jsonData['isDueAmount'] as bool;
            _showRatingWidget = true;
          });
        }
      });
    } on Exception catch (e, s) {
      print(s);
    }
  }
}

import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:url_launcher/url_launcher.dart';

import 'font_util.dart';

class Utilities {
  /// contains the colours
  static final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.pink,
    Colors.teal,
    Colors.grey,
    Colors.deepOrange,
    Colors.deepPurpleAccent
  ];

  static Color getRandomColor() {
    return colors[new Random().nextInt(colors.length)];
  }

  /// https://stackoverflow.com/a/57609840/5280371
  static Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
      BuildContext context, String assetName,
      {double scale}) async {
    // Scale ratio of icon
    double scaleRatio = scale ?? 1;
    // Read SVG file as String
    String svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    // Create DrawableRoot from SVG String
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, null);

    // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width = 32 *
        devicePixelRatio *
        scaleRatio; // where 32 is your SVG's original width
    double height = 32 * devicePixelRatio * scaleRatio; // same thing

    // Convert to ui.Picture
    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));

    // Convert to ui.Image. toImage() takes width and height as parameters
    // you need to find the best size to suit your needs and take into account the
    // screen DPI
    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  }

  static String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else
      return null;
  }

  static bool isValidateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return false;
    }
    return regExp.hasMatch(value);
  }

  static String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  static String getCurrentDateTime() {
    try {
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
          .format(DateTime.now().toLocal());
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  static String formatToServerDateTime(String formattedString) {
    try {
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
          .format(DateTime.parse(formattedString).toLocal());
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  static String formatDateTime(String formattedString) {
    try {
      return DateFormat("dd MMM, yyyy 'at' hh:mm a")
          .format(DateTime.parse(formattedString).toLocal());
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  static String formatDate(String formattedString) {
    try {
      return DateFormat("dd MMM, yyyy")
          .format(DateTime.parse(formattedString).toLocal());
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  static String getLocalFile(String filename) {
    getApplicationDocumentsDirectory().then((directory) {
      assert(directory != null);
      String dir = directory.path;
      File f = new File('$dir/$filename');
      return f.toString();
    });
    //String dir = (await getApplicationDocumentsDirectory()).path;
    //File f = new File('$dir/$filename');
    return null;
  }

  static openURL(String url) async {
    if (await canLaunch(url)) await launch(url);
    else throw 'Could not launch $url';
  }

  static rateApp(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rate App', style: FontUtil.black87W600S18),
          content: SingleChildScrollView(
            child: Text(
                'If you enjoy using this app. It would be great to take a moment to rate it.',
                style: FontUtil.black87W400S14,
            ),
          ),
          actions: <Widget>[
            OutlineButton(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Text('Not Now', style: FontUtil.themeColorW500S15),
              borderSide: BorderSide(color: MyColor.colorBlue),
              onPressed: () {
                Navigator.of(context).pop();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            FlatButton(
              color: MyColor.colorBlue,
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Rate It!', style: FontUtil.whiteW500S15),
              onPressed: () async {
                Navigator.of(context).pop();
                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                Platform.isIOS
                    ? Utilities.openURL('https://apps.apple.com/us/app/id<App Id>') // TODO replace with your iOSAppId
                    : Utilities.openURL('https://play.google.com/store/apps/details?id=' + packageInfo.packageName);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        );
      },
    );
  }

  static showApprovalDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rate App', style: FontUtil.black87W600S18),
          content: SingleChildScrollView(
            child: Text(
              "Your account isn't approved yet. Soon a contact person will contact with you.\n"
              "For more information call: ${ConstantValues.HELP_CENTER}",
              style: FontUtil.black87W400S14,
            ),
          ),
          actions: <Widget>[
            OutlineButton(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Text('Ok, Got it', style: FontUtil.themeColorW500S15),
              borderSide: BorderSide(color: MyColor.colorBlue),
              onPressed: () {
                Navigator.of(context).pop();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            FlatButton(
              color: MyColor.colorBlue,
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Call Now', style: FontUtil.whiteW500S15),
              onPressed: () {
                Navigator.of(context).pop();
                // Make phone call via UrlLauncher
                launch("tel:${ConstantValues.HELP_CENTER}");
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        );
      },
    );
  }
}

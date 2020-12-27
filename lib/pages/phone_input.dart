import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thikthak/constant/colors.dart';
import 'package:thikthak/constant/constant.dart';
import 'package:thikthak/customs/widgets.dart';
import 'package:thikthak/pages/phone_verify.dart';
import 'package:thikthak/utils/util.dart';

class PhoneInput extends StatefulWidget {
  @override
  _PhoneInputState createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  /*
   *  _phoneNumberController - This will be used as a controller for listening to the changes what the user is entering
   *  and it's listener will take care of the rest
   */
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /*  Scaffold: Using a Scaffold widget as parent
     *  SafeArea: As a precaution - wrapping all child descendants in SafeArea, so that even notched phones won't loose data
     *  Center: As we are just having Card widget - making it to stay in Center would really look good
     *  SingleChildScrollView: There can be chances arising where
     */

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
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: _getColumnBody(),
      ),
    );
  }

  Widget _getColumnBody() => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //  Subtitle for Enter your phone
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
            child: Widgets.subTitle('Enter your mobile number'),
          ),
          //  PhoneNumber TextFormFields
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 0.0,
                  child: TextFormField(
                    autofocus: true,
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    key: Key('EnterPhone-TextFormField'),
                    inputFormatters: [
                      new LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorMaxLines: 1,
                      prefix: Container(
                        transform: Matrix4.translationValues(-5.0, 0.0, 0.0),
                        child: Text(ConstantValues.COUNTRY_CODE),
                      ),
                      icon:
                          Image.asset('assets/images/bd_flag.png', scale: 2.5),
                    ),
                    onFieldSubmitted: (phone) {
                      if (phone.length == 10) {
                        _startPhoneAuth();
                      } else {
                        Util.showColorToast(
                            'Phone number not valid', Colors.red);
                      }
                    },
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(0.0, -12.0, 0.0),
                  child: Divider(
                      color: Colors.grey,
                      height: 0,
                      thickness: 1.2,
                      indent: 50),
                ),
              ],
            ),
          ),

          /*
           *  Some informative text
           */
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: 16.0),
              Icon(Icons.info, color: Colors.black54, size: 20.0),
              SizedBox(width: 10.0),
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'We will send ',
                      style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w400))),
                  TextSpan(
                      text: 'One Time Password',
                      style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700))),
                  TextSpan(
                      text: ' to this mobile number',
                      style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w400))),
                ])),
              ),
            ],
          ),

          /*
           *  Button: OnTap of this, it appends the dial code and the phone number entered by the user to send OTP,
           *  knowing once the OTP has been sent to the user - the user will be navigated to a new Screen,
           *  where is asked to enter the OTP he has received on his mobile (or) wait for the system to automatically detect the OTP
           */
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
                    "Send Code",
                    style: GoogleFonts.ubuntu(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onPressed: () {
                    _startPhoneAuth();
                  },
                  padding: EdgeInsets.all(14.0),
                ),
              ),
            ),
          ),
        ],
      );

  _startPhoneAuth() {
    if (_phoneNumberController.text.length == 10) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              PhoneVerify(mobileNumber: _phoneNumberController.text)));
    } else {
      Util.showColorToast('Phone number not valid', Colors.red);
    }
  }
}

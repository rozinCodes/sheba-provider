import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data_models/countries.dart';

class Widgets {
  static Widget getLogo({String logoPath, double height}) => Material(
        type: MaterialType.transparency,
        elevation: 10.0,
        child: Image.asset(logoPath, height: height),
      );

  static Widget searchCountry(TextEditingController controller) => Padding(
        padding:
            const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 2.0, right: 8.0),
        child: Card(
          child: TextFormField(
            autofocus: true,
            controller: controller,
            decoration: InputDecoration(
                hintText: 'Search your country',
                contentPadding: const EdgeInsets.only(
                    left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                border: InputBorder.none),
          ),
        ),
      );

  static Widget phoneNumberField(
          TextEditingController controller, String prefix) =>
      Card(
        elevation: 0.0,
        child: TextFormField(
          controller: controller,
          autofocus: true,
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
              child: Text(prefix),
            ),
            icon: Image.asset('assets/images/bd_flag.png', scale: 2.5),
          ),
        ),
      );

  static Widget selectableWidget(
          Country country, Function(Country) selectThisCountry) =>
      Material(
        color: Colors.white,
        type: MaterialType.canvas,
        child: InkWell(
          onTap: () => selectThisCountry(country), //selectThisCountry(country),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: Text(
              "  " +
                  country.flag +
                  "  " +
                  country.name +
                  " (" +
                  country.dialCode +
                  ")",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      );

  static Widget selectCountryDropDown(Country country, Function onPressed) =>
      Card(
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text(' ${country.flag}  ${country.name} ')),
                Icon(Icons.arrow_drop_down, size: 24.0)
              ],
            ),
          ),
        ),
      );

  static Widget subTitle(String text) => Align(
      alignment: Alignment.centerLeft,
      child: Text(' $text',
          style: GoogleFonts.ubuntu(
              textStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500))));
}

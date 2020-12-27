import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountFragment extends StatefulWidget {
  @override
  _AccountFragmentState createState() => _AccountFragmentState();
}

class _AccountFragmentState extends State<AccountFragment> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            child: Text(
              'Support',
              style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
                  color: Colors.grey,
                ),
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

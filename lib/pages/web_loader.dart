import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebLoader extends StatefulWidget {
  final String title;
  final String url;

  WebLoader({this.title, @required this.url});

  @override
  _WebLoaderState createState() => _WebLoaderState();
}

class _WebLoaderState extends State<WebLoader> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? 'WebLoader',
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              color: Colors.black87,
            ),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: [
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (String url) {
                debugPrint('loading started');
              },
              onPageFinished: (String url) {
                setState(() => isLoading = false);
              },
              gestureNavigationEnabled: true,
            ),
            isLoading ? Center(child: CircularProgressIndicator()) : Container(),
          ],
        );
      }),
    );
  }
}

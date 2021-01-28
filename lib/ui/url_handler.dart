import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'image_utils.dart';

class UrlHandler {

  void onUrlTapped(BuildContext context, String url) async {
    if (ImageUtils.isUrlImageOrMovie(url)) {
      showImageInWebViewDialog(context, url);
    } else {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        showImageInWebViewDialog(context, url);
      }
    }
  }

  void showImageInWebViewDialog(BuildContext context, String url) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => SimpleDialog(
          contentPadding: EdgeInsets.zero,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 400, maxWidth: 600),
              child: Container(
                color: Colors.black,
                child: _photoOrWebView(url),
              ),
            ),
          ],
        ));
  }

  Widget _photoOrWebView(String url) {
    String lowerUrl = url.toLowerCase();
    if (lowerUrl.contains(".jpg") ||
        (url.contains(".gif") && !url.contains(".gifv")) ||
        url.contains(".png")) {
      return Image.network(url);
    } else {
      return WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      );
    }
  }
}
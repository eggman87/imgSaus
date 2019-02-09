import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class GalleryImageView extends StatefulWidget {
  final String imageUrl;

  GalleryImageView({this.imageUrl, Key key}) : super(key: key);

  @override
  GalleryImageViewState createState() => GalleryImageViewState(imageUrl);
}

class GalleryImageViewState extends State<GalleryImageView> {
  final String imageUrl;

  bool isFailed = false;

  GalleryImageViewState(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    if (isFailed) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("error loading image", style: TextStyle(color: Colors.white)),
            FlatButton(
              child: Text("Retry"),
              color: Colors.white,
              onPressed: _retry,
            )
          ],
        ),
      );
    } else {
      return TransitionToImage(
        disableMemoryCache: true,
        image: AdvancedNetworkImage('$imageUrl',
            useDiskCache: true,
            retryLimit: 1,
            printError: true,
            loadFailedCallback: _loadFailed),
        loadingWidgetBuilder: (progress) => Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            ),
      );
    }
  }

  void _loadFailed() {
    setState(() {
      isFailed = true;
    });
  }

  void _retry() {
    setState(() {
      isFailed = false;
    });
  }
}

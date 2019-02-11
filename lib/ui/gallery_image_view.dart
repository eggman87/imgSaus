import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';


class GalleryImageView extends StatefulWidget {
  final String imageUrl;

  GalleryImageView({this.imageUrl, Key key}) : super(key: key);

  @override
  GalleryImageViewState createState() => GalleryImageViewState(imageUrl);
}

class GalleryImageViewState extends State<GalleryImageView> {
  final String imageUrl;

  bool isFailed = false;
  int retryCount = 0;

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
      return Image(key: Key('$retryCount'),image: NetworkImageWithRetry('$imageUrl?retryCount=$retryCount', fetchStrategy:_imageFetchStrategy));
    }
  }

  Future<FetchInstructions> _imageFetchStrategy(Uri uri, FetchFailure failure) {
    if (failure != null) {
      _loadFailed();
      return new Future.value(FetchInstructions.giveUp(uri: null));
    } else {
      return FetchStrategyBuilder().build()(uri, failure);
    }
  }

  void _loadFailed() {
    setState(() {
      isFailed = true;
    });
  }

    void _retry() {
    setState(() {
      retryCount ++;
      isFailed = false;
    });
  }
}

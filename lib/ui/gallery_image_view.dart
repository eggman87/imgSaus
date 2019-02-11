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
  void initState() {
    super.initState();

    retryCount = PageStorage.of(context)?.readState(context, identifier: "retryCount") ?? 0;
  }

  Future<FetchInstructions> _imageFetchStrategy(Uri uri, FetchFailure failure) {
    if (failure != null) {
      _loadFailed();
      return new Future.value(FetchInstructions.giveUp(uri: null));
    } else {
      return FetchStrategyBuilder(maxAttempts: 1, totalFetchTimeout: Duration(seconds: 15)).build()(uri, failure);
    }
  }

  void _loadFailed() {
    setState(() {
      retryCount++;
      PageStorage.of(context)?.writeState(context, retryCount, identifier: "retryCount");
      isFailed = true;
    });
  }

  void _retry() {
    setState(() {
      isFailed = false;
    });
  }

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
      return Image(
          key: Key('$retryCount'),
          image: NetworkImageWithRetry('$imageUrl?retryCount=$retryCount', fetchStrategy: _imageFetchStrategy));
    }
  }
}

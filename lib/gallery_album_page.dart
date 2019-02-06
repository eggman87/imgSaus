import 'package:flutter/material.dart';
import 'package:imgsrc/gallery_repository.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/vertical_swipe_detector.dart';
import 'package:video_player/video_player.dart';

class AlbumCount {
  final int currentPosition;
  final int totalCount;
  //we manually pass the item up because we load ALL images from api here (only 3 returned on initial call).
  final GalleryItem currentVisibleItem;

  AlbumCount(this.currentPosition, this.totalCount, this.currentVisibleItem);
}

class GalleryAlbumPage extends StatefulWidget {
  GalleryAlbumPage(this.item, this.onCountChanged, {Key key}) : super(key: key);

  final GalleryItem item;
  final Function(AlbumCount) onCountChanged;

  @override
  _GalleryAlbumPageState createState() => _GalleryAlbumPageState();
}

class _GalleryAlbumPageState extends State<GalleryAlbumPage> {
  int _position = 0;
  List<GalleryItem> _images;

  //note: if the album is large enough, we might have to manually dispose as user swipes through...
  Map<int, VideoPlayerController> _controllers = new Map();

  @override
  void initState() {
    super.initState();

    this._images = widget.item.images;
    //imgur api only returns 3 images max
    if (this._images.length < widget.item.imagesCount) {
      _loadAlbumDetails();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }

    _controllers.clear();

    super.dispose();
  }

  void _loadAlbumDetails() {
    var repository = GalleryRepository();
    repository.getAlbumDetails(widget.item.id).then((it) {
      if (!this.mounted) {
        return;
      }
      setState(() {
        if (it.isOk()) {
          this._images = it.body.images;
          widget.onCountChanged(AlbumCount(_position, _images.length, this._images[_position]));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return Container();
    }

    String imageUrl = this._images[_position].imageUrl();
    Widget widgetToWrap;
    if (GalleryItem.isLinkVideo(imageUrl)) {
      VideoPlayerController controller = _controllers[_position];
      VideoPlayer player;

      if (controller == null) {
        controller = VideoPlayerController.network(imageUrl);
        player = VideoPlayer(controller);
        _controllers[_position] = controller;
        controller.setLooping(true);
        controller.setVolume(0);

        controller.initialize().then((_) {
          setState(() {
            controller.play();
          });
        });
      } else {
        player = new VideoPlayer(controller);
      }
      widgetToWrap = player;
    } else {
      widgetToWrap = Image.network(imageUrl);
    }
    return VerticalSwipeDetector(child: widgetToWrap, onSwipeUp: _onSwipeUp, onSwipeDown: _onSwipeDown);
  }

  void _onSwipeUp() {
    if (_position < _images.length - 1) {
      setState(() {
        _position++;
        widget.onCountChanged(AlbumCount(_position, _images.length, this._images[_position]));
      });
    }
  }

  void _onSwipeDown() {
    if (_position > 0) {
      setState(() {
        _position--;
        widget.onCountChanged(AlbumCount(_position, _images.length, this._images[_position]));
      });
    }
  }
}
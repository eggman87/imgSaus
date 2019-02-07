import 'package:flutter/material.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:video_player/video_player.dart';

class GalleryImagePage extends StatefulWidget {
  GalleryImagePage(
    this.item, {
    Key key,
  }) : super(key: key);

  final GalleryItem item;

  @override
  _GalleryImagePageState createState() => _GalleryImagePageState();
}

class _GalleryImagePageState extends State<GalleryImagePage> {
  VideoPlayerController _controller;

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
      _controller = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.item.imageUrl();

    if (widget.item.isAlbum) {
      imageUrl = widget.item.images[0].imageUrl();
    }

    if (!mounted) {
      return Container();
    }

    if (_controller != null) {
      _controller.dispose();
    }

    if (GalleryItem.isLinkVideo(imageUrl)) {
      _controller = VideoPlayerController.network(imageUrl);
      var player = VideoPlayer(_controller);
      _controller.setLooping(true);
      _controller.setVolume(0);

      _controller.initialize().then((_) {
        _controller.play();
      });
      return player;
    } else {
      return Image.network(imageUrl);
    }
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:imgsrc/action/actions.dart';
import 'package:imgsrc/model/app_state.dart';
import 'package:imgsrc/model/gallery_item.dart';
import 'package:imgsrc/ui/gallery_image_view.dart';
import 'package:redux/redux.dart';
import 'package:video_player/video_player.dart';

class GalleryImagePage extends StatefulWidget {
  GalleryImagePage(this.item, {Key key, VideoPlayerController controller})
      : this.controller = controller,
        super(key: key);

  final GalleryItem item;
  VideoPlayerController controller;

  @override
  _GalleryImagePageState createState() => _GalleryImagePageState();
}

class _GalleryImagePageState extends State<GalleryImagePage> {
  VideoPlayerController _controller;
  Store<AppState> _store;

  //did we create the controller? if so we are responsible for destroying it.
  bool _isVideoControllerOwner = false;

  @override
  void dispose() {
    if (_isVideoControllerOwner) {
      if (_controller != null) {
        _controller.dispose();
        _controller = null;
      }
      if (_store != null) {
        _store.dispatch(ClearVideoControllerAction(widget.item.id));
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.item.imageUrl();

    if (GalleryItem.isLinkVideo(imageUrl)) {
      if (widget.controller != null) {
        _controller = widget.controller;
      } else {
        _controller = VideoPlayerController.network(imageUrl);
        _isVideoControllerOwner = true;
        _store = StoreProvider.of<AppState>(context);
        _store.dispatch(SetVideoControllerAction(widget.item.id, _controller));
        _controller.setLooping(true);
        _controller.setVolume(0);

        _controller.initialize().then((_) {
          setState(() {}); //necessary to trigger rebuild of controller aspect ratio.
          _controller.play();
        });
      }

      var player = VideoPlayer(_controller);
      return _controller.value.initialized
          ? Center(
              child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Hero(tag: "gallery_video", child: player),
            ))
          : Container();
    } else {
      return GalleryImageView(imageUrl: imageUrl);
    }
  }
}
